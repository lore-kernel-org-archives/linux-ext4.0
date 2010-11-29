From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 01/15 RESEND] libext2fs: fix potential build failure with OMIT_COM_ERR
Date: Mon, 29 Nov 2010 17:55:03 +0900
Message-ID: <1291020917-8671-2-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45792 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab0K2Iz0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:26 -0500
Received: by ywl5 with SMTP id 5so1866777ywl.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:25 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This fixes following build failure when OMIT_COM_ERR is defined:

 lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_clear_generic_bit=
map=E2=80=99:
 lib/ext2fs/gen_bitmap.c:437: error: invalid storage class for function=
 =E2=80=98ext2fs_test_clear_generic_bitmap_range=E2=80=99
 lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statement =
at end of input
 lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_get_generic_bitma=
p_end=E2=80=99:
 lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statement =
at end of input
 lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_get_generic_bitma=
p_start=E2=80=99:
 lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statement =
at end of input
 lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_unmark_generic_bi=
tmap=E2=80=99:
 lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statement =
at end of input
 lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_mark_generic_bitm=
ap=E2=80=99:
 lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statement =
at end of input
 lib/ext2fs/gen_bitmap.c: In function =E2=80=98ext2fs_test_generic_bitm=
ap=E2=80=99:
 lib/ext2fs/gen_bitmap.c:559: error: expected declaration or statement =
at end of input
make[2]: *** [gen_bitmap.o] Error 1
make[2]: Leaving directory e2fsprogs/lib/ext2fs'
make[1]: *** [all-libs-recursive] Error 1
make[1]: Leaving directory e2fsprogs'
make: *** [all] Error 2

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/ext2fs/gen_bitmap.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index 99bf28d..eded435 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -178,9 +178,9 @@ int ext2fs_test_generic_bitmap(ext2fs_generic_bitma=
p bitmap,
 #ifndef OMIT_COM_ERR
 		com_err(0, EXT2_ET_MAGIC_GENERIC_BITMAP,
 			"test_bitmap(%lu)", (unsigned long) bitno);
+#endif
 		return 0;
 	}
-#endif
=20
 	if ((bitno < bitmap->start) || (bitno > bitmap->end)) {
 		ext2fs_warn_bitmap2(bitmap, EXT2FS_TEST_ERROR, bitno);
@@ -200,9 +200,9 @@ int ext2fs_mark_generic_bitmap(ext2fs_generic_bitma=
p bitmap,
 #ifndef OMIT_COM_ERR
 		com_err(0, EXT2_ET_MAGIC_GENERIC_BITMAP,
 			"mark_bitmap(%lu)", (unsigned long) bitno);
+#endif
 		return 0;
 	}
-#endif
=20
 	if ((bitno < bitmap->start) || (bitno > bitmap->end)) {
 		ext2fs_warn_bitmap2(bitmap, EXT2FS_MARK_ERROR, bitno);
@@ -222,9 +222,9 @@ int ext2fs_unmark_generic_bitmap(ext2fs_generic_bit=
map bitmap,
 #ifndef OMIT_COM_ERR
 		com_err(0, EXT2_ET_MAGIC_GENERIC_BITMAP,
 			"mark_bitmap(%lu)", (unsigned long) bitno);
+#endif
 		return 0;
 	}
-#endif
=20
 	if ((bitno < bitmap->start) || (bitno > bitmap->end)) {
 		ext2fs_warn_bitmap2(bitmap, EXT2FS_UNMARK_ERROR, bitno);
@@ -243,9 +243,9 @@ __u32 ext2fs_get_generic_bitmap_start(ext2fs_generi=
c_bitmap bitmap)
 #ifndef OMIT_COM_ERR
 		com_err(0, EXT2_ET_MAGIC_GENERIC_BITMAP,
 			"get_bitmap_start");
+#endif
 		return 0;
 	}
-#endif
=20
 	return bitmap->start;
 }
@@ -260,9 +260,9 @@ __u32 ext2fs_get_generic_bitmap_end(ext2fs_generic_=
bitmap bitmap)
 #ifndef OMIT_COM_ERR
 		com_err(0, EXT2_ET_MAGIC_GENERIC_BITMAP,
 			"get_bitmap_end");
+#endif
 		return 0;
 	}
-#endif
 	return bitmap->end;
 }
=20
@@ -277,9 +277,9 @@ void ext2fs_clear_generic_bitmap(ext2fs_generic_bit=
map bitmap)
 #ifndef OMIT_COM_ERR
 		com_err(0, EXT2_ET_MAGIC_GENERIC_BITMAP,
 			"clear_generic_bitmap");
+#endif
 		return;
 	}
-#endif
=20
 	memset(bitmap->bitmap, 0,
 	       (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1));
--=20
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
