From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] tune2fs: Zero inode table when removing checksums
Date: Mon, 16 Sep 2013 09:53:05 -0400
Message-ID: <20130916135305.GD4457@thunk.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
 <20130829004417.3190.38773.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:32781 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab3IPNxI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Sep 2013 09:53:08 -0400
Content-Disposition: inline
In-Reply-To: <20130829004417.3190.38773.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 28, 2013 at 05:44:17PM -0700, Darrick J. Wong wrote:
> When disabling group checksums, we have to initialize the inode table.  Right
> now tune2fs doesn't do this; it merely punts to e2fsck to clean up the mess.
> Unfortunately, if the "uninitialized" inode table contains things that look
> like inodes (i_link_count > 0, specifically), the e2fsck tries to recover these
> inodes.  This leads to it misinterpreting i_blocks as a block map, at which
> point it needlessly resurrects phantom inodes and crosslinked file repairs.  As
> part of initializing the block bitmaps, we must also mark block group metadata
> blocks in use.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
