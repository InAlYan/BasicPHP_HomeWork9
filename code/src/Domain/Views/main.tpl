<!DOCTYPE html>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/main.css">
<script src="/js/main.js"></script>
<html>
    <head>
        <title>{{ title }}</title>
    </head>
    <body class="h-100 d-flex flex-column">

        <div class="container">
            <header class="d-flex flex-wrap align-items-center justify-content-center justify-content-md-between py-3 mb-4 border-bottom">
                <div class="col-md-3 mb-2 mb-md-0">
                    <a href="/" class="d-inline-flex link-body-emphasis text-decoration-none">
                        <svg class="bi" width="40" height="32" role="img" aria-label="Bootstrap"><use xlink:href="#bootstrap"/></svg>
                    </a>
                </div>

                <ul class="nav col-12 col-md-auto mb-2 justify-content-center mb-md-0">
                    <li><a href="/" class="nav-link px-2 link-secondary">Главная</a></li>
                    <li><a href="/user" class="nav-link px-2">Пользователи</a></li>
                </ul>

                <div>{% include "auth.tpl" %}</div>
            </header>
        </div>

        <main class="flex-shrink-0">
            <div class="container content-template">
                {% include content_template_name %}
            </div>
        </main>

        <footer class="footer mt-auto py-3 bg-body-tertiary">
            <div class="container">
                {% include content_template_footer %}
            </div>
        </footer>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>


        <script>
            // Установка времени
            setInterval(() => {
                (
                    async () => {
                        const response = await fetch('/page/time');
                        const answer = await response.json();
                        document.querySelector('#server-time').textContent = answer.time;
                    }
                )();
            }, 1000);
        </script>
    </body>
</html>