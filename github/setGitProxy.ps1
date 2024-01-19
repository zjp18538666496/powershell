#获取全局配置中 HTTP 代理的设置。
git config --global --get http.proxy

#获取全局配置中 HTTPS 代理的设置。
git config --global --get https.proxy

#取消全局配置中的 HTTP 代理设置。
git config --global --unset http.proxy

#取消全局配置中的 HTTPS 代理设置。
git config --global --unset https.proxy

#设置全局的 HTTP 代理为 http://127.0.0.1:10809。
git config --global http.proxy http://127.0.0.1:10809

#设置全局的 HTTPS 代理为 http://127.0.0.1:10809。
git config --global https.proxy http://127.0.0.1:10809

#再次获取全局配置中 HTTP 代理的设置，以确认更改。
git config --global --get http.proxy

#再次获取全局配置中 HTTPS 代理的设置，以确认更改。
git config --global --get https.proxy

#清空本地 DNS 缓存，以便刷新系统的 DNS 解析。
ipconfig /flushdns
