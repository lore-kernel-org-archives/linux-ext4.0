From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 09/51] libext2fs: Create the inode bitmap checksum
Date: Mon, 19 Dec 2011 12:03:04 -0800
Message-ID: <20111219200304.GJ8233@tux1.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011415.20947.77748.stgit@elm3c44.beaverton.ibm.com> <8D63B0B0-ED5C-426E-82FE-5122A84DFFEC@gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:60148 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1LSUEA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Dec 2011 15:04:00 -0500
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 19 Dec 2011 13:03:58 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBJK36q3100758
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 13:03:10 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBJK35Lq019621
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 13:03:06 -0700
Content-Disposition: inline
In-Reply-To: <8D63B0B0-ED5C-426E-82FE-5122A84DFFEC@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 18, 2011 at 07:18:20AM -0700, Andreas Dilger wrote:
> On 2011-12-13, at 18:14, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> > Provide a field in the block group descriptor to store inode bitmap checksum,
> > and some helper functions to calculate and verify it.
> > +int ext2fs_inode_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
> > +                    char *bitmap, int size)
> > +{
> > +    struct ext4_group_desc *gdp = (struct ext4_group_desc *)
> > +            ext2fs_group_desc(fs, fs->group_desc, group);
> > +    __u32 provided, calculated;
> > +
> > +    if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> > +                    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +        return 1;
> > +    provided = gdp->bg_inode_bitmap_csum_lo;
> > +    calculated = ext2fs_crc32c_le(~0, fs->super->s_uuid,
> > +                      sizeof(fs->super->s_uuid));
> 
> It makes sense to precompute the uuid checksum and store it in the
> ext2_filsys struct so that it is accessible everywhere, like is done in the
> kernel.

I wonder how much that'll help compared to the IO overhead, but I suppose every
bit helps.

> > +    calculated = ext2fs_crc32c_le(calculated, (unsigned char *)bitmap,
> > +                      size);
> > +    if (fs->super->s_desc_size >= EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION)
> > +        provided |= (__u32)gdp->bg_inode_bitmap_csum_hi << 16;
> > +    else
> > +        calculated &= 0xFFFF;
> > +
> > +    return provided == calculated;
> > +}
> > +
> > 
> > +++ b/lib/ext2fs/ext2_fs.h
> > @@ -191,6 +191,10 @@ struct ext4_group_desc
> >    __u32    bg_reserved;
> > };
> > 
> > +#define EXT4_BG_INODE_BITMAP_CSUM_HI_LOCATION    \
> > +    (offsetof(struct ext4_group_desc, bg_inode_bitmap_csum_hi) + \
> > +     sizeof(__u16))
> 
> It is a bit misleading to call this constant the "location" since it is
> actually the end of the csum_hi field.  Either the sizeof(__u16) should be
> moved to the caller, or this should be renamed to
> EXT4_BG_INODE_BITMAP_CSUM_HI_END or similar. 

Ok.

--D

