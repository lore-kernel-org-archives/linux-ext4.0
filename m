From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent
 cache
Date: Fri, 13 Apr 2012 14:48:23 -0400
Message-ID: <20120413184823.GA5898@thunk.org>
References: <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
 <4F70F51F.8030405@linux.intel.com>
 <20120326235707.GC19489@thunk.org>
 <m2zkaiyzjl.fsf@firstfloor.org>
 <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
 <1334339612.3796.2.camel@schen9-DESK>
 <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com>
 <1334341876.3796.8.camel@schen9-DESK>
 <20120413183722.GG26332@thunk.org>
 <20120413184158.GZ17822@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56797 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab2DMSs3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Apr 2012 14:48:29 -0400
Content-Disposition: inline
In-Reply-To: <20120413184158.GZ17822@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 08:41:58PM +0200, Andi Kleen wrote:
> > The reason why I ask this is we're seeing anything like this with Eric
> > Whitney's 48 CPU scalability testing; we're not CPU bottlenecked, and
> > I don't even see evidence of a larger than usual CPU utilization
> > compared to other file systems.
> 
> I bet Eric didn't test with this statistic counter.

Huh?  You can't turn it off, and he's been doing regular scalability
tests at least once per kernel release.

Can you say a bit more about exactly how you are doing this test and
what are the "other issues" where this is becoming a bottleneck?  If
possible I'd like to ask Eric if he can add it to his regular
scalability tests.

Thanks,

						 - Ted
