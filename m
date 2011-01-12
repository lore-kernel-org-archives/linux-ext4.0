From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Date: Wed, 12 Jan 2011 22:48:23 +1100
Message-ID: <20110112114823.GO28803@dastard>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
 <20101109011222.GD2715@dastard>
 <20101109033038.GF3099@thunk.org>
 <20101109044242.GH2715@dastard>
 <20101109214147.GK3099@thunk.org>
 <20101109234049.GQ2715@dastard>
 <AANLkTimwmJ_ZoE9oAuA1WGhCgK585jDznqnc6k0=9Ntb@mail.gmail.com>
 <20110111213007.GF2917@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, Lawrence Greenfield <leg@google.com>,
	Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110111213007.GF2917@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jan 11, 2011 at 04:30:07PM -0500, Ted Ts'o wrote:
> On Tue, Jan 11, 2011 at 04:13:42PM -0500, Lawrence Greenfield wrote:
> > > IOWs, all they want to do is avoid the unwritten extent conversion
> > > overhead. Time has shown that a bad security/performance tradeoff
> > > decision was made 13 years ago in XFS, so I see little reason to
> > > repeat it for ext4 today....
> 
> I suspect things may have changed somewhat; both in terms of
> requirements and nature of cluter file systems, and the performance of
> various storage systems (including PCIe-attached flash devices).  

We can throw 1000x more CPU power and memory at the problem than
we could 13 years ago. IOW the system balance hasn't changed (even
considering pci-e SSDs) compared to 13 years. Hence if it was a bad
tradeoff 13 years ago, it's still a bad tradeoff today.

> > I'd make use of FALLOC_FL_EXPOSE_OLD_DATA. It's not the CPU overhead
> > of extent conversion. It's that extent conversion causes more metadata
> > operations than what you'd have otherwise, which means systems that
> > want to use O_DIRECT and make sure the data doesn't go away either
> > have to write O_DIRECT|O_DSYNC or need to call fdatasync().
> > cluster file system implementor,
> 
> One possibility might be to make it an optional feature which is only
> enabled via a mount option.  That way someone would have to explicit
> ask for this feature two ways (via a new flag to fallocate) and a
> mount option.

Proliferation of mount options just to enable feature X of API Y for
filesystem Z is not a good idea. Either you enable it via the
fallocate API or you don't allow it at all.

> It might not make sense for XFS, but for people who are using ext4
> as the local storage file system back-end,

How does this differ from a local filesystem? Are you talking about
storage nodes for clustered/cloudy storage?

If so, I know of quite a few places that use XFS for this purpose
and they all seem to measure storage in petabytes made up of small
boxes containing anywhere between 30-100TB each. The only request
for additional preallocation functionality I've got from people
running such applications recently is for XFS_IOC_ZERO_RANGE. This
is quite relevant, because that specifically converts allocated
extents to unwritten extents. i.e. they like to be able to
efficiently re-initialise allocated space to zeros rather than
have it contain stale data.

> and are doing all sorts of things to get the best performance,
> including disabling the journal, I suspect it really would make
> sense.

That's not really a convincing argument for a new interface that
needs to be maintained forever.

> So it could always be an
> optional-to-implement flag, that not all file systems should feel
> obliged to implement.

It could, but it still needs better justification.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
