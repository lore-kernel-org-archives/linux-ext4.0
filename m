From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/31] libext2fs: Rewind extent pointer when totally
 deleting an extent
Date: Mon, 7 Oct 2013 09:37:25 -0400
Message-ID: <20131007133725.GF4540@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012740.28415.55304.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43085 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab3JGNh1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 09:37:27 -0400
Content-Disposition: inline
In-Reply-To: <20131001012740.28415.55304.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:27:40PM -0700, Darrick J. Wong wrote:
> During a punch operation, if we decide to delete an extent out of the extent
> tree, the subsequent extents are moved on top of the current extent (that is to
> say, they're memmmove'd down one slot).  Therefore it is not correct to advance
> to the next leaf because that means we miss half the extents in the range!
> Rereading the current pointer should be fine.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

BTW, in the future, this is the sort of change where creating a
regression test would be highly appreciated --- especially since you
presumably had to create test cases while you were creating the patch,
so it's much less effort to encapsulate it into a test case while
developing the patch.

					- Ted
