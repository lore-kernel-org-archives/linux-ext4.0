From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] [patch 2/2] i_version update - ext4 part
Date: Mon, 14 May 2007 14:31:48 -0600
Message-ID: <20070514203147.GA26257@schatzie.adilger.int>
References: <1179140701.7733.4.camel@frecb002711.frec.bull.fr> <20070514202148.GE5286@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Kalpak Shah <kalpak@clusterfs.com>
To: Cordenner jean noel <jean-noel.cordenner@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43484 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759AbXENUbu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2007 16:31:50 -0400
Content-Disposition: inline
In-Reply-To: <20070514202148.GE5286@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 14, 2007  14:21 -0600, Andreas Dilger wrote:
> On May 14, 2007  13:05 +0200, Cordenner jean noel wrote:
> > @@ -331,12 +331,13 @@
> >  	} osd2;				/* OS dependent 2 */
> >  	__le16	i_extra_isize;
> >  	__le16	i_pad1;
> > +	__le32	i_disk_version_hi;
> 
> No, this is not correct.  There are already several other fields here
> (nanosecond ctime, mtime, atime, crtime (creation time)) so you need
> to use the correct reserved field for this.
> 
> 	__u16	i_extra_isize;
> 	__u16	i_pad1;
> 	__u32	i_ctime_extra;	/* extra Change time (nsec << 2 | epoch) */
> 	__u32	i_mtime_extra;	/* extra Modification time (nsec << 2 | epoch)*/
> 	__u32	i_atime_extra;	/* extra Access time (nsec << 2 | epoch) */
> 	__u32	i_crtime;	/* File creation time */
> 	__u32	i_crtime_extra;	/* extra File creation time (nsec << 2 |epoch)*/

Sorry, I meant to add (before hitting send :-) that the field after
i_crtime_extra is supposed to be "i_disk_version_hi".

See the patch from Kalpak Shah "[RFC] 64-bit inode version" which also handles
the case for expanding i_extra_isize to cover the needed extra fields if
i_extra_isize is not large enough.  That patch didn't include the 64-bit
i_version_hi yet, because there wasn't yet agreement at that time if
the iversion_hi should be allocated separately, but that was since decided.

Without that patch, your patch will possibly corrupt the extended attributes
by just overwriting i_disk_version_hi while ignoring the actual value of
i_extra_isize.  This would clobber the EA magic and result in loss of all
EAs in that inode.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
