From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 17:12:05 -0400
Message-ID: <20080425211205.GC25950@Krystal>
References: <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts13.bellnexxia.net ([209.226.175.34]:34125 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760360AbYDYVRJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 17:17:09 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Fri, 25 Apr 2008, H. Peter Anvin wrote:
> > 
> > Yes, that should work.  It's still ugly, and I have to say I find the
> > complexity rather distasteful.  I am willing to be convinced it's worth it,
> > but I would really like to see hard numbers.
> 
> I really cannot imagine that this kind of pain is *ever* worth it. 
> 
> Please give an example of something so important that we'd want to do 
> complex code rewriting on the fly. What _is_ the point of imv_cond()?
> 
> 		Linus

The point is to provide a way to dynamically enable code at runtime
without noticeable performance impact on the system. It's principally
useful to control the markers in the kernel, which can be placed in very
frequently executed code paths. The original markers add a memory read,
test and conditional branch at each marker site. By using the immediate
values patchset, it goes down to a load immediate value, test and branch.

However, Ingo was still unhappy with the conditional branch, so I cooked
this jump patching optimization on top of the immediate values. It
looks for an expected pattern which limits the liveliness of the %al and
ZF registers to the 3 instructions and, if it finds it, patches a jump
located just before the mov instruction to skip the whole pattern and
behave exactly like the conditional branch.

So basically we get code dynamically actvated by patching a single jump.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
