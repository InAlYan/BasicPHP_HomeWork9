<p>Список пользователей в хранилище</p>
<form action="/user/edit" method="post">

<button name="action" value="+">+</button>

<div class="table-responsive small">
    <table class="table table-striped table-sm">
        <thead>
            <tr>
                <th scope="col">ID</th>
                <th scope="col">Имя</th>
                <th scope="col">Фамилия</th>
                <th scope="col">День рождения</th>
                {% if isAdmin %}
                    <th scope="col">Редактировать</th>
                    <th scope="col">Удалить</th>
                {% endif %}
            </tr>
        </thead>
        <tbody>
            {% for user in users %}
                <tr>
                    <td>
                        <a href="/user/edit/?id={{user.getUserId()}}">
                            {{user.getUserId()}}
                        </a>
                    </td>
                    <td>
                      <a href="/user/edit/?id={{user.getUserId()}}">
                         {{user.getUserName()}}
                      </a>
                    </td>
                    <td>
                        <a href="/user/edit/?id={{user.getUserId()}}">
                            {{user.getUserLastName()}}
                        </a>
                    </td>
                    <td>
                        <a href="/user/edit/?id={{user.getUserId()}}">
                            {% if (user.getUserBirthday() is not same as (null)) %}
                                {{user.getUserBirthday() | date('d.m.Y')}}
                            {% endif %}
                        </a>
                    </td>
                    {% if isAdmin %}
                        <td>
                            <button name="action" value="+_{{user.getUserId()}}">...</button>
                        </td>
                        <td>
                            <button name="action" value="-_{{user.getUserId()}}">-</button>
                        </td>
                    {% endif %}
                </tr>
            {% endfor %}
        </tbody>
    </table>

    <script>
        // Обновление списка пользователей
        let maxId = $('.table-responsive tbody tr:last-child td:first-child').text(); // МОЁ

        setInterval(function() {
            $.ajax({
                method: 'POST',
                url: '/user/indexRefresh/',
                data: { maxId : maxId }
            }).done(function(data){

                let dataObj = $.parseJSON(data);

                const isAdmin = dataObj.isAdmin;
                const users = dataObj.userData;

                if(users.length != 0) {
                    for(var k in users) {

                        let row = "<tr>";

                        row += "<td><a href ='/user/edit/?id=" + users[k].id + "'>" + users[k].id + "</a></td>";
                        maxId = users[k].id;
                        row += "<td><a href ='/user/edit/?id=" + users[k].id + "'>" + users[k].username + "</td>";
                        row += "<td><a href ='/user/edit/?id=" + users[k].id + "'>" + users[k].userlastname + "</td>";
                        row += "<td><a href ='/user/edit/?id=" + users[k].id + "'>" + users[k].userbirthday + "</td>";

                        if(isAdmin) {
                            row += "<td><button name='action' value=+_" + users[k].id + ">...</button></td>";
                            row += "<td><button name='action' value=-_" + users[k].id + ">-</button></td>";
                        }

                        row += "</tr>";

                        $('.content-template tbody').append(row);
                    }
                }
            });
        }, 10000);
    </script>

    <script>
        // Асинхронное удаление пользователей


    </script>

</div>

</form>