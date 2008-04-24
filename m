From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Thu, 24 Apr 2008 16:45:32 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804241633040.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>  <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>  <480DB493.6080004@gmail.com>
 <20080422095315.GA28014@elte.hu>  <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>  <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
 <4811090A.9030809@gmail.com> <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org> <48112C74.8000405@gmail.com>
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
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000AbYDXXrD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Apr 2008 19:47:03 -0400
In-Reply-To: <48112C74.8000405@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 25 Apr 2008, Jiri Slaby wrote:
> 
> Blah, sorry, I lived in a theory, that Rafael got one from 2.6.25 and no,
> really, he had -git2 applied. Mea culpa, anyway I'll test 2.6.25 too, just for
> sure.

No problem. I do think this is a post-2.6.25 thing, because I don't think 
we've ever seen it before that.

There is a 2.6.25-rc8-mm2 report, but that was a -mm tree that had a lot 
of the stuff that was merged after 2.6.25, so I'm pretty sure that counts 
as "post" too. If it wasn't, we'd be seeing a lot more of this.

> Not really. I have no idea what triggers it. Seems like suspend is some kind
> of catalyzer not working every time.

I don't think suspend/resume is sufficient, because I've tried to 
reproduce it here (and I tried your test program too) on my macmini, and 
it's not happening. So there almost certainly something else too required 
to trigger it.

Btw, how do you suspend/resume? That matters, because I've been testing 
just the normal

	echo mem > /sys/power/state

and with a kernel where everything is compiled-in. But if you use the GUI 
suspend, on a common distro, I think that one ends up doing a whole lot 
more, including doing things like unloading and reloading modules, and for 
all we know the problem is not about suspend itself, but about the things 
going on around it.

And it might be a module unload issue, rather than the suspend itself (the 
same way I theorized that it might be a ifconfig down/up rather than the 
suspend code itself). Who knows..

It might also very well be hardware-specific. You guys seem to have 
different wireless setups (ath5k vs b43) but it migth be generic 80211 
code, but it might also be something *totally* unrelated, and the only 
reason wireless has shown up might be that networking is just in use when 
the problem happens.

Jiri, Zdenek, Rafael, could you try to compare hardware with each other 
and see if there is some pattern there?

(And btw, the program you used that allocates a hundred meg and tries to 
find it - I'm assuming you're not paging or anythign like that, ie you're 
not even close to out-of-memory. If that isn't correct, holler. I'm trying 
to reproduce this thing).

			Linus
