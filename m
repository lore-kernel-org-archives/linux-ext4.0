From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] debugfs: Add inline data feature for symlink.
Date: Fri, 8 Aug 2014 11:04:22 -0700
Message-ID: <20140808180422.GC11191@birch.djwong.org>
References: <1406789932-13770-1-git-send-email-houpu.hp@alibaba-inc.com>
 <63e6941e-70ab-4fec-941c-f13f47585594@alibaba-inc.com>
 <20140801164810.GT8628@birch.djwong.org>
 <20140804065341.GC6751@guyi-aliyun>
 <20140805122758.GE2949@guyi-aliyun>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Pu Hou <houpu.hp@alibaba-inc.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25308 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHHSE2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 14:04:28 -0400
Content-Disposition: inline
In-Reply-To: <20140805122758.GE2949@guyi-aliyun>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 05, 2014 at 08:27:58PM +0800, Pu Hou wrote:
> On Mon, Aug 04, 2014 at 02:53:41PM +0800, Pu Hou wrote:
> > On Sat, Aug 02, 2014 at 12:48:10AM +0800, Darrick J. Wong wrote:
> > > On Fri, Aug 01, 2014 at 06:37:56PM +0800, Pu Hou wrote:
> > > > On Thu, Jul 31, 2014 at 02:58:52PM +0800, Pu Hou wrote:
> > > > >> Symlink in debugfs can take advantage of inline data feature. The path name of the target of the symbol link which is longer than 60 byte and shorter than 132 byte can stay in inline data area.
> > > > >
> > > > >I think Ted prefers wrapping commit messages at 70 bytes.
> > > > >
> > > > Thanks for reminding me. I will fix it.
> > > > 
> > > > >> +	data.ea_size = size - EXT4_MIN_INLINE_DATA_SIZE;
> > > > >> +	data.ea_data = buf + EXT4_MIN_INLINE_DATA_SIZE;
> > > > >> +	return ext2fs_inline_data_ea_set(&data);
> > > > >
> > > > >Doesn't ext2fs_inline_data_set() suffice?
> > > > >
> > > > It is unnecessary to use this dedicated function.
> > > 
> > > Why do you say it's unnecessary?  The dedicated function does (or at least is
> > > supposed to) do exactly what you want.
> > > 
> > 
> > Compare with the dedicated function, ext2fs_inline_data_set() will check
> > the available xattr size and inline data size by read the inode and do
> > some calculation. And I thought some "dirty data" of an inode on disk might
> > have an effect on the calculated available size.
> > 
> > Now I find that this concern is unnecessary. Because ext2fs_write_new_inode()
> > which is called before will make sure the xattr of the inode are clean.
> > So there is no need to use this dedicated function.
> > 
> > > Now I'm wondering -- why worry about size at all?  You can modify
> > > ext2fs_symlink to call ext2fs_inline_data_set() directly.  If there's not
> > > enough room, it'll return EXT2_ET_INLINE_DATA_NO_SPACE and you can try again
> > > with the classic stuff-it-in-a-block method.
> > > 
> > > (Of course, if you try this and the API turns not to behave as advertised I'd
> > > like to hear about that too. :))
> > 
> > That sounds nice. I will try in this way and give a feedback later.
> >
> I tried to call ext2fs_inline_data_set() from ext2fs_symlink. The result is
> not as expected. Before it gets to "return EXT2_ET_INLINE_DATA_NO_SPACE",
> ext2fs_inline_data_size() is called. In this function, it may return at here:
> 
> 	if (!(inode.i_flags & EXT4_INLINE_DATA_FL))
> 		return EXT2_ET_NO_INLINE_DATA;
> 
> and the message was printed as below:
> 
> ext2fs_symlink: Inode doesn't have inline data
> symlink: Inode doesn't have inline data

Yeah, you have to set EXT4_INLINE_DATA_FL then write_new_inode before calling
ext2fs_inline_data_set() so that the subsequent inlinedata calls (which re-read
the inode off the disk) see the flag.  (Yuck)

> That is because we did not mark EXT4_INLINE_DATA_FL yet. Even if mark the flag,
> it still return at this point:
> 
> 	data.fs = fs;
> 	data.ino = ino;
> 	retval = ext2fs_inline_data_ea_get(&data);
> 	if (retval)
> 		return retval;
> 
> and the message was printed as below:
> 
> ext2fs_symlink: Extended attribute key not found
> symlink: Extended attribute key not found

Personally, I think that's a bug in inline_data.c.  Retrieving any of the
inline data shouldn't fail just because there's no EA -- what if the EA is
damaged?  For the case of creating a symlink, the EA doesn't exist because we
haven't finished creating the file yet.

I think it makes more sense for ext2fs_inline_data_ea_get() to check for
EXT2_ET_EA_KEY_NOT_FOUND when it tries to grab the EA, and simply set
data.ea_size = 0.

> That means the xattr of the new created inode is clean.
> because ext2fs_write_new_inode() is called early, the xattr is made clean.

If you've already called write_new_inode (for the inline symlink case) then you
must call write_inode or else you see the behavior you observed.

> I think use "ext2fs_xattr_inode_max_size() + EXT4_MIN_INLINE_DATA_SIZE"
> to get the available xattr size. And use ext2fs_inline_data_ea_set()
> directly to set inline data is a workaround.

There should provide a test case.  Ted seems to be getting stricter about that.

Oh well, how about this patch?  Seeing as I'm messing around with the inline
data patchbomb some more anyway.

--D

diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index 2e1fc68..68f8893 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -35,7 +35,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	struct ext2_inode	inode;
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
-	int			fastlink;
+	int			fastlink, inlinelink;
 	unsigned int		target_len;
 	char			*block_buf = 0;
 
@@ -78,15 +78,36 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	memset(&inode, 0, sizeof(struct ext2_inode));
 	inode.i_mode = LINUX_S_IFLNK | 0777;
 	inode.i_uid = inode.i_gid = 0;
-	ext2fs_iblk_set(fs, &inode, fastlink ? 0 : 1);
 	inode.i_links_count = 1;
 	ext2fs_inode_size_set(fs, &inode, target_len);
 	/* The time fields are set by ext2fs_write_new_inode() */
 
+	inlinelink = !fastlink &&
+		     (fs->super->s_feature_incompat &
+					EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+		     (target_len < fs->blocksize);
 	if (fastlink) {
 		/* Fast symlinks, target stored in inode */
 		strcpy((char *)&inode.i_block, target);
+	} else if (inlinelink) {
+		/* Try inserting an inline data symlink */
+		inode.i_flags |= EXT4_INLINE_DATA_FL;
+		retval = ext2fs_write_new_inode(fs, ino, &inode);
+		if (retval)
+			goto cleanup;
+		retval = ext2fs_inline_data_set(fs, ino, &inode, target,
+						target_len);
+		if (retval) {
+			inode.i_flags &= ~EXT4_INLINE_DATA_FL;
+			inlinelink = 0;
+			goto need_block;
+		}
+		retval = ext2fs_read_inode(fs, ino, &inode);
+		if (retval)
+			goto cleanup;
 	} else {
+need_block:
+		ext2fs_iblk_set(fs, &inode, 1);
 		/* Slow symlinks, target stored in the first block */
 		memset(block_buf, 0, fs->blocksize);
 		strcpy(block_buf, target);
@@ -105,11 +126,14 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	 * number is assigned by write_new_inode, which means that the
 	 * operations using ino must come after it.
 	 */
-	retval = ext2fs_write_new_inode(fs, ino, &inode);
+	if (inlinelink)
+		retval = ext2fs_write_inode(fs, ino, &inode);
+	else
+		retval = ext2fs_write_new_inode(fs, ino, &inode);
 	if (retval)
 		goto cleanup;
 
-	if (!fastlink) {
+	if (!fastlink && !inlinelink) {
 		retval = ext2fs_bmap2(fs, ino, &inode, NULL, BMAP_SET, 0, NULL,
 				      &blk);
 		if (retval)
@@ -140,7 +164,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	/*
 	 * Update accounting....
 	 */
-	if (!fastlink)
+	if (!fastlink && !inlinelink)
 		ext2fs_block_alloc_stats2(fs, blk, +1);
 	ext2fs_inode_alloc_stats2(fs, ino, +1, 0);
 
