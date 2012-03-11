From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/54] e2fsck: Verify inode bitmap checksum
Date: Sat, 10 Mar 2012 21:11:50 -0500
Message-ID: <20120311021150.GB1048@thunk.org>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
 <20120306235844.11945.9126.stgit@elm3b70.beaverton.ibm.com>
 <20120310054657.GA1048@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55312 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab2CKCMA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 21:12:00 -0500
Content-Disposition: inline
In-Reply-To: <20120310054657.GA1048@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 10, 2012 at 12:46:57AM -0500, Ted Ts'o wrote:
> 
> This patch just looks wrong.  RO_COMPAT_GDT_CSUM is the old feature,
> and doesn't imply that there will be a checksum in the inode bitmap
> block.  Shouldn't this be RO_COMPAT_METADATA_CSUM?

Correction; the big problem here is that check_inode_bitmap_checksum()
(and in the next e2fsck page, check_block_bitmap_checksum()) are are
doing their thing without actually checking for
RO_COMPAT_METADATA_CSUM).  These code paths shouldn't be getting
activated at all for non-METADATA_CSUM file systems.  But they are.

(And the check_block_bitmap_checksum() function is using
EXT2_BLOCKS_PER_GROUP where it needs to use EXT2_CLUSTERS_PER_GROUP or
it will end up corrupting memory which will cause the bigalloc-related
test f_dup_ba blow up.  But again, this code path shouldn't have been
getting activated in the first place.)

					- Ted
