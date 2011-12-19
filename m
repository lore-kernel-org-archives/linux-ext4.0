From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 02/51] libext2fs: Change ext4 on-disk layout to support
	metadata checksumming
Date: Mon, 19 Dec 2011 12:13:49 -0800
Message-ID: <20111219201349.GM8233@tux1.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011330.20947.96607.stgit@elm3c44.beaverton.ibm.com> <BBB7550D-77E9-441D-8ECF-C5A5A3B839C8@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37452 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab1LSUSH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 15:18:07 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 19 Dec 2011 15:18:03 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBJKDrfS3420264
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 15:13:53 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBJKDoXE032762
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 15:13:53 -0500
Content-Disposition: inline
In-Reply-To: <BBB7550D-77E9-441D-8ECF-C5A5A3B839C8@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 19, 2011 at 05:54:23AM +0100, Andreas Dilger wrote:
> On 2011-12-14, at 2:13 AM, Darrick J. Wong wrote:
> > Define flags and extend ext4 structure definitions to support metadata
> > checksumming.  Ted T'so covered many of these fields in an earlier patch, but
> > there are more required changes to the disk layout.
> > 
> > diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> > index 0f8cde8..ce2fd66 100644
> > --- a/lib/ext2fs/ext2_fs.h
> > +++ b/lib/ext2fs/ext2_fs.h
> > @@ -234,6 +234,13 @@ struct ext2_dx_countlimit {
> > +/*
> > + * This goes at the end of each htree block.
> > + */
> > +struct ext2_dx_tail {
> > +	__u32 reserved;
> > +	__u32 checksum;	/* crc32c(uuid+inum+dxblock) */
> > +};
> 
> These should have a structure prefix, like "dxt_reserved" and "dxt_checksum"
> to make them easier to find with tags.
> 
> >  /*
> > + * This is a bogus directory entry at the end of each leaf block that
> > + * records checksums.
> > + */
> > +struct ext2_dir_entry_tail {
> > +	__u32	reserved_zero1;		/* Pretend to be unused */
> > +	__u16	rec_len;		/* 12 */
> > +	__u16	reserved_name_len;	/* 0xDE00, fake namelen/filetype */
> > +	__u32	checksum;		/* crc32c(uuid+inode+dirent) */
> > +};
> 
> Similarly, this should get a structure prefix for all of the fields, like
> "det_checksum" or similar.

Ok.

--D

