From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 20:56:03 +0200
Message-ID: <20080425185603.GA22261@elte.hu>
References: <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425162215.GA16273@elte.hu> <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org> <20080425164509.GB19962@elte.hu> <alpine.LFD.1.10.0804250950360.2779@woody.linux-foundation.org> <20080425170237.GA24472@elte.hu> <alpine.LFD.1.10.0804251009340.2779@woody.linux-foundation.org> <20080425175333.GA25276@elte.hu> <alpine.LFD.1.10.0804251108370.2779@woody.linux-foundation.org> <20080425181924.GA6076@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:35738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbYDYS5K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 14:57:10 -0400
Content-Disposition: inline
In-Reply-To: <20080425181924.GA6076@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> > Ok, fair enough. Without the IPI, I don't think there's a big deal. 
> > And you have the numbers to prove it. Consider me convinced.
> 
> great - i've lined up all the fixes into this git tree which you can 
> pull from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-x86-fixes4.git for-linus
> 
> this has Jiri's fix followed by Mathieu's vmap logic cleanups, plus a 
> bit of extra checks and the API extensions for set_fixmap (we didnt 
> end up using them but they make sense nevertheless).
> 
> Lightly tested though, so even if you agree with the changes you might 
> want to wait an hour with the pull just in case some trivial build 
> issue slipped in. Shortlog and diff below.

ok, it's better tested now - 10 random bootups, amongst them 64/32-bit 
allyesconfig bootups, and some targeted testing as well with 
offlining/onlining CPUs and no problems found so far. Please pull.

	Ingo
