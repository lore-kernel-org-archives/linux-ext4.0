From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 23:21:54 -0700
Message-ID: <4812CA02.8040705@goop.org>
References: <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org> <20080425230028.GC31226@Krystal> <481265B7.9040505@goop.org> <48126A80.4000203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	"Frank Ch. Eigler" <fche@redhat.com>, systemtap@sources.redhat.com
To: Masami Hiramatsu <mhiramat@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:56827 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYDZGWE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Apr 2008 02:22:04 -0400
In-Reply-To: <48126A80.4000203@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Masami Hiramatsu wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Mathieu Desnoyers wrote:
>>     
>>> This idea has been considered a few years ago at OLS in the tracing BOF
>>> if I remember well.  The results were this : First, there is no way to
>>> guarantee that no code path, nor any return address from any function,
>>> interrupt, sleeping thread, will return to the "old" version of the
>>> function. Nor is it possible to determine when a quiescent state is
>>> reached. Therefore, we couldn't see how we can do the teardown.
>>>   
>>>       
>> Does that matter?  The new function is semantically identical to the old 
>> one, and the old code will remain in place.  If there's still users in 
>> the old function it may take a while for them to get flushed out (and 
>> won't be traced in the meantime), but you have to expect some missed 
>> events if you're shoving any kind of dynamic marker into the code.  The 
>> main problem is if there's something still depending on the first 5 
>> bytes of the function (most likely if there's a loop head somewhere near 
>> the top of the function).
>>     
>
> I think we have to ensure no threads sleeping or being interrupted on
> the function when removing new function. How would you check it?
>   

Not sure I follow you.  You'd never remove any code.  But you'd only 
start tracing new callers of the function.  If the function loops 
indefinitely, you could potentially have some users which never end up 
getting traced.  Also, if those users depend on instructions in the 
first 5 bytes of the function, they would crash because of the jump to 
the new function patched on top of them.

Overall, it doesn't seem like a very satisfactory mechanism...

    J
