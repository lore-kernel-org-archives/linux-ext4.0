From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Ensure that inode is non-NULL before calling
 ext4_error_inode
Date: Wed, 2 Apr 2014 11:32:17 -0400
Message-ID: <20140402153217.GC6901@thunk.org>
References: <20140402143630.GB27299@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49081 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247AbaDBPco (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Apr 2014 11:32:44 -0400
Content-Disposition: inline
In-Reply-To: <20140402143630.GB27299@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 02, 2014 at 10:36:30AM -0400, Matthew Wilcox wrote:
> 
> __ext4_handle_dirty_metadata can be called with a NULL inode, but
> ext4_error_inode can't.  This is supposed to be a "can't happen" path,
> so we need to find out whether it can legitimately happen or whether
> there's some other bug that is causing this to happen.  This prevents
> a NULL pointer reference, so it should be included regardless of what
> the underlying error is.
> 
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

This was fixed by the following commit which will be shortly
pushed to Linus.  Admittedly, I should have done a better job noting
it in the commit description (sorry about that):

http://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=0edaa0178ea7142691ae9c10baa42b3e6466d047

In my patch I made sure we printed something so there would be better
chance of debugging the problem:

+			if (inode == NULL) {
+				pr_err("EXT4: jbd2_journal_dirty_metadata "
+				       "failed: handle type %u started at "
+				       "line %u, credits %u/%u, errcode %d",
+				       handle->h_type,
+				       handle->h_line_no,
+				       handle->h_requested_credits,
+				       handle->h_buffer_credits, err);
+				return err;
+			}

It turns out this case does happen if we are journalling fs-level
metadata, such as block group descriptor.

				- Ted

