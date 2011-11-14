From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH v3 07/11] e4defrag: Allow user who can use reserved blocks
 to defrag
Date: Mon, 14 Nov 2011 15:24:49 +0900
Message-ID: <4EC0B431.20802@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:51595 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1KNGiI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Nov 2011 01:38:08 -0500
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id pAE6c6MU024500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 14 Nov 2011 15:38:06 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix free blocks check for general users to use the reserved blocks because
they can use reserved blocks in the following cases:
- the users are specified by mount option resuid/resgid
- e4defrag has CAP_SYS_RESOURCE capability

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 misc/e4defrag.c |   37 +++++++------------------------------
 1 file changed, 7 insertions(+), 30 deletions(-)
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index effd774..45e9b72 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -471,12 +471,15 @@ static int defrag_fadvise(int fd, struct move_extent defrag_data,
  * @fd:			defrag target file's descriptor.
  * @file:		file name.
  * @blk_count:		file blocks.
+ *
+ * Note that the users who cannot use the reserved blocks might pass this
+ * free space check though there is no free blocks except for reserved blocks.
+ * In this case, they can catch ENOSPC when donor file is created by fallocate
+ * in file_defrag(). So, it's no problem.
  */
 static int check_free_size(int fd, const char *file, ext4_fsblk_t blk_count)
 {
-	ext4_fsblk_t	free_blk_count;
 	struct statfs64	fsbuf;
-	uid_t		current_uid = getuid();
 
 	if (fstatfs64(fd, &fsbuf) < 0) {
 		if (mode_flag & DETAIL) {
@@ -487,16 +490,7 @@ static int check_free_size(int fd, const char *file, ext4_fsblk_t blk_count)
 		return -1;
 	}
 
-	/* Compute free space for root and normal user separately */
-	if (current_uid == ROOT_UID)
-		free_blk_count = fsbuf.f_bfree;
-	else
-		free_blk_count = fsbuf.f_bavail;
-
-	if (free_blk_count >= blk_count)
-		return 0;
-
-	return -ENOSPC;
+	return (fsbuf.f_bfree >= blk_count) ? 0 : -ENOSPC;
 }
 
 /*
@@ -768,23 +762,6 @@ static int get_exts_count(struct fiemap_extent_list *ext_list_head)
 	return ret;
 }
 
-/* get_file_blocks() -  Get total file blocks.
- *
- * @ext_list_head:	the extent list head of the target file
- */
-static ext4_fsblk_t get_file_blocks(struct fiemap_extent_list *ext_list_head)
-{
-	ext4_fsblk_t blk_count = 0;
-	struct fiemap_extent_list *ext_list_tmp = ext_list_head;
-
-	do {
-		blk_count += ext_list_tmp->data.len;
-		ext_list_tmp = ext_list_tmp->next;
-	} while (ext_list_tmp != ext_list_head);
-
-	return blk_count;
-}
