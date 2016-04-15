From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: XFS reverse-mapping, reflink, and online fs scrub update
Date: Fri, 15 Apr 2016 12:29:35 -0700
Message-ID: <20160415192935.GF18517@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: david@fromorbit.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16518 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbcDOTaq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Apr 2016 15:30:46 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since LSF is next week, I've pushed the rmap+reflink patches to github.
The kernel patches are against 4.6-rc3, the xfsprogs patches against
for-next, and xfstests patches are against master.

The djwong-devel branches in the kernel/xfsprogs/xfstests repositories should
be fairly stable.  The djwong-experimental branches contain all the patches to
implement "multiple bmaps become one rmap" and the beginnings of deferring
rmaps across transaction rolls via redo intent items to maintain atomicity.
Unfortunately I didn't get that part done in time for LSF and there's some
bug that (I think) happens when we're deleting records from the rmapbt on
reflink filesystems that causes test failures.

So, basically, djwong-devel if you want to run code, and djwong-experimental
if you don't mind HBD and bugs everywhere.  This is basically a code dump.

Also, the online scrub patches (kernel and userspace) are tacked on the
end of the -devel branches now.

Maybe see you all at LSF.  I get to fly through Denver in the middle of a
snow storm tomorrow!  Oh boy! <grumble> <crap flight options>

--D

Semi-sane:
https://github.com/djwong/linux/commits/djwong-devel
https://github.com/djwong/xfsprogs/commits/djwong-devel
https://github.com/djwong/xfstests/commits/djwong-devel
https://github.com/djwong/xfs-documentation/commits/djwong-devel
https://github.com/djwong/man-pages/commits/djwong-devel

HBD:
https://github.com/djwong/linux/commits/djwong-experimental
https://github.com/djwong/xfsprogs/commits/djwong-experimental
