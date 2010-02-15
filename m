From: tytso@mit.edu
Subject: Re: [PATCH] ext4: ext4_xattr_ibody_set() error ignored in
 ext4_expand_extra_isize_ea()
Date: Mon, 15 Feb 2010 14:28:49 -0500
Message-ID: <20100215192849.GM5337@thunk.org>
References: <4B6AF1AF.3010008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33702 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab0BOT2w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Feb 2010 14:28:52 -0500
Content-Disposition: inline
In-Reply-To: <4B6AF1AF.3010008@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 04, 2010 at 05:11:27PM +0100, Roel Kluin wrote:
> The error handling was missing.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is this needed?

Yep, it's added, thanks.  I'm not entirely right the error handling is
completely correct in this function; in particular, if we fail after
this point in the function, and we've already changed the status of
EXT4_STATE_XATTR flag, but then we fail due to some error (maybe an
I/O error), it's not clear the cleanup section is properly unwinding
all of the side effects made so far in this function.

Still, adding the error check clearly makes the code better than it
was before, so I've added it to the ext4 patch queue.

    	       	    	     	    - Ted
