From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent
 cache
Date: Fri, 13 Apr 2012 14:37:22 -0400
Message-ID: <20120413183722.GG26332@thunk.org>
References: <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
 <20120324031357.GA5690@tassilo.jf.intel.com>
 <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
 <4F70F51F.8030405@linux.intel.com>
 <20120326235707.GC19489@thunk.org>
 <m2zkaiyzjl.fsf@firstfloor.org>
 <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
 <1334339612.3796.2.camel@schen9-DESK>
 <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com>
 <1334341876.3796.8.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49769 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab2DMShf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Apr 2012 14:37:35 -0400
Content-Disposition: inline
In-Reply-To: <1334341876.3796.8.camel@schen9-DESK>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 11:31:16AM -0700, Tim Chen wrote:
> 
> Benchmark is working on files on normal hard disk.  
> However, I have I have a large number
> of processes (80 processes, one for each cpu), each reading
> a separate mmaped file.  The files are in the same directory.
> That makes cache line bouncing on the counters particularly bad
> due to the large number of processes running.

OK, so this is with an 80 CPU machine?

And when you say 20% speed up, do you mean to say we are actually
being CPU constrained when reading from files on a normal hard disk?

The reason why I ask this is we're seeing anything like this with Eric
Whitney's 48 CPU scalability testing; we're not CPU bottlenecked, and
I don't even see evidence of a larger than usual CPU utilization
compared to other file systems.

So still I'm trying to understand why your results are so different
from what Eric has been seeing, and I'm still puzzled why this is
super urgent.

Ultimately, this isn't a regression and if Linus is willing to take a
change at this point, I'm willing to send it --- but I really don't
understand the urgency.

Best regards,

						- Ted
