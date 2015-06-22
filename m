From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: minor cleanup of ext4_da_reserve_space()
Date: Sun, 21 Jun 2015 21:25:46 -0400
Message-ID: <20150622012546.GR29480@thunk.org>
References: <20150408170853.GA3885@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47642 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbbFVBZs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jun 2015 21:25:48 -0400
Content-Disposition: inline
In-Reply-To: <20150408170853.GA3885@wallace>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 08, 2015 at 01:08:53PM -0400, Eric Whitney wrote:
> Remove outdated comments and dead code from ext4_da_reserve_space.
> Clean up its trace point, and relocate it to make it more useful.
> 
> While we're at it, fix a nearby conditional used to determine if
> we have a non-bigalloc file system.  It doesn't match usage elsewhere
> in the code, and misleadingly suggests that an s_cluster_ratio value
> of 0 would be legal.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Applied, thanks.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
