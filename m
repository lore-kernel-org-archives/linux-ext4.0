From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Tue, 10 Jul 2007 16:30:27 -0700
Message-ID: <20070710163027.1bf7e94e.akpm@linux-foundation.org>
References: <1183275416.4010.125.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761848AbXGJXam (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 19:30:42 -0400
In-Reply-To: <1183275416.4010.125.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:36:56 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> This patch is a spinoff of the old nanosecond patches.

I don't know what the "old nanosecond patches" are.  A link to a suitable
changlog for those patches would do in a pinch.  Preferable would be to
write a proper changelog for this patch.

> It includes some cleanups and addition of a creation timestamp. The
> EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
> s_{min, want}_extra_isize fields in struct ext3_super_block.
> 
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> Index: linux-2.6.22-rc4/fs/ext4/ialloc.c

Please include diffstat output when preparing patches.

> +
> +#define EXT4_FITS_IN_INODE(ext4_inode, einode, field)	\
> +	((offsetof(typeof(*ext4_inode), field) +	\
> +	  sizeof((ext4_inode)->field))			\
> +	<= (EXT4_GOOD_OLD_INODE_SIZE +			\
> +	    (einode)->i_extra_isize))			\

Please add explanatory commentary to EXT4_FITS_IN_INODE(): tell readers
under what circumstances something will not fit in an inode and what the
consequences of this are.

> +static inline __le32 ext4_encode_extra_time(struct timespec *time)
> +{
> +       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
> +			   time->tv_sec >> 32 : 0) |
> +			   ((time->tv_nsec << 2) & EXT4_NSEC_MASK));
> +}
> +
> +static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
> +{
> +       if (sizeof(time->tv_sec) > 4)
> +	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
> +			       << 32;
> +       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
> +}

Consider uninlining these functions.

> +#define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)			       \
> +do {									       \
> +	(raw_inode)->xtime = cpu_to_le32((inode)->xtime.tv_sec);	       \
> +	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
> +		(raw_inode)->xtime ## _extra =				       \
> +				ext4_encode_extra_time(&(inode)->xtime);       \
> +} while (0)
> +
> +#define EXT4_EINODE_SET_XTIME(xtime, einode, raw_inode)			       \
> +do {									       \
> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
> +		(raw_inode)->xtime = cpu_to_le32((einode)->xtime.tv_sec);      \
> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
> +		(raw_inode)->xtime ## _extra =				       \
> +				ext4_encode_extra_time(&(einode)->xtime);      \
> +} while (0)
> +
> +#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
> +do {									       \
> +	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	       \
> +	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
> +		ext4_decode_extra_time(&(inode)->xtime,			       \
> +				       raw_inode->xtime ## _extra);	       \
> +} while (0)
> +
> +#define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
> +do {									       \
> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
> +		(einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
> +	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
> +		ext4_decode_extra_time(&(einode)->xtime,		       \
> +				       raw_inode->xtime ## _extra);	       \
> +} while (0)

Ugly.  I expect these could be implemented as plain old C functions. 
Caller could pass in the address of the ext4_inode field which the function
is to operate upon.

>  #if defined(__KERNEL__) || defined(__linux__)

(What's the __linux__ for?)

>  #define i_reserved1	osd1.linux1.l_i_reserved1
>  #define i_frag		osd2.linux2.l_i_frag
> @@ -539,6 +603,13 @@
>  	return container_of(inode, struct ext4_inode_info, vfs_inode);
>  }
>  
> +static inline struct timespec ext4_current_time(struct inode *inode)
> +{
> +	return (inode->i_sb->s_time_gran < NSEC_PER_SEC) ?
> +		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
> +}

Now, I've forgotten how this works.  Remind me, please.  Can ext4
filesystems ever have one-second timestamp granularity?  If so, how does
one cause that to come about?

> --- linux-2.6.22-rc4.orig/include/linux/ext4_fs_i.h	2007-06-11 17:22:15.000000000 -0700
> +++ linux-2.6.22-rc4/include/linux/ext4_fs_i.h	2007-06-11 17:39:05.000000000 -0700
> @@ -153,6 +153,7 @@
>  
>  	unsigned long i_ext_generation;
>  	struct ext4_ext_cache i_cached_extent;
> +	struct timespec i_crtime;
>  };

It is unobvious what this field does.  Please prefer to add commentary to
_all_ struct fields - it really helps.

I thought checkpatch was going to have a little whine about that but the
version I have here doesn't.

>  
>  #endif	/* _LINUX_EXT4_FS_I */
> Index: linux-2.6.22-rc4/include/linux/ext4_fs_sb.h
> ===================================================================
> --- linux-2.6.22-rc4.orig/include/linux/ext4_fs_sb.h	2007-06-11 17:28:15.000000000 -0700
> +++ linux-2.6.22-rc4/include/linux/ext4_fs_sb.h	2007-06-11 17:39:05.000000000 -0700
> @@ -79,6 +79,7 @@
>  	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
>  	int s_jquota_fmt;			/* Format of quota to use */
>  #endif
> +	unsigned int s_want_extra_isize; /* New inodes should reserve # bytes */
>  
>  #ifdef EXTENTS_STATS

OK, I can kind-of see how this is working, but some overall description of
how the inode sizing design operates would be helpful.  It would certainly
make reviewing of this proposed change more fruitful.  Perhaps that new
comment over EXT4_FITS_IN_INODE() would be a suitable place.
