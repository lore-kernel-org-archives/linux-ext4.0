From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH][e2fsprogs] Move ext2fs_struct_generic_bitmap back into ext2fs.h
Date: Tue, 07 Aug 2007 16:16:39 -0500
Message-ID: <20070807211639.22127.99361.stgit@rx8>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:49836 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965979AbXHGVWI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Aug 2007 17:22:08 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l77LM78m018047
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 17:22:07 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l77LM7Ww141696
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 15:22:07 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l77LM7et021378
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 15:22:07 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l77LM6ji021364
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 15:22:07 -0600
Received: from [127.0.1.1] (rx8.austin.ibm.com [9.41.41.30])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l77LM6xH043946
	for <linux-ext4@vger.kernel.org>; Tue, 7 Aug 2007 16:22:06 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Move ext2fs_struct_generic_bitmap back into ext2fs.h

In Commit: f1f115a78f5ea599fc5f8815a741d43fedd5840d

The ext2fs_struct_generic_bitmap structure is remove from ext2fs.h and
put into gen_bitmap.c.  This breaks big endian compiles since swapfs.c
uses this structure as well if EXT2_BIG_ENDIAN_BITMAPS is defined.

Since we have multiple users, this patch move
ext2fs_struct_generic_bitmap back into ext2fs.h in order to compile on
PowerPC or other big endian archs.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/ext2fs.h     |   11 +++++++++++
 lib/ext2fs/gen_bitmap.c |   11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d1cda2f..f34d2f9 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -100,6 +100,17 @@ typedef __u32		ext2_dirhash_t;
 
 typedef struct struct_ext2_filsys *ext2_filsys;
 
+struct ext2fs_struct_generic_bitmap {
+	errcode_t	magic;
+	ext2_filsys 	fs;
+	__u32		start, end;
+	__u32		real_end;
+	char	*	description;
+	char	*	bitmap;
+	errcode_t	base_error_code;
+	__u32		reserved[7];
+};
+
 #define EXT2FS_MARK_ERROR 	0
 #define EXT2FS_UNMARK_ERROR 	1
 #define EXT2FS_TEST_ERROR	2
diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index 66172e5..3d01149 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -27,17 +27,6 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-struct ext2fs_struct_generic_bitmap {
-	errcode_t	magic;
-	ext2_filsys 	fs;
-	__u32		start, end;
-	__u32		real_end;
-	char	*	description;
-	char	*	bitmap;
-	errcode_t	base_error_code;
-	__u32		reserved[7];
-};
-
 /* 
  * Used by previously inlined function, so we have to export this and
  * not change the function signature
