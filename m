From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 38/74] libext2fs: mark group data blocks when loading
 block bitmap
Date: Sat, 11 Jan 2014 14:08:19 -0500
Message-ID: <20140111190819.GD1582@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012233.30655.1041.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47571 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaAKTI2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Jan 2014 14:08:28 -0500
Content-Disposition: inline
In-Reply-To: <20131211012233.30655.1041.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:22:33PM -0800, Darrick J. Wong wrote:
> The kernel[1] and e2fsck[2] both react to a BLOCK_UNINIT group by
> calculating the block bitmap that's needed to show all the group
> blocks for that group (if any) and using that.  However, when reading
> bitmaps from disk, libext2fs simply imports a block of zeroes into the
> bitmap, without bothering to check for group blocks.  This erroneous
> behavior results in the filesystem having a block bitmap that does not
> accurately reflect disk contents, and worse yet makes it seem as
> though superblocks, group descriptors, bitmaps, and inode tables are
> "free" space on disk.
> 
> So, fix the block bitmap loading routines to calculate the correct
> block bitmap for all groups and load it into the main fs block bitmap....

Thanks, applied.

						- Ted
