From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 4/4] ext4: implement ext4_fiemap
Date: Fri, 04 Jul 2008 13:03:12 -0600
Message-ID: <20080704190312.GY6239@webber.adilger.int>
References: <20080625221915.GU28100@wotan.suse.de>
 <1215104513.4272.23.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mark Fasheh <mfasheh@suse.com>, Eric Sandeen <sandeen@redhat.com>,
	linux-ext4@vger.kernel.org
To: Kalpak Shah <Kalpak.Shah@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54979 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYGDTDQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2008 15:03:16 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m64J3EYa018466
	for <linux-ext4@vger.kernel.org>; Fri, 4 Jul 2008 12:03:15 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K3H00M01WTHPB00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 04 Jul 2008 12:03:14 -0700 (PDT)
In-reply-to: <1215104513.4272.23.camel@localhost>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 03, 2008  22:31 +0530, Kalpak Shah wrote:
> On Wed, 2008-06-25 at 15:19 -0700, Mark Fasheh wrote:
> > +int ext4_xattr_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo)
> > +{
> > +	/* in-inode? */
> > +	if (EXT4_I(inode)->i_state & EXT4_STATE_XATTR) {
> > +		struct ext4_iloc iloc;
> > +		int offset;	/* offset of xattr in inode */
> > +
> > +		physical = iloc.bh->b_blocknr << blockbits;
> > +		offset = EXT4_GOOD_OLD_INODE_SIZE +
> > +				EXT4_I(inode)->i_extra_isize;
>  
> @@ -3148,14 +3148,24 @@ int ext4_xattr_fiemap(struct inode *inod
>  		physical += offset;
>  		length = EXT4_SB(inode->i_sb)->s_inode_size - offset;
>  		flags |= FIEMAP_EXTENT_DATA_INLINE;
> -	} else { /* external block */
> -		physical = EXT4_I(inode)->i_file_acl << blockbits;
> -		length = inode->i_sb->s_blocksize;
> +		if (EXT4_I(inode)->i_file_acl == 0)
> +			flags |= FIEMAP_EXTENT_LAST;
> +
> +		error = fiemap_fill_next_extent(fieinfo, 0, physical, length,
> +						flags, inode->i_sb->s_dev);
> +		if (error)
> +			goto out;
>  	}
>  
> +	/* external block */
> +	flags = FIEMAP_EXTENT_LAST;
> +	physical = EXT4_I(inode)->i_file_acl << blockbits;
> +	length = inode->i_sb->s_blocksize;
>  	if (physical)
> -		error = fiemap_fill_next_extent(fieinfo, 0, physical,
> -					length, flags, inode->i_sb->s_dev);
> +		error = fiemap_fill_next_extent(fieinfo, 0, physical, length,
> +						flags, inode->i_sb->s_dev);
> +
> +out:
>  	return (error < 0 ? error : 0);

It seems a bit unpleasant to have both logical offsets be 0 in this case.
I'd suggest having the in-inode logical offset be "offset", and the external
EA logical offset be "s_inode_size" or "s_blocksize".

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

