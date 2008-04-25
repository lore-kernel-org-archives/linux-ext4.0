From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 09:41:12 +0200
Message-ID: <48118B18.5020008@gmail.com>
References: <4811090A.9030809@gmail.com>	<20080424.183558.96469288.davem@davemloft.net>	<alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org> <20080424.185757.254044977.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com,
	mingo@elte.hu, rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:27493 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYDYHlV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 03:41:21 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3488481fgb.17
        for <linux-ext4@vger.kernel.org>; Fri, 25 Apr 2008 00:41:17 -0700 (PDT)
In-Reply-To: <20080424.185757.254044977.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added 3 80211 experts.

On 04/25/2008 03:57 AM, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Thu, 24 Apr 2008 18:48:32 -0700 (PDT)
> 
>> But that 0xf0 definitely has shown up before. It's not the *only* 
>> corruption, but it's definitely a very interesting pattern. And the other 
>> ones that didn't show the 0xf0 pattern could obviously be due to pointers 
>> that were corrupted by 0xf0 in low bytes, so it _may_ be the source of the 
>> other corruptions too that didn't have an obvious 0xf0 directly in them.
> 
> Ok.
> 
> Do we know of any pattern of the wireless device type in use?
> If there is a pattern to that, it would be a huge clue.
> 
> And if it is predominantly one particular wireless device type, we
> should be able to come up with a patch to test.

Johannes, Michael, Jiri? Someone writes to freed memory patterns 0xf0 (not 
aligned to anything, addressed per byte), one of suspects is mac80211, don't you 
know that pattern from anywhere?

Thanks, Jiri.
