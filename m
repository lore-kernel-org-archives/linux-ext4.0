From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 11/37] libext2fs: Create the inode bitmap checksum
Date: Wed, 14 Sep 2011 12:31:50 -0700
Message-ID: <20110914193150.GZ12086@tux1.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003622.1176.1504.stgit@elm3c44.beaverton.ibm.com> <20110914170259.GG3429@dhcp-172-31-195-159.cam.corp.google.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42807 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424Ab1INTcP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 15:32:15 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8EJ1XRA032031
	for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 15:01:33 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8EJW7a9238038
	for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 15:32:07 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8EJVrcg030715
	for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 15:31:58 -0400
Content-Disposition: inline
In-Reply-To: <20110914170259.GG3429@dhcp-172-31-195-159.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 01:02:59PM -0400, Ted Ts'o wrote:
> On Wed, Aug 31, 2011 at 05:36:22PM -0700, Darrick J. Wong wrote:
> > diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> > index 1f08673..367bfdf 100644
> > --- a/lib/ext2fs/ext2_fs.h
> > +++ b/lib/ext2fs/ext2_fs.h
> > @@ -169,7 +169,8 @@ struct ext4_group_desc
> >  	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
> >  	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
> >  	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
> > -	__u32	bg_reserved2[3];
> > +	__u32	bg_inode_bitmap_csum;	/* crc32c(uuid+group+ibitmap) */
> > +	__u32	bg_reserved2[2];
> >  };
> 
> 
> One of the reasons why I like to coalesce the patches to the data
> structures into their own separate commit, is it's hard when I'm
> reviewing individual patches in a mail reader what's going on from a
> big picture spective.  (Heck, even just *finding* the patches that
> modify the on-disk format is hard....)
> 
> But as near as I can tell, your patch series only uses one of the
> 32-bit fields in bg_reserved.  Is there a good reason why
> bg_inode_bitmap_csum can't also used one of the two fields in
> bg_reserved?  That way we get two 32-bit checksums for both struct
> ext2_group_desc and struct ext4_group_desc.  Is there a third 32-bit
> per-block group checksum I'm forgetting about? 

No, but I was under the impression that Amir was using one of bg_reserved for
snapshots.  If that's not true, I'll move both bitmap checksums to bg_reserved.

--D
> 
> 	  		     		       - Ted
