From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't read blocks from disk after extents being
 swapped in move_extent_per_page()
Date: Fri, 12 Feb 2016 01:21:58 -0500
Message-ID: <20160212062158.GH11298@thunk.org>
References: <1455117406-15497-1-git-send-email-guaneryu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49113 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbcBLGWA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Feb 2016 01:22:00 -0500
Content-Disposition: inline
In-Reply-To: <1455117406-15497-1-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 10, 2016 at 11:16:45PM +0800, Eryu Guan wrote:
> I notice ext4/307 fails occasionally on ppc64 host, reporting md5
> checksum mismatch after moving data from original file to donor file.
> 
> The reason is that move_extent_per_page() calls __block_write_begin()
> and block_commit_write() to write saved data from original inode blocks
> to donor inode blocks, but __block_write_begin() not only maps buffer
> heads but also reads block content from disk if the size is not block
> size aligned. At this time the physical block number in mapped buffer
> head is pointing to the donor file not the original file, and that
> results in reading wrong data to page, which get written to disk in
> following block_commit_write call.

Thanks, applied.

					- Ted
