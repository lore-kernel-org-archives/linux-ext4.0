From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/74] libext2fs: use ext2fs_punch() to truncate quota
 file
Date: Thu, 12 Dec 2013 12:36:34 -0500
Message-ID: <20131212173634.GE13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011843.30655.22033.stgit@birch.djwong.org>
 <20131212172840.GD13547@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39372 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab3LLRgh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 12:36:37 -0500
Content-Disposition: inline
In-Reply-To: <20131212172840.GD13547@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 12, 2013 at 12:28:40PM -0500, Theodore Ts'o wrote:
> On Tue, Dec 10, 2013 at 05:18:43PM -0800, Darrick J. Wong wrote:
> > Use the new ext2fs_punch() call to truncate the quota file.  This also
> > eliminates the need to fix it to work with bigalloc.
> > 
> > Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks, applied.

Hmm, I spoke too soon.  This is causing a test failure when applied
against the maint branch.  I know that you developed this versus the
next branch, so it's possible the bug in ext2fs_punch() was fixed
next.  I'm going to drop this from the maint branch for now, I'll take
a closer look at this after going through the rest of the bug fix
patches, and see whether it works when applied against next (in which
case I'll have to see which bug fix we need to apply to backport the
fix to the maint branch).

					- Ted
