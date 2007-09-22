From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Potential pitfall in the clusterfs extent patches for e2fsprogs
Date: Fri, 21 Sep 2007 18:12:19 -0600
Message-ID: <20070922001219.GW32520@schatzie.adilger.int>
References: <E1IWiqO-0002zY-0p@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:34802 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXIVALy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2007 20:11:54 -0400
Content-Disposition: inline
In-Reply-To: <E1IWiqO-0002zY-0p@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 15, 2007  21:22 -0400, Theodore Ts'o wrote:
> The problem with this is that it's fragile; you could potentially have
> an inode that happens to have as its first block something which looks
> like the extent magic number, and if the second block passes the extent
> validity checks, e2fsck will flag an error --- and if e2fsck is run in
> preen mode, it will just set the extent flag without prompting the user
> or aborting the boot process.

Well, I agree it's possible, but given that it is checking 8 bytes for
validity (though only a 2-byte magic) it seems reasonably safe.  There
are only 5 blocks in the filesystem that could correctly match in this
case (though I grant they are low-valued blocks due to little-endian
placement of the 16-bit magic).  They would have to be allocated as the
first block in the file (0x0000f30a, 0x0001f30a, ..., 0x0004f30a) and
3 always-invalid blocks that would have to be allocated as the second
block (0x000N0002, 0x000N0003, 0x000N0004).  The latter are used as
group descriptor and/or bitmap/inode table blocks, so the inode would
likely be corrupt as a non-extent inode as well.

I'm not terribly worried about it.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
