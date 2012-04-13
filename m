From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 13 Apr 2012 20:41:58 +0200
Message-ID: <20120413184158.GZ17822@one.firstfloor.org>
References: <20120324031357.GA5690@tassilo.jf.intel.com> <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com> <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org> <m2zkaiyzjl.fsf@firstfloor.org> <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com> <1334339612.3796.2.camel@schen9-DESK> <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com> <1334341876.3796.8.camel@schen9-DESK> <20120413183722.GG26332@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41728 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab2DMSl7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 14:41:59 -0400
Content-Disposition: inline
In-Reply-To: <20120413183722.GG26332@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 02:37:22PM -0400, Ted Ts'o wrote:
> On Fri, Apr 13, 2012 at 11:31:16AM -0700, Tim Chen wrote:
> > 
> > Benchmark is working on files on normal hard disk.  
> > However, I have I have a large number
> > of processes (80 processes, one for each cpu), each reading
> > a separate mmaped file.  The files are in the same directory.
> > That makes cache line bouncing on the counters particularly bad
> > due to the large number of processes running.
> 
> OK, so this is with an 80 CPU machine?

4 sockets, 40 cores, 80 threads.

> 
> And when you say 20% speed up, do you mean to say we are actually
> being CPU constrained when reading from files on a normal hard disk?

The files are in memory, but we're still CPU constrained due to various
other issues.

> The reason why I ask this is we're seeing anything like this with Eric
> Whitney's 48 CPU scalability testing; we're not CPU bottlenecked, and
> I don't even see evidence of a larger than usual CPU utilization
> compared to other file systems.

I bet Eric didn't test with this statistic counter.

> Ultimately, this isn't a regression and if Linus is willing to take a

The old kernel didn't have that problem, so it's a regression.

> change at this point, I'm willing to send it --- but I really don't
> understand the urgency.

If we don't fix performance regressions before each release then Linux
will get slower and slower. At least I don't want a slow Linux.

-Andi
