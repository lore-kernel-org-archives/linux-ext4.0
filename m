From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] ext4: memory leakage in ext4_mb_free_blocks()
Date: Wed, 24 Mar 2010 21:55:55 +0800
Message-ID: <ac8f92701003240655i32c5cfesf95651b96b812c66@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:63010 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab0CXOCj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 10:02:39 -0400
Received: by yxe26 with SMTP id 26so2826649yxe.23
        for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 07:02:38 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Wed Mar 24 21:54:22     2010

There is memory leakage in ext4_mb_free_blocks(), if error, double
free of blocks, occurs in ext4_mb_free_metadata().

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc8.c	2010-03-24 21:46:50.000000000 +0800
@@ -4419,7 +4419,8 @@ ext4_mb_free_metadata(handle_t *handle,
 	spin_lock(&sbi->s_md_lock);
 	list_add(&new_entry->list, &handle->h_transaction->t_private_list);
 	spin_unlock(&sbi->s_md_lock);
-	return 0;
+	/* info the caller new_entry is used */
+	return 1;
 }

 /*
@@ -4547,7 +4548,8 @@ do_more:

 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count);
-		ext4_mb_free_metadata(handle, &e4b, new_entry);
+		if (0 == ext4_mb_free_metadata(handle, &e4b, new_entry))
+			kmem_cache_free(ext4_free_ext_cachep, new_entry);
 	} else {
 		/* need to update group_info->bb_free and bitmap
 		 * with group lock held. generate_buddy look at
