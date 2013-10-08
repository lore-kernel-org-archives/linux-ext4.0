From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/31] libext2fs: Allow callers to punch a single block
Date: Tue, 8 Oct 2013 11:54:13 -0400
Message-ID: <20131008155413.GF17896@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012746.28415.15964.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43679 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab3JHPya (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Oct 2013 11:54:30 -0400
Content-Disposition: inline
In-Reply-To: <20131001012746.28415.15964.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:27:46PM -0700, Darrick J. Wong wrote:
> The range of blocks to punch is treated as an inclusive range on both ends,
> i.e. if start=1 and end=2, both blocks 1 and 2 are punched out.  Thus, start ==
> end means that the caller wishes to punch a single block.  Remove the check
> that prevents us from punching a single block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
