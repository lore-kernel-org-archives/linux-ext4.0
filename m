From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 02/54] libext2fs: Change ext4 on-disk layout to support
	metadata checksumming
Date: Mon, 12 Mar 2012 15:24:17 -0700
Message-ID: <20120312222417.GN15164@tux1.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com> <20120306235734.11945.46038.stgit@elm3b70.beaverton.ibm.com> <20120309220435.GC5635@thunk.org>
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
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41788 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757548Ab2CLWY0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 18:24:26 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 12 Mar 2012 18:24:25 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 281ED6E804C
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 18:24:23 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2CMOMcx330862
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 18:24:22 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2CMOJ55005516
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 18:24:21 -0400
Content-Disposition: inline
In-Reply-To: <20120309220435.GC5635@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 09, 2012 at 05:04:35PM -0500, Ted Ts'o wrote:
> On Tue, Mar 06, 2012 at 03:57:34PM -0800, Darrick J. Wong wrote:
> > Define flags and extend ext4 structure definitions to support metadata
> > checksumming.  Ted T'so covered many of these fields in an earlier patch, but
> > there are more required changes to the disk layout.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> > @@ -619,7 +630,7 @@ struct ext2_super_block {
> >  	__u64   s_mmp_block;            /* Block for multi-mount protection */
> >  	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
> >  	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
> > -	__u8    s_reserved_char_pad;
> > +	__u8    s_checksum_type;	/* metadata checksum algorithm */
> >  	__u16	s_reserved_pad;		/* Padding to next 32bits */
> >  	__u64	s_kbytes_written;	/* nr of lifetime kilobytes written */
> >  	__u32	s_snapshot_inum;	/* Inode number of active snapshot */
> 
> Note: when you change the superblock definition, you *must* also
> update the test in lib/ext2fs/tst_super_size.c.
> 
> If you don't then running "make check" from the top-level of the build
> tree will likely bomb out.  And you will also reveal to me that you
> haven't run the full set of regression tests before submitting your
> patch series.  :-)

Ok, thank you for catching (and fixing) this.

--D
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

