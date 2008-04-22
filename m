From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
	ffffffffffffffff
Date: Tue, 22 Apr 2008 11:53:15 +0200
Message-ID: <20080422095315.GA28014@elte.hu>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com> <200804220254.45251.rjw@sisk.pl> <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org> <480DB493.6080004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:49656 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbYDVJyT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Apr 2008 05:54:19 -0400
Content-Disposition: inline
In-Reply-To: <480DB493.6080004@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Jiri Slaby <jirislaby@gmail.com> wrote:

>> What do you do to trigger this? Any particular load? Is it still just 
>> doing suspend/resume, or do you have something else that you are 
>> playing with?
>
> Yesterday I did 2 suspend/resumes after 1 hour of uptime and ran 
> git-status for a fraction of a second until it was killed. So I can 
> perfectly reproduce it when I suspend, resume and produce some io 
> load. I guess it's time to bisect 2.6.25-rc8-mm2 as I'm able to 
> reproduce it the best and haven't seen that bug in -rc8-mm1 for over 
> week of suspending and working.

the most dangerous x86 change we added was the PAT stuff. Does it 
influence the crashes in any way if you boot with 'nopat' or if you 
disable CONFIG_X86_PAT=y into the .config?

the other area was the DMA ops change - that should be rather trivial on 
64-bit though.

	Ingo
