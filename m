From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/49] libext2fs: fix memory leak when drastically
 shrinking extent tree depth
Date: Fri, 14 Mar 2014 09:56:59 -0400
Message-ID: <20140314135659.GO8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065559.30585.1536.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41379 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbaCNN5B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:57:01 -0400
Content-Disposition: inline
In-Reply-To: <20140311065559.30585.1536.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:55:59PM -0700, Darrick J. Wong wrote:
> In ext2fs_extent_free(), h(andle)->max_depth is used as a loop
> conditional variable to free all the h->path[].buf pointers.  However,
> ext2fs_extent_delete() sets max_depth = 0 if we've removed everything
> from the extent tree, which causes a subsequent _free() to leak some
> buf pointers.  max_depth can be re-incremented when splitting extent
> nodes, but there's no guarantee that it'll reach the old value before
> the free.
> 
> Therefore, remember the size of h->paths[] separately, and use that
> when freeing the extent handle.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
