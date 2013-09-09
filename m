From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: Use blk64_t and location getters for
 free_gdp_blocks()
Date: Mon, 9 Sep 2013 10:35:50 -0400
Message-ID: <20130909143550.GD6059@thunk.org>
References: <20130813013202.GB6945@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57015 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3IIOfx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 10:35:53 -0400
Content-Disposition: inline
In-Reply-To: <20130813013202.GB6945@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 12, 2013 at 06:32:02PM -0700, Darrick J. Wong wrote:
> free_gdp_blocks needs to be taught to use 64-bit fields and the appropriate
> getters, otherwise it'll truncate high block numbers (when, say, resizing a
> 16T+ fs) and mark the low numbered group descriptor blocks as free.  Yikes.
> It's easy to trigger if you create a new 20T fs and shrink it to 18T.
> 
> Reported-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
