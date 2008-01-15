From: Ingo Molnar <mingo@elte.hu>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Tue, 15 Jan 2008 22:42:13 +0100
Message-ID: <20080115214212.GB32428@elte.hu>
References: <200801071151.11200.lists@naasa.net> <20080114035439.GA7330@mail.ustc.edu.cn> <400304530.01514@ustc.edu.cn> <200801141230.13694.jplatte@naasa.net> <1200310886.15103.1.camel@twins> <E1JEOmD-0001Ap-U7@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:53930 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbYAOVmj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2008 16:42:39 -0500
Content-Disposition: inline
In-Reply-To: <E1JEOmD-0001Ap-U7@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Mon, Jan 14, 2008 at 12:41:26PM +0100, Peter Zijlstra wrote:
> > 
> > On Mon, 2008-01-14 at 12:30 +0100, Joerg Platte wrote:
> > > Am Montag, 14. Januar 2008 schrieb Fengguang Wu:
> > > 
> > > > Joerg, this patch fixed the bug for me :-)
> > > 
> > > Fengguang, congratulations, I can confirm that your patch fixed the bug! With 
> > > previous kernels the bug showed up after each reboot. Now, when booting the 
> > > patched kernel everything is fine and there is no longer any suspicious 
> > > iowait!
> > > 
> > > Do you have an idea why this problem appeared in 2.6.24? Did somebody change 
> > > the ext2 code or is it related to the changes in the scheduler?
> > 
> > It was Fengguang who changed the inode writeback code, and I guess the
> > new and improved code was less able do deal with these funny corner
> > cases. But he has been very good in tracking them down and solving them,
> > kudos to him for that work!
> 
> Thank you.
> 
> In particular the bug is triggered by the patch named:
>         "writeback: introduce writeback_control.more_io to indicate more io"
> That patch means to speed up writeback, but unfortunately its
> aggressiveness has disclosed bugs in reiserfs, jfs and now ext2.
> 
> Linus, given the number of bugs it triggered, I'd recommend revert 
> this patch(git commit 2e6883bdf49abd0e7f0d9b6297fc3be7ebb2250b). Let's 
> push it back to -mm tree for more testings?

i dont think a revert at this stage is a good idea and i'm not sure 
pushing it back into -mm would really expose more of these bugs. And 
these are real bugs in filesystems - bugs which we want to see fixed 
anyway. You are also tracking down those bugs very fast.

[ perhaps, if it's possible technically (and if it is clean enough), you
  might want to offer a runtime debug tunable that can be used to switch
  off the new aspects of your code. That would speed up testing, in case
  anyone suspects the new writeback code. ]

	Ingo
