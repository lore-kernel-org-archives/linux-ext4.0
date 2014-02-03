From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] libext2fs: allow clients to read-ahead metadata
Date: Mon, 3 Feb 2014 15:26:36 -0800
Message-ID: <20140203232636.GB9176@birch.djwong.org>
References: <20140201103721.9011.5971.stgit@birch.djwong.org>
 <20140201103735.9011.14433.stgit@birch.djwong.org>
 <0E88D038-7509-435F-BBAF-6A8416749785@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38762 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaBCX0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Feb 2014 18:26:41 -0500
Content-Disposition: inline
In-Reply-To: <0E88D038-7509-435F-BBAF-6A8416749785@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 03, 2014 at 02:32:45PM -0700, Andreas Dilger wrote:
> On Feb 1, 2014, at 3:37 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > This patch adds to libext2fs the ability to pre-fetch metadata
> > into the page cache in the hopes of speeding up libext2fs' clients.
> > There are two new library functions -- the first allows a client to
> > readahead a list of blocks, and the second is a helper function that
> > uses that first mechanism to load group data (bitmaps, inode tables).
> > 
> > e2fsck will employ both of these methods to speed itself up.
> > 
> > diff --git a/lib/ext2fs/readahead.c b/lib/ext2fs/readahead.c
> > new file mode 100644
> > index 0000000..05f6135
> > --- /dev/null
> > +++ b/lib/ext2fs/readahead.c
> > +errcode_t ext2fs_readahead(ext2_filsys fs, int flags, dgrp_t start,
> > +			   dgrp_t ngroups)
> > +{
> > +
> > +	for (i = start; i < end; i++) {
> > +		if ((flags & EXT2FS_READ_ITABLE) &&
> > +		    ext2fs_bg_free_inodes_count(fs, i) <
> > +				fs->super->s_inodes_per_group) {
> > +			super = ext2fs_inode_table_loc(fs, i);
> > +			err = ext2fs_add_dir_block2(dblist, 0, super,
> > +					fs->inode_blocks_per_group);
> 
> This prefetches all of the inode table blocks, when it could instead
> just prefetch the in-use blocks using:
> 
> 		if ((flags & EXT2FS_READ_ITABLE) &&
> 		    ext2fs_bg_itable_unused(fs, i) <
> 		    fs->inode_blocks_per_group))
> 			err = ext2fs_add_dir_block2(dblist, 0, super,
> 					fs->inode_blocks_per_group - 
> 					ext2fs_bg_itable_unused(fs, i));

I think you need to convert ext2fs_bg_itable_unused() to blocks there, but
point taken.  Actually, the first insane-o patch had this, but I forgot it when
writing up the second version.

> If there is corruption in the filesystem and the "unused" blocks need
> to be read later it is probably more than offset by not reading those
> actually unused blocks for the rest of the time.

<shrug> I'm not particularly concerned about less than optimal IO throughput on
broken filesystems.

--D
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


