From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] ext4: verify extent header depth
Date: Wed,  6 Jul 2016 23:27:11 +0200
Message-ID: <1467840431-24550-1-git-send-email-vegard.nossum@oracle.com>
Cc: linux-ext4@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29603 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbcGFV1W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2016 17:27:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

According to the wiki [1], eh_depth cannot be larger than 5:

    Depth of this extent node in the extent tree. 0 = this extent node
    points to data blocks; otherwise, this extent node points to other
    extent nodes. The extent tree can be at most 5 levels deep: a logical
    block number can be at most 2^32, and the smallest n that satisfies
    4*(((blocksize - 12)/12)^n) >= 2^32 is 5.

[1]: https://ext4.wiki.kernel.org/index.php/Ext4_Disk_Layout#Extent_Tree

Without this, we can end up trying to reserve too much space for the
transaction in case of malicious corruption (here, eh_depth = 65280):

    JBD2: ext4.exe wants too many credits credits:195849 rsv_credits:0 max:256
    ------------[ cut here ]------------
    WARNING: CPU: 0 PID: 50 at fs/jbd2/transaction.c:293 start_this_handle+0x569/0x580
    CPU: 0 PID: 50 Comm: ext4.exe Not tainted 4.7.0-rc5+ #508
    Stack:
     604a8947 625badd8 0002fd09 00000000
     60078643 00000000 62623910 601bf9bc
     62623970 6002fc84 626239b0 900000125
    Call Trace:
     [<6001c2dc>] show_stack+0xdc/0x1a0
     [<601bf9bc>] dump_stack+0x2a/0x2e
     [<6002fc84>] __warn+0x114/0x140
     [<6002fdff>] warn_slowpath_null+0x1f/0x30
     [<60165829>] start_this_handle+0x569/0x580
     [<60165d4e>] jbd2__journal_start+0x11e/0x220
     [<60146690>] __ext4_journal_start_sb+0x60/0xa0
     [<60120a81>] ext4_truncate+0x131/0x3a0
     [<60123677>] ext4_setattr+0x757/0x840
     [<600d5d0f>] notify_change+0x16f/0x2a0
     [<600b2b16>] do_truncate+0x76/0xc0
     [<600c3e56>] path_openat+0x806/0x1300
     [<600c55c9>] do_filp_open+0x89/0xf0
     [<600b4074>] do_sys_open+0x134/0x1e0
     [<600b4140>] SyS_open+0x20/0x30
     [<6001ea68>] handle_syscall+0x88/0x90
     [<600295fd>] userspace+0x3fd/0x500
     [<6001ac55>] fork_handler+0x85/0x90

    ---[ end trace 08b0b88b6387a244 ]---

Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fs/ext4/extents.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 30de10a..b584ddd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -476,6 +476,10 @@ static int __ext4_ext_check(const char *function, unsigned int line,
 		error_msg = "invalid extent entries";
 		goto corrupted;
 	}
+	if (unlikely(depth > 5)) {
+		error_msg = "too large eh_depth";
+		goto corrupted;
+	}
 	/* Verify checksum on non-root extent tree nodes */
 	if (ext_depth(inode) != depth &&
 	    !ext4_extent_block_csum_verify(inode, eh)) {
-- 
1.9.1

