From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: zap extent-format inode with no extent header
Date: Mon, 30 Nov 2015 14:22:14 -0500
Message-ID: <20151130192214.GF4316@thunk.org>
References: <20151128215132.GD10580@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bo Branten <bosse@acc.umu.se>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58205 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbbK3TWU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 14:22:20 -0500
Content-Disposition: inline
In-Reply-To: <20151128215132.GD10580@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 28, 2015 at 01:51:32PM -0800, Darrick J. Wong wrote:
> The kernel requires all inodes with the extent flag set to have a
> valid extent tree header in i_block.  The ext2fs_extent_open2 prefers
> to initialize the header if i_block is zeroed, but e2fsck never writes
> the new header to disk.  Since the kernel won't create inodes with the
> flag and no header anyway, zap such files.
> 
> Reported-by: Bo Branten <bosse@acc.umu.se>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
