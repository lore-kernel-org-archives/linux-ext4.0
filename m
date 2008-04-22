From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Tue, 22 Apr 2008 11:49:07 +0200
Message-ID: <480DB493.6080004@gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com> <200804220254.45251.rjw@sisk.pl> <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>, mingo@elte.hu
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:37793 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758089AbYDVJtJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 05:49:09 -0400
Received: by nf-out-0910.google.com with SMTP id g13so717407nfb.21
        for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2008 02:49:07 -0700 (PDT)
In-Reply-To: <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linus Torvalds napsal(a):
> 
> On Tue, 22 Apr 2008, Rafael J. Wysocki wrote:
>>> The same place, dentry.d_hash.next is 1. No slub debug clues... I think, I'll 
>>> give slab a try. Any other clues?
>> Well, SLUB uses some per CPU data structures.  Is it possible that they get
>> corrupted and which leads to the observed symptoms?
> 
> It really doesn't look like the slub allocations themselves would be 
> corrupted. It very much looks like wild pointers corrupting allocations 
> that themselves were fine.

Hmm, correct.

> What do you do to trigger this? Any particular load? Is it still just 
> doing suspend/resume, or do you have something else that you are playing 
> with?

Yesterday I did 2 suspend/resumes after 1 hour of uptime and ran git-status 
for a fraction of a second until it was killed. So I can perfectly reproduce 
it when I suspend, resume and produce some io load. I guess it's time to 
bisect 2.6.25-rc8-mm2 as I'm able to reproduce it the best and haven't seen 
that bug in -rc8-mm1 for over week of suspending and working.

> Also, have you tried CONFIG_DEBUG_PAGEALLOC? That can also be a very 
> powerful way to find memory corruption.

Not yet.

> Does anybody see any other patterns? Looking at the modules linked in in 
> the oopses from Zdenek, Rafael and Jiri, I don't see anything odd. You 
> both all have 80211 support, maybe the corruption comes from the wireless 
> layer?

May be, however I don't use that stack, it's a desktop machine, it's only 
sitting there not turned on, but sure, it's loaded.
