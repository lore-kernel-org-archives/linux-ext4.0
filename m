From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 4][PATCH 2/5] i_version: Add hi 32 bit inode version on ext4 on-disk inode
Date: Wed, 11 Jul 2007 05:46:16 -0600
Message-ID: <20070711114616.GR6417@schatzie.adilger.int>
References: <1183275436.4010.127.camel@localhost.localdomain> <20070710163047.1aba94f9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:50771 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760729AbXGKLqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 07:46:19 -0400
Content-Disposition: inline
In-Reply-To: <20070710163047.1aba94f9.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  16:30 -0700, Andrew Morton wrote:
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> > Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> > ---
> > Index: linux-2.6.21/include/linux/ext4_fs.h
> > ===================================================================
> > --- linux-2.6.21.orig/include/linux/ext4_fs.h
> > +++ linux-2.6.21/include/linux/ext4_fs.h
> > @@ -342,6 +342,7 @@ struct ext4_inode {
> >  	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
> >  	__le32  i_crtime;       /* File Creation time */
> >  	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
> > +	__le32	i_version_hi;	/* high 32 bits for 64-bit version */
> >  };
> 
> Aren't there forward- backward-compatibility issues here?  How does the
> filesystem driver work out whether this field is present and valid?

This uses the same EXT4_FITS_IN_INODE() check as any other, so the
compatibility issues are handled.  NFSv4 could live with 32-bit versions
with only a small danger of overflow, so we can still export ext3
filesystems with 128-byte inodes that have been updated to ext4.  For
Lustre (which requires 64-bit versions), we will enforce that space is
available with s_min_extra_isize and RO_COMPAT_EXTRA_ISIZE.

In the case where an older ext3/ext4 filesystem with large inodes does
not have enough space for i_version_hi the EAs that follow i_extra_isize
will be shifted to make room for it (if possible, which is likely).  There
are no critical fields inside i_extra_isize so in the rare case of a
failure to enlarge the i_extra_isize is not a cause for alarm.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
