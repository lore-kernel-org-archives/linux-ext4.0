From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] properly calculate overhead in ext2fs_initialize()
Date: Sun, 22 Jul 2007 15:31:29 -0400
Message-ID: <20070722193129.GB16658@thunk.org>
References: <46A12D62.2010704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52054 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbXGVTbd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jul 2007 15:31:33 -0400
Content-Disposition: inline
In-Reply-To: <46A12D62.2010704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 20, 2007 at 04:47:14PM -0500, Eric Sandeen wrote:
> For some odd geometries*, mkfs will try to allocate inode tables off
> the end of the block group and fail, rather than warning that too
> many inodes have been requested.
> 
> This is because when ext2fs_initialize calculates metadata overhead,
> it is only adding in group descriptor blocks and the superblock
> if the *last* bg contains them - but the first bg also has all of 
> the various metadata bits taking up space.
> 
> Unconditionally adding those counts into the overhead seems to fix
> it properly.

Yes, but it screws up the test right after that.  We need to calculate
the overheads for both the first and last block group.  When I respun
your patch and applied it to git, I fixed this.

I also added an explicit "Addresses-Red-Hat-Bugzilla: " entry to the
commit log.  (This is mainly for your convenience when you're
cherry-picking patches.)

Finally, your patch didn't apply because you apparently nuked a
newline in the patch here:

> +	overhead = (int) (3 + fs->inode_blocks_per_group +
> +			  fs->desc_blocks + super->s_reserved_gdt_blocks);
>  
>  	/* This can only happen if the user requested too many inodes */
>  	if (overhead > super->s_blocks_per_group)Index: e2fsprogs-1.40.2/tests/m_mkfs_overhead/expect.1
                                                 ^^^^^^

The patch I applied to git looks like this.  (Note that due to a bug
in the test scripts, there are significant ^M characters, so you can't
just apply this patch that you get via e-mail.  You'll need to pull it
from git, or reuse the m_mkfs_overhead/expect.1 file from your patch.)

     	     	       				     - Ted

commit 5a92a627f1e067ecfaa2478cfafeca2817cdc69f
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sun Jul 22 15:07:13 2007 -0400

    Properly calculate overhead in ext2fs_initialize()
    
    For some odd geometries*, mkfs will try to allocate inode tables off
    the end of the block group and fail, rather than warning that too
    many inodes have been requested.
    
    This is because when ext2fs_initialize calculates metadata overhead,
    it is only adding in group descriptor blocks and the superblock
    if the *last* bg contains them - but the first bg also has all of
    the various metadata bits taking up space.
    
    We need to calculate the overhead both for the first block group and
    the last block groups separately, since the two different tests need
    to know what the overheads are for those two cases, which may be
    different.
    
    *for example "mke2fs  -b 1024 -m 0 -g 256 -N 3745 fsfile 1024"
    
    (Note, the test here is a little funky; the expected output is
    actually a mkfs failure - but a proper failure instead of the
    allocator catching the problem at the last minute)
    
    Addresses-Red-Hat-Bugzilla: #241767
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 9cc3d12..16e9eaa 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -298,16 +298,13 @@ ipg_retry:
 	}
 
 	/*
-	 * Overhead is the number of bookkeeping blocks per group.  It
-	 * includes the superblock backup, the group descriptor
-	 * backups, the inode bitmap, the block bitmap, and the inode
-	 * table.
+	 * Calculate the maximum number of bookkeeping blocks per
+	 * group.  It includes the superblock, the block group
+	 * descriptors, the block bitmap, the inode bitmap, the inode
+	 * table, and the reserved gdt blocks.
 	 */
-
-	overhead = (int) (2 + fs->inode_blocks_per_group);
-
-	if (ext2fs_bg_has_super(fs, fs->group_desc_count - 1))
-		overhead += 1 + fs->desc_blocks + super->s_reserved_gdt_blocks;
+	overhead = (int) (3 + fs->inode_blocks_per_group +
+			  fs->desc_blocks + super->s_reserved_gdt_blocks);
 
 	/* This can only happen if the user requested too many inodes */
 	if (overhead > super->s_blocks_per_group)
@@ -316,8 +313,13 @@ ipg_retry:
 	/*
 	 * See if the last group is big enough to support the
 	 * necessary data structures.  If not, we need to get rid of
-	 * it.
+	 * it.  We need to recalculate the overhead for the last block
+	 * group, since it might or might not have a superblock
+	 * backup.
 	 */
+	overhead = (int) (2 + fs->inode_blocks_per_group);
+	if (ext2fs_bg_has_super(fs, fs->group_desc_count - 1))
+		overhead += 1 + fs->desc_blocks + super->s_reserved_gdt_blocks;
 	rem = ((super->s_blocks_count - super->s_first_data_block) %
 	       super->s_blocks_per_group);
 	if ((fs->group_desc_count == 1) && rem && (rem < overhead))
diff --git a/tests/m_mkfs_overhead/expect.1 b/tests/m_mkfs_overhead/expect.1
new file mode 100644
index 0000000..fff3684
--- /dev/null
+++ b/tests/m_mkfs_overhead/expect.1
@@ -0,0 +1,10 @@
+./test.img: Cannot create filesystem with requested number of inodes while setting up superblock
+./test.img: Attempt to read block from filesystem resulted in short read while opening filesystem
+features: Filesystem not open
+ 
+../e2fsck/e2fsck: Attempt to read block from filesystem resulted in short read while trying to open ./test.img
+Could this be a zero-length partition?
+Exit status is 8
+
+../misc/dumpe2fs: Attempt to read block from filesystem resulted in short read while trying to open ./test.img
+Couldn't find valid filesystem superblock.
diff --git a/tests/m_mkfs_overhead/script b/tests/m_mkfs_overhead/script
new file mode 100644
index 0000000..8cd9134
--- /dev/null
+++ b/tests/m_mkfs_overhead/script
@@ -0,0 +1,5 @@
+DESCRIPTION="test bg overhead calculation"
+FS_SIZE=1024
+MKE2FS_OPTS="-b 1024 -m 0 -g 256 -N 3745"
+. $cmd_dir/run_mke2fs
+
