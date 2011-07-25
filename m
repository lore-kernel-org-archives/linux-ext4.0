From: Utako Kusaka <u-kusaka@wm.jp.nec.com>
Subject: [PATCH] ext4: Add missing cast in ext4_fallocate
Date: Mon, 25 Jul 2011 16:33:49 +0900
Message-ID: <4E2D1C5D.6070103@wm.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55675 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYHeU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jul 2011 03:34:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Cast map.m_lblk to loff_t.

File size is corrupt when we get an ENOSPC.
Logical block number is __u32, so new_size will be set to overflowed value.

# df -T /mnt/mp1
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda6     ext4     9843276    153056   9190200   2% /mnt/mp1
# fallocate -o 0 -l 2199023251456 /mnt/mp1/testfile
fallocate: /mnt/mp1/testfile: fallocate failed: No space left on device
# stat /mnt/mp1/testfile
  File: `/mnt/mp1/testfile'
  Size: 4293656576	Blocks: 19380440   IO Block: 4096   regular file
Device: 806h/2054d	Inode: 12          Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2011-07-25 13:01:31.414490496 +0900
Modify: 2011-07-25 13:01:31.414490496 +0900
Change: 2011-07-25 13:01:31.454490495 +0900

Signed-off-by: Utako Kusaka <u-kusaka@wm.jp.nec.com>
--
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f815cc8..a082f43 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3835,7 +3835,7 @@ retry:
 						blkbits) >> blkbits))
 			new_size = offset + len;
 		else
-			new_size = (map.m_lblk + ret) << blkbits;
+			new_size = ((loff_t)map.m_lblk + ret) << blkbits;

 		ext4_falloc_update_inode(inode, mode, new_size,
 					 (map.m_flags & EXT4_MAP_NEW));


