From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/1] [RFC] 64-bit inode version
Date: Wed, 11 Apr 2007 12:30:04 -0600
Message-ID: <20070411183004.GU5967@schatzie.adilger.int>
References: <1176297438.7350.23.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Eric Sandeen <sandeen@redhat.com>, sct <sct@redhat.com>,
	TheodoreTso <tytso@mit.edu>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:42871 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbXDKSaG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Apr 2007 14:30:06 -0400
Content-Disposition: inline
In-Reply-To: <1176297438.7350.23.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 11, 2007  18:47 +0530, Kalpak Shah wrote:
> This patch adds 64-bit inode version support to ext4. The lower 32 bits
> are stored in the osd1.linux1.l_i_version field while the high 32 bits
> are stored in the i_version_hi field newly created in the ext4_inode.

Note that this is NOT a duplicate of the Bull "change attribute" patches,
rather this implements only the on-disk storage of the 64-bit version
number, and the ability to resize i_extra_isize to allow inodes in the
filesystem which weren't created with a big enough i_extra_isize to add
new fields.  That would basically be needed by all ext4 filesystems that
did not yet have the nanosecond timestamp patches applied when they were
created.

> +		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
> +			ei->i_fs_version |= (__u64)(le32_to_cpu(raw_inode->i_version_hi))
> +									 << 32;

Minor nit - can the wrapping here be fixed when it is added to the git tree:

			ei->i_fs_version |=
				(__u64)le32_to_cpu(raw_inode->i_version_hi)<<32;

> +		if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi)) {
> +			raw_inode->i_version_hi = cpu_to_le32(ei->i_fs_version
> +									>> 32);

And here:
			raw_inode->i_version_hi =
				cpu_to_le32(ei->i_fs_version >> 32);


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
