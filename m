From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/35] e2fsck: turn inline data symlink into a fast
 symlink when possible
Date: Mon, 20 Apr 2015 21:47:32 -0400
Message-ID: <20150421014732.GA3238@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023413.25243.97254.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49113 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbbDUBrf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 21:47:35 -0400
Content-Disposition: inline
In-Reply-To: <20150402023413.25243.97254.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:34:13PM -0700, Darrick J. Wong wrote:
> When there's a problem accessing the EA part of an inline data symlink
> and we want to truncate the symlink back to 60 characters (hoping the
> user can re-establish the link later on, apparently) be sure to turn
> off the inline data flag to convert the symlink back to a regular fast
> symlink.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
