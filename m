From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 25 Feb 2008 21:31:36 +0530
Message-ID: <20080225160136.GA5029@skywalker>
References: <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <47BC75A1.10605@redhat.com> <20080221140546.GF14614@mit.edu> <47BDA978.7060403@redhat.com> <20080222231434.GG3029@webber.adilger.int> <20080223001539.GD20118@mit.edu> <20080225042050.GH3534@webber.adilger.int> <20080225151339.GB8408@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56665 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYBYQBw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Feb 2008 11:01:52 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1PG1Ra4016384
	for <linux-ext4@vger.kernel.org>; Tue, 26 Feb 2008 03:01:27 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1PG5Shj282536
	for <linux-ext4@vger.kernel.org>; Tue, 26 Feb 2008 03:05:28 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1PG1stG027812
	for <linux-ext4@vger.kernel.org>; Tue, 26 Feb 2008 03:01:54 +1100
Content-Disposition: inline
In-Reply-To: <20080225151339.GB8408@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 25, 2008 at 10:13:39AM -0500, Theodore Tso wrote:
> On Sun, Feb 24, 2008 at 09:20:50PM -0700, Andreas Dilger wrote:
> > On Feb 22, 2008  19:15 -0500, Theodore Ts'o wrote:
> > > So before the recent patch were we actually creating long symlinks in
> > > extents format?  Or were we just setting the flag but still treating
> > > them as a block number?  If it was the latter, I guess we can put in
> > > code into e2fsck to detect that case, and convert it back to a
> > > singleton block number.  
> > 
> > Eric informed me that the long symlinks were actually stored in extent
> > mapped blocks.  That is not harmful, because it can only be a single
> > block and it will always fit into the inode.  The other thing to note
> > is that extent mapping is REQUIRED for > 32-bit blocknumbers, so we
> > may as well fix e2fsprogs to allow these symlinks to be handled normally.
> 
> Well, at least some kernel versions (as of sometime just before
> 2.6.25, iirc) were storing the long symlink as a single block in
> i_block[0], despite EXTENTS_FL being set.  Valerie noticed this, and I
> confirmed it, as it caused the mainline e2fsck extents support to core
> dump.  Basically, what this means is that e2fsprogs can't trust
> EXTENTS_FL for long symlinks.
> 
> But you do raise a good point that we need to support using the
> extents format in order to support blocks > 2**32, so we can't just
> arbitrary convert all symlinks to the old-style direct block maps.

How about the patch like below on top of the patch queue. Patch queue
currently enable extent flag only for directory and file . This patch
add it to normal symlink. With this fast symlink still have the extent
format enabled. I guess this would need a patch to the interim branch of
e2fsprogs to allow normal symlink to have extent format.

-aneesh

ext4: Enable extent format for symlink.

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

This patch enable extent format for normal symlink. Extent format enables
to refere file system blocks > 32 bits. Enabling extent format for symlink
enables to have symlink block beyond 2**32 blocks. We still don't enable
extent format for fast symlink.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/ialloc.c |    4 ++--
 fs/ext4/namei.c  |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 78d1094..1462189 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -842,8 +842,8 @@ got:
 		goto fail_free_drop;
 	}
 	if (test_opt(sb, EXTENTS)) {
-		/* set extent flag only for diretory and file */
-		if (S_ISDIR(mode) || S_ISREG(mode)) {
+		/* set extent flag only for diretory, file and normal symlink*/
+		if (S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode)) {
 			EXT4_I(inode)->i_flags |= EXT4_EXTENTS_FL;
 			ext4_ext_tree_init(handle, inode);
 			err = ext4_update_incompat_feature(handle, sb,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index da942bc..63c33e0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2222,6 +2222,8 @@ retry:
 			goto out_stop;
 		}
 	} else {
+		/* clear the extent format for fast symlink */
+		EXT4_I(inode)->i_flags &= ~EXT4_EXTENTS_FL;
 		inode->i_op = &ext4_fast_symlink_inode_operations;
 		memcpy((char*)&EXT4_I(inode)->i_data,symname,l);
 		inode->i_size = l-1;
