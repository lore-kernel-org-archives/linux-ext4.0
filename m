From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: [Bug 9855] ext3 ACL corruption
Date: Tue, 05 Feb 2008 19:12:26 +1030
Message-ID: <1202200946.4280.4.camel@kulgan.wumi.org.au>
References: <1201771074.4480.2.camel@kulgan.wumi.org.au>
	 <20080131100539.GQ23836@webber.adilger.int>
	 <1201781664.4480.16.camel@kulgan.wumi.org.au>
	 <20080205010617.GL23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
	bugme-daemon@bugzilla.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:48432 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbYBEImf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 03:42:35 -0500
In-Reply-To: <20080205010617.GL23836@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-02-04 at 18:06 -0700, Andreas Dilger wrote:
> Hmm, I wonder if e2fsck is calculating the wrong file offset or something?
> The kernel appears to be taking the EA data offset from the end of
> i_extra_isize and the ext3_xattr_ibody_header fields (so 0x88 + e_value_offs
> from the start of the inode).
> 
> Conversely, debugfs isn't having any problem with this EA at all.
> 
> h, I think I see the problem, and this was fixed in newer e2fsck.
> The EAs are stored "out of order" in the inode and older e2fsprogs
> considered that an error.  That was fixed in the final 1.40 release:
> 
> 	Remove check in e2fsck which requires EA's in inodes to be sorted;
> 	they don't need to be sorted, and e2fsck was previously wrongly
> 	clearing unsorted EA's stored in the inode structure.

Ah, I think you got it! I've just now reproduced the problem on one
filesystem with the old e2fsck-1.40-WIP from Debian Etch and then
checked again with the newer e2fsck-1.40.5 from Sid. The new version
doesn't report any problems.

Thanks very much for your time looking into this.

Regards,
Kevin.
