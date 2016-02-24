From: <zhangaihua1@huawei.com>
Subject: [PATCH] fix waring calltrace when usb was ejected.
Date: Wed, 24 Feb 2016 12:25:21 +0800
Message-ID: <1456287921-8961-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: zhangaihua <zhangaihua1@huawei.com>
To: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:2873 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932188AbcBXEWM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Feb 2016 23:22:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: zhangaihua <zhangaihua1@huawei.com>

When the usb was ejected, the bdi will be unregistered without telling
anyone else. Once this happens, will cause a kernel warning calltrace.

We can fix it by adding check before __mark_inode_dirty like ext4 in
ext4_commit_super().

The  calltrace :
[ 191.767446] ------------[ cut here ]------------
[ 191.767449] WARNING: at fs/fs-writeback.c:2065
[ 191.767452] Modules linked in:
[ 191.767455]
[ 191.767459] CPU: 9 PID: 1451 Comm: ls Not tainted 4.4.0+ #6
[ 191.767463] Hardware name: Hisilicon PhosphorHi1382 EVB (DT)
[ 191.767466] task: ffffffc00e130c00 ti: ffffffc0d2a88000 task.ti:
ffffffc0d2a88000
[ 191.767478] PC is at __mark_inode_dirty+0x2b0/0x3d0
[ 191.767482] LR is at __mark_inode_dirty+0x2b0/0x3d0
[ 191.767484] pc : [<ffffffc000278490>] lr : [<ffffffc000278490>]
pstate: 80000145
[ 191.767487] sp : ffffffc0d2a8bd80
[ 191.767489] x29: ffffffc0d2a8bd80 x28: ffffffc0d2a88000
[ 191.767493] x27: ffffffc000ccd000 x26: 000000000000003d
[ 191.767498] x25: 000000000000011d x24: ffffffc00d570140
[ 191.767502] x23: 0000000000000000 x22: 0000000000000000
[ 191.767505] x21: ffffffc00d5700b8 x20: ffffffc0d3f201e0
[ 191.767509] x19: 0000000000000001 x18: 0000000000000000
[ 191.767513] x17: 00000000004b59f0 x16: ffffffc00025a640
[ 191.767517] x15: 0000007ff9236214 x14: 0ffffffffffffffe
[ 191.767521] x13: 0000000000000028 x12: 0101010101010101
[ 191.767524] x11: ffffffc0d2a8bac0 x10: ffffffc0d2a8bac0
[ 191.767528] x9 : ffffffd000000000 x8 : 6769737465726564
[ 191.767532] x7 : 0000000000000263 x6 : ffffffc0014d7377
[ 191.767536] x5 : 0000000000000005 x4 : 0000000000000002
[ 191.767539] x3 : ffffffc0014d6dda x2 : 0000000000000018
[ 191.767543] x1 : 0000000000000001 x0 : 0000000000000018
[ 191.767546]
[ 191.767549] ---[ end trace 67962b8750ae0a5b ]---
[ 191.767551] Call trace:
[ 191.767556] [<ffffffc000278490>] __mark_inode_dirty+0x2b0/0x3d0
[ 191.767561] [<ffffffc000262570>] generic_update_time+0x90/0xd0
[ 191.767565] [<ffffffc000264220>] touch_atime+0xa0/0xc0
[ 191.767571] [<ffffffc00025a1b0>] iterate_dir+0x100/0x140
[ 191.767575] [<ffffffc00025a6cc>] SyS_getdents64+0x8c/0x120
[ 191.767582] [<ffffffc000084cb0>] el0_svc_naked+0x24/0x28
[ 191.767644] EXT2-fs (sda1): previous I/O error to superblock detected
[ 191.767644]
[ 191.767654] EXT2-fs (sda1): error: ext2_get_inode: unable to read
inode block - inode=11, block=234
[ 191.767684] EXT2-fs (sda1): previous I/O error to superblock detected
[ 191.767684]
[ 191.767691] EXT2-fs (sda1): error: ext2_get_inode: unable to read
inode block - inode=12, block=234
[ 539.516201] EXT2-fs (sda1): previous I/O error to superblock detected
[ 539.516201]
[ 539.516210] EXT2-fs (sda1): error: ext2_get_inode: unable to read
inode block - inode=11, block=234
[ 539.516240] EXT2-fs (sda1): previous I/O error to superblock detected
[ 539.516240]
[ 539.516247] EXT2-fs (sda1): error: ext2_get_inode: unable to read
inode block - inode=12, block=234

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
---
 fs/ext4/super.c    | 3 ++-
 fs/fs-writeback.c  | 3 +++
 include/linux/fs.h | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ed01ec..15d9c4e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -354,13 +354,14 @@ static void save_error_info(struct super_block *sb, const char *func,
  * This is a kludge to prevent these oops until we can put in a proper
  * hook in del_gendisk() to inform the VFS and file system layers.
  */
-static int block_device_ejected(struct super_block *sb)
+int block_device_ejected(struct super_block *sb)
 {
 	struct inode *bd_inode = sb->s_bdev->bd_inode;
 	struct backing_dev_info *bdi = inode_to_bdi(bd_inode);
 
 	return bdi->dev == NULL;
 }
+EXPORT_SYMBOL(block_device_ejected);
 
 static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
 {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6915c95..66b1941 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1985,6 +1985,9 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 	struct super_block *sb = inode->i_sb;
 	int dirtytime;
 
+	if (block_device_ejected(sb))
+		return;
+
 	trace_writeback_mark_inode_dirty(inode, flags);
 
 	/*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ae68100..0c40338 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3075,6 +3075,8 @@ static inline bool dir_relax(struct inode *inode)
 	return !IS_DEADDIR(inode);
 }
 
+int block_device_ejected(struct super_block *sb);
+
 extern bool path_noexec(const struct path *path);
 extern void inode_nohighmem(struct inode *inode);
 
-- 
1.9.3

