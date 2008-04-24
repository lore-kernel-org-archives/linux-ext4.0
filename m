From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Thu, 24 Apr 2008 15:41:27 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>  <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>  <480DB493.6080004@gmail.com>
 <20080422095315.GA28014@elte.hu>  <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>  <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
 <4811090A.9030809@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751AbYDXWnM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Apr 2008 18:43:12 -0400
In-Reply-To: <4811090A.9030809@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 25 Apr 2008, Jiri Slaby wrote:
> 
> 20 arpings running on wlan0 (don't know if this is related so far), suspend,
> resume, right after resume:
> 
> freed 114
> alloced 115
> freed 115
> alloced 116
> WHAT THE HELL (000a3ff8):
> ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22

Very interesting indeed.

> Shouldn't be 2.6.25 uttered as broken until this is solved to not corrupt
> anyone's data? I'm going to play with that testing program further in the
> meantime.

Do you actually see this with _plain_ 2.6.25? So far I've assumed that all 
the reports are about post-2.6.25 issues.

Also, it does seem like you can re-create this at will in ways that others 
can not. Could you try to bisect it a bit? Right now we have no real clue 
what it is all about, except that it seems to be related to suspend/resume 
and there are some indications that it's about networking (and _perhaps_ 
wireless in particular).

		Linus
