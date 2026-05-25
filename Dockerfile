FROM php:8.3-fpm

RUN apt-get update \
    && apt-get install -y --no-install-recommends nginx supervisor \
    && rm -rf /var/lib/apt/lists/*

RUN cat > /etc/nginx/sites-available/default <<'NGINX'
server {
    listen 80 default_server;
    server_name _;

    root /var/www/html;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
    }
}
NGINX

RUN cat > /var/www/html/index.php <<'PHP'
<?php
header('Content-Type: text/html; charset=utf-8');

function h($value) {
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

$headers = function_exists('getallheaders') ? getallheaders() : [];

?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>PHP-FPM Environment Test</title>
    <style>
        body { font-family: system-ui, sans-serif; margin: 40px; }
        table { border-collapse: collapse; width: 100%; max-width: 1000px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; vertical-align: top; }
        th { background: #f2f2f2; }
        .ok { color: green; font-weight: bold; }
    </style>
</head>
<body>
    <h1 class="ok">PHP-FPM OK</h1>

    <table>
        <tr><th>Server time</th><td><?= h(date('Y-m-d H:i:s T')) ?></td></tr>
        <tr><th>PHP version</th><td><?= h(PHP_VERSION) ?></td></tr>
        <tr><th>Hostname</th><td><?= h(gethostname()) ?></td></tr>
        <tr><th>Server software</th><td><?= h($_SERVER['SERVER_SOFTWARE'] ?? '') ?></td></tr>
        <tr><th>Remote IP</th><td><?= h($_SERVER['REMOTE_ADDR'] ?? '') ?></td></tr>
        <tr><th>Host</th><td><?= h($_SERVER['HTTP_HOST'] ?? '') ?></td></tr>
        <tr><th>URI</th><td><?= h($_SERVER['REQUEST_URI'] ?? '') ?></td></tr>
        <tr><th>Request method</th><td><?= h($_SERVER['REQUEST_METHOD'] ?? '') ?></td></tr>
        <tr><th>X-Forwarded-For</th><td><?= h($_SERVER['HTTP_X_FORWARDED_FOR'] ?? '') ?></td></tr>
        <tr><th>X-Forwarded-Proto</th><td><?= h($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') ?></td></tr>
        <tr><th>X-Real-IP</th><td><?= h($_SERVER['HTTP_X_REAL_IP'] ?? '') ?></td></tr>
    </table>

    <h2>Request headers</h2>
    <table>
        <tr><th>Header</th><th>Value</th></tr>
        <?php foreach ($headers as $name => $value): ?>
            <tr>
                <td><?= h($name) ?></td>
                <td><?= h($value) ?></td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>
PHP

RUN cat > /etc/supervisor/conf.d/app.conf <<'SUPERVISOR'
[supervisord]
nodaemon=true

[program:php-fpm]
command=php-fpm
autostart=true
autorestart=true

[program:nginx]
command=nginx -g "daemon off;"
autostart=true
autorestart=true
SUPERVISOR

EXPOSE 80

CMD ["supervisord", "-c", "/etc/supervisor/conf.d/app.conf"]
