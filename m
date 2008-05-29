From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH 1/2] EXT3: fix online resize bug
Date: Thu, 29 May 2008 14:17:07 -0400
Message-ID: <20080529181707.GF23090@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757618AbYE2S0P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2008 14:26:15 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

There is a bug when we are trying to verify that the reserve inode's double
indirect blocks point back to the primary gdt blocks.  The fix is obvious, we
need to mod the gdb count by the addr's per block.  You can verify this with the
following test case

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

without this patch the resize2fs fails, with it the resize2fs succeeds.  Thank
you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


Index: linux-2.6/fs/ext3/resize.c
===================================================================
--- linux-2.6.orig/fs/ext3/resize.c
+++ linux-2.6/fs/ext3/resize.c
@@ -580,7 +580,8 @@ static int reserve_backup_gdb(handle_t *
 	}
 
 	blk = EXT3_SB(sb)->s_sbh->b_blocknr + 1 + EXT3_SB(sb)->s_gdb_count;
-	data = (__le32 *)dind->b_data + EXT3_SB(sb)->s_gdb_count;
+	data = (__le32 *)dind->b_data + (EXT3_SB(sb)->s_gdb_count %
+					 EXT3_ADDR_PER_BLOCK(sb));
 	end = (__le32 *)dind->b_data + EXT3_ADDR_PER_BLOCK(sb);
 
 	/* Get each reserved primary GDT block and verify it holds backups */
