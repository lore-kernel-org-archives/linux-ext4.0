From: akpm@linux-foundation.org
Subject: + ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch added to -mm tree
Date: Thu, 25 Oct 2007 14:37:55 -0700
Message-ID: <200710252137.l9PLbt58025275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix freespace accounting with mballoc on 32bit machines
has been added to the -mm tree.  Its filename is
     ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3036,7 +3036,7 @@ static int ext4_mb_mark_diskspace_used(s
 				- ac->ac_b_ex.fe_len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
-	percpu_counter_add(&sbi->s_freeblocks_counter, - ac->ac_b_ex.fe_len);
+	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
 
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
 	if (err)
_

Patches currently in -mm which might be from sandeen@redhat.com are

ext2-change-the-default-behaviour-on-error.patch
ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
ext3-change-the-default-behaviour-on-error.patch
