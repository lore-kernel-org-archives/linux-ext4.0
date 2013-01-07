From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: release buffer in failed path in dx_probe()
Date: Sun, 6 Jan 2013 23:24:52 -0500
Message-ID: <20130107042451.GB4956@thunk.org>
References: <1357371781-18194-1-git-send-email-yan@linux.vnet.ibm.com>
 <1357371781-18194-2-git-send-email-yan@linux.vnet.ibm.com>
 <20130105194135.GK20106@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Guo Chao <yan@linux.vnet.ibm.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42093 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab3AGEY5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jan 2013 23:24:57 -0500
Content-Disposition: inline
In-Reply-To: <20130105194135.GK20106@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 05, 2013 at 11:41:35AM -0800, Darrick J. Wong wrote:
> On Sat, Jan 05, 2013 at 03:43:00PM +0800, Guo Chao wrote:
> > If checksum fails, we should also release the buffer
> > read from previous iteration.
> > 
> > Cc: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>

Thanks, applied.

> Acked-by: Darrick J. Wong <darrick.wong@oracle.com>

BTW, technically speaking it should be "Reviewed-by"; that's what I've
used in the commit.

"Acked-by:" gets used when a commit touches multiple subsystem trees.
For example, suppose someone changes a function in fs/direct-io.c,
which also required changes in btrfs, xfs, and ext4.  This commit
might go through Al Viro's vfs tree, and might have an Acked-by from
Chris Mason, Dave Chinner, and me, indicating that developers who are
well versed in those trees have agreed that the patches which touched
those other subsystems looked sane.

Since in this case the commit only touches ext4 code, and is going
through the ext4 tree, "Reviewed-by" is what normally gets used.

Cheers,

					- Ted
