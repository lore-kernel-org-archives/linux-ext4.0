From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/24] e2fsck: fix off-by-one bounds check on group number
Date: Thu, 24 Jul 2014 22:20:11 -0400
Message-ID: <20140725022011.GD1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225348.31374.59045.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55628 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335AbaGYCUN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jul 2014 22:20:13 -0400
Content-Disposition: inline
In-Reply-To: <20140718225348.31374.59045.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:53:48PM -0700, Darrick J. Wong wrote:
> Since fs->group_desc_count is the number of block groups, the number
> of the last group is always one less than this count.  Fix the bounds
> check to reflect that.
> 
> This flaw shouldn't have any user-visible side effects, since the
> block bitmap test based on last_grp later on can handle overbig block
> numbers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
