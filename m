From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Tue, 22 Apr 2008 11:48:42 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>  <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>  <480DB493.6080004@gmail.com>
 <20080422095315.GA28014@elte.hu> <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932238AbYDVSzw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Apr 2008 14:55:52 -0400
In-Reply-To: <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Tue, 22 Apr 2008, Zdenek Kabelac wrote:
> 
> Unsure how it is related to my orginal Oops post - but now when I've
> debug pagealloc enabled this appeared in my log after resume - should
> I open new bug for this - or could this be part of the problem I've
> experienced later?
> 
> (Note - now I'm running commit: 8a81f2738f10ca817c975cec893aa58497e873b2
> 
>  sd 0:0:0:0: [sda] Starting disk
>  mmc0: new SD card at address 5a61
>  mmc mmc0:5a61: parent mmc0 is sleeping, will not add
>  ------------[ cut here ]------------
>  WARNING: at drivers/base/power/main.c:78 device_pm_add+0x6c/0xf0()

This is unrelated to the other issue, I think.

Your warning comes from commit 58aca23226a19983571bd3b65167521fc64f5869, 
which admittedly looks like total crap. Rafael, what's the point of that 
commit?

I read the commit message, but I can't make myself agree with the commit 
code itself. If it's a "checking that the order is correct" thing, it 
should be a warning, but not change the actual _action_ of the code.

Because the commit refused to add the device, it is also then the direct 
reason for the oops you get later, as far as I can tell:

>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
>  IP: [klist_del+29/128] klist_del+0x1d/0x80
>  PGD 0
>  Oops: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
>  CPU 0
>  Call Trace:
>   [bus_remove_device+158/208] bus_remove_device+0x9e/0xd0
>   [device_add+1358/1376] device_add+0x54e/0x560

So I would suggest reverting that commit, or at least just making it a 
warning (while still registering the device).

		Linus
