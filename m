From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent
 cache
Date: Fri, 13 Apr 2012 11:31:16 -0700
Message-ID: <1334341876.3796.8.camel@schen9-DESK>
References: <20120323221715.GA6712@tassilo.jf.intel.com>
	 <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
	 <20120324031357.GA5690@tassilo.jf.intel.com>
	 <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
	 <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org>
	 <m2zkaiyzjl.fsf@firstfloor.org>
	 <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
	 <1334339612.3796.2.camel@schen9-DESK>
	 <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>, Ted Ts'o <tytso@mit.edu>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853Ab2DMSbQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Apr 2012 14:31:16 -0400
In-Reply-To: <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2012-04-13 at 11:08 -0700, Linus Torvalds wrote:
> On Fri, Apr 13, 2012 at 10:53 AM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> >>
> >> Do you have numbers?
> >
> > In a benchmark that does mmaped-read, there is a 28% speed up
> > after getting rid of the counters.
> 
> Ok, that's big. But is it any actual real workload on a real
> filesystem? It looks like this should only happen for actual IO, so I
> get the feeling that this is some made-up benchmark for a filesystem
> on a RAM-disk?
> 
>                   Linus

Benchmark is working on files on normal hard disk.  
However, I have I have a large number
of processes (80 processes, one for each cpu), each reading
a separate mmaped file.  The files are in the same directory.
That makes cache line bouncing on the counters particularly bad
due to the large number of processes running.

Tim

