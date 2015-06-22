From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't retry file block mapping on bigalloc fs with
 non-extent file
Date: Sun, 21 Jun 2015 21:20:50 -0400
Message-ID: <20150622012050.GQ29480@thunk.org>
References: <20150319212557.GG11031@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47636 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbbFVBUw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Jun 2015 21:20:52 -0400
Content-Disposition: inline
In-Reply-To: <20150319212557.GG11031@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 19, 2015 at 02:25:57PM -0700, Darrick J. Wong wrote:
> ext4 isn't willing to map clusters to a non-extent file.  Don't signal
> this with an out of space error, since the FS will retry the
> allocation (which didn't fail) forever.  Instead, return EUCLEAN so
> that the operation will fail immediately all the way back to userspace.
> 
> (The fix is either to run e2fsck -E bmap2extent, or to chattr +e the file.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
