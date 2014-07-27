From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/18] e2fsck: don't offer to fix the checksum of fixed
 extents
Date: Sun, 27 Jul 2014 19:52:30 -0400
Message-ID: <20140727235230.GE6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003531.28334.40019.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59622 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaG0Xwc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 19:52:32 -0400
Content-Disposition: inline
In-Reply-To: <20140726003531.28334.40019.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:35:31PM -0700, Darrick J. Wong wrote:
> If an extent fails checksum and the sanity checks, and the user elects
> to fix the extents, don't bother asking (the second time) if the user
> would like to fix the checksum.  Refactor some redundant code to make
> what's going on a little cleaner.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
