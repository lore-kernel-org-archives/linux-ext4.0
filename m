From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH v2] ext4: reduce lock contention in __ext4_new_inode
Date: Sat,  5 Aug 2017 11:04:36 +0800
Message-ID: <20170805030436.32314-1-wshilong@ddn.com>
Cc: tytso@mit.edu, wshilong@ddn.com, adilger@dilger.ca, sihara@ddn.com,
        lixi@ddn.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38073 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdHEDEz (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Aug 2017 23:04:55 -0400
Received: by mail-pg0-f67.google.com with SMTP id 123so3303387pga.5
        for <linux-ext4@vger.kernel.org>; Fri, 04 Aug 2017 20:04:55 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
302,600         312,813 ops/per second
295,644         316,557
288,125         306,961
302,960         310,517
295,175         311,927

Now create and removal performaces are similar, and creation
performaces are improved more than 3x with large journal size.
In default journal size, performances are improved by 50%.

Tested-by: Shuichi Ihara <sihara@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
v1->v2: use ext4_fs_is_busy() helper.
---
 fs/ext4/ialloc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 507bfb3..19323ea 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -957,8 +957,13 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		if (!ret2)
 			goto got; /* we grabbed the inode! */
 next_inode:
-		if (ino < EXT4_INODES_PER_GROUP(sb))
+		if (ino < EXT4_INODES_PER_GROUP(sb)) {
+			/* Lock contention, relax a bit */
+			if (ext4_fs_is_busy(sbi))
+				schedule_timeout_uninterruptible(
+						msecs_to_jiffies(1));
 			goto repeat_in_this_group;
+		}
 next_group:
 		if (++group == ngroups)
 			group = 0;
-- 
2.9.3
