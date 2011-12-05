From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 06/22] ext4: Calculate and verify inode checksums
Date: Mon, 5 Dec 2011 11:45:39 -0800
Message-ID: <20111205194539.GD7137@tux1.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232656.19194.82262.stgit@elm3c44.beaverton.ibm.com> <20111205162406.GB32031@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37947 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab1LETuc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 14:50:32 -0500
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 5 Dec 2011 14:50:28 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pB5JjlU0288444
	for <linux-ext4@vger.kernel.org>; Mon, 5 Dec 2011 14:45:47 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pB5JjkFW004359
	for <linux-ext4@vger.kernel.org>; Mon, 5 Dec 2011 14:45:47 -0500
Content-Disposition: inline
In-Reply-To: <20111205162406.GB32031@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 05, 2011 at 11:24:06AM -0500, Ted Ts'o wrote:
> On Mon, Nov 28, 2011 at 03:26:56PM -0800, Darrick J. Wong wrote:
> > +	/* Precompute second piece of csum */
> > +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> > +			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> > +		__u32 csum;
> > +		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> > +		__le32 inum = cpu_to_le32(inode->i_ino);
> > +		__le32 gen = cpu_to_le32(inode->i_generation);
> > +		csum = ext4_chksum(sbi, sbi->s_uuid_csum, (__u8 *)&inum,
> > +				   sizeof(inum));
> > +		ei->i_uuid_inum_csum = ext4_chksum(sbi, csum, (__u8 *)&gen,
> > +						   sizeof(gen));
> > +	}
> 
> Why do we include a copy of i_generation in the precomputed initial
> part of the checksum?  Since i_generation is in the raw, on-disk
> version of the inode, what's the rationale for including it here?  It
> shouldn't *hurt*, but it a few extra CPU cycles, and I'm not seeing
> how it helps.

i_uuid_inum_csum seeds crc32c for all the metadata objects that are attached to
an inode (extents, dir blocks, xattrs), not just the inode itself.  That way
you can ensure that a piece of metadata corresponds to a specific incarnation
of an inode, not just any of the inode's incarnations since mkfs time.

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

