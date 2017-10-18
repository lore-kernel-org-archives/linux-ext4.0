From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: improve smp scalability for inode generation
Date: Wed, 18 Oct 2017 21:08:21 +0300
Message-ID: <87376gpbvu.fsf@openvz.org>
References: <8760bcpdc8.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:52884 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdJRSEf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Oct 2017 14:04:35 -0400
Received: by mail-lf0-f68.google.com with SMTP id b190so6766736lfg.9
        for <linux-ext4@vger.kernel.org>; Wed, 18 Oct 2017 11:04:34 -0700 (PDT)
In-Reply-To: <8760bcpdc8.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain


Dmitry Monakhov <dmonakhov@openvz.org> writes:

> ->s_next_generation is protected by s_next_gen_lock but it usage
> pattern is very primitive and can be replaced with atomic_ops
>
> This significantly improve creation/unlink scenario on SMP systems,
> for example lat_fs_create_unlink test [1] on x2 E5-2680 (32vcpu) system
> shows ~20% improvement.
> | nr_tsk | wo/ patch | w/ patch |
> |--------+-----------+----------|
> |      1 |       137 |      140 |
> |      2 |       224 |      233 |
> |      4 |       356 |      372 |
> |      8 |       439 |      519 |
> |     16 |       443 |      585 |
> |     32 |       598 |      695 |
> |     64 |       559 |      707 |
> |    128 |       385 |      437 |

FYI with lazytime enabled lat_fs_create_unlink is ~16x times slower.
The reason is quite obvious ext4_update_other_inodes_time() increase
lock contention for inode_hash_lock (4k/256) times.

->ext4_do_update_inode
  ->ext4_update_other_inodes_time
    for (i = 0; i < inodes_per_block; i++, ino++, buf += inode_size)
      ->find_inode_nowait
        ->spin_lock(&inode_hash_lock) -> 16x contention increase

inode_hash_lock is known problem. I have patches to convert inode_hash_table
per bucket lock similar to dentry_hash, but this require massige changes in
various filesystems so will require a lot of time to be merged.

Currently lazytime amplify it significantly. May be it is reasonable to
use spin_trylock inside find_inode_nowait to make it true lightweight hint?


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=lazytime_trylock.patch

diff --git a/fs/inode.c b/fs/inode.c
index d1e35b5..a5b1cba1 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1360,7 +1360,9 @@ struct inode *find_inode_nowait(struct super_block *sb,
 	struct inode *inode, *ret_inode = NULL;
 	int mval;
 
-	spin_lock(&inode_hash_lock);
+	if (!spin_trylock(&inode_hash_lock))
+		return NULL;
+
 	hlist_for_each_entry(inode, head, i_hash) {
 		if (inode->i_sb != sb)
 			continue;

--=-=-=--
