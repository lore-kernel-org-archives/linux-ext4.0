From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: semi-stable page writes
Date: Mon, 29 Oct 2012 21:00:27 -0400
Message-ID: <20121030010027.GA4508@thunk.org>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121029220122.GT29378@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121029220122.GT29378@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 30, 2012 at 09:01:22AM +1100, Dave Chinner wrote:
> On Fri, Oct 26, 2012 at 03:19:09AM -0700, Darrick J. Wong wrote:
> > Hi everyone,
> > 
> > Are people still annoyed about writes taking unexpectedly long amounts of tme
> > due to the stable page write patchset?  I'm guessing yes...
> 
> I haven't heard anyone except th elunatic fringe complain
> recently...

We are currently carrying a patch in the Google kernel which
unconditionally disables stable page writes specifically because it
introduced significant latencies that were unacceptable for some of
our (internal) customers of said production kernel.

I'll leave it to others to decide whether the Google production kernel
is part of the lunatic fringe or not.  :-)

I would certainly welcome some option which allows the stable page
writes to be selectively enabled or disabled.  I think it would be
better to only take the performance hit if the underyling hardware
requires it (i.e., for iSCSI, or for DIF/DIX) or some other part of
the storage stack (whether it be the file system or the dm layer), but
if people want to make it a mount option, I could with that.

I suspect disabling stable writes via a mount option or sysfs tunable
would be much more error prone, and hence much more of a support issue
for the enterprise distributions, however.  So if it is done via
tunable, the kernel should warn, loudly, if it's an configuration that
will lead to problems (i.e., because btrfs wants to do data
checksumming, or because it's required by iSCSI, or whatever).
Otherwise it's going to be a support nightmare.

IMO, it would be better to have the system automatically do the right
thing, though.  If there is no need for stable page writes, why pay
the performance penalty for it?

						- Ted
