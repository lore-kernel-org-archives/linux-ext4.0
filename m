From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs- fix ext2fs_swap_inode_full attr test on BE
	boxes
Date: Fri, 14 Mar 2008 09:32:41 -0400
Message-ID: <20080314133241.GD7412@mit.edu>
References: <47C882CD.3090204@redhat.com> <n7x63vph2q5.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62332 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbYCNNdf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2008 09:33:35 -0400
Content-Disposition: inline
In-Reply-To: <n7x63vph2q5.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 14, 2008 at 02:09:06PM +0100, Matthias Koenig wrote:
> (also the git tag for the 1.40.8 release seems to be missing).

Oops, forgot to do a "git push --tags" again.  Fixed.

> Eric Sandeen <sandeen@redhat.com> writes:
> 
> > After the fix for resize2fs's inode mover losing in-inode
> > extended attributes, the regression test I wrote caught 
> > that the attrs were still getting lost on powerpc.
> >
> > Looks like the problem is that ext2fs_swap_inode_full()
> > isn't paying attention to whether or not the EA magic is
> > in hostorder, so it's not recognized (and not swapped)
> > on BE machines.  Patch below seems to fix it.
>
> This patch seems to be missing in the current e2fsprogs 1.40.8 release
> (though announced in the release notes that this issue should be fixed
> on BE machines).
> Check r_inline_xattr still fails on ppc and s390 architectures without 
> this patch. It builds fine with this patch applied.

This patch is in the repo, which I thought superceded the one which
Eric sent.  (The authorship is wrong; and that was my fault for not
including '--author="Eric Sandeen <sandeen@redhat.com>"' on the commit
command-line.  I've already apologized to Eric privately; now I'm
apologizing publically.  :-)

But looking at it again, I believe I misunderstood, and the two
patches are attacking quite separate problems.  OK, i'll get this one
in as well in the next go-around.

						- Ted

commit edfd9b0a9fe7b90f56da981ca26d5233cc3749d6
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Mar 8 20:20:40 2008 -0500

    resize2fs: Fix resizing filesystems with large inodes
    
    Use ext2fs_get_next_inode_full() in resize2fs and clean up large inode
    handling; previous attempt was not properly handling all cases, and
    was incorrectly setting i_extra_isize.  This caused some extended
    attributes to get removed or randomly assigned to other inodes as a
    result of the resize, which can be unfortunate on systems using
    SELinux.
    
    The previous commit didn't fix things completely on big-endian systems
    like PowerPC.
    
    Addresses-Red-Hat-Bugzilla: #434893
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index dd26089..6dec3eb 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1109,8 +1109,7 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 {
 	struct process_block_struct	pb;
 	ext2_ino_t		ino, new_inode;
-	struct ext2_inode 	inode, *buf = NULL;
-	struct ext2_inode_large	*large_inode;
+	struct ext2_inode 	*inode = NULL;
 	ext2_inode_scan 	scan = NULL;
 	errcode_t		retval;
 	int			group;
@@ -1154,12 +1153,12 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 	}
 	ext2fs_set_inode_callback(scan, progress_callback, (void *) rfs);
 	pb.rfs = rfs;
-	pb.inode = &inode;
+	pb.inode = inode;
 	pb.error = 0;
 	new_inode = EXT2_FIRST_INODE(rfs->new_fs->super);
 	inode_size = EXT2_INODE_SIZE(rfs->new_fs->super);
-	buf = malloc(inode_size);
-	if (!buf) {
+	inode = malloc(inode_size);
+	if (!inode) {
 		retval = ENOMEM;
 		goto errout;
 	}
@@ -1168,29 +1167,29 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 	 * elsewhere in the inode table
 	 */
 	while (1) {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino, inode, inode_size);
 		if (retval) goto errout;
 		if (!ino)
 			break;
 
-		if (inode.i_links_count == 0 && ino != EXT2_RESIZE_INO)
+		if (inode->i_links_count == 0 && ino != EXT2_RESIZE_INO)
 			continue; /* inode not in use */
 
-		pb.is_dir = LINUX_S_ISDIR(inode.i_mode);
+		pb.is_dir = LINUX_S_ISDIR(inode->i_mode);
 		pb.changed = 0;
 
-		if (inode.i_file_acl && rfs->bmap) {
+		if (inode->i_file_acl && rfs->bmap) {
 			new_block = ext2fs_extent_translate(rfs->bmap, 
-							    inode.i_file_acl);
+							    inode->i_file_acl);
 			if (new_block) {
-				inode.i_file_acl = new_block;
-				retval = ext2fs_write_inode(rfs->old_fs, 
-							    ino, &inode);
+				inode->i_file_acl = new_block;
+				retval = ext2fs_write_inode_full(rfs->old_fs, 
+							    ino, inode, inode_size);
 				if (retval) goto errout;
 			}
 		}
 		
-		if (ext2fs_inode_has_valid_blocks(&inode) &&
+		if (ext2fs_inode_has_valid_blocks(inode) &&
 		    (rfs->bmap || pb.is_dir)) {
 			pb.ino = ino;
 			retval = ext2fs_block_iterate2(rfs->old_fs,
@@ -1221,23 +1220,19 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 			}
 		}
 		ext2fs_mark_inode_bitmap(rfs->new_fs->inode_map, new_inode);
-		memcpy(buf, &inode, sizeof(struct ext2_inode));
-		large_inode = (struct ext2_inode_large *)buf;
-		large_inode->i_extra_isize = sizeof(struct ext2_inode_large) -
-			EXT2_GOOD_OLD_INODE_SIZE;
 		if (pb.changed) {
 			/* Get the new version of the inode */
 			retval = ext2fs_read_inode_full(rfs->old_fs, ino,
-						buf, inode_size);
+						inode, inode_size);
 			if (retval) goto errout;
 		}
-		inode.i_ctime = time(0);
+		inode->i_ctime = time(0);
 		retval = ext2fs_write_inode_full(rfs->old_fs, new_inode,
-						buf, inode_size);
+						inode, inode_size);
 		if (retval) goto errout;
 
 		group = (new_inode-1) / EXT2_INODES_PER_GROUP(rfs->new_fs->super);
-		if (LINUX_S_ISDIR(inode.i_mode))
+		if (LINUX_S_ISDIR(inode->i_mode))
 			rfs->new_fs->group_desc[group].bg_used_dirs_count++;
 		
 #ifdef RESIZE2FS_DEBUG
@@ -1263,8 +1258,8 @@ errout:
 		ext2fs_close_inode_scan(scan);
 	if (block_buf)
 		ext2fs_free_mem(&block_buf);
-	if (buf)
-		free(buf);
+	if (inode)
+		free(inode);
 	return retval;
 }
 


