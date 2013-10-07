From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/31] libext2fs: ind_punch() must not stop examining
 blocks prematurely
Date: Mon, 7 Oct 2013 09:43:15 -0400
Message-ID: <20131007134315.GH4540@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012753.28415.4639.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43094 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab3JGNnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 09:43:17 -0400
Content-Disposition: inline
In-Reply-To: <20131001012753.28415.4639.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:27:53PM -0700, Darrick J. Wong wrote:
> When we're iterating the main loop in ind_punch(), "offset" tracks how far
> we've progressed into the block map, "start" tells us where to start punching,
> and "count" tells us how many blocks we are to punch after "start".  Therefore,
> we would like to break out of the loop once the "offset" that we're looking at
> has progressed past the end of the punch range.  Unfortunately, if start !=0,
> the if-break clause in the loop causes us to break out of the loop early.
> 
> Therefore, change the breakout test to terminate the loop at the correct time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.  Again, it's my bad for not including more test cases
when originally implementing the ext2fs_punch() funciton, but one of
these days, we should add better testing for this function.

      	       	      	  	 	 - Ted
