From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/49] libext2fs: repair side effects when iterating
 dirents in inline dirs
Date: Fri, 14 Mar 2014 09:30:47 -0400
Message-ID: <20140314133047.GH8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065521.30585.9816.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41345 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbaCNNat (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:30:49 -0400
Content-Disposition: inline
In-Reply-To: <20140311065521.30585.9816.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:55:21PM -0700, Darrick J. Wong wrote:
> In ext2fs_inline_data_dir_iterate(), we must be very careful to undo
> any modifications we make to the dir_context pointer passed in by the
> caller, because it's entirely possible that the caller will still want
> to do something with the ctx or something inside.
> 
> Specifically, ext2fs_dblist_dir_iterate() wants to be able to free
> ctx->buf, and it reuses the ctx for multiple dblist entries.  That
> means that assigning ctx->buf will cause weird crashes at the end of
> dir_iterate().
> 
> Since we're being careful with ctx, we might as well handle adding the
> INLINE_DATA flag to ctx->flags for ext2fs_process_dir_block, since the
> dblist caller forgets to unset the flag before reusing the ctx.
> 
> This fixes some crashes and valgrind complaints in resize2fs, and is
> necessary for the next patch, which fixes resize2fs not to corrupt
> inline_data filesystems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
