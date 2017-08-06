From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH v3] ext4: reduce lock contention in __ext4_new_inode
Date: Sun,  6 Aug 2017 17:05:01 +0800
Message-ID: <20170806090501.45477-1-wshilong@ddn.com>
Cc: tytso@mit.edu, wshilong@ddn.com, adilger@dilger.ca, sihara@ddn.com,
        lixi@ddn.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35739 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751300AbdHFJF2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Aug 2017 05:05:28 -0400
Received: by mail-pf0-f196.google.com with SMTP id j68so6127011pfc.2
        for <linux-ext4@vger.kernel.org>; Sun, 06 Aug 2017 02:05:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wshilong@ddn.com>

While running number of creating file threads concurrently,
we found heavy lock contention on group spinlock:

FUNC                           TOTAL_TIME(us)       COUNT        AVG(us)
ext4_create                    1707443399           1440000      1185.72
_raw_spin_lock                 1317641501           180899929    7.28
jbd2__journal_start            287821030            1453950      197.96
jbd2_journal_get_write_access  33441470             73077185     0.46
ext4_add_nondir                29435963             1440000      20.44
ext4_add_entry                 26015166             1440049      18.07
ext4_dx_add_entry              25729337             1432814      17.96
ext4_mark_inode_dirty          12302433             5774407      2.13

most of cpu time blames to _raw_spin_lock, here is some testing
numbers with/without patch.

Test environment:
Server : SuperMicro Sever (2 x E5-2690 v3@2.60GHz, 128GB 2133MHz
         DDR4 Memory, 8GbFC)
Storage : 2 x RAID1 (DDN SFA7700X, 4 x Toshiba PX02SMU020 200GB
          Read Intensive SSD)

format command:
        mkfs.ext4 -J size=4096

test command:
        mpirun -np 48 mdtest -n 30000 -d /ext4/mdtest.out -F -C \
                -r -i 5 -v -p 10 -u

Kernel version: 4.13.0-rc3

Test  1,440,000 files with 48 directories by 48 processes:

Without patch:

File Creation   File removal
79,033          289,569 ops/per second
81,463          285,359
79,875          288,475
79,917          284,624
79,420          290,91

ith patch:
File Creation   File removal
609,982		281,461 ops/per second
611,971		276,029
612,027		280,225
611,159		282,631
611,001		271,177

Now creation performaces are improved about 8x with large journal size!!!!

The main problem here is we test inode bitmap and then lock and retest,
this might make us do repeat lock again and again which eat most of
cpu time.

the main reason we don't find free bit and set with lock held is we
need journal inode bitmap before test and set bit, however with
repeat logic, we could confirm journal stuff has been
properly setup after first try, another case is no journal
mode, however, that is not normal use, we could drop
to old way and schedule a bit for that.

Tested-by: Shuichi Ihara <sihara@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
v2->v3: new approach
---
 fs/ext4/ialloc.c | 46 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 507bfb3..de368f5 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -761,6 +761,7 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	ext4_group_t flex_group;
 	struct ext4_group_info *grp;
 	int encrypt = 0;
+	bool hold_lock;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -917,21 +918,48 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 			continue;
 		}
 
+		hold_lock = false;
 repeat_in_this_group:
+		/* if @hold_lock is ture, that means, journal
+		 * is properly setup and inode bitmap buffer is
+		 * journaled too, we can directly hold lock and
+		 * set bit if found, this will avoid lock contention
+		 * which make us retry again and again.
+		 */
+		if (hold_lock)
+			ext4_lock_group(sb, group);
+
 		ino = ext4_find_next_zero_bit((unsigned long *)
 					      inode_bitmap_bh->b_data,
 					      EXT4_INODES_PER_GROUP(sb), ino);
-		if (ino >= EXT4_INODES_PER_GROUP(sb))
+		if (ino >= EXT4_INODES_PER_GROUP(sb)) {
+			if (hold_lock)
+				ext4_unlock_group(sb, group);
 			goto next_group;
+		}
 		if (group == 0 && (ino+1) < EXT4_FIRST_INO(sb)) {
 			ext4_error(sb, "reserved inode found cleared - "
 				   "inode=%lu", ino + 1);
+			if (hold_lock)
+				ext4_unlock_group(sb, group);
 			continue;
 		}
+
+		if (hold_lock) {
+			ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
+			ext4_unlock_group(sb, group);
+			ino++;
+			if (!ret2)
+				goto got;
+			BUG_ON(1);
+		}
+
 		if ((EXT4_SB(sb)->s_journal == NULL) &&
 		    recently_deleted(sb, group, ino)) {
-			ino++;
-			goto next_inode;
+			if (++ino < EXT4_INODES_PER_GROUP(sb))
+				goto repeat_in_this_group;
+			else
+				goto next_group;
 		}
 		if (!handle) {
 			BUG_ON(nblocks <= 0);
@@ -950,15 +978,23 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 			ext4_std_error(sb, err);
 			goto out;
 		}
+
+		if (EXT4_SB(sb)->s_journal)
+			hold_lock = true;
+
 		ext4_lock_group(sb, group);
 		ret2 = ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data);
 		ext4_unlock_group(sb, group);
 		ino++;		/* the inode bitmap is zero-based */
 		if (!ret2)
 			goto got; /* we grabbed the inode! */
-next_inode:
-		if (ino < EXT4_INODES_PER_GROUP(sb))
+		if (ino < EXT4_INODES_PER_GROUP(sb)) {
+			/* make no journal mode happy too */
+			if (!EXT4_SB(sb)->s_journal && ext4_fs_is_busy(sbi))
+				schedule_timeout_uninterruptible(
+					msecs_to_jiffies(1));
 			goto repeat_in_this_group;
+		}
 next_group:
 		if (++group == ngroups)
 			group = 0;
-- 
2.9.3
