From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] xfstests, generic: add project quota attribute tests
Date: Mon, 11 Jul 2016 18:15:56 +0200
Message-ID: <20160711161556.GB9334@quack2.suse.cz>
References: <1467786171-21127-1-git-send-email-wangshilong1991@gmail.com>
 <20160706233533.GK27480@dastard>
 <d0018d66-cb32-16df-b46e-5c418cc4bfae@sandeen.net>
 <20160708005127.GK12670@dastard>
 <20160708024654.GE19871@thunk.org>
 <77863b4a-95e6-4100-79c2-5cbcaf0872e7@sandeen.net>
 <20160708050228.GH19871@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <david@fromorbit.com>,
	Wang Shilong <wangshilong1991@gmail.com>,
	fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
	sihara@ddn.com, lixi@ddn.com, Wang Shilong <wshilong@ddn.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160708050228.GH19871@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 08-07-16 01:02:28, Ted Tso wrote:
> On Thu, Jul 07, 2016 at 10:19:27PM -0500, Eric Sandeen wrote:
> > I don't know how we got to the point where we have 2 parallel
> > quota infrastructures, it's an unfortunate mess IMHO.  :(
> 
> Actually, I've been staring at the quotatools source code and it's
> even more complicated than that.  There are newer quotactl
> subcommands, such as Q_XGETQSTAT and Q_XGETQSTATV, which currently
> quotatools only tries using if it thinks the quota format (which in
> this sense seems to be system API, not the actual quota file format
> --- these two concepts seem to have been overloaded at some point) is
> "xfs".

quota-tools currently assume that certain quotactl(8) calls are fine only
for certain quota formats. And this has been long true - since its
beginning, XFS and VFS quota stacks were pretty independent including
supported quotactl calls. Only recently (about year and half ago) I have
added necessary plumbing so that "XFS quotactls" and "VFS quotactls" can be
used independently of the underlying filesystem. The distinction still
remained in quota-tools because there was no real need in unifying them and
we still have to keep knowing about the distinction so that quota-tools can
work with older kernels.

> Currently quotatools only assumes the "xfs" quota format should be
> used for "xfs" and "gfs" --- but it works for other file systems,
> including ext4 as well.  As a result, there's certain information,
> such as whether ext4 is doing limits enforcement as well as quota
> tracking, which is *not* being exposed to the user.  I suspect one of
> the reasons for this is the tests in quotatools for which kernel
> interfaces are present are fairly primitive, and in fact there are
> some comments in quotasys.c which makes references to behaviours of
> certain specific Red Hat kernel versions to decide which interfaces
> are available.  :-(

No, the reason is that until recently there was no kernel interface
to convey this information to userspace for VFS based quotas and nobody
complained :). If there is some functionality you miss in quota-tools, then
I can have a look at implementing it. E.g. reporting whether only tracking
or also enforcement is enabled is relatively simple to add.
 
> And if we just did the simple thing to enable use of the "new" (aka
> "xfs", although this is ***massive*** misnomer) quota format in
> quotatools, it would break if the latest quota tools were ever
> compiled on older Enterprise Linux systems.

What would you like to achieve with this? There is 'QF_META' format which
is different from 'QF_XFS' format basically only in the set of quotactls
used. As I said above it might be nice to separate kernel-api from the
underlying-quota-format but in reality these two were bound together in
older kernels so they are not really independent.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
