{% if not user_authorised %}
    <div class="col-md-3 text-end">
        <a href="/user/login" class="btn btn-primary">Войти</a>
    </div>

{% else %}
    <span>Добро пожаловать на сайт {{ user_name }}!</span>
    <a href="/user/logout" class="btn btn-primary">Выход из системы</a>
{% endif %}