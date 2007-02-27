From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [PATCH 1/1] nanosecond timestamps
Date: Mon, 26 Feb 2007 17:11:26 -0700
Message-ID: <20070227001125.GH10715@schatzie.adilger.int>
References: <1170427180.6086.17.camel@garfield> <20070225023651.8c89f8fc.akpm@linux-foundation.org> <20070226214215.GE10715@schatzie.adilger.int> <1172532018.16469.5.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kalpak Shah <kalpak@clusterfs.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sct@redhat.com
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:42297 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965267AbXB0ALe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Feb 2007 19:11:34 -0500
Content-Disposition: inline
In-Reply-To: <1172532018.16469.5.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 26, 2007  17:20 -0600, Dave Kleikamp wrote:
> I wanted to see if I could clean this up, and this is what I came up
> with.  I also did some macro magic to make these macros take one less
> argument.  I ended up breaking two macros up into three smaller macros
> and two inline functions.  Does this look any better?  (This is
> incremental against Kalpak's patch.)
> 
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Looks like an improvement to me, if only to give a name and clarity to
the "EXT3_FITS_IN_INODE()" part of the function.

One other note - there was a problem with the original patch because
i_crtime is also in the extended part of the inode so it needs to
be validated against i_extra_isize so we need to submit a new patch
for that anyways and may as well include this cleanup in that patch.

Thanks Dave.

> diff -Nurp linux.orig/fs/ext3/inode.c linux/fs/ext3/inode.c
> --- linux.orig/fs/ext3/inode.c	2007-02-26 17:10:22.000000000 -0600
> +++ linux/fs/ext3/inode.c	2007-02-26 17:02:28.000000000 -0600
> @@ -2674,10 +2674,10 @@ void ext3_read_inode(struct inode * inod
>  	inode->i_nlink = le16_to_cpu(raw_inode->i_links_count);
>  	inode->i_size = le32_to_cpu(raw_inode->i_size);
>  
> -	EXT3_INODE_GET_XTIME(i_ctime, i_ctime_extra, inode, raw_inode);
> -	EXT3_INODE_GET_XTIME(i_mtime, i_mtime_extra, inode, raw_inode);
> -	EXT3_INODE_GET_XTIME(i_atime, i_atime_extra, inode, raw_inode);
> -	EXT3_INODE_GET_XTIME(i_crtime, i_crtime_extra, ei, raw_inode);
> +	EXT3_INODE_GET_XTIME(i_ctime, inode, raw_inode);
> +	EXT3_INODE_GET_XTIME(i_mtime, inode, raw_inode);
> +	EXT3_INODE_GET_XTIME(i_atime, inode, raw_inode);
> +	EXT3_INODE_GET_XTIME(i_crtime, ei, raw_inode);
>  
>  	ei->i_state = 0;
>  	ei->i_dir_start_lookup = 0;
> @@ -2829,10 +2829,10 @@ static int ext3_do_update_inode(handle_t
>  	}
>  	raw_inode->i_links_count = cpu_to_le16(inode->i_nlink);
>  	raw_inode->i_size = cpu_to_le32(ei->i_disksize);
> -	EXT3_INODE_SET_XTIME(i_ctime, i_ctime_extra, inode, raw_inode);
> -	EXT3_INODE_SET_XTIME(i_mtime, i_mtime_extra, inode, raw_inode);
> -	EXT3_INODE_SET_XTIME(i_atime, i_atime_extra, inode, raw_inode);
> -	EXT3_INODE_SET_XTIME(i_crtime, i_crtime_extra, ei, raw_inode);
> +	EXT3_INODE_SET_XTIME(i_ctime, inode, raw_inode);
> +	EXT3_INODE_SET_XTIME(i_mtime, inode, raw_inode);
> +	EXT3_INODE_SET_XTIME(i_atime, inode, raw_inode);
> +	EXT3_INODE_SET_XTIME(i_crtime, ei, raw_inode);
>  
>  	raw_inode->i_blocks = cpu_to_le32(inode->i_blocks);
>  	raw_inode->i_dtime = cpu_to_le32(ei->i_dtime);
> diff -Nurp linux.orig/include/linux/ext3_fs.h linux/include/linux/ext3_fs.h
> --- linux.orig/include/linux/ext3_fs.h	2007-02-26 17:10:22.000000000 -0600
> +++ linux/include/linux/ext3_fs.h	2007-02-26 17:07:20.000000000 -0600
> @@ -331,37 +331,42 @@ struct ext3_inode {
>  #define EXT3_EPOCH_MASK ((1 << EXT3_EPOCH_BITS) - 1)
>  #define EXT3_NSEC_MASK  (~0UL << EXT3_EPOCH_BITS)
>  
> +#define EXT3_FITS_IN_INODE(ext3_inode, field)	 	\
> +	((offsetof(typeof(*ext3_inode), field) -	 	\
> +	  offsetof(typeof(*ext3_inode), i_extra_isize) + 	\
> +	  sizeof((ext3_inode)->field)) <=			\
> +	 le16_to_cpu((ext3_inode)->i_extra_isize))
> +
> +static inline __le32 ext3_encode_extra_time(struct timespec *time)
> +{
> +	return cpu_to_le32((sizeof(time->tv_sec) > 4 ? time->tv_sec >> 32 : 0) |
> +			   ((time->tv_nsec << 2) & EXT3_NSEC_MASK));

I think this should be:

	return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
			    (time->tv_sec >> 32) & EXT3_EPOCH_MASK : 0) |
			   (time->tv_nsec << EXT3_EPOCH_BITS));

We should use EXT3_EPOCH_BITS, and don't really need "& EXT3_NSEC_MASK"
unless there is some reason to believe that tv_nsec is > 1e9.  Even then
it would be truncated at 32 bits by the (__u32) cast in cpu_to_le32().

> +static inline void ext3_decode_extra_time(struct timespec *time, __le32 extra) {
> +	if (sizeof(time->tv_sec) > 4)
> +		time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT3_EPOCH_MASK)
> +				<< 32;
> +	time->tv_nsec = (le32_to_cpu(extra) & EXT3_NSEC_MASK) >> 2;

And this should be:

	time->tv_nsec = (le32_to_cpu(extra) & EXT3_NSEC_MASK) >>EXT3_EPOCH_BITS;

We could again skip the "& EXT3_NSEC_MASK" because le32_to_cpu(extra) will
truncate the input at 32 bits, so:

	time->tv_nsec = le32_to_cpu(extra) >> EXT3_EPOCH_BITS;

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
