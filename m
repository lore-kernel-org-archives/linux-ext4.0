From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 13/54] e2fsck: Verify inode bitmap checksum
Date: Mon, 12 Mar 2012 14:25:37 -0700
Message-ID: <20120312212537.GL15164@tux1.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com> <20120306235844.11945.9126.stgit@elm3b70.beaverton.ibm.com> <20120310054657.GA1048@thunk.org> <20120311021150.GB1048@thunk.org>
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
Received: from e34.co.us.ibm.com ([32.97.110.152]:59849 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab2CLV12 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Mar 2012 17:27:28 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 12 Mar 2012 15:27:22 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 28E97C40002
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 15:26:18 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2CLPvGX243490
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 15:26:02 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2CLPhVG027251
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 15:25:47 -0600
Content-Disposition: inline
In-Reply-To: <20120311021150.GB1048@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 10, 2012 at 09:11:50PM -0500, Ted Ts'o wrote:
> On Sat, Mar 10, 2012 at 12:46:57AM -0500, Ted Ts'o wrote:
> > 
> > This patch just looks wrong.  RO_COMPAT_GDT_CSUM is the old feature,
> > and doesn't imply that there will be a checksum in the inode bitmap
> > block.  Shouldn't this be RO_COMPAT_METADATA_CSUM?
> 
> Correction; the big problem here is that check_inode_bitmap_checksum()
> (and in the next e2fsck page, check_block_bitmap_checksum()) are are
> doing their thing without actually checking for
> RO_COMPAT_METADATA_CSUM).  These code paths shouldn't be getting
> activated at all for non-METADATA_CSUM file systems.  But they are.

You're right, the function could be optimized to exit early if metadata_csum
isn't set.  The bitmap verify function won't flag errors when metadata_csum is
unset, at least, but I suppose it is unecessary looping and IO.

--D

> (And the check_block_bitmap_checksum() function is using
> EXT2_BLOCKS_PER_GROUP where it needs to use EXT2_CLUSTERS_PER_GROUP or
> it will end up corrupting memory which will cause the bigalloc-related
> test f_dup_ba blow up.  But again, this code path shouldn't have been
> getting activated in the first place.)
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

