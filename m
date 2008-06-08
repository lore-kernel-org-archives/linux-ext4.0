From: akpm@linux-foundation.org
Subject: - ext3-fix-online-resize-bug.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:49:04 -0700
Message-ID: <200806081949.m58Jn4A2017624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jbacik@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix online resize bug
has been removed from the -mm tree.  Its filename was
     ext3-fix-online-resize-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: fix online resize bug
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

Patches currently in -mm which might be from jbacik@redhat.com are

origin.patch
ext4-fix-online-resize-bug.patch

