From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/4]ext4: Remove unneeded BUG_ON() in
	ext4_move_extents()
Date: Sat, 5 Sep 2009 23:13:38 -0400
Message-ID: <20090906031338.GC3055@mit.edu>
References: <4A9DE3E5.8080104@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36984 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbZIFDNj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Sep 2009 23:13:39 -0400
Content-Disposition: inline
In-Reply-To: <4A9DE3E5.8080104@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 02, 2009 at 12:17:57PM +0900, Akira Fujita wrote:
> ext4: Remove unneeded BUG_ON() in ext4_move_extents()
> 
> From: Akira Fujita <a-fujita@rs.jp.nec.com>
> 
> ext4_move_extents() checks with BUG_ON() whether
> the exchanged blocks count accords with request blocks count.
> But, if the target range (orig_start + len) includes sparse block(s),
> 'moved_len' (exchanged blocks count) does not accord with
> 'len' (request blocks count),
> since sparse block is not counted in 'moved_len'.
> Therefore we hit BUG_ON(), though it succeeded.

Added to the ext4 patch queue.

					- Ted
