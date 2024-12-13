<?php

namespace Geekbrains\Application1\Domain\Controllers;

use Geekbrains\Application1\Application\Application;
use Geekbrains\Application1\Application\Auth;
use Geekbrains\Application1\Application\Render;
use Geekbrains\Application1\Domain\Models\User;
use Geekbrains\Application1\Domain\Controllers\AbstractController;

class UserController extends AbstractController {

    protected array $actionsPermissions = [
        'actionHash' => ['admin', 'manager'],
        'actionSave' => ['admin'],
        'actionUpdate' => ['admin'],
        'actionEdit' => ['admin'],
        'actionDelete' => ['admin'],
        'actionIndex' => ['admin', 'user'],
        'actionShow' => ['admin'],
        'actionLogout' => ['admin', 'user'],
        'actionIndexRefresh' => ['admin', 'user']
    ];

    public function actionIndex(): string {
        $users = User::getAllUsersFromStorage();

        $render = new Render();

        if(!$users){
            return $render->renderPage(
                'user-empty.tpl',
                [
                    'title' => 'Список пользователей в хранилище',
                    'message' => "Список пуст или не найден"
                ]);
        }
        else{
            return $render->renderPage(
                'user-index.tpl', 
                [
                    'title' => 'Список пользователей в хранилище',
                    'users' => $users,
                    'isAdmin' => User::isAdmin($_SESSION['id_user'] ?? null), // Так в семинаре
//                    'isAdmin' => User::isAdmin() // Моё
                ]);
        }
    }

    public function actionSave() {
        if(User::validateRequestData()) {
            $user = new User();
            $user->setParamsFromRequestData();
            $user->saveToStorage();

             header('Location: ' . '/user');
        }
        else {
            Application::logErrorToFile("Переданные в методе actionSave данные некорректны " . Application::commonTailOfLogMessage());

            throw new \Exception("Переданные данные некорректны");
        }
    }

    public function actionUpdate() {
        $id =  $this->postCorrectedId();

        if(User::exists($id)) {
            $user = new User();
            $user->setUserId($id);

            $arrayData = [];

            if(isset($_POST['name'])) $arrayData['user_name'] = $_POST['name'];
            if(isset($_POST['lastname'])) $arrayData['user_lastname'] = $_POST['lastname'];
            if(isset($_POST['birthday'])) $arrayData['user_birthday_timestamp'] = $_POST['birthday'];

            $user->updateUser($arrayData);

            header('Location: ' . '/user');
        }
        else {
            Application::logErrorToFile("Обновляемый пользователь не существует " . Application::commonTailOfLogMessage());
            throw new \Exception("Пользователь не существует");
        }
    }

    public function actionDelete() {

        $id = $this->postCorrectedId();
        if(User::exists($id)) {
            User::deleteFromStorage($id);

//             header('Location: ' . '/user');
        }
        else {
            Application::logErrorToFile("Удаляемый пользователь не существует " . Application::commonTailOfLogMessage());
            throw new \Exception("Пользователь не существует");
        }
    }

    public function actionShow(): string {

        $id = $this->getCorrectedId();

        if(User::exists($id)) {
            $user = User::getUserFromStorageById($id);

            $render = new Render();
            return $render->renderPage(
                'user-created.tpl', [
                    'title' => 'Создан новый пользователь',
                    'message' => "Новый пользователь ",
                    'user' => $user
                ]
            );
        }
        else {
            Application::logErrorToFile("Показываемый пользователь не существует " . Application::commonTailOfLogMessage());
            throw new \Exception("Пользователь с таким id не существует");
        }
    }

    public function actionEdit() {

        $id = $this->getCorrectedId();

        // Редактирование пользователя
        if(User::exists($id)) {

            $user = User::getUserFromStorageById($id);

            $render = new Render();
            return $render->renderPageWithForm("user-form.tpl",
                [
                    'title' => 'Изменение пользователя',
                    'message' => 'Изменение пользователя',
                    'user' => $user,
                    'action' => 'update'
                ]);
        }
        // Создание пользователя
        else {
            $render = new Render();
            return $render->renderPageWithForm("user-form.tpl",
                [
                    'title' => 'Новый пользователь',
                    'message' => "Новый пользователь",
                    'action' => 'save'
                ]);
        }
    }

    public function actionIndexRefresh() {
        $limit = null;

        if (isset($_POST['maxId']) && $_POST['maxId'] > 0) {
            $limit = $_POST['maxId'];
        }

        $users = User::getAllUsersFromStorage($limit);

        $userData = [];

        if(count($users) > 0) {
            foreach ($users as $user) {
                $userData[] = $user->getUserDataAsArray();
            }
        }

        $data = ['isAdmin' => User::isAdmin($_SESSION['id_user'] ?? null), 'userData' => $userData];

//        return json_encode($userData, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT); // ТАК БЫЛО
        return json_encode($data, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    }

    private function getCorrectedId(): int
    {
        return (isset($_GET['id'])) ? (int)$_GET['id'] : 0;
    }

    private function postCorrectedId(): int
    {
        return (isset($_POST['id_user'])) ? (int)$_POST['id_user'] : 0;
    }

    public function actionHash(): string {
        return Auth::getPasswordHash($_GET['pass_string']);
    }

    public function actionAuth(): string {
        $render = new Render();
        return $render->renderPageWithForm('user-auth.tpl',
        [
            'title' => 'Форма логина',
        ]);
    }

    public function actionLogin(): string {

        $result =false;

        if  (!empty($_POST['login']) && !empty($_POST['password'])) {
            // Если checkbox "сохранить" установлен передаем параметром в процедуру аутентификации
            $result = Application::$auth->proceedAuth($_POST['login'], $_POST['password'], isset($_POST['user-remember']));
        }
        else {
            // Добавлено логирование
            $auth_error = "";
            if (empty($_POST['login'])) {
                $auth_error = "Логин не задан";
                Application::logErrorToFile("Логин не задан " . Application::commonTailOfLogMessage());
            }
            if (empty($_POST['password'])) {
                $auth_error .= " Пароль не задан";
                Application::logErrorToFile("Пароль не задан " . Application::commonTailOfLogMessage());
            }

            $render = new Render();
            return $render->renderPageWithForm('user-auth.tpl',
                [
                    'title' => 'Форма логина',
                    'auth_success' => false,
                    'auth_error' => $auth_error
                ]);
            // Добавлено логирование
        }

        if (!$result) {

            Application::logErrorToFile("Неверные логин и (или) пароль " . Application::commonTailOfLogMessage());

            $render = new Render();
            return $render->renderPageWithForm('user-auth.tpl',
                [
                    'title' => 'Форма логина',
                    'auth_success' => false,
                    'auth_error' => 'Неверные логин и (или) пароль'
                ]);
        } else {
            header('Location: /');
            return "";
        }
    }

    public function actionLogout(): void {
        session_destroy();
        unset($_SESSION['user_name']);
        unset($_SESSION['user_lastname']);
        unset($_SESSION['id_user']);
        unset($_SESSION['csrf_token']);

        if (isset($_COOKIE['user-token'])) {
            unset($_COOKIE['user-token']);
            setcookie('user-token', '', -1, '/');
        }

        header('Location: /');
        die();
    }

}