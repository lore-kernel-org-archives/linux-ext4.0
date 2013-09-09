From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/6] resize2fs: Use blk64_t and location getters for
 free_gdp_blocks()
Date: Mon, 9 Sep 2013 10:41:36 -0400
Message-ID: <20130909144136.GF6059@thunk.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
 <20130829004357.3190.18064.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57028 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827Ab3IIOli (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Sep 2013 10:41:38 -0400
Content-Disposition: inline
In-Reply-To: <20130829004357.3190.18064.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 28, 2013 at 05:43:57PM -0700, Darrick J. Wong wrote:
> free_gdp_blocks needs to be taught to use 64-bit fields and the appropriate
> getters, otherwise it'll truncate high block numbers (when, say, resizing a
> >16T fs) and mark the low numbered group descriptor blocks as free.  Yikes.
> 
> Reported-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
