From: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Sat, 26 Apr 2008 08:56:34 -0300
Message-ID: <20080426115634.GH16635@ghostprotocols.net>
References: <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org> <20080425230028.GC31226@Krystal> <481265B7.9040505@goop.org> <48126A80.4000203@redhat.com> <4812CA02.8040705@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Masami Hiramatsu <mhiramat@redhat.com>,         Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,         Linus Torvalds <torvalds@linux-foundation.org>,         "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,         Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,         David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,         rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,         linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,         penberg@cs.helsinki.fi, clameter@sgi.com, linux-kernel@vger.kernel.org,         pageexec@freemail.hu, "Frank Ch. Eigler" <fche@redhat.com>,         systemtap@sources.redhat.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <systemtap-return-8628-gls-systemtap=m.gmane.org@sourceware.org>
Content-Disposition: inline
In-Reply-To: <4812CA02.8040705@goop.org>
List-Unsubscribe: <mailto:systemtap-unsubscribe-gls-systemtap=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:systemtap-subscribe@sourceware.org>
List-Post: <mailto:systemtap@sourceware.org>
List-Help: <mailto:systemtap-help@sourceware.org>, <http://sourceware.org/lists.html#faqs>
Sender: systemtap-owner@sourceware.org
List-Id: linux-ext4.vger.kernel.org

Em Fri, Apr 25, 2008 at 11:21:54PM -0700, Jeremy Fitzhardinge escreveu:
> Masami Hiramatsu wrote:
>> Jeremy Fitzhardinge wrote:
>>   
>>> Mathieu Desnoyers wrote:
>>>     
>>>> This idea has been considered a few years ago at OLS in the tracing BOF
>>>> if I remember well.  The results were this : First, there is no way to
>>>> guarantee that no code path, nor any return address from any function,
>>>> interrupt, sleeping thread, will return to the "old" version of the
>>>> function. Nor is it possible to determine when a quiescent state is
>>>> reached. Therefore, we couldn't see how we can do the teardown.
>>>>         
>>> Does that matter?  The new function is semantically identical to the old 
>>> one, and the old code will remain in place.  If there's still users in 
>>> the old function it may take a while for them to get flushed out (and 
>>> won't be traced in the meantime), but you have to expect some missed 
>>> events if you're shoving any kind of dynamic marker into the code.  The 
>>> main problem is if there's something still depending on the first 5 bytes 
>>> of the function (most likely if there's a loop head somewhere near the 
>>> top of the function).
>>>     
>>
>> I think we have to ensure no threads sleeping or being interrupted on
>> the function when removing new function. How would you check it?
>>   
>
> Not sure I follow you.  You'd never remove any code.  But you'd only start 

You do, when you decide to stop tracing. He is not talking about the old
function, that one, indeed will always be there, but what about the new
one? When tracing stops we want to remove it and revert to using the old
one...

But perhaps you are suggesting that the new one, once loaded, stays
there forever, that would work, but after several tracing sessions one
would have to eventually reboot the machine due to many modules left
loaded.

- Arnaldo
