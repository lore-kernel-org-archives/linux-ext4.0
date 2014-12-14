From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/47] libext2fs: set interior tree block goal more
 intelligently
Date: Sat, 13 Dec 2014 20:17:40 -0500
Message-ID: <20141214011740.GB29787@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215205.883.11850.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54776 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaLNBRm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 20:17:42 -0500
Content-Disposition: inline
In-Reply-To: <20141107215205.883.11850.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:52:05PM -0800, Darrick J. Wong wrote:
> When we're splitting an extent node, try to allocate the new interior
> tree block just prior to the first extent in the block we're trying to
> split.  The previous logic only set a goal block if we had to split
> both the current node and its parent, which is somewhat infrequent.
> When that would happen, the goal would start at zero, leading to poor
> locality.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
