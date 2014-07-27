From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 16/18] e2fsck: leave room for checksum structure when
 salvaging a directory
Date: Sun, 27 Jul 2014 19:45:49 -0400
Message-ID: <20140727234549.GC6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003518.28334.33196.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59608 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaG0Xpv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 19:45:51 -0400
Content-Disposition: inline
In-Reply-To: <20140726003518.28334.33196.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:35:18PM -0700, Darrick J. Wong wrote:
> When we're salvaging a directory, leave room at the end of the block
> for the checksum entry so that e2fsck can write the checksummed dir
> block out later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
