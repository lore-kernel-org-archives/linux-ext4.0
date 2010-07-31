From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V2] mke2fs.8.in: clarify the sign of a block-size
 constraint.
Date: Fri, 30 Jul 2010 20:40:58 -0400
Message-ID: <20100731004058.GD31324@thunk.org>
References: <20100724220124.GO4032@pooh.frostnet.net>
 <4C51B37E.4020404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Frost <chris@frostnet.net>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:49166 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab0GaAlI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Jul 2010 20:41:08 -0400
Content-Disposition: inline
In-Reply-To: <4C51B37E.4020404@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 29, 2010 at 11:59:42AM -0500, Eric Sandeen wrote:
> This bit of the mke2fs manpage is slightly confusing:
> 
> -b block-size
>     Specify the size of blocks in bytes. <snip>
>     If block-size is negative, then mke2fs will use heuristics 
>     to determine the appropriate block size, with the constraint 
>     that the block size will be at least block-size bytes.
> 
> because it sounds like the block size will be at least a negative
> number.  Clarify just what the negative sign means.
> 
> Reported-by: Chris Frost <chris@frostnet.net>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied, thanks.

					- Ted
