From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/54] e2fsck: fix the journal recreation message
Date: Mon, 26 Jan 2015 23:37:03 -0800
Message-ID: <20150127073703.13308.19956.stgit@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33572 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbbA0HhI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 02:37:08 -0500
In-Reply-To: <20150127073533.13308.44994.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we recreate the journal, don't say that the FS "is now ext3
again", since we could be fixing a damaged ext4 FS journal, which does
not magically convert the FS back to ext3.

=46ix the po files too, though this string hasn't been translated.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/unix.c                         |    2 +-
 po/ca.po                              |    2 +-
 po/cs.po                              |    2 +-
 po/de.po                              |    2 +-
 po/eo.po                              |    2 +-
 po/es.po                              |    2 +-
 po/fr.po                              |    2 +-
 po/id.po                              |    2 +-
 po/it.po                              |    2 +-
 po/nl.po                              |    2 +-
 po/pl.po                              |    2 +-
 po/sv.po                              |    2 +-
 po/tr.po                              |    2 +-
 po/uk.po                              |    2 +-
 po/vi.po                              |    2 +-
 po/zh_CN.po                           |    2 +-
 tests/f_badjour_indblks/expect.1      |    2 +-
 tests/f_badjourblks/expect.1          |    2 +-
 tests/f_miss_journal/expect.1         |    2 +-
 tests/j_corrupt_sb_magic/expect       |    2 +-
 tests/j_long_trans/expect             |    2 +-
 tests/j_long_trans_mcsum_32bit/expect |    2 +-
 tests/j_long_trans_mcsum_64bit/expect |    2 +-
 23 files changed, 23 insertions(+), 23 deletions(-)


diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 615d690..5cba013 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1675,7 +1675,7 @@ print_unsupp_features:
 			log_out(ctx, "%s", _(" Done.\n"));
 			log_out(ctx, "%s",
 				_("\n*** journal has been re-created - "
-				  "filesystem is now ext3 again ***\n"));
+				  "filesystem is journalled again ***\n"));
 		}
 	}
 no_journal:
diff --git a/po/ca.po b/po/ca.po
index 02388da..c9ff513 100644
--- a/po/ca.po
+++ b/po/ca.po
@@ -3178,7 +3178,7 @@ msgstr " Fet.\n"
 #: e2fsck/unix.c:1663
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** registre de canvis recreat - el sist. de fitxers torna a ser ext3=
 ***\n"
diff --git a/po/cs.po b/po/cs.po
index be0a410..298c94e 100644
--- a/po/cs.po
+++ b/po/cs.po
@@ -3190,7 +3190,7 @@ msgstr " Hotovo.\n"
 #: e2fsck/unix.c:1664
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** =C5=BEurn=C3=A1l by znovu vytvo=C5=99en=C2=A0=E2=80=93 souborov=C3=
=BD syst=C3=A9m se op=C4=9Bt stal ext3 ***\n"
diff --git a/po/de.po b/po/de.po
index fd96bb1..8c2078b 100644
--- a/po/de.po
+++ b/po/de.po
@@ -3159,7 +3159,7 @@ msgstr " Erledigt.\n"
 #: e2fsck/unix.c:1663
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** Journal wurde wiederhergestellt - Dateisystem ist nun wieder ext3=
 ***\n"
diff --git a/po/eo.po b/po/eo.po
index 33e1635..6ce44ad 100644
--- a/po/eo.po
+++ b/po/eo.po
@@ -3113,7 +3113,7 @@ msgstr " Pretas.\n"
 #: e2fsck/unix.c:1663
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** ka=C5=9Dprotokolo rekrei=C4=9Dis -- dosiersistemo estas denove ex=
t3 ***\n"
diff --git a/po/es.po b/po/es.po
index 4137940..8dd4fe4 100644
--- a/po/es.po
+++ b/po/es.po
@@ -3235,7 +3235,7 @@ msgstr " Hecho.\n"
 #: e2fsck/unix.c:1663
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** el fichero de transacciones se ha creado de nuevo ***\n"
diff --git a/po/fr.po b/po/fr.po
index 44a482f..9670f86 100644
--- a/po/fr.po
+++ b/po/fr.po
@@ -3173,7 +3173,7 @@ msgstr "Compl
 #: e2fsck/unix.c:1664
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** le journal a =E9t=E9 re-cr=E9=E9 - le syst=E8me de fichiers est d=
e nouveau ext3 ***\n"
diff --git a/po/id.po b/po/id.po
index 0b747ff..7d56ceb 100644
--- a/po/id.po
+++ b/po/id.po
@@ -3170,7 +3170,7 @@ msgstr " Selesai.\n"
 #: e2fsck/unix.c:1663
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** jurnal telah dibuat kembali - sistem berkas sekarang ext3 lagi **=
*\n"
diff --git a/po/it.po b/po/it.po
index f6c7374..3736d90 100644
--- a/po/it.po
+++ b/po/it.po
@@ -3220,7 +3220,7 @@ msgstr ""
 #: e2fsck/unix.c:1663
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
=20
 #: e2fsck/unix.c:1687
diff --git a/po/nl.po b/po/nl.po
index dcc716d..033ef05 100644
--- a/po/nl.po
+++ b/po/nl.po
@@ -3177,7 +3177,7 @@ msgstr " voltooid.\n"
 #: e2fsck/unix.c:1664
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** journal is opnieuw aangemaakt -- het bestandssysteem is nu weer e=
xt3 ***\n"
diff --git a/po/pl.po b/po/pl.po
index 4fef6fb..7d71292 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -3177,7 +3177,7 @@ msgstr " Wykonano.\n"
 #: e2fsck/unix.c:1664
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** kronika zosta=C5=82a ponownie utworzona - system plik=C3=B3w to z=
nowu ext3 ***\n"
diff --git a/po/sv.po b/po/sv.po
index 3391aee..a8d171f 100644
--- a/po/sv.po
+++ b/po/sv.po
@@ -3176,7 +3176,7 @@ msgstr " Klar.\n"
 #: e2fsck/unix.c:1664
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** journalen har =C3=A5terskapats - filsystemet =C3=A4r nu ext3 igen=
 ***\n"
diff --git a/po/tr.po b/po/tr.po
index 0c715c0..4cd64ba 100644
--- a/po/tr.po
+++ b/po/tr.po
@@ -3249,7 +3249,7 @@ msgstr " Tamamland=C4=B1.\n"
 #: e2fsck/unix.c:1663
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** g=C3=BCnl=C3=BCk yeniden olu=C5=9Fturuldu - dosya sistemi yeniden=
 ext3 ***\n"
diff --git a/po/uk.po b/po/uk.po
index f93282a..7deeafb 100644
--- a/po/uk.po
+++ b/po/uk.po
@@ -3177,7 +3177,7 @@ msgstr " =D0=92=D0=B8=D0=BA=D0=BE=D0=BD=D0=B0=D0=BD=
=D0=BE.\n"
 #: e2fsck/unix.c:1664
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** =D0=B6=D1=83=D1=80=D0=BD=D0=B0=D0=BB =D1=81=D1=82=D0=B2=D0=BE=D1=80=
=D0=B5=D0=BD=D0=BE =D0=BF=D0=BE=D0=B2=D1=82=D0=BE=D1=80=D0=BD=D0=BE - =D1=
=82=D0=B5=D0=BF=D0=B5=D1=80 =D1=86=D0=B5 =D0=B7=D0=BD=D0=BE=D0=B2=D1=83=
 =D1=84=D0=B0=D0=B9=D0=BB=D0=BE=D0=B2=D0=B0 =D1=81=D0=B8=D1=81=D1=82=D0=
=B5=D0=BC=D0=B0 ext3 ***\n"
diff --git a/po/vi.po b/po/vi.po
index 2300c19..e08e7f5 100644
--- a/po/vi.po
+++ b/po/vi.po
@@ -3139,7 +3139,7 @@ msgstr " Xong.\n"
 #: e2fsck/unix.c:1664
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
 "\n"
 "*** nh=E1=BA=ADt k=C3=BD =C4=91=C3=A3 =C4=91=C6=B0=E1=BB=A3c t=E1=BA=A1=
o l=E1=BA=A1i =E2=80=94 h=E1=BB=87 th=E1=BB=91ng t=E1=BA=ADp tin l=C3=BA=
c n=C3=A0y l=C3=A0 ext3 l=E1=BA=A1i ***\n"
diff --git a/po/zh_CN.po b/po/zh_CN.po
index 37c4aa7..d79f348 100644
--- a/po/zh_CN.po
+++ b/po/zh_CN.po
@@ -3003,7 +3003,7 @@ msgstr "=E5=AE=8C=E6=88=90.\n"
 #: e2fsck/unix.c:1663
 msgid ""
 "\n"
-"*** journal has been re-created - filesystem is now ext3 again ***\n"
+"*** journal has been re-created - filesystem is journalled again ***\=
n"
 msgstr ""
=20
 #: e2fsck/unix.c:1687
diff --git a/tests/f_badjour_indblks/expect.1 b/tests/f_badjour_indblks=
/expect.1
index 7ccc59b..a326900 100644
--- a/tests/f_badjour_indblks/expect.1
+++ b/tests/f_badjour_indblks/expect.1
@@ -25,7 +25,7 @@ Recreate journal? yes
=20
 Creating journal (1024 blocks):  Done.
=20
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been re-created - filesystem is journalled again ***
=20
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/256 files (0.0% non-contiguous), 1111/8192 blocks
diff --git a/tests/f_badjourblks/expect.1 b/tests/f_badjourblks/expect.=
1
index 34c6658..dc38b2b 100644
--- a/tests/f_badjourblks/expect.1
+++ b/tests/f_badjourblks/expect.1
@@ -23,7 +23,7 @@ Recreate journal? yes
=20
 Creating journal (1024 blocks):  Done.
=20
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been re-created - filesystem is journalled again ***
=20
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/256 files (0.0% non-contiguous), 1079/8192 blocks
diff --git a/tests/f_miss_journal/expect.1 b/tests/f_miss_journal/expec=
t.1
index 6ec8b38..77d3223 100644
--- a/tests/f_miss_journal/expect.1
+++ b/tests/f_miss_journal/expect.1
@@ -21,7 +21,7 @@ Recreate journal? yes
=20
 Creating journal (1024 blocks):  Done.
=20
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been re-created - filesystem is journalled again ***
=20
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/256 files (0.0% non-contiguous), 1079/2048 blocks
diff --git a/tests/j_corrupt_sb_magic/expect b/tests/j_corrupt_sb_magic=
/expect
index 2169a15..0d2e9b4 100644
--- a/tests/j_corrupt_sb_magic/expect
+++ b/tests/j_corrupt_sb_magic/expect
@@ -26,7 +26,7 @@ Recreate journal? yes
=20
 Creating journal (1024 blocks):  Done.
=20
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been re-created - filesystem is journalled again ***
=20
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 12/128 files (0.0% non-contiguous), 1092/2048 blocks
diff --git a/tests/j_long_trans/expect b/tests/j_long_trans/expect
index 7638ef1..09da441 100644
--- a/tests/j_long_trans/expect
+++ b/tests/j_long_trans/expect
@@ -100,7 +100,7 @@ Recreate journal? yes
=20
 Creating journal (8192 blocks):  Done.
=20
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been re-created - filesystem is journalled again ***
=20
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/16384 files (0.0% non-contiguous), 14420/262144 block=
s
diff --git a/tests/j_long_trans_mcsum_32bit/expect b/tests/j_long_trans=
_mcsum_32bit/expect
index 0d141c1..0f35126 100644
--- a/tests/j_long_trans_mcsum_32bit/expect
+++ b/tests/j_long_trans_mcsum_32bit/expect
@@ -139,7 +139,7 @@ Recreate journal? yes
=20
 Creating journal (16384 blocks):  Done.
=20
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been re-created - filesystem is journalled again ***
=20
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/32768 files (0.0% non-contiguous), 27039/524288 block=
s
diff --git a/tests/j_long_trans_mcsum_64bit/expect b/tests/j_long_trans=
_mcsum_64bit/expect
index 94e9925..17c2517 100644
--- a/tests/j_long_trans_mcsum_64bit/expect
+++ b/tests/j_long_trans_mcsum_64bit/expect
@@ -138,7 +138,7 @@ Recreate journal? yes
=20
 Creating journal (16384 blocks):  Done.
=20
-*** journal has been re-created - filesystem is now ext3 again ***
+*** journal has been re-created - filesystem is journalled again ***
=20
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
 test_filesys: 11/32768 files (0.0% non-contiguous), 27057/524288 block=
s

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
