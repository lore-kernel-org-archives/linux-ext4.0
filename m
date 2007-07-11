From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 3][PATCH 1/1] ext4 nanosecond timestamp
Date: Wed, 11 Jul 2007 05:28:46 -0600
Message-ID: <20070711112846.GP6417@schatzie.adilger.int>
References: <1183275416.4010.125.camel@localhost.localdomain> <20070710163027.1bf7e94e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:36028 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbXGKL2y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 07:28:54 -0400
Content-Disposition: inline
In-Reply-To: <20070710163027.1bf7e94e.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  16:30 -0700, Andrew Morton wrote:
> > +#define EXT4_FITS_IN_INODE(ext4_inode, einode, field)	\
> > +	((offsetof(typeof(*ext4_inode), field) +	\
> > +	  sizeof((ext4_inode)->field))			\
> > +	<= (EXT4_GOOD_OLD_INODE_SIZE +			\
> > +	    (einode)->i_extra_isize))			\
> 
> Please add explanatory commentary to EXT4_FITS_IN_INODE(): tell readers
> under what circumstances something will not fit in an inode and what the
> consequences of this are.

/* Extended fields will fit into an inode if the filesystem was formatted
 * with large inodes (-I 256 or larger) and there are not currently EAs
 * consuming all of the available space.  For new inodes we always reserve
 * enough space for the kernel's known extended fields, but for inodes
 * created with an old kernel this might not have been the case.  None of
 * the extended inode fields is critical for correct filesystem operation.
 */

> > +#define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
> > +do {									       \
> > +	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	       \
> > +	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
> > +		ext4_decode_extra_time(&(inode)->xtime,			       \
> > +				       raw_inode->xtime ## _extra);	       \
> > +} while (0)
> 
> Ugly.  I expect these could be implemented as plain old C functions. 
> Caller could pass in the address of the ext4_inode field which the function
> is to operate upon.

We thought about that also, but then the caller needs to do all of the
pointer gymnastics themselves like:

     ext4_inode_get_xtime(&inode->i_ctime, &inode->i_ctime_extra,
                         &raw_inode->i_ctime, &raw_inode->i_ctime_extra)

instead of the current:

     EXT4_INODE_GET_XTIME(ctime, inode, raw_inode);

IMHO it is preferrable to make the multiple callsites more readable than
the macros.

> >  #if defined(__KERNEL__) || defined(__linux__)
> 
> (What's the __linux__ for?)
> 
> >  #define i_reserved1	osd1.linux1.l_i_reserved1
> >  #define i_frag		osd2.linux2.l_i_frag

This is actually unrelated to the current patch, just part of the context.
AFAIK, this is historical, so that the kernel and e2fsprogs can use the
same ext2_fs.h header.  I don't think it is really needed, but such cleanup
shouldn't be a part of this patch either.

> > +static inline struct timespec ext4_current_time(struct inode *inode)
> > +{
> > +	return (inode->i_sb->s_time_gran < NSEC_PER_SEC) ?
> > +		current_fs_time(inode->i_sb) : CURRENT_TIME_SEC;
> > +}
> 
> Now, I've forgotten how this works.  Remind me, please.  Can ext4
> filesystems ever have one-second timestamp granularity?  If so, how does
> one cause that to come about?

Yes, this is possible if an ext2/3/4 filesystem is formatted with 128-byte
inodes (which is the default for all but ext4) and this fs is mounted as
ext4dev.  The inodes can never hold the extra time information (FITS_IN_INODE
check above) so the superblock limits the timestamp resolution to 1s in that
case.

> > @@ -153,6 +153,7 @@
> >  
> >  	unsigned long i_ext_generation;
> >  	struct ext4_ext_cache i_cached_extent;
> > +	struct timespec i_crtime;
> >  };
> 
> It is unobvious what this field does.  Please prefer to add commentary to
> _all_ struct fields - it really helps.

It is the inode creation time.  This is useful for debug/forensic purposes,
and at some point there will be an API so that Samba can use it also.

> >  #endif	/* _LINUX_EXT4_FS_I */
> > Index: linux-2.6.22-rc4/include/linux/ext4_fs_sb.h
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/include/linux/ext4_fs_sb.h	2007-06-11 17:28:15.000000000 -0700
> > +++ linux-2.6.22-rc4/include/linux/ext4_fs_sb.h	2007-06-11 17:39:05.000000000 -0700
> > @@ -79,6 +79,7 @@
> >  	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
> >  	int s_jquota_fmt;			/* Format of quota to use */
> >  #endif
> > +	unsigned int s_want_extra_isize; /* New inodes should reserve # bytes */
> 
> OK, I can kind-of see how this is working, but some overall description of
> how the inode sizing design operates would be helpful.  It would certainly
> make reviewing of this proposed change more fruitful.  Perhaps that new
> comment over EXT4_FITS_IN_INODE() would be a suitable place.

Hmm, I'm sure there were emails on the topic, but they aren't attached to
the patch.  s_want_extra_isize is just an override for sizeof(ext4_inode)
in case the sysadmin wants to reserve more fields in new inodes.  There is
also s_min_extra_isize which is what the kernel and e2fsck guarantee that
will be available in all in-use inodes, if RO_COMPAT_EXTRA_ISIZE is set
(ro-compat so that older kernels can't create inodes with a smaller
extra_isize).  That feature is only enabled if requested by the sysadmin.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
