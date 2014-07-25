From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/24] misc: fix problems with strncat
Date: Fri, 25 Jul 2014 07:22:07 -0400
Message-ID: <20140725112207.GF1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225407.31374.16212.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56136 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaGYLWO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 07:22:14 -0400
Content-Disposition: inline
In-Reply-To: <20140718225407.31374.16212.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:54:07PM -0700, Darrick J. Wong wrote:
> The third argument to strncat is the maximum number of characters to
> copy out of the second argument; it is not the maximum length of the
> first argument.
> 
> Therefore, code in a check just in case we ever find a /sys/block/X
> path long enough to hit the end of the buffer.  FWIW the longest path
> I could find on my machine was 133 bytes.
> 
> Fixes-Coverity-Bug: 1252003
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
