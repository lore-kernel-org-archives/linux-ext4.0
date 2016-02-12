From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix scheduling in atomic on group checksum failure
Date: Thu, 11 Feb 2016 23:47:19 -0500
Message-ID: <20160212044719.GC11298@thunk.org>
References: <1455112710-18765-1-git-send-email-jack@suse.cz>
 <20160210175246.GA6338@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Dmitry Vyukov <dvyukov@google.com>,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48686 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbcBLEr0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Feb 2016 23:47:26 -0500
Content-Disposition: inline
In-Reply-To: <20160210175246.GA6338@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 10, 2016 at 09:52:46AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 10, 2016 at 02:58:30PM +0100, Jan Kara wrote:
> > When block group checksum is wrong, we call ext4_error() while holding
> > group spinlock from ext4_init_block_bitmap() or
> > ext4_init_inode_bitmap() which results in scheduling while in atomic.
> > Fix the issue by calling ext4_error() later after dropping the spinlock.
> > 
> > CC: stable@vger.kernel.org
> > Reported-by: Dmitry Vyukov <dvyukov@google.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> Looks ok, so
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
