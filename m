From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] e2fsprogs: fix data lost with mke2fs -S
Date: Thu, 16 Feb 2012 23:20:38 -0500
Message-ID: <20120217042038.GA9319@thunk.org>
References: <4EF2EA9E.9080500@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57025 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab2BQEUl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Feb 2012 23:20:41 -0500
Content-Disposition: inline
In-Reply-To: <4EF2EA9E.9080500@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 22, 2011 at 05:30:22PM +0900, Akira Fujita wrote:
> If we run the mke2fs with the -S option and the uninit_bg feature
> simultaneously, the mke2fs marks blockgroups as uninitialized.
> The e2fsck which run immediately after the mke2fs
> removes all of the files.
> 
> To avoid this, the patch prohibits user from
> setting the -S option and the uninit_bg feature simultaneously.

This is not the best fix.  The best fix is to clear the itable_unused
fields in the block group descriptors if mke2fs -S is set.  See below
for what I have in my tree.

					- Ted

commit 9b6a158524fe82202bef6d0d8a101b47e6c02b64
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Feb 16 23:16:34 2012 -0500

    mke2fs: allow file systems w/ uninit_bg to be recovered with mke2fs -S
    
    The command mke2fs -S is used as a last ditch recovery command to
    write new superblock and block group descriptors, but _not_ to destroy
    the inode table in hopes of recovering from a badly corrupted file
    system.  If the uninit_bg feature is enabled, we need to make sure to
    clear the unused inodes count field in the block group descriptors or
    else e2fsck -fy will leave the file system completely empty.
    
    Thanks to Akira Fujita for reporting this problem.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 08789c4..c70c1b4 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2434,6 +2434,17 @@ int main (int argc, char *argv[])
 	if (super_only) {
 		fs->super->s_state |= EXT2_ERROR_FS;
 		fs->flags &= ~(EXT2_FLAG_IB_DIRTY|EXT2_FLAG_BB_DIRTY);
+		/* 
+		 * The command "mke2fs -S" is used to recover
+		 * corrupted file systems, so do not mark any of the
+		 * inodes as unused; we want e2fsck to consider all
+		 * inodes as potentially containing recoverable data.
+		 */
+		if (fs->super->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+			for (i = 1; i < fs->group_desc_count; i++)
+				ext2fs_bg_itable_unused_set(fs, i, 0);
+		}
 	} else {
 		/* rsv must be a power of two (64kB is MD RAID sb alignment) */
 		blk64_t rsv = 65536 / fs->blocksize;
