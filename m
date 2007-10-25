From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: fix freespace accounting with mballoc on 32bit machines
Date: Thu, 25 Oct 2007 15:08:06 -0500
Message-ID: <4720F7A6.9060905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Tomas <alex@clusterfs.com>, Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbXJYUKw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2007 16:10:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On a 32bit machine, passing the negative unsigned long fe_len
into percpu_counter_add (which expects s64) messes up the counters:

[root@bear-05 linux-2.6.23-rc7]# df -h

Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb7              97G -149P  149P   -  /mnt/test

Patch below fixes this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

--- linux.orig/fs/ext4/mballoc.c	2007-10-25 14:47:25.048435451 -0500
+++ linux/fs/ext4/mballoc.c	2007-10-25 14:47:35.815160682 -0500
@@ -3005,7 +3005,7 @@
 				- ac->ac_b_ex.fe_len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
-	percpu_counter_add(&sbi->s_freeblocks_counter, - ac->ac_b_ex.fe_len);
+	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
 
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
 	if (err)
