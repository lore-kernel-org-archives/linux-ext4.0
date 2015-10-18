From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 6/8] ext4: make the bitmap read routines return real
 error codes
Date: Sat, 17 Oct 2015 21:45:42 -0400
Message-ID: <20151018014542.GG2678@thunk.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
 <20151012215458.28872.63722.stgit@birch.djwong.org>
 <20151015163655.GQ10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56545 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbbJRBpq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Oct 2015 21:45:46 -0400
Content-Disposition: inline
In-Reply-To: <20151015163655.GQ10390@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 15, 2015 at 09:36:55AM -0700, Darrick J. Wong wrote:
> Make the bitmap reaading routines return real error codes (EIO,
> EFSCORRUPTED, EFSBADCRC) which can then be reflected back to
> userspace for more precise diagnosis work.
> 
> In particular, this means that mballoc no longer claims that we're out
> of memory if the block bitmaps become corrupt.
> 
> v2: Use ERR_PTR to return error codes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
