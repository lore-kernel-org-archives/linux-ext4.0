From: akpm@linux-foundation.org
Subject: [patch 52/64] ext3: fix online resize bug
Date: Thu, 05 Jun 2008 22:46:47 -0700
Message-ID: <200806060546.m565klxX016020@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jbacik@redhat.com, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbYFFFrX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 01:47:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Josef Bacik <jbacik@redhat.com>

There is a bug when we are trying to verify that the reserve inode's
double indirect blocks point back to the primary gdt blocks.  The fix is
obvious, we need to mod the gdb count by the addr's per block.  You can
verify this with the following test case

dd if=/dev/zero of=disk1 seek=1024 count=1 bs=100M
losetup /dev/loop1 disk1
pvcreate /dev/loop1
vgcreate loopvg1 /dev/loop1
lvcreate -l 100%VG loopvg1 -n looplv1
mkfs.ext3 -J size=64 -b 1024 /dev/loopvg1/looplv1
mount /dev/loopvg1/looplv1 /mnt/loop
dd if=/dev/zero of=disk2 seek=1024 count=1 bs=50M
losetup /dev/loop2 disk2
pvcreate /dev/loop2
vgextend loopvg1 /dev/loop2
lvextend -l 100%VG /dev/loopvg1/looplv1
resize2fs /dev/loopvg1/looplv1

without this patch the resize2fs fails, with it the resize2fs succeeds.

Signed-off-by: Josef Bacik <jbacik@redhat.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/resize.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/ext3/resize.c~ext3-fix-online-resize-bug fs/ext3/resize.c
--- a/fs/ext3/resize.c~ext3-fix-online-resize-bug
+++ a/fs/ext3/resize.c
@@ -580,7 +580,8 @@ static int reserve_backup_gdb(handle_t *
 	}
 
 	blk = EXT3_SB(sb)->s_sbh->b_blocknr + 1 + EXT3_SB(sb)->s_gdb_count;
-	data = (__le32 *)dind->b_data + EXT3_SB(sb)->s_gdb_count;
+	data = (__le32 *)dind->b_data + (EXT3_SB(sb)->s_gdb_count %
+					 EXT3_ADDR_PER_BLOCK(sb));
 	end = (__le32 *)dind->b_data + EXT3_ADDR_PER_BLOCK(sb);
 
 	/* Get each reserved primary GDT block and verify it holds backups */
_
