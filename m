From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 13 Apr 2012 11:08:20 -0700
Message-ID: <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com>
References: <20120323221715.GA6712@tassilo.jf.intel.com> <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
 <20120324031357.GA5690@tassilo.jf.intel.com> <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
 <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org>
 <m2zkaiyzjl.fsf@firstfloor.org> <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
 <1334339612.3796.2.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andi Kleen <andi@firstfloor.org>, "Ted Ts'o" <tytso@mit.edu>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40856 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2DMSIm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 14:08:42 -0400
Received: by wibhj6 with SMTP id hj6so6766940wib.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Apr 2012 11:08:41 -0700 (PDT)
In-Reply-To: <1334339612.3796.2.camel@schen9-DESK>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 10:53 AM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
>>
>> Do you have numbers?
>
> In a benchmark that does mmaped-read, there is a 28% speed up
> after getting rid of the counters.

Ok, that's big. But is it any actual real workload on a real
filesystem? It looks like this should only happen for actual IO, so I
get the feeling that this is some made-up benchmark for a filesystem
on a RAM-disk?

                  Linus
