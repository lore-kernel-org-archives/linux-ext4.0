From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Fri, 8 Jul 2016 01:02:28 -0400
Message-ID: <20160708050228.GH19871@thunk.org>
References: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
 <20160706233533.GK27480@dastard>
 <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
 <20160708005127.GK12670@dastard>
 <20160708024654.GE19871@thunk.org>
 <77863b4a-95e6-4100-79c2-5cbcaf0872e7@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Wang Shilong <wangshilong1991@gmail.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	sihara@ddn.com, lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41642 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbcGHFCh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2016 01:02:37 -0400
Content-Disposition: inline
In-Reply-To: <77863b4a-95e6-4100-79c2-5cbcaf0872e7@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 07, 2016 at 10:19:27PM -0500, Eric Sandeen wrote:
> 
> But the point I keep trying to make - and failing, apparently - 
> is that we will / should have two sets of tests for userspace
> functionality at least; one using standard quota tools, and one
> using xfs_quota.  Both should test the same kernel paths, but
> if we want to know that userspace is working we need to test both.

I agree completely that we should test both userspace stacks.  Where I
disagree is whether this has anything to do with using the usrquota
and grpquota mount options, and which ext4 mkfs options are used to
set up quota or project quota support.  That's a completely orthogonal
issue.

> I don't know how we got to the point where we have 2 parallel
> quota infrastructures, it's an unfortunate mess IMHO.  :(

Actually, I've been staring at the quotatools source code and it's
even more complicated than that.  There are newer quotactl
subcommands, such as Q_XGETQSTAT and Q_XGETQSTATV, which currently
quotatools only tries using if it thinks the quota format (which in
this sense seems to be system API, not the actual quota file format
--- these two concepts seem to have been overloaded at some point) is
"xfs".

Currently quotatools only assumes the "xfs" quota format should be
used for "xfs" and "gfs" --- but it works for other file systems,
including ext4 as well.  As a result, there's certain information,
such as whether ext4 is doing limits enforcement as well as quota
tracking, which is *not* being exposed to the user.  I suspect one of
the reasons for this is the tests in quotatools for which kernel
interfaces are present are fairly primitive, and in fact there are
some comments in quotasys.c which makes references to behaviours of
certain specific Red Hat kernel versions to decide which interfaces
are available.  :-(

And if we just did the simple thing to enable use of the "new" (aka
"xfs", although this is ***massive*** misnomer) quota format in
quotatools, it would break if the latest quota tools were ever
compiled on older Enterprise Linux systems.

Ugh.  I suspect one of the reasons why things have gotten into such a
mess is that quota is mostly an enterprise feature, and most community
distros and community users/kernel developers don't really use it.  As
a result, no one has bothered to put in clean ways of doing interface
versioning, as I suspect a lot of work happens right before the
Enterprise Linux cutoff date, and there isn't much incentive to clean
things up afterwards.

> But if we want to test xfs_quota tests on ext4, we still
> need to know that e2fsprogs is pquota-capable.
> 
> If we want to test standard quota tools on ext4, we need to know
> that *those* binaries are capable, as well as e2fsprogs.  etc...

Completely agree.

						- Ted
