From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 19/24] e2fsck: always submit logical block 0 of a
 directory for pass 2
Date: Fri, 25 Jul 2014 08:40:59 -0400
Message-ID: <20140725124059.GJ1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225438.31374.51461.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56295 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbaGYMlB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2014 08:41:01 -0400
Content-Disposition: inline
In-Reply-To: <20140718225438.31374.51461.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:54:38PM -0700, Darrick J. Wong wrote:
> Always iterate logical block 0 in a directory, even if no physical
> block has been allocated.  Pass 2 will notice the lack of mapping and
> offer to allocate a new directory block; this enables us to link the
> directory into lost+found.
> 
> Previously, if there were no logical blocks mapped, we would fail to
> pick up even block 0 of the directory for processing in pass 2.  This
> meant that e2fsck never allocated a block 0 and therefore wouldn't fix
> the missing . and .. entries for the directory; subsequent e2fsck runs
> would complain about (yet never fix) the problem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
