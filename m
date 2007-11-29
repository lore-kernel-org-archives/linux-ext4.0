From: akpm@linux-foundation.org
Subject: [patch 4/8] ext4: fix freespace accounting with mballoc on 32bit machines
Date: Thu, 29 Nov 2007 12:52:50 -0800
Message-ID: <200711292052.lATKqouX006834@imap1.linux-foundation.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, sandeen@redhat.com
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758001AbXK2UyI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Nov 2007 15:54:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
