From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] [patch 2/2] i_version update - ext4 part
Date: Mon, 14 May 2007 15:11:09 -0700
Message-ID: <1179180669.3772.20.camel@dyn9047017103.beaverton.ibm.com>
References: <1179140701.7733.4.camel@frecb002711.frec.bull.fr>
	 <20070514202148.GE5286@schatzie.adilger.int>
	 <20070514203147.GA26257@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Cordenner jean noel <jean-noel.cordenner@bull.net>,
	linux-ext4@vger.kernel.org, Kalpak Shah <kalpak@clusterfs.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:53197 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbXENWLR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 May 2007 18:11:17 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l4EM7cEe010329
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 18:07:38 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4EMBBP1140650
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 16:11:11 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4EMBBJo032259
	for <linux-ext4@vger.kernel.org>; Mon, 14 May 2007 16:11:11 -0600
In-Reply-To: <20070514203147.GA26257@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-05-14 at 14:31 -0600, Andreas Dilger wrote:
> On May 14, 2007  14:21 -0600, Andreas Dilger wrote:
> > On May 14, 2007  13:05 +0200, Cordenner jean noel wrote:
> > > @@ -331,12 +331,13 @@
> > >  	} osd2;				/* OS dependent 2 */
> > >  	__le16	i_extra_isize;
> > >  	__le16	i_pad1;
> > > +	__le32	i_disk_version_hi;
> > 
> > No, this is not correct.  There are already several other fields here
> > (nanosecond ctime, mtime, atime, crtime (creation time)) so you need
> > to use the correct reserved field for this.
> > 
> > 	__u16	i_extra_isize;
> > 	__u16	i_pad1;
> > 	__u32	i_ctime_extra;	/* extra Change time (nsec << 2 | epoch) */
> > 	__u32	i_mtime_extra;	/* extra Modification time (nsec << 2 | epoch)*/
> > 	__u32	i_atime_extra;	/* extra Access time (nsec << 2 | epoch) */
> > 	__u32	i_crtime;	/* File creation time */
> > 	__u32	i_crtime_extra;	/* extra File creation time (nsec << 2 |epoch)*/
> 
> Sorry, I meant to add (before hitting send :-) that the field after
> i_crtime_extra is supposed to be "i_disk_version_hi".
> 


> See the patch from Kalpak Shah "[RFC] 64-bit inode version" which also handles
> the case for expanding i_extra_isize to cover the needed extra fields if
> i_extra_isize is not large enough.  That patch didn't include the 64-bit
> i_version_hi yet, because there wasn't yet agreement at that time if
> the iversion_hi should be allocated separately, but that was since decided.
> 

Kalpak already sent a patch [PATCH] Add i_version_hi for 64-bit version,
which added i_version_hi after i_crtime. His patch has in ext4 git tree
for a while.

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.21-
ext4-1

Regards,
Mingming

> Without that patch, your patch will possibly corrupt the extended attributes
> by just overwriting i_disk_version_hi while ignoring the actual value of
> i_extra_isize.  This would clobber the EA magic and result in loss of all
> EAs in that inode.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
