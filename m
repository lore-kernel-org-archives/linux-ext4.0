From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/54] e2fsck: handle multiple *ind block collisions with
 critical metadata
Date: Wed, 28 Jan 2015 08:52:54 -0500
Message-ID: <20150128135254.GO2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073710.13308.92552.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42249 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429AbbA2CFr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Jan 2015 21:05:47 -0500
Content-Disposition: inline
In-Reply-To: <20150127073710.13308.92552.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:37:10PM -0800, Darrick J. Wong wrote:
> An earlier patch tried to detect indirect blocks that conflicted with
> critical FS metadata for the purpose of preventing corrections being
> made to those indirect blocks.  Unfortunately, that patch cannot
> handle more than one conflicting *ind block per file; therefore, use
> the ref_block parameter to test the metadata block map to decide if
> we need to avoid fixing the *ind block when we're iterating the
> block's entries.  (We have to iterate the block to capture any blocks
> that the block points to, as they could be in use.)
> 
> As a side note, in 1B we'll reallocate all those conflicting *ind
> blocks and restart fsck, so the contents will be checked eventually.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
