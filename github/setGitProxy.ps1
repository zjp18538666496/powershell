#��ȡȫ�������� HTTP ��������á�
git config --global --get http.proxy

#��ȡȫ�������� HTTPS ��������á�
git config --global --get https.proxy

#ȡ��ȫ�������е� HTTP �������á�
git config --global --unset http.proxy

#ȡ��ȫ�������е� HTTPS �������á�
git config --global --unset https.proxy

#����ȫ�ֵ� HTTP ����Ϊ http://127.0.0.1:10809��
git config --global http.proxy http://127.0.0.1:10809

#����ȫ�ֵ� HTTPS ����Ϊ http://127.0.0.1:10809��
git config --global https.proxy http://127.0.0.1:10809

#�ٴλ�ȡȫ�������� HTTP ��������ã���ȷ�ϸ��ġ�
git config --global --get http.proxy

#�ٴλ�ȡȫ�������� HTTPS ��������ã���ȷ�ϸ��ġ�
git config --global --get https.proxy

#��ձ��� DNS ���棬�Ա�ˢ��ϵͳ�� DNS ������
ipconfig /flushdns
