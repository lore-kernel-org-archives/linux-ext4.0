From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 20:53:50 +0200
Message-ID: <20080425185350.GA2679@elf.ucw.cz>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425155000.GA4438@elte.hu> <4811FF60.6040905@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54886 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195AbYDYSxK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 14:53:10 -0400
Content-Disposition: inline
In-Reply-To: <4811FF60.6040905@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 2008-04-25 08:57:20, H. Peter Anvin wrote:
> Ingo Molnar wrote:
>>
>> text_poke() itself only applies/unapplies the LOCK prefix - a single byte. 
>> We shouldnt be doing that at all: the cost of LOCK is insignificant (a few 
>> cycles) and most systems are SMP anyway.
>>
>
> Alas, on older CPUs the cost of LOCK can be massive.  The question is how 
> much we really care - the embedded people (who would definitely be 
> affected) will simply build UP kernels, and this only affects booting SMP 
> kernels on UP.

Like... say distros on older hardware?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
