From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 13 Apr 2012 11:33:10 -0700
Message-ID: <CA+55aFx43+qb-Mz+P_gcJjNMD4=Qi0Q14LKCR1macppWy2xJxQ@mail.gmail.com>
References: <20120323221715.GA6712@tassilo.jf.intel.com> <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
 <20120324031357.GA5690@tassilo.jf.intel.com> <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
 <4F70F51F.8030405@linux.intel.com> <20120326235707.GC19489@thunk.org>
 <m2zkaiyzjl.fsf@firstfloor.org> <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
 <1334339612.3796.2.camel@schen9-DESK> <CA+55aFyHUaxJJB7J8C=DQEGprL+YhzN23dYGxszoYiVur0kgqw@mail.gmail.com>
 <1334341876.3796.8.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andi Kleen <andi@firstfloor.org>, "Ted Ts'o" <tytso@mit.edu>,
	Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60924 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab2DMSdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Apr 2012 14:33:31 -0400
Received: by wibhr17 with SMTP id hr17so6089309wib.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Apr 2012 11:33:30 -0700 (PDT)
In-Reply-To: <1334341876.3796.8.camel@schen9-DESK>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 11:31 AM, Tim Chen <tim.c.chen@linux.intel.com>=
 wrote:
>
> Benchmark is working on files on normal hard disk.
> However, I have I have a large number
> of processes (80 processes, one for each cpu), each reading
> a separate mmaped file. =A0The files are in the same directory.
> That makes cache line bouncing on the counters particularly bad
> due to the large number of processes running.

Ok, that sounds like a potentially realistic case then, even if your
benchmark probably shows the worst possible case.

Considering that the counters are apparently not all that useful, it
does sound like they should just be removed, Ted.

                          Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
