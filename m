From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [EXT4 set 4][PATCH 3/5] i_version:ext4 inode version read/store
Date: Wed, 11 Jul 2007 05:50:13 -0600
Message-ID: <20070711115013.GS6417@schatzie.adilger.int>
References: <1183275456.4010.129.camel@localhost.localdomain> <20070710163117.d14fce90.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:51226 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759769AbXGKLuV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 07:50:21 -0400
Content-Disposition: inline
In-Reply-To: <20070710163117.d14fce90.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  16:31 -0700, Andrew Morton wrote:
> > This patch adds 64-bit inode version support to ext4. The lower 32 bits
> > are stored in the osd1.linux1.l_i_version field while the high 32 bits
> > are stored in the i_version_hi field newly created in the ext4_inode.
> 
> So reading the code here does serve to answer the question I raised against
> the earlier patch.  A bit.
> 
> I'd have thought that this patch and the one which adds i_version_hi should
> be folded into a single diff?

It could be - the original patch to reserve i_version_hi was submitted to
before the patches were ready to avoid that space being used by something
else.

> > +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
> > +		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
> > +			inode->i_version |=
> > +			(__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
> 
> <checks the precedence of "(type)" versus "<<">
> 
> <OK>
> 
> > +	}
> 
> I don't quite see how the above two tests are sufficient to unambiguously
> determine that the i_version_hi field is present on-disk.
> 
> I guess we're implicitly assuming that if the on-disk inode is big enough
> then it _must_ have i_version_hi in there?  If so, why is the comparison
> with EXT4_GOOD_OLD_INODE_SIZE needed?

The GOOT_OLD_INODE_SIZE check is needed to know if i_extra_isize is even
present or valid in the on-disk inode.

> > @@ -2852,8 +2859,14 @@ static int ext4_do_update_inode(handle_t
> > +	raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
> > +	if (ei->i_extra_isize) {
> > +		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi)) {
> 
> There's no comparison with EXT4_GOOD_OLD_INODE_SIZE here...

Because this is the in-memory version and it is always valid (set to zero
if there is extra space in the on-disk inode).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
