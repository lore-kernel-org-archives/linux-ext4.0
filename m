From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/12] libext2fs: fix maximum bg overhead calculation
 with meta_bg enabled
Date: Sat, 24 Oct 2015 00:37:39 -0400
Message-ID: <20151024043739.GI7917@thunk.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
 <20151012215635.29065.41295.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41829 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbbJXKvf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Oct 2015 06:51:35 -0400
Content-Disposition: inline
In-Reply-To: <20151012215635.29065.41295.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 12, 2015 at 02:56:35PM -0700, Darrick J. Wong wrote:
> When meta_bg is enabled at mkfs time, we put at most one group
> descriptor block in each blockgroup.  Unfortunately, the calculation
> of max overhead per bg doesn't know this, so mkfs fails when it isn't
> strictly necessary.  Fix it, since Dave reported that he couldn't
> create a 500TB ext4 filesystem.
> 
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
