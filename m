From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] replace MAX_DEFRAG_SIZE with EXT_MAX_BLOCK
Date: Mon, 14 Sep 2009 15:29:35 -0500
Message-ID: <4AAEA7AF.6080801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933929AbZINU3e (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Sep 2009 16:29:34 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8EKTb7h006977
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2009 16:29:37 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n8EKTZ3D023266
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2009 16:29:36 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There's no reason to redefine the maximum allowable offset
in an extent-based file just for defrag; 
EXT_MAX_BLOCK already does this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1147994..0bd094f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -459,7 +459,6 @@ struct move_extent {
 	__u64 len;		/* block length to be moved */
 	__u64 moved_len;	/* moved block length */
 };
-#define MAX_DEFRAG_SIZE         ((1UL<<31) - 1)
 
 #define EXT4_EPOCH_BITS 2
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 20a8410..7cbe9a7 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -138,6 +138,7 @@ typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
 #define EXT_BREAK      1
 #define EXT_REPEAT     2
 
+/* Maximum logical block in a file; ext4_extent's ee_block is __le32 */
 #define EXT_MAX_BLOCK	0xffffffff
 
 /*
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index bbf2dd9..92bf922 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -960,12 +960,12 @@ mext_check_arguments(struct inode *orig_inode,
 		return -EINVAL;
 	}
 
-	if ((orig_start > MAX_DEFRAG_SIZE) ||
-	    (donor_start > MAX_DEFRAG_SIZE) ||
-	    (*len > MAX_DEFRAG_SIZE) ||
-	    (orig_start + *len > MAX_DEFRAG_SIZE))  {
-		ext4_debug("ext4 move extent: Can't handle over [%lu] blocks "
-			"[ino:orig %lu, donor %lu]\n", MAX_DEFRAG_SIZE,
+	if ((orig_start > EXT_MAX_BLOCK) ||
+	    (donor_start > EXT_MAX_BLOCK) ||
+	    (*len > EXT_MAX_BLOCK) ||
+	    (orig_start + *len > EXT_MAX_BLOCK))  {
+		ext4_debug("ext4 move extent: Can't handle over [%u] blocks "
+			"[ino:orig %lu, donor %lu]\n", EXT_MAX_BLOCK,
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}

