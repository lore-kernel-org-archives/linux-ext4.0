From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: add ext2fs_extent_open2
Date: Tue, 19 May 2009 21:57:17 -0400
Message-ID: <20090520015717.GB3523@mit.edu>
References: <517626.72758.qm@web43512.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: number9652 <number9652@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57861 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888AbZETB5V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 May 2009 21:57:21 -0400
Content-Disposition: inline
In-Reply-To: <517626.72758.qm@web43512.mail.sp1.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 19, 2009 at 01:34:12PM -0700, number9652 wrote:
> 
> The patch below adds a function, ext2fs_extent_open2(), that behaves
> as ext2fs_extent_open(), but will use the user-supplied inode
> structure when opening an extent instead of reading the inode from
> disk.  It also changes several of the calls to extent_open() to use
> this enhancement.

Thanks, this patch looks good.  Can I get a "Signed-off-by:" from you?

See the SUBMITTING-PATCHES file in the top-level document for the
legal significance of what it means; and yes, I'd prefer if you could
give me your real name in the Signed-off-by.  (I also find it much
more personal to use people's name rather than cold pseudonyms like
"number9652".  :-)

Many thanks,

					- Ted
