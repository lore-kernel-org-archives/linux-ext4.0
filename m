From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 04/74] libext2fs: use ext2fs_punch() to truncate quota
 file
Date: Thu, 12 Dec 2013 13:10:23 -0800
Message-ID: <20131212211023.GE10143@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211011843.30655.22033.stgit@birch.djwong.org>
 <20131212172840.GD13547@thunk.org>
 <20131212173634.GE13547@thunk.org>
 <20131212200709.GG10150@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34741 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3LLVKd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Dec 2013 16:10:33 -0500
Content-Disposition: inline
In-Reply-To: <20131212200709.GG10150@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 12, 2013 at 12:07:09PM -0800, Darrick J. Wong wrote:
> On Thu, Dec 12, 2013 at 12:36:34PM -0500, Theodore Ts'o wrote:
> > On Thu, Dec 12, 2013 at 12:28:40PM -0500, Theodore Ts'o wrote:
> > > On Tue, Dec 10, 2013 at 05:18:43PM -0800, Darrick J. Wong wrote:
> > > > Use the new ext2fs_punch() call to truncate the quota file.  This also
> > > > eliminates the need to fix it to work with bigalloc.
> > > > 
> > > > Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Thanks, applied.
> > 
> > Hmm, I spoke too soon.  This is causing a test failure when applied
> > against the maint branch.  I know that you developed this versus the
> > next branch, so it's possible the bug in ext2fs_punch() was fixed
> > next.  I'm going to drop this from the maint branch for now, I'll take
> > a closer look at this after going through the rest of the bug fix
> > patches, and see whether it works when applied against next (in which
> > case I'll have to see which bug fix we need to apply to backport the
> > fix to the maint branch).
> 
> Hmm, I'll try to reproduce it here; which test is failing?

Is t_quota_2off the culprit?

> It's possible that I fubar'd the ordering when I resorted the patches just
> prior to sending them out. :/

I discovered that at some point, configure.in got touched, which caused
configure to be re-run during a build.  Unfortunately --disable-quota is the
default, so the quota check part tests never got run, and that's why I never
noticed on subsequent runs of make check. :(

The problem is that on a ^extents filesystem (such as what t_quota_2off
creates), the end parameter of ~0ULL overflows the (end - start + 1)
calculation, effectively setting count to 0, and no blocks get punched.
libquota then zeroes the inode, and the blocks are lost.

Since block map files shouldn't really have more than 2^32 blocks anyway, I
think it's safe to clamp 'end' to 2^32 in the non-extent case.

I'll send a patch shortly.

--D
