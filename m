From: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Wed, 16 Jan 2008 13:25:13 +0800
Message-ID: <400461184.09985@ustc.edu.cn>
References: <200801071151.11200.lists@naasa.net> <20080114035439.GA7330@mail.ustc.edu.cn> <400304530.01514@ustc.edu.cn> <200801141230.13694.jplatte@naasa.net> <1200310886.15103.1.camel@twins> <400358577.30629@ustc.edu.cn> <170fa0d20801151313s57dcc08cn550113036c3003be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.ustc.edu.cn ([202.38.64.16]:48445 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750912AbYAPF0o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Jan 2008 00:26:44 -0500
Content-Disposition: inline
In-Reply-To: <170fa0d20801151313s57dcc08cn550113036c3003be@mail.gmail.com>
Message-Id: <E1JF0m1-000101-OK@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 15, 2008 at 04:13:22PM -0500, Mike Snitzer wrote:
> On Jan 14, 2008 7:50 AM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > On Mon, Jan 14, 2008 at 12:41:26PM +0100, Peter Zijlstra wrote:
> > >
> > > On Mon, 2008-01-14 at 12:30 +0100, Joerg Platte wrote:
> > > > Am Montag, 14. Januar 2008 schrieb Fengguang Wu:
> > > >
> > > > > Joerg, this patch fixed the bug for me :-)
> > > >
> > > > Fengguang, congratulations, I can confirm that your patch fixed the bug! With
> > > > previous kernels the bug showed up after each reboot. Now, when booting the
> > > > patched kernel everything is fine and there is no longer any suspicious
> > > > iowait!
> > > >
> > > > Do you have an idea why this problem appeared in 2.6.24? Did somebody change
> > > > the ext2 code or is it related to the changes in the scheduler?
> > >
> > > It was Fengguang who changed the inode writeback code, and I guess the
> > > new and improved code was less able do deal with these funny corner
> > > cases. But he has been very good in tracking them down and solving them,
> > > kudos to him for that work!
> >
> > Thank you.
> >
> > In particular the bug is triggered by the patch named:
> >         "writeback: introduce writeback_control.more_io to indicate more io"
> > That patch means to speed up writeback, but unfortunately its
> > aggressiveness has disclosed bugs in reiserfs, jfs and now ext2.
> >
> > Linus, given the number of bugs it triggered, I'd recommend revert
> > this patch(git commit 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b). Let's
> > push it back to -mm tree for more testings?
> 
> Fengguang,
> 
> I'd like to better understand where your writeback work stands
> relative to 2.6.24-rcX and -mm.  To be clear, your changes in
> 2.6.24-rc7 have been benchmarked to provide a ~33% sequential write
> performance improvement with ext3 (as compared to 2.6.22, CFS could be
> helping, etc but...).  Very impressive!

Wow, glad to hear that.

> Given this improvement it is unfortunate to see your request to revert
> 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b but it is understandable if
> you're not confident in it for 2.6.24.
> 
> That said, you recently posted an -mm patchset that first reverts
> 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b and then goes on to address
> the "slow writes for concurrent large and small file writes" bug:
> http://lkml.org/lkml/2008/1/15/132
> 
> For those interested in using your writeback improvements in
> production sooner rather than later (primarily with ext3); what
> recommendations do you have?  Just heavily test our own 2.6.24 + your
> evolving "close, but not ready for merge" -mm writeback patchset?

It's not ready mainly because it is fresh made and need more
feedbacks. It's doing OK on my desktop :-)
