From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 17/18] e2fsck: make insert_dirent_tail more robust
Date: Sun, 27 Jul 2014 19:48:56 -0400
Message-ID: <20140727234856.GD6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003524.28334.95739.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59614 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaG0XtC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 19:49:02 -0400
Content-Disposition: inline
In-Reply-To: <20140726003524.28334.95739.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:35:25PM -0700, Darrick J. Wong wrote:
> Fix the routine that adds dirent checksum structures to the directory
> block to handle oddball situations a bit more robustly.
> 
> First, when we're walking the entry array, we might encounter an
> entry that ends exactly one byte before where the checksum entry needs
> to start, i.e. there's space for the tail entry, but it needs to be
> reinitialized.  When that happens, we should proceed until d points to
> that space so that the tail entry can be initialized.
> 
> Second, it's possible that we've been fed a directory block where the
> entries end just short of the end of the block.  In this case, we need
> to adjust the size of the last entry to point exactly to where the
> dirent tail starts.  The current code requires that entries end
> exactly on the block boundary, but this is not always the case with
> damaged filesystems.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
