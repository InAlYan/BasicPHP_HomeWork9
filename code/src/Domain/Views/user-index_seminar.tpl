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
                            {{user.getUserLastName()}}.
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
                            <a href="/user/edit/?id_user={{user.getUserID()}}">...</a>
                        </td>
                        <td>
                            <a href="/user/delete/?id_user={{user.getUserID()}}">-</a>
                        </td>
                    {% endif %}
                </tr>
            {% endfor %}
        </tbody>
    </table>

    <script>
        let maxId = $('.table-responsive tbody tr:last-child td:first-child').html();

        setInterval(function() {
            $.ajax({
                method: 'POST',
                url: '/user/indexRefresh/',
                data: { maxId : maxId }
            }).done(function(data){
                // data - JSON response
                // k => [usernsme, userlastname, userbirthday]

                let users = $.parseJSON(data);

                if(users.length != 0) {
                    for(var k in users) {
                        let row = "<tr>";

                        row += "<td>" + users[k].id + "</td>";
                        maxId = users[k].id;

                        row += "<td>" + users[k].username + "</td>";
                        row += "<td>" + users[k].userlastname + "</td>";
                        row += "<td>" + users[k].userbirthday + "</td>";

                        row += "</tr>";

                        $('.content-template tbody').append(row);
                    }
                }
            });
            // alert('i`m working');
        }, 10000);
    </script>

</div>

</form>