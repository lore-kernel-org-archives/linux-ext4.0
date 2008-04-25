From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 19:10:37 +0200
Message-ID: <4812108D.6020103@gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>  <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>  <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>  <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>  <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org> <4811090A.9030809@gmail.com> <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:38901 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbYDYJKp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 05:10:45 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3519639fgb.17
        for <linux-ext4@vger.kernel.org>; Fri, 25 Apr 2008 02:10:44 -0700 (PDT)
In-Reply-To: <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/25/2008 12:41 AM, Linus Torvalds wrote:
> Also, it does seem like you can re-create this at will in ways that others 
> can not. Could you try to bisect it a bit? Right now we have no real clue 
> what it is all about, except that it seems to be related to suspend/resume 
> and there are some indications that it's about networking (and _perhaps_ 
> wireless in particular).

Yes! I'm able to reproduce it 90%! We can exclude X, 80211 and so ath5k too (I 
removed them from /lib/modules, so they won't ever load).

I set the water mark at 1700 megabytes to allocate by the testing programs, so 
that it eats almost all free available memory. Then, I wait to "alloced 1" and 
then pm-suspend on second console. After resume, it spits out the corruption.

I'm going to bisect it, will be back in few hours ;).
