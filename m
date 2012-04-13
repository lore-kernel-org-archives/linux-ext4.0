From: Eric Whitney <eric.whitney@hp.com>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 13 Apr 2012 15:01:47 -0400
Message-ID: <4F88781B.9090005@hp.com>
References: <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com> <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org> <m2zkaiyzjl.fsf@firstfloor.org> <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com> <1334339612.3796.2.camel@schen9-DESK> <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com> <1334341876.3796.8.camel@schen9-DESK> <20120413183722.GG26332@thunk.org> <20120413184158.GZ17822@one.firstfloor.org> <20120413184823.GA5898@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34576 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2DMTBx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 15:01:53 -0400
In-Reply-To: <20120413184823.GA5898@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/13/2012 02:48 PM, Ted Ts'o wrote:
> On Fri, Apr 13, 2012 at 08:41:58PM +0200, Andi Kleen wrote:
>>> The reason why I ask this is we're seeing anything like this with Eric
>>> Whitney's 48 CPU scalability testing; we're not CPU bottlenecked, and
>>> I don't even see evidence of a larger than usual CPU utilization
>>> compared to other file systems.
>>
>> I bet Eric didn't test with this statistic counter.
>
> Huh?  You can't turn it off, and he's been doing regular scalability
> tests at least once per kernel release.

Yes, as recently as 3.4-rc1.  I saw Andi's patch, and tested it this 
week against that baseline with the ffsb profiles we've been using for 
ext4 (and other filesystem) scalability measurements.

I didn't get a noticeable delta for throughput or reported CPU 
utilization on my 48 core eight node NUMA test setup.  That said, I plan 
to look at this more closely to verify that my workloads should have 
seen a delta in the first place.  Ted knows them well, though.  It's 
worth noting that I've got plenty of free CPU capacity while running the 
workload, which differs from Andi's/Tim's description.

>
> Can you say a bit more about exactly how you are doing this test and
> what are the "other issues" where this is becoming a bottleneck?  If
> possible I'd like to ask Eric if he can add it to his regular
> scalability tests.

Yes, I'm certainly willing to do that if practical, and I'm curious to 
know more about what the workload looks like.

Eric

>
> Thanks,
>
> 						 - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

