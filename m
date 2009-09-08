From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Make non-journal fsync work properly.
Date: Tue, 8 Sep 2009 01:06:14 -0400
Message-ID: <20090908050614.GA10477@mit.edu>
References: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56833 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbZIHFGQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Sep 2009 01:06:16 -0400
Content-Disposition: inline
In-Reply-To: <1252119300.23871.7.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 04, 2009 at 07:55:00PM -0700, Frank Mayhar wrote:
> Teach ext4_write_inode() and ext4_do_update_inode() about non-journal
> mode:  If we're not using a journal, ext4_write_inode() now calls
> ext4_do_update_inode() (after getting the iloc via ext4_get_inode_loc())
> with a new "do_sync" parameter.  If that parameter is nonzero
> ext4_do_update_inode() calls sync_dirty_buffer() instead of
> ext4_handle_dirty_metadata().

Hi Frank,

The problem with this patch is that it's only safe to call
sync_dirty_buffer() if we are not journalling.  If we are using the
journal, we must *not* call sync_dirty_buffer(), but instead must use
jbd2_journal_dirty_metadata().

The problem is that there are paths where ext4_do_update_inode() can
get called with do_sync==1, even when journalling is enabled.
Specifically, if ext4_write_inode() is called with wait==1, wait is
passed to ext4_do_update_inode() as do_sync, and then when a journal
is present, we will end up calling sync_dirty_buffer(), which means we
will be writing out the modified metadata *before* the transaction has
committed.

If you try using your patch with journalling enabled, and you try
doing some power fail testing, my code inspection leads me to believe
with 99% certainty that the filesystem will be corrupted as a result.

I think what you need to do instead is to add an extra parameter
do_sync to ext4_handle_dirty_metadata(), and continue to call
ext4_handle_dirty_metadata.  However in code paths where we will later
force a commit to guarantee that the metadata has been written out
(i.e., in the fsync() code path), ext4_handle_dirty_metadata() should
be called with the new do_sync parameter set to 1.

Does that make sense?

						- Ted
