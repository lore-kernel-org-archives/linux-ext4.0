From: Viji V Nair <viji@fedoraproject.org>
Subject: optimising filesystem for many small files
Date: Sat, 17 Oct 2009 12:22:48 +0530
Message-ID: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0955570942=="
To: ext3-users@redhat.com, linux-ext4@vger.kernel.org
Return-path: <ext3-users-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

--===============0955570942==
Content-Type: multipart/alternative; boundary=000e0cd15048e694c604761bf5ed

--000e0cd15048e694c604761bf5ed
Content-Type: text/plain; charset=ISO-8859-1

Hi,

System : Fedora 11 x86_64
Current Filesystem: 150G ext4 (formatted with "-T small" option)
Number of files: 50 Million, 1 to 30K png images

We are generating these files using a python programme and getting very slow
IO performance. While generation there in only write, no read. After
generation there is heavy read and no write.

I am looking for best practices/recommendation to get a better performance.

Any suggestions of the above are greatly appreciated.

Viji

--000e0cd15048e694c604761bf5ed
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>System : Fedora 11 x86_64<br>Current Filesystem: 150G ext4 (form=
atted with &quot;-T small&quot; option)<br>Number of files: 50 Million, 1 t=
o 30K png images <br><br>We are generating these files using a python progr=
amme and getting very slow IO performance. While generation there in only w=
rite, no read. After generation there is heavy read and no write.<br>
<br>I am looking for best practices/recommendation to get a better performa=
nce. <br><br>Any suggestions of the above are greatly appreciated.<br><br>V=
iji<br><br><br><br><br>

--000e0cd15048e694c604761bf5ed--


--===============0955570942==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Ext3-users mailing list
Ext3-users@redhat.com
https://www.redhat.com/mailman/listinfo/ext3-users
--===============0955570942==--
