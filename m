From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/31] libext2fs: Fix a minor grammatical error in the error
 catalog
Date: Mon, 30 Sep 2013 18:27:08 -0700
Message-ID: <20131001012708.28415.7839.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22362 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3JAB1N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:27:13 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

'an block' should be 'a block'.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2_err.et.in |    2 +-
 po/ca.po                  |    2 +-
 po/cs.po                  |    2 +-
 po/de.po                  |    2 +-
 po/e2fsprogs.pot          |    2 +-
 po/es.po                  |    2 +-
 po/fr.po                  |    2 +-
 po/id.po                  |    2 +-
 po/it.po                  |    2 +-
 po/nl.po                  |    2 +-
 po/pl.po                  |    2 +-
 po/sv.po                  |    2 +-
 po/tr.po                  |    2 +-
 po/vi.po                  |    2 +-
 po/zh_CN.po               |    2 +-
 15 files changed, 15 insertions(+), 15 deletions(-)


diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index d100acd..c547a2c 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -96,7 +96,7 @@ ec	EXT2_ET_INODE_BITMAP_READ,
 	"Can't read an inode bitmap"
=20
 ec	EXT2_ET_BLOCK_BITMAP_WRITE,
-	"Can't write an block bitmap"
+	"Can't write a block bitmap"
=20
 ec	EXT2_ET_BLOCK_BITMAP_READ,
 	"Can't read an block bitmap"
diff --git a/po/ca.po b/po/ca.po
index 44cd45a..0d8f36a 100644
--- a/po/ca.po
+++ b/po/ca.po
@@ -6010,7 +6010,7 @@ msgstr "escriptura dels mapes de bits de bloc i d=
e node-i"
=20
 #: lib/ext2fs/ext2_err.c:40
 #, fuzzy
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "en escriure el mapa de bits dels blocs"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/cs.po b/po/cs.po
index b110c43..fe34399 100644
--- a/po/cs.po
+++ b/po/cs.po
@@ -5972,7 +5972,7 @@ msgid "Can't read an inode bitmap"
 msgstr "Bitmapu iuzl=C5=AF nelze p=C5=99e=C4=8D=C3=ADst"
=20
 #: lib/ext2fs/ext2_err.c:40
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "Bitmapu blok=C5=AF nelze zapsat"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/de.po b/po/de.po
index 0e7b39e..b7f71c2 100644
--- a/po/de.po
+++ b/po/de.po
@@ -5976,7 +5976,7 @@ msgid "Can't read an inode bitmap"
 msgstr "Die Inode-Bitmap kann nicht gelesen werden"
=20
 #: lib/ext2fs/ext2_err.c:40
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "Die Block-Bitmap kann nicht geschrieben werden"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/e2fsprogs.pot b/po/e2fsprogs.pot
index e298bed..0e63d47 100644
--- a/po/e2fsprogs.pot
+++ b/po/e2fsprogs.pot
@@ -5640,7 +5640,7 @@ msgid "Can't read an inode bitmap"
 msgstr ""
=20
 #: lib/ext2fs/ext2_err.c:40
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr ""
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/es.po b/po/es.po
index 95c99ff..f47480b 100644
--- a/po/es.po
+++ b/po/es.po
@@ -6181,7 +6181,7 @@ msgstr "escribiendo los mapas de bits de los nodo=
s-i"
=20
 #: lib/ext2fs/ext2_err.c:40
 #, fuzzy
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "leyendo los mapas de bits del nodo-i y del bloque"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/fr.po b/po/fr.po
index 0c59a39..602441e 100644
--- a/po/fr.po
+++ b/po/fr.po
@@ -5987,7 +5987,7 @@ msgid "Can't read an inode bitmap"
 msgstr "Ne peut lire un bitmap d'i-noeuds"
=20
 #: lib/ext2fs/ext2_err.c:40
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "Ne peut =E9crire un bitmap de blocs"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/id.po b/po/id.po
index dce13bd..fb4e8fb 100644
--- a/po/id.po
+++ b/po/id.po
@@ -6027,7 +6027,7 @@ msgstr "menulis inode bitmap"
=20
 #: lib/ext2fs/ext2_err.c:40
 #, fuzzy
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "membaca inode dan blok bitmap"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/it.po b/po/it.po
index d26d63d..ba8ba61 100644
--- a/po/it.po
+++ b/po/it.po
@@ -6088,7 +6088,7 @@ msgstr "scrivendo le mappe di bit di inode"
=20
 #: lib/ext2fs/ext2_err.c:40
 #, fuzzy
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "lettura delle mappe di bit inode e blocco"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/nl.po b/po/nl.po
index 3125bbc..b98cb32 100644
--- a/po/nl.po
+++ b/po/nl.po
@@ -5982,7 +5982,7 @@ msgid "Can't read an inode bitmap"
 msgstr "Kan een inode-bitkaart niet lezen"
=20
 #: lib/ext2fs/ext2_err.c:40
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "Kan een blok-bitkaart niet schrijven"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/pl.po b/po/pl.po
index 924fcba..62fac2e 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -5946,7 +5946,7 @@ msgid "Can't read an inode bitmap"
 msgstr "Nie mo=BFna odczyta=E6 bitmapy i-w=EAz=B3=F3w"
=20
 #: lib/ext2fs/ext2_err.c:40
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "Nie mo=BFna zapisa=E6 bitmapy blok=F3w"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/sv.po b/po/sv.po
index b2c5df1..d89370e 100644
--- a/po/sv.po
+++ b/po/sv.po
@@ -5952,7 +5952,7 @@ msgid "Can't read an inode bitmap"
 msgstr "Kan inte l=C3=A4sa en inodsbitkarta"
=20
 #: lib/ext2fs/ext2_err.c:40
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "Kan inte skriva en blockbitkarta"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/tr.po b/po/tr.po
index 186cd79..c677675 100644
--- a/po/tr.po
+++ b/po/tr.po
@@ -6352,7 +6352,7 @@ msgstr "d=C3=BC=C4=9F=C3=BCm bite=C5=9Flemleri ya=
z=C4=B1l=C4=B1yor"
=20
 #: lib/ext2fs/ext2_err.c:40
 #, fuzzy
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "d=C3=BC=C4=9F=C3=BCm ve blok bite=C5=9Flemleri okunuyor"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/vi.po b/po/vi.po
index 4f15af2..736542e 100644
--- a/po/vi.po
+++ b/po/vi.po
@@ -5929,7 +5929,7 @@ msgid "Can't read an inode bitmap"
 msgstr "Kh=C3=B4ng th=E1=BB=83 =C4=91=E1=BB=8Dc m=E1=BA=A3ng =E1=BA=A3=
nh n=C3=BAt"
=20
 #: lib/ext2fs/ext2_err.c:40
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "Kh=C3=B4ng th=E1=BB=83 ghi m=E1=BA=A3ng =E1=BA=A3nh kh=E1=BB=91=
i"
=20
 #: lib/ext2fs/ext2_err.c:41
diff --git a/po/zh_CN.po b/po/zh_CN.po
index edbcc27..77f4a22 100644
--- a/po/zh_CN.po
+++ b/po/zh_CN.po
@@ -5644,7 +5644,7 @@ msgstr "inode =E4=BD=8D=E5=9B=BE"
=20
 #: lib/ext2fs/ext2_err.c:40
 #, fuzzy
-msgid "Can't write an block bitmap"
+msgid "Can't write a block bitmap"
 msgstr "=E5=9D=97=E4=BD=8D=E5=9B=BE"
=20
 #: lib/ext2fs/ext2_err.c:41

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
