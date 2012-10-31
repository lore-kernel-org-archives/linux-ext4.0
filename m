From: Jan Kara <jack@suse.cz>
Subject: Re: semi-stable page writes
Date: Wed, 31 Oct 2012 12:45:45 +0100
Message-ID: <20121031114545.GB18424@quack.suse.cz>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121029220122.GT29378@dastard>
 <20121030010027.GA4508@thunk.org>
 <20121030233021.GG29378@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121030233021.GG29378@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 31-10-12 10:30:21, Dave Chinner wrote:
> On Mon, Oct 29, 2012 at 09:00:27PM -0400, Theodore Ts'o wrote:
> > On Tue, Oct 30, 2012 at 09:01:22AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 26, 2012 at 03:19:09AM -0700, Darrick J. Wong wrote:
> > > > Hi everyone,
> > > > 
> > > > Are people still annoyed about writes taking unexpectedly long amounts of tme
> > > > due to the stable page write patchset?  I'm guessing yes...
> > > 
> > > I haven't heard anyone except th elunatic fringe complain
> > > recently...
> > 
> > We are currently carrying a patch in the Google kernel which
> > unconditionally disables stable page writes specifically because it
> > introduced significant latencies that were unacceptable for some of
> > our (internal) customers of said production kernel.
> > 
> > I'll leave it to others to decide whether the Google production kernel
> > is part of the lunatic fringe or not.  :-)
> 
> Google is, and has the resources to maintain a lunatic fringe kernel
> ;)
> 
> Besides, we've discussed google's problem before, and it came down
> to bad application design (i.e. no buffering to protect against
> variable filesystem/storage latency) and not stable pages being the
> source of the problem. Turning off stable pages was a hack to work
> around a badly designed application stack....
  Well, so far I heard like 4 or 5 complaints about performance that were
tracked down to stable pages. Likely the most convincing was a case of an
application mmaping 1 GB file and randomly changing bits here and there.
Throughput of that application dropped to about a third with stable pages
(which surprised me at the first sight but after doing the math it's
obvious).

  As much as I agree that the problems can be solved in the applications
(if you have the liberty to modify them...), reported problems seem to be
common enough so that we try to do better than we do now.

> > IMO, it would be better to have the system automatically do the right
> > thing, though.  If there is no need for stable page writes, why pay
> > the performance penalty for it?
> 
> Yes, and the right thing to do is to put correctness before performance.
> Stable pages are needed for correctness in a lot of cases, so that shoul
> dbe the default. If the user has performance problems, then they can turn
> it off. At no time should the default require tuning to get correct
> behaviour. case in point: filesystems default to "barriers = on".
  I agree here. But still that does not rule out the possibility of getting
it right in the kernel without having to enable stable pages in all cases.
I.e., if btrfs needs stable pages, let it set the flag that it needs them.
Same for DIF/DIX, RAID5 or whatever else...

								Honza
