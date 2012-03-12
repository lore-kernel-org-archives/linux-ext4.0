From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 13/54] e2fsck: Verify inode bitmap checksum
Date: Mon, 12 Mar 2012 15:30:10 -0700
Message-ID: <20120312223010.GO15164@tux1.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com> <20120306235844.11945.9126.stgit@elm3b70.beaverton.ibm.com> <20120310054657.GA1048@thunk.org> <20120311021150.GB1048@thunk.org> <20120312212537.GL15164@tux1.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:59535 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab2CLWaU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Mar 2012 18:30:20 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 12 Mar 2012 16:30:20 -0600
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 18B46C9005A
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 18:30:16 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2CMUFQA1908904
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 18:30:15 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2CMUBno027407
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 19:30:14 -0300
Content-Disposition: inline
In-Reply-To: <20120312212537.GL15164@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 12, 2012 at 02:25:37PM -0700, Darrick J. Wong wrote:
> On Sat, Mar 10, 2012 at 09:11:50PM -0500, Ted Ts'o wrote:
> > On Sat, Mar 10, 2012 at 12:46:57AM -0500, Ted Ts'o wrote:
> > > 
> > > This patch just looks wrong.  RO_COMPAT_GDT_CSUM is the old feature,
> > > and doesn't imply that there will be a checksum in the inode bitmap
> > > block.  Shouldn't this be RO_COMPAT_METADATA_CSUM?
> > 
> > Correction; the big problem here is that check_inode_bitmap_checksum()
> > (and in the next e2fsck page, check_block_bitmap_checksum()) are are
> > doing their thing without actually checking for
> > RO_COMPAT_METADATA_CSUM).  These code paths shouldn't be getting
> > activated at all for non-METADATA_CSUM file systems.  But they are.
> 
> You're right, the function could be optimized to exit early if metadata_csum
> isn't set.  The bitmap verify function won't flag errors when metadata_csum is
> unset, at least, but I suppose it is unecessary looping and IO.
> 
> --D
> 
> > (And the check_block_bitmap_checksum() function is using
> > EXT2_BLOCKS_PER_GROUP where it needs to use EXT2_CLUSTERS_PER_GROUP or
> > it will end up corrupting memory which will cause the bigalloc-related
> > test f_dup_ba blow up.  But again, this code path shouldn't have been
> > getting activated in the first place.)

As for this bit -- I should have paid closer attention when bigalloc went in.
I'll send out a corrected patch.

--D
> > 
> > 					- Ted
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

