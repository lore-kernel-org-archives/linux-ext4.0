From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Wed, 16 Jan 2008 01:26:41 -0800 (PST)
Message-ID: <76258.29672.qm@web32604.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Snitzer <snitzer@gmail.com>,
	Fengguang Wu <wfg@mail.ustc.edu.cn>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752583AbYAPJ05@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

----- Original Message ----
> From: Mike Snitzer <snitzer@gmail.com>
> To: Fengguang Wu <wfg@mail.ustc.edu.cn>
> Cc: Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; Linus Torvalds <torvalds@linux-foundation.org>; Andrew Morton <akpm@li>
> Sent: Tuesday, January 15, 2008 10:13:22 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> On Jan 14, 2008 7:50 AM, Fengguang Wu  wrote:
> > On Mon, Jan 14, 2008 at 12:41:26PM +0100, Peter Zijlstra wrote:
> > >
> > > On Mon, 2008-01-14 at 12:30 +0100, Joerg Platte wrote:
> > > > Am Montag, 14. Januar 2008 schrieb Fengguang Wu:
> > > >
> > > > > Joerg, this patch fixed the bug for me :-)
> > > >
> > > > Fengguang, congratulations, I can confirm that your patch
> fixed
> 
 the bug! With
> > > > previous kernels the bug showed up after each reboot. Now,
> when
> 
 booting the
> > > > patched kernel everything is fine and there is no longer
> any
> 
 suspicious
> > > > iowait!
> > > >
> > > > Do you have an idea why this problem appeared in 2.6.24?
> Did
> 
 somebody change
> > > > the ext2 code or is it related to the changes in the scheduler?
> > >
> > > It was Fengguang who changed the inode writeback code, and I
> guess
> 
 the
> > > new and improved code was less able do deal with these funny corner
> > > cases. But he has been very good in tracking them down and
> solving
> 
 them,
> > > kudos to him for that work!
> >
> > Thank you.
> >
> > In particular the bug is triggered by the patch named:
> >         "writeback: introduce writeback_control.more_io to
> indicate
> 
 more io"
> > That patch means to speed up writeback, but unfortunately its
> > aggressiveness has disclosed bugs in reiserfs, jfs and now ext2.
> >
> > Linus, given the number of bugs it triggered, I'd recommend revert
> > this patch(git commit
> 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b).
> 
 Let's
> > push it back to -mm tree for more testings?
> 
> Fengguang,
> 
> I'd like to better understand where your writeback work stands
> relative to 2.6.24-rcX and -mm.  To be clear, your changes in
> 2.6.24-rc7 have been benchmarked to provide a ~33% sequential write
> performance improvement with ext3 (as compared to 2.6.22, CFS could be
> helping, etc but...).  Very impressive!
> 
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
> 
Hi Fengguang, Mike,

 I can add myself to Mikes question. It would be good to know a "roadmap" for the writeback changes. Testing 2.6.24-rcX so far has been showing quite nice improvement of the overall writeback situation and it would be sad to see this [partially] gone in 2.6.24-final. Linus apparently already has reverted  "...2250b". I will definitely repeat my tests with -rc8. and report.

 Cheers
Martin




