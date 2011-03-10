From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: don't kfree uninitialized s_group_info members
Date: Thu, 10 Mar 2011 17:03:15 -0600
Message-ID: <4D7958B3.8070309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: dame_eugene@mail.ru
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab1CJXDU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Mar 2011 18:03:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Per kernel.org bugzilla #30872 we may call kfree on uninitialized
members of the s_group_info array.  We can avoid this by kzalloc'ing
the array, and only freeing them on the error path if they are
non-zero.

This doesn't entirely solve the oops on mount if we fail down this
path; failed_mount4: frees the sbi, for one, which gets referenced
later in the failed mount paths - I haven't worked that out yet.

Reported-by: Eugene A. Shatokhin <dame_eugene@mail.ru>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d1fe09a..e56befe 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2381,7 +2381,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	/* An 8TB filesystem with 64-bit pointers requires a 4096 byte
 	 * kmalloc. A 128kb malloc should suffice for a 256TB filesystem.
 	 * So a two level scheme suffices for now. */
-	sbi->s_group_info = kmalloc(array_size, GFP_KERNEL);
+	sbi->s_group_info = kzalloc(array_size, GFP_KERNEL);
 	if (sbi->s_group_info == NULL) {
 		printk(KERN_ERR "EXT4-fs: can't allocate buddy meta group\n");
 		return -ENOMEM;
@@ -2412,7 +2412,8 @@ err_freebuddy:
 		kmem_cache_free(cachep, ext4_get_group_info(sb, i));
 	i = num_meta_group_infos;
 	while (i-- > 0)
-		kfree(sbi->s_group_info[i]);
+		if (sbi->s_group_info[i])
+			kfree(sbi->s_group_info[i]);
 	iput(sbi->s_buddy_cache);
 err_freesgi:
 	kfree(sbi->s_group_info);
