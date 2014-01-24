From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mke2fs: add make_hugefile feature
Date: Thu, 23 Jan 2014 17:37:21 -0800
Message-ID: <20140124013721.GC8973@birch.djwong.org>
References: <1390285023-23133-1-git-send-email-tytso@mit.edu>
 <24F1EAE7-6E6D-4411-9092-D159E0BE3A9C@dilger.ca>
 <20140121213943.GE31769@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33658 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaAXBh2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jan 2014 20:37:28 -0500
Content-Disposition: inline
In-Reply-To: <20140121213943.GE31769@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 21, 2014 at 04:39:43PM -0500, Theodore Ts'o wrote:
> On Tue, Jan 21, 2014 at 11:45:17AM -0700, Andreas Dilger wrote:
> > > Then "mke2fs -T hugefile /dev/sdXX" will create as many 1G files
> > > needed to fill the file system.
> > 
> > How is this different from using fallocate to allocate the files?
> 
> There are a couple of differences.  One is that currently using
> fallocate to allocate the file results in an embarassingly bad extent
> tree:
> 
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..    2047:      34816..     36863:   2048:             unwritten
>    1:     2048..    4095:      36864..     38911:   2048:             unwritten
>    2:     4096..    6143:      38912..     40959:   2048:             unwritten
>    3:     6144..    8191:      40960..     43007:   2048:             unwritten
>    4:     8192..   10239:      43008..     45055:   2048:             unwritten
>    5:    10240..   12287:      45056..     47103:   2048:             unwritten
>    6:    12288..   14335:      47104..     49151:   2048:             unwritten
> ....
> 
> (This we came from running "fallocate -o 0 -l 512M /mnt/foo" on a
> freshly formatted file system, running Linux 3.12.)
> 
> Compare and contrast that with "mke2fs -T hugefile /tmp/foo.img 1G"
> creates:
> 
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..   32767:      24904..     57671:  32768:            
>    1:    32768..   65535:      57672..     90439:  32768:            
>    2:    65536..   98303:      90440..    123207:  32768:            
>    3:    98304..  131071:     123208..    155975:  32768:            
> 
> This is a bug in how fallocate and mballoc are working together that
> we should fix, of course. :-) And come to think of it, I'm really
> surprised that the extent merging code isn't papering over the fact
> that mballoc is only handing back block allocations 2048 blocks at a
> time.

Does the following still apply for why ext4_can_extents_be_merged() refuses to
allow uninit extents to be merged?

"Make sure that both extents are initialized. We don't merge
uninitialized extents so that we can be sure that end_io code has
the extent that was written properly split out and conversion to
initialized is trivial."

I removed the bits that prevent successful merging of uninit extents and each
2048 block allocation was (sometimes) appended to the prevous extent, but I
didn't check against conversion races.  I'll include the patch at the foot.

> The other difference is the obvious one from the filefrag output,
> which is the data blocks are marked as initialized, instead of
> unwritten.  Yes, this brings up the whole controversy over the
> NO_HIDE_STALE flag, but if you are creating the fresh file system, the
> security issues hopefully not as severe --- and I will eventually add
> support for zero'ing the files, or using discard to zero the data
> blocks, even if at work we really don't care about this because we
> trust the userspace programs that would be using these huge files.

It wouldn't be difficult to have some flags to mark the extent uninit and/or
zero the blocks.  Certainly mke2fs could just zero everything to make life
easier.

> Finally, to help eventually support eventual userspace SMR aware
> applicaitons, one reason why it's useful to have mke2fs support
> creating the huge file is that it's much easier to make sure the file
> is appropriate aligned to begin at an SMR zone boundary.  This is not
> something we currently have any kernel/userspace interfaces to do, in
> terms of telling fallocate that you want to constrain the starting
> block number for the data blocks that you are asking it to
> fallocate(2) for you.

That seems like it would be useful...

> > Is this just to create a test image for e2fsck or similar?
> 
> It is certainly useful for that, but the mk_hugefiles feature is one
> that I expect we would be using on production systems.
> 
> It is definitely the case that writing this code has exposed all sorts
> of interesting bugs and performance shortcomings in libext2fs and
> e2fsprogs in general, so just creating this functionality as part of
> mke2fs it was certainly a useful exercise in and of itself.  :-)
> 
> >  It might make sense to include f_hugefiles/script and expect.1 for it?
> 
> Oh, certainly.  This patch was much more of an RFC than anything else.
> And as I said, I'm still trying to figure out whether or not it makes
> sense to push this code upstream, or leave it as a Google internal
> enhancement.

<shrug> fuse2fs would use it, but I don't know that anyone cares about fuse2fs.

Well, here's a patch for all to enjoy.  xfstests didn't blow up when I ran it.

--D
From: Darrick J. Wong <darrick.wong@oracle.com>
Subject: [PATCH] ext4: merge uninitialized extents

Allow for merging uninitialized extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/extents.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3384dc4..7f0132d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1691,7 +1691,7 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 	 * the extent that was written properly split out and conversion to
 	 * initialized is trivial.
 	 */
-	if (ext4_ext_is_uninitialized(ex1) || ext4_ext_is_uninitialized(ex2))
+	if (ext4_ext_is_uninitialized(ex1) != ext4_ext_is_uninitialized(ex2))
 		return 0;
 
 	ext1_ee_len = ext4_ext_get_actual_len(ex1);
@@ -1708,6 +1708,11 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 	 */
 	if (ext1_ee_len + ext2_ee_len > EXT_INIT_MAX_LEN)
 		return 0;
+	if (ext4_ext_is_uninitialized(ex1) &&
+	    (ext4_test_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN) ||
+	     atomic_read(&EXT4_I(inode)->i_unwritten) ||
+	     (ext1_ee_len + ext2_ee_len > EXT_UNINIT_MAX_LEN)))
+		return 0;
 #ifdef AGGRESSIVE_TEST
 	if (ext1_ee_len >= 4)
 		return 0;
@@ -1731,7 +1736,7 @@ static int ext4_ext_try_to_merge_right(struct inode *inode,
 {
 	struct ext4_extent_header *eh;
 	unsigned int depth, len;
-	int merge_done = 0;
+	int merge_done = 0, uninit;
 
 	depth = ext_depth(inode);
 	BUG_ON(path[depth].p_hdr == NULL);
@@ -1741,8 +1746,11 @@ static int ext4_ext_try_to_merge_right(struct inode *inode,
 		if (!ext4_can_extents_be_merged(inode, ex, ex + 1))
 			break;
 		/* merge with next extent! */
+		uninit = ext4_ext_is_uninitialized(ex);
 		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
 				+ ext4_ext_get_actual_len(ex + 1));
+		if (uninit)
+			ext4_ext_mark_uninitialized(ex);
 
 		if (ex + 1 < EXT_LAST_EXTENT(eh)) {
 			len = (EXT_LAST_EXTENT(eh) - ex - 1)
@@ -1896,7 +1904,7 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	struct ext4_ext_path *npath = NULL;
 	int depth, len, err;
 	ext4_lblk_t next;
-	int mb_flags = 0;
+	int mb_flags = 0, uninit;
 
 	if (unlikely(ext4_ext_get_actual_len(newext) == 0)) {
 		EXT4_ERROR_INODE(inode, "ext4_ext_get_actual_len(newext) == 0");
@@ -1946,9 +1954,11 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 						  path + depth);
 			if (err)
 				return err;
