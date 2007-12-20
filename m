From: akpm@linux-foundation.org
Subject: - ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:55 -0800
Message-ID: <200712202338.lBKNct6d019015@imap1.linux-foundation.org>
To: sandeen@redhat.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757568AbXLTXsO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2007 18:48:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: fix freespace accounting with mballoc on 32bit machines
has been removed from the -mm tree.  Its filename was
     ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: fix freespace accounting with mballoc on 32bit machines
From: Eric Sandeen <sandeen@redhat.com>

On a 32bit machine, passing the negative unsigned long fe_len
into percpu_counter_add (which expects s64) messes up the counters:

[root@bear-05 linux-2.6.23-rc7]# df -h

Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb7              97G -149P  149P   -  /mnt/test

Patch below fixes this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/mballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/mballoc.c~ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines fs/ext4/mballoc.c
--- a/fs/ext4/mballoc.c~ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines
+++ a/fs/ext4/mballoc.c
@@ -3005,7 +3005,7 @@ static int ext4_mb_mark_diskspace_used(s
 				- ac->ac_b_ex.fe_len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
-	percpu_counter_add(&sbi->s_freeblocks_counter, - ac->ac_b_ex.fe_len);
+	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
 
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
 	if (err)
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ecryptfs-fix-string-overflow-on-long-cipher-names.patch
ecryptfs-fix-unlocking-in-error-paths.patch
ecryptfs-redo-dgetmntget-on-dentry_open-failure.patch
hfs-handle-more-on-disk-corruptions-without-oopsing.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ext3-change-the-default-behaviour-on-error.patch
