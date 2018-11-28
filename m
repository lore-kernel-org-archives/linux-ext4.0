Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55316 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeK2IiK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Nov 2018 03:38:10 -0500
Date: Wed, 28 Nov 2018 13:35:03 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Artem Blagodarenko <artem.blagodarenko@gmail.com>,
        linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        alexey.lyashkov@gmail.com
Subject: Re: [PATCH v2] ext2fs: don't read group descriptors during e2label
Message-ID: <20181128213503.GB8111@magnolia>
References: <20181128204840.4544-1-artem.blagodarenko@gmail.com>
 <41473332-C973-4E58-8DF5-577E3C937846@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41473332-C973-4E58-8DF5-577E3C937846@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2018 at 02:16:30PM -0700, Andreas Dilger wrote:
> 
> > On Nov 28, 2018, at 1:48 PM, Artem Blagodarenko <artem.blagodarenko@gmail.com> wrote:
> > 
> > tune2fs is used to make e2label duties.  ext2fs_open2() reads group
> > descriptors which are not used during disk label obtaining, but
> > takes a lot of time on large partitions.
> > 
> > This patch change ext2fs_open2(), so only initialized
> > superblock is returned. without block descriptors. This save
> > time dramatically.
> > 
> > Cray-bug-id: LUS-5777
> > Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
> 
> One minor nit at the end, but looks fine otherwise:
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> 
> > 
> > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > index 5b87d395..2abb6f76 100644
> > --- a/lib/ext2fs/ext2fs.h
> > +++ b/lib/ext2fs/ext2fs.h
> > @@ -204,6 +204,7 @@ typedef struct ext2_file *ext2_file_t;
> > #define EXT2_FLAG_IGNORE_CSUM_ERRORS	0x200000
> > #define EXT2_FLAG_SHARE_DUP		0x400000
> > #define EXT2_FLAG_IGNORE_SB_ERRORS	0x800000
> > +#define EXT2_FLAG_JOURNAL_ONLY		0x1000000
> > 
> > /*
> >  * Special flag in the ext2 inode i_flag field that means that this is
> > diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> > index 85d73e2a..af671070 100644
> > --- a/lib/ext2fs/openfs.c
> > +++ b/lib/ext2fs/openfs.c
> > @@ -135,6 +135,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
> > 	int		j;
> > #endif
> > 	char		*time_env;
> > +	unsigned long	enough_desc_blocks;
> > 
> > 	EXT2_CHECK_MAGIC(manager, EXT2_ET_MAGIC_IO_MANAGER);
> > 
> > @@ -440,12 +441,23 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
> > 		dest += fs->blocksize*first_meta_bg;
> > 	}
> > 
> > -	for (i = first_meta_bg ; i < fs->desc_blocks; i++) {
> > +	/*
> > +	 * Need superblock and journal inode only. Do not read
> > +	 * met_bg group blocks if journal inode group already loaded
> > +	 */
> > +	if (flags & EXT2_FLAG_JOURNAL_ONLY)
> > +		enough_desc_blocks =
> > +			fs->super->s_journal_inum /
> > +			EXT2_INODES_PER_GROUP(fs->super) + 1;
> > +	else
> > +		enough_desc_blocks = fs->desc_blocks;
> > +
> > +	for (i = first_meta_bg; i < enough_desc_blocks; i++) {
> > 		blk = ext2fs_descriptor_block_loc2(fs, group_block, i);
> > 		io_channel_cache_readahead(fs->io, blk, 1);
> > 	}
> > 
> > -	for (i=first_meta_bg ; i < fs->desc_blocks; i++) {
> > +	for (i = first_meta_bg; i < enough_desc_blocks; i++) {
> > 		blk = ext2fs_descriptor_block_loc2(fs, group_block, i);
> > 		retval = io_channel_read_blk64(fs->io, blk, 1, dest);
> > 		if (retval)
> > @@ -468,8 +480,12 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
> > 	 */
> > 	if (superblock > 1 && ext2fs_has_group_desc_csum(fs)) {
> > 		dgrp_t group;
> > +		dgrp_t enough_desc_count;
> > +
> > +		enough_desc_count = enough_desc_blocks *
> > +				    EXT2_DESC_PER_BLOCK(fs->super);
> > 
> > -		for (group = 0; group < fs->group_desc_count; group++) {
> > +		for (group = 0; group < enough_desc_count; group++) {
> > 			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
> > 			ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
> > 			ext2fs_bg_itable_unused_set(fs, group, 0);
> > diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> > index cd4057c3..b226fdbf 100644
> > --- a/misc/tune2fs.c
> > +++ b/misc/tune2fs.c
> > @@ -2882,6 +2882,12 @@ retry_open:
> > 	/* keep the filesystem struct around to dump MMP data */
> > 	open_flag |= EXT2_FLAG_NOFREE_ON_ERROR;
> > 
> > +	if (print_label || L_flag) {
> > +		open_flag |= EXT2_FLAG_JOURNAL_ONLY;
> > +		/* don't want metadata to be flushed at close */
> > +		//open_flag &= ~EXT2_FLAG_RW;

Might want to remove this ^^^^^ commented out line too...

--D

> > +	}
> > +
> > 	retval = ext2fs_open2(device_name, io_options, open_flag,
> > 			      0, 0, io_ptr, &fs);
> > 	if (retval) {
> > @@ -2999,7 +3005,6 @@ _("Warning: The journal is dirty. You may wish to replay the journal like:\n\n"
> > 	if ((open_flag & EXT2_FLAG_RW) && !(mount_flags & (EXT2_MF_BUSY | EXT2_MF_MOUNTED)) &&
> > 	    ext2fs_has_feature_journal_needs_recovery(fs->super)) {
> > 		errcode_t err;
> > -
> > 		printf(_("Recovering journal.\n"));
> > 		err = ext2fs_run_ext3_journal(&fs);
> > 		if (err) {
> 
> Not sure why this hunk is here?  There should normally be a blank line after
> local variable declarations.
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
