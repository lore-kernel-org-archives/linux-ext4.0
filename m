From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] filefrag: fix block size value
Date: Sun, 27 Jul 2014 20:28:46 -0400
Message-ID: <20140728002846.GG6725@thunk.org>
References: <20140724113850.GA14140@hercules.tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Rakesh Pandit <rakesh@tuxera.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59663 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaG1A2x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 20:28:53 -0400
Content-Disposition: inline
In-Reply-To: <20140724113850.GA14140@hercules.tuxera.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 24, 2014 at 02:38:51PM +0300, Rakesh Pandit wrote:
> ioctl(FIGETBSZ) was used to get block size earlier but 2508eaa7
> (filefrag: improvements to filefrag FIEMAP handling) moved to fstatfs
> f_bsize which doesn't work well for many files systems.
> 
> Block size returned using fstatfs isn't block size but "optimal
> transfer block size" as per man page. Even stat st_blksize is
> "preferred I/O block size" and in may file systems it may even vary
> from file to file (POSIX). This patch returns back usage of FIGETBSZ
> to get block size. For file systems which don't support FIEMAP, this
> fixes the number of FIBMAP ioctl calls required.
> 
> Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>

Thanks, applied.  I added fallback where if FIGETBSZ fails for some
reason, filefrag will now fall back to using f_bsize.

		      	       	       - Ted
