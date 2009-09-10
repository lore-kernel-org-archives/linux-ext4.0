From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Make non-journal fsync work properly. REPOST
Date: Wed, 9 Sep 2009 22:55:19 -0400
Message-ID: <20090910025519.GJ24951@mit.edu>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com> <20090908050614.GA10477@mit.edu> <1252424465.17646.7.camel@bobble.smo.corp.google.com> <20090908220504.GS22901@mit.edu> <1252517664.18594.3.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53267 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbZIJCzW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Sep 2009 22:55:22 -0400
Content-Disposition: inline
In-Reply-To: <1252517664.18594.3.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 09, 2009 at 10:34:24AM -0700, Frank Mayhar wrote:
> Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
> mode:  If we're not using a journal, ext4_write_inode() now calls
> ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
> with a new "do_sync" parameter.  If that parameter is nonzero _and_ we're
> not using a journal, ext4_do_update_inode() calls sync_dirty_buffer()
> instead of ext4_handle_dirty_metadata().
> 
> This problem was found in power-fail testing, checking the amount of
> loss of files and blocks after a power failure when using fsync() and
> when not using fsync().  It turned out that using fsync() was actually
> worse than not doing so, possibly because it increased the likelihood
> that the inodes would remain unflushed and would therefore be lost at
> the power failure.
> 
> Signed-off-by: Frank Mayhar <fmayhar@google.com>

Added to the ext4 patch queue, thanks.

					- Ted
