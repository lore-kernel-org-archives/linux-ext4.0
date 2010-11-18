From: Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] ext4: Fix 'return 0' for error case in ext4_fill_super
Date: Thu, 18 Nov 2010 22:47:12 +0100
Message-ID: <1290116832-29443-1-git-send-email-joro@8bytes.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joerg Roedel <joro@8bytes.org>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The ext4_fill_super may return with value 0 in case of an error. The
reason is that the ret variable is used to store the return value of a
called function and is not set back to an error value later on.
This issue caused a NULL pointer de-ref in vfs_kern_mount on one of my
machines when it tried to mount a partition:

	BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
	IP: [<ffffffff8112e8dc>] vfs_kern_mount+0x7c/0x180
	PGD 218480067 PUD 225323067 PMD 0
	Oops: 0000 [#1] SMP
	last sysfs file: /sys/devices/system/cpu/cpu5/cache/index2/shared_cpu_map
	CPU 1

	...

	Process mount (pid: 3591, threadinfo ffff8802258fc000, task ffff88022586dac0)
	Stack:
	 ffff8802258fde38 0000000000000000 ffff880225e299b0 ffff880200000001
	 ffffffff81a230e0 ffff880225e2c818 ffff8802258fde88 ffffffff8112ea52
	 ffff8802258fde98 0000000000000246 ffff88022586dac0 0000000000000060
	Call Trace:
	 [<ffffffff8112ea52>] do_kern_mount+0x52/0x130
	 [<ffffffff811497ff>] do_mount+0x2bf/0x810
	 [<ffffffff810face3>] ? strndup_user+0x53/0x70
	 [<ffffffff81149de0>] sys_mount+0x90/0xe0
	 [<ffffffff81002fdb>] system_call_fastpath+0x16/0x1b

This patch fixes the issue by using the 'err' variable instead of 'ret'
for that function-call like it is done in for all other function-calls
in ext4_fill_super too.
If have seen this issue on 2.6.36 too, so this patch may be -stable
material as well.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 fs/ext4/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 61182fe..499cf5d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3268,9 +3268,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 * Test whether we have more sectors than will fit in sector_t,
 	 * and whether the max offset is addressable by the page cache.
 	 */
-	ret = generic_check_addressable(sb->s_blocksize_bits,
+	err = generic_check_addressable(sb->s_blocksize_bits,
 					ext4_blocks_count(es));
-	if (ret) {
+	if (err) {
 		ext4_msg(sb, KERN_ERR, "filesystem"
 			 " too large to mount safely on this system");
 		if (sizeof(sector_t) < 8)
-- 
1.7.0.4
