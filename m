From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/24] e2fsck: collapse holes in extent-based directories
Date: Fri, 25 Jul 2014 08:33:24 -0400
Message-ID: <20140725123324.GI1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225430.31374.42289.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56269 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaGYMda (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 08:33:30 -0400
Content-Disposition: inline
In-Reply-To: <20140718225430.31374.42289.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:54:30PM -0700, Darrick J. Wong wrote:
> If we notice a hole in the block map of an extent-based directory,
> offer to collapse the hole by decreasing the logical block # of the
> extent.  This saves us from pass 3's inefficient strategy, which fills
> the holes by mapping in a lot of empty directory blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
