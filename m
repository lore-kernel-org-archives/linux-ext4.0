From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/54] e2fsck: decrement bad count _after_ remapping a
 duplicate block
Date: Wed, 28 Jan 2015 08:58:41 -0500
Message-ID: <20150128135841.GP2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073718.13308.99370.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42247 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbbA2CFq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Jan 2015 21:05:46 -0500
Content-Disposition: inline
In-Reply-To: <20150127073718.13308.99370.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:37:18PM -0800, Darrick J. Wong wrote:
> Decrement the bad count *after* we've shown that (a) we can allocate a
> replacement block and (b) remap the file block.  Unfortunately,
> the only way to tell if the remapping succeeded is to wait until the
> next clone_file_block() call or block_iterate3() returns.
> 
> Otherwise, there's a corruption error: we decrease the badcount once in
> preparation to remap, then the remap fails (either we can't find a
> replacement block or we have to split the extent tree and can't find a
> new extent block), so we delete the file, which decreases the badcount
> on the block a second time.  Later on e2fsck will think that it's
> straightened out all the duplicate blocks, which isn't true.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
