From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 3/4] Add bitmap configuration interface
Date: Fri, 18 Mar 2011 11:13:00 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1103181056110.4087@dhcp-27-109.brq.redhat.com>
References: <1300387821-21705-1-git-send-email-lczerner@redhat.com> <1300387821-21705-4-git-send-email-lczerner@redhat.com> <B2BCB67B-A28D-4EB6-B731-D556C7B5126C@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932229Ab1CRKNG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Mar 2011 06:13:06 -0400
In-Reply-To: <B2BCB67B-A28D-4EB6-B731-D556C7B5126C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 17 Mar 2011, Andreas Dilger wrote:

> On 2011-03-17, at 12:50 PM, Lukas Czerner wrote:
> > Add a possibility for user to configure what bitmap backed will be used
> > for what bitmap. It is also useful for testing and benchmarking
> > different bitmap backends and its behaviour.
> > 
> > Setting can be done via usual config file with new section [bitmaps]
> > with subnames defining particular bitmaps. Argument is simply number of
> > the backend. All backends are defined in ext2fsP.h like this:
> > 
> > enum ext2fs_bmap_backends {
> > 		EXT2FS_BMAP64_BITARRAY = 0,
> > 		EXT2FS_BMAP64_RBTREE,
> > 		EXT2FS_BMAP64_COUNT,
> > };
> > 
> > Here is an example of bitmap configuration, with the list of all
> > supported bitmaps.
> > 
> > [bitmaps]
> > 	generic_bitmap = 1
> > 	inode_used_map = 1
> > 	inode_bad_map = 1
> 
> I wonder if this is enough just for debugging (presumably very few people will actually set this) or if there should be some symbolic constants used, like "bitmap", "rbtree", ...?  That avoids exposing arbitrary internal constants to userspace, that will need to be preserved indefinitely.

Yes, I thought about that, but it seemed unnecessary. However I can see
your point, I'll change that.

> 
> Also useful would be a "default =" option that changes all of the unspecified bitmap types at once, to avoid the need to list all bitmaps explicitly (which may change over time), or possibly if "inode_map=" and "block_map=" are specified they become the default types for all other unspecified inode and block bitmaps?

Now that's very good idea, I'll take a look into it.

> 
> > This feature requires interface change of ext2fs_alloc_generic_bmap()
> > and its definition now is:
> > 
> > errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
> > 				    int type, __u64 start, __u64 end,
> > 				    __u64 real_end,
> > 				    ext2fs_generic_bitmap *ret)
> 
> I was going to write that this will break the ABI/API for e2fsprogs, so probably is not acceptable to Ted.  However, looking at the "master" branch, I see that it already has an "int type" argument, along with 64-bit arguments.
> 
> What branch is this patch series against?

It is based on master branch from
git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

> 
> > -errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
> > -				       const char *descr,
> > +errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs, int type,
> > 				       ext2fs_inode_bitmap *ret)
> > {
> 
> Ah, unlike your comment above, this is changing the ext2fs_allocate_{block,inode}_bitmap() functions, which definitely will break the ABI/API.  The other confusing thing is that since the number of parameters hasn't changed (size unchanged on 32-bit) then this wouldn't break the ABI totally and it would only cause a crash if the bitmap allocation failed and "type" is interpreted as a char * pointer.
> 
> One option is to have a separate helper function that changes the default bitmap type in ext2_filsys (maybe separate defaults for inode and block bitmaps), and then call that before this function.  Not ideal, but doesn't change the ABI/API, and is sufficient for most uses.  Alternately, it would be possible to declare a new ext2fs_allocate_{block,inode}_bitmap2() function that has this new parameter, and make ext2fs_allocate_{block,inode}_bmap() call it with the default bitmap type.

Well I know that this breaks ABI/API and if that matters I can fix that.
However I have a question, is preserving ABI/API really that important
in e2fsprogs ? I guess it is when you are mentioning it, but I can not
really see why ?

> 
> > 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> > +	if (type >= EXT2_BMAP_COUNT || type < 0)
> > +		return EINVAL;
> 
> Is EINVAL a valid error return for libext2fs?  Anything returning an errcode_t should probably be using a new EXT2_ET_INVALID_BITMAP_TYPE error defined in lib/ext2fs/ext2_err.et.in.

You're right I'll fix that.

> 
> > +enum ext2_bitmap_type {
> > +	EXT2_GENERIC_MAP		=0,
> > +	EXT2_INODE_USED_MAP,		/* Inodes which are in use */
> > +	EXT2_INODE_BAD_MAP,		/* Inodes which are bad somehow */
> > +	EXT2_INODE_DIR_MAP,		/* Inodes which are directories */
> > +	EXT2_INODE_BB_MAP,		/* Inodes which are in bad blocks */
> > +	EXT2_INODE_IMAGIC_MAP,		/* AFS inodes */
> 
> 	EXT2_INODE_IMAGIC_MAP,		/* Inodes disconnected but used by AFS */
> 
> > +	EXT2_INODE_REG_MAP,		/* Inodes which are regular files*/
> > +	EXT2_INODE_MAP,
> > +	EXT2_INODE_DUP_MAP,
> > +	EXT2_INODE_DONE_MAP,
> > +	EXT2_INODE_LOOP_MAP,
> 
> Would be nice to have comments for the rest of these as well.  I renamed a couple to be consistent with _INODE_ or _BLOCK_ in each name.  Let's see:
> 
> 	EXT2_INODE_MAP,			/* Inodes in use */
> 	EXT2_INODE_DUP_MAP,		/* Inodes with duplicate block usage */
> 	EXT2_INODE_DONE_MAP,		/* Dirs linked to root during e2fsck */
> 	EXT2_INODE_LOOP_MAP,		/* Dirs hit in path walk for e2fsck*/
> 
> 	EXT2_BLOCK_MAP,			/* Blocks in use */
> 	EXT2_BLOCK_BAD_MAP,		/* Blocks marked bad via badblocks */
> 	EXT2_BLOCK_SCRAMBLE,		/* Blocks scrambled for e2image */
> 	EXT2_BLOCK_TO_MOVE,		/* Blocks to move for resize2fs */
> 	EXT2_BLOCK_RESERVED,		/* Blocks reserved for resize2fs */
> 	EXT2_BLOCK_METADATA,		/* Blocks for metadata for resize2fs */
> 
> 	EXT2_BLOCK_EMPTY_DIR,		/* Blocks for lost+found expansion */
> 	EXT2_INODE_EMPTY_DIR_MAP,	/* ??? */
> 	EXT2_BLOCK_CHECK_DESC_MAP,      /* Blocks used for group descriptors */
> 	EXT2_BLOCK_TOUCHED_MAP,		/* Blocks accessed during tst_iscan */

Thanks!

> 
> > +	EXT2_BMAP_COUNT,		/* Stop mark */
> > +};
> 
> It isn't quite clear whether we need to have explicit block bitmap definitions for programs like tst_iscan.  If it isn't possible for a program to allocate arbitrary bitmaps without having to register them first, it will really be a pain.  I'd instead suggest that the "type" just default to EXT2_BLOCK_MAP for obscure bitmaps like "TOUCHED_MAP", and again allow specifying a bitmap name.

Well I tried to cover all bitmaps in e2fsprogs tools. Now, if someone
would like to use some anonymous bitmap, or just do not want to create
new bitmap definitions, one can easily use EXT2_GENERIC_BITMAP.
> 
> > -#define EXT2FS_BMAP64_BITARRAY	1
> > -#define EXT2FS_BMAP64_RBTREE	2
> > +enum ext2fs_bmap_backends {
> > +	EXT2FS_BMAP64_BITARRAY = 0,
> > +	EXT2FS_BMAP64_RBTREE,
> > +	EXT2FS_BMAP64_COUNT,
> 
> For debugging purposes, it is preferable to have an enum not contain "0" as a valid value, since that allows one to see if the bitmap type is being specified correctly, or if it is unset.  Maybe EXT2FS_BMAP64_UNSET = 0?

Good point, I'll change that.

> 
> > +static char *ext2_bmap_profile_value[EXT2_BMAP_COUNT] = {
> > +	[EXT2_GENERIC_MAP] = "generic_bitmap",
> > +	[EXT2_INODE_USED_MAP] = "inode_used_map",
> > +	[EXT2_INODE_BAD_MAP] = "inode_bad_map",
> > +
> > +const
> > +static struct ext2_bmap_definition ext2_bmap_default[EXT2_BMAP_COUNT] = {
> > +	[EXT2_GENERIC_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "generic bitmap"},
> > +	[EXT2_INODE_USED_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "in-use inode map"},
> > +	[EXT2_INODE_BAD_MAP] = {EXT2_DEFAULT_BITMAP_BACKEND, "bad inode map"},
> 
> It is cumbersome to have to update 3 places for each bitmap.  Could we just get rid of ext2_bmap_profile_value[] and only use ext2_bmap_default[]?  Also, the strings here have now lost their i18n for error messages.

I was thinking about merging those two structures, maybe using macros,
I'll look into it. Yes, is has lost their i18n for error messages, do
you have any suggestion to preserve localization with statically
declared strings ?

> 
> Cheers, Andreas
> 

Thanks!
-Lukas
