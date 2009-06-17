From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] resize2fs: update sb backup journal if journal was moved
Date: Wed, 17 Jun 2009 14:40:19 -0500
Message-ID: <4A3946A3.2040401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37600 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031AbZFQTkS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jun 2009 15:40:18 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5HJeLEd031173
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2009 15:40:21 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5HJeKrO009709
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2009 15:40:20 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5HJeJYs022716
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2009 15:40:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was reported in Fedora, since the livecd creator does
a lot of resizing.

If we've moved the journal blocks during resize (likely now,
due to the journal being in the middle) the backup blocks don't
get updated, and a subsequent e2fsck will find issues:

e2fsck 1.41.6 (30-May-2009)
Backing up journal inode block information.

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/mnt/test/img: ***** FILE SYSTEM WAS MODIFIED *****
/mnt/test/img: 11/16000 files (0.0% non-contiguous), 17789/38400 blocks

This can be shown in a simple test:

# dd if=/dev/zero of=img bs=1 count=0 seek=3000M
# mke2fs -t ext4 -F img
# resize2fs img 150M
# e2fsck -f img

(thanks to the Fedora reporter Mads Kiilerich!
https://bugzilla.redhat.com/show_bug.cgi?id=506105#c2)

The following is just rough; I'd at least move it to a helper function,
and needs some error checking.

But it does fix it.  Question is, should I do it unconditionally,
or only if the journal inode got moved?  Doing it conditionally
would require a bit more work to sort out whether it's been moved.

Or, I could just compare the two and overwrite it if they differ, vs
actually walking the backup blocks and see if any are off the end
of the filesystem... what seems best?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 0d5dc81..acb338e 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -148,6 +148,17 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 	if (retval)
 		goto errout;
 
+	if (rfs->new_fs->super->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) {
+		struct ext2_inode inode;
+
+		retval = ext2fs_read_inode(rfs->new_fs,
+			  rfs->new_fs->super->s_journal_inum, &inode);
+		memcpy(rfs->new_fs->super->s_jnl_blocks, inode.i_block, EXT2_N_BLOCKS*4);
+		rfs->new_fs->super->s_jnl_blocks[16] = inode.i_size;
+		rfs->new_fs->super->s_jnl_backup_type = EXT3_JNL_BACKUP_BLOCKS;
+		ext2fs_mark_super_dirty(fs);
+	}
+
 	rfs->new_fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 	retval = ext2fs_close(rfs->new_fs);
 	if (retval)

