From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/5] ext4: Mark group corrupt on group descriptor
 checksum error
Date: Wed, 28 Aug 2013 18:49:47 -0400
Message-ID: <20130828224947.GK27079@thunk.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130719235605.24017.35311.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50917 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab3H1Wtu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Aug 2013 18:49:50 -0400
Content-Disposition: inline
In-Reply-To: <20130719235605.24017.35311.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 19, 2013 at 04:56:05PM -0700, Darrick J. Wong wrote:
> If the group descriptor fails validation, mark the whole blockgroup corrupt so
> that the inode/block allocators skip this group.  The previous approach takes
> the risk of writing to a damaged group descriptor; hopefully it was never the
> case that the [ib]bitmap fields pointed to another valid block and got dirtied,
> since the memset would fill the page with 1s.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
