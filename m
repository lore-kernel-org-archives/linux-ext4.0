From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Sun, 27 Apr 2008 20:49:25 -0400
Message-ID: <48151F15.7050606@redhat.com>
References: <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <4812D09D.6010901@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYD1Axm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Apr 2008 20:53:42 -0400
In-Reply-To: <4812D09D.6010901@goop.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeremy Fitzhardinge wrote:
> Mathieu Desnoyers wrote:
>> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
>>   
>>> On Fri, 25 Apr 2008, H. Peter Anvin wrote:
>>>     
>>>> Yes, that should work.  It's still ugly, and I have to say I find the
>>>> complexity rather distasteful.  I am willing to be convinced it's worth it,
>>>> but I would really like to see hard numbers.
>>>>       
>>> I really cannot imagine that this kind of pain is *ever* worth it. 
>>>
>>> Please give an example of something so important that we'd want to do 
>>> complex code rewriting on the fly. What _is_ the point of imv_cond()?
>>>
>>> 		Linus
>>>     
>> The point is to provide a way to dynamically enable code at runtime
>> without noticeable performance impact on the system. It's principally
>> useful to control the markers in the kernel, which can be placed in very
>> frequently executed code paths. The original markers add a memory read,
>> test and conditional branch at each marker site. By using the immediate
>> values patchset, it goes down to a load immediate value, test and branch.
>>
>> However, Ingo was still unhappy with the conditional branch, so I cooked
>> this jump patching optimization on top of the immediate values. 
> 
> I think all this demonstrates that the conditional branch is a bearable 
> cost compared to the alternative.  A conditional branch which almost 
> always branches the same way is very predictable, and really shouldn't 
> cost very much.

I agree with you.

When I measured the performance of a tracer (LKST) which used conditional
branches, the overhead of the conditional branch itself was very small
(less than 1%).
Moreover, some benchmarks showed the performance of the patched kernel
became ~1% faster than before :-) (I guessed that came from changing of
memory access pattern and timing.)

I think, if someone is considering about the actual performance impacts,
we'd better discuss the effects of the individual trace points, based
on the actual results of some benchmarks.
Thus, we can improve it step by step.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

