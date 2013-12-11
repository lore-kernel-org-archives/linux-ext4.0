From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/74] libext2fs: fix another minor grammatical error in the
 error catalog
Date: Tue, 10 Dec 2013 17:19:16 -0800
Message-ID: <20131211011916.30655.79317.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25982 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3LKBT2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:19:28 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

'an block' should be 'a block'.  Missed the read case in the first patc=
h.

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
index 2486321..93a1106 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -99,7 +99,7 @@ ec	EXT2_ET_BLOCK_BITMAP_WRITE,
 	"Can't write a block bitmap"
=20
 ec	EXT2_ET_BLOCK_BITMAP_READ,
-	"Can't read an block bitmap"
+	"Can't read a block bitmap"
=20
 ec	EXT2_ET_INODE_TABLE_WRITE,
 	"Can't write an inode table"
diff --git a/po/ca.po b/po/ca.po
index 0d8f36a..10e87ea 100644
--- a/po/ca.po
+++ b/po/ca.po
@@ -6015,7 +6015,7 @@ msgstr "en escriure el mapa de bits dels blocs"
=20
 #: lib/ext2fs/ext2_err.c:41
 #, fuzzy
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "en escriure el mapa de bits dels blocs"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/cs.po b/po/cs.po
index fe34399..2ea495e 100644
--- a/po/cs.po
+++ b/po/cs.po
@@ -5976,7 +5976,7 @@ msgid "Can't write a block bitmap"
 msgstr "Bitmapu blok=C5=AF nelze zapsat"
=20
 #: lib/ext2fs/ext2_err.c:41
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "Bitmapu blok=C5=AF nelze p=C5=99e=C4=8D=C3=ADst"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/de.po b/po/de.po
index b7f71c2..d1ed005 100644
--- a/po/de.po
+++ b/po/de.po
@@ -5980,7 +5980,7 @@ msgid "Can't write a block bitmap"
 msgstr "Die Block-Bitmap kann nicht geschrieben werden"
=20
 #: lib/ext2fs/ext2_err.c:41
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "Die Block-Bitmap kann nicht gelesen werden"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/e2fsprogs.pot b/po/e2fsprogs.pot
index 0e63d47..3ce9e14 100644
--- a/po/e2fsprogs.pot
+++ b/po/e2fsprogs.pot
@@ -5644,7 +5644,7 @@ msgid "Can't write a block bitmap"
 msgstr ""
=20
 #: lib/ext2fs/ext2_err.c:41
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr ""
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/es.po b/po/es.po
index f47480b..b9be136 100644
--- a/po/es.po
+++ b/po/es.po
@@ -6186,7 +6186,7 @@ msgstr "leyendo los mapas de bits del nodo-i y de=
l bloque"
=20
 #: lib/ext2fs/ext2_err.c:41
 #, fuzzy
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "leyendo los mapas de bits del nodo-i y del bloque"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/fr.po b/po/fr.po
index 602441e..69c13d4 100644
--- a/po/fr.po
+++ b/po/fr.po
@@ -5991,7 +5991,7 @@ msgid "Can't write a block bitmap"
 msgstr "Ne peut =E9crire un bitmap de blocs"
=20
 #: lib/ext2fs/ext2_err.c:41
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "Ne peut lire un bitmap de blocs"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/id.po b/po/id.po
index fb4e8fb..61ccea4 100644
--- a/po/id.po
+++ b/po/id.po
@@ -6032,7 +6032,7 @@ msgstr "membaca inode dan blok bitmap"
=20
 #: lib/ext2fs/ext2_err.c:41
 #, fuzzy
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "membaca inode dan blok bitmap"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/it.po b/po/it.po
index ba8ba61..7ba7d71 100644
--- a/po/it.po
+++ b/po/it.po
@@ -6093,7 +6093,7 @@ msgstr "lettura delle mappe di bit inode e blocco=
"
=20
 #: lib/ext2fs/ext2_err.c:41
 #, fuzzy
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "lettura delle mappe di bit inode e blocco"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/nl.po b/po/nl.po
index b98cb32..74e337f 100644
--- a/po/nl.po
+++ b/po/nl.po
@@ -5986,7 +5986,7 @@ msgid "Can't write a block bitmap"
 msgstr "Kan een blok-bitkaart niet schrijven"
=20
 #: lib/ext2fs/ext2_err.c:41
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "Kan een blok-bitkaart niet lezen"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/pl.po b/po/pl.po
index 62fac2e..d7d2498 100644
--- a/po/pl.po
+++ b/po/pl.po
@@ -5950,7 +5950,7 @@ msgid "Can't write a block bitmap"
 msgstr "Nie mo=BFna zapisa=E6 bitmapy blok=F3w"
=20
 #: lib/ext2fs/ext2_err.c:41
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "Nie mo=BFna odczyta=E6 bitmapy blok=F3w"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/sv.po b/po/sv.po
index d89370e..53e9da6 100644
--- a/po/sv.po
+++ b/po/sv.po
@@ -5956,7 +5956,7 @@ msgid "Can't write a block bitmap"
 msgstr "Kan inte skriva en blockbitkarta"
=20
 #: lib/ext2fs/ext2_err.c:41
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "Kan inte l=C3=A4sa en blockbitkarta"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/tr.po b/po/tr.po
index c677675..69d6787 100644
--- a/po/tr.po
+++ b/po/tr.po
@@ -6357,7 +6357,7 @@ msgstr "d=C3=BC=C4=9F=C3=BCm ve blok bite=C5=9Fle=
mleri okunuyor"
=20
 #: lib/ext2fs/ext2_err.c:41
 #, fuzzy
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "d=C3=BC=C4=9F=C3=BCm ve blok bite=C5=9Flemleri okunuyor"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/vi.po b/po/vi.po
index 736542e..a56afa5 100644
--- a/po/vi.po
+++ b/po/vi.po
@@ -5933,7 +5933,7 @@ msgid "Can't write a block bitmap"
 msgstr "Kh=C3=B4ng th=E1=BB=83 ghi m=E1=BA=A3ng =E1=BA=A3nh kh=E1=BB=91=
i"
=20
 #: lib/ext2fs/ext2_err.c:41
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "Kh=C3=B4ng th=E1=BB=83 =C4=91=E1=BB=8Dc m=E1=BA=A3ng =E1=BA=A3=
nh kh=E1=BB=91i"
=20
 #: lib/ext2fs/ext2_err.c:42
diff --git a/po/zh_CN.po b/po/zh_CN.po
index 77f4a22..f7ddd31 100644
--- a/po/zh_CN.po
+++ b/po/zh_CN.po
@@ -5649,7 +5649,7 @@ msgstr "=E5=9D=97=E4=BD=8D=E5=9B=BE"
=20
 #: lib/ext2fs/ext2_err.c:41
 #, fuzzy
-msgid "Can't read an block bitmap"
+msgid "Can't read a block bitmap"
 msgstr "=E5=9D=97=E4=BD=8D=E5=9B=BE"
=20
 #: lib/ext2fs/ext2_err.c:42

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
