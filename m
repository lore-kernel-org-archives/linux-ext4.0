From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 13:09:29 -0400
Message-ID: <20080425170929.GA16180@Krystal>
References: <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts10.bellnexxia.net ([209.226.175.54]:37560 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbYDYROc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 13:14:32 -0400
Content-Disposition: inline
In-Reply-To: <481209F2.4050908@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Yes, the immediate values, in general, only need to do atomic writes,
>> because I have taken care of placing the mov instruction in the correct
>> alignment so its immediate value happens to be aligned in memory.
>> However, the latest optimisation I did to change a conditional branch
>> into a jump when the correct code pattern is detected :
>> mov, test, bne short
>> into a
>> nop2, nop2, nop1, jmp short
>> or
>> mov, test, bne near
>> into a
>> nop2, nop2, nop1, jmp near
>
> And how, pray tell, do you deal with the fact that:
>
> a) the EFLAGS may be live on exit;

Actually, not only EFLAGS can be live on exit, but also the immediate
value itself.

If we take the mov, test, jne short case into account, I force the mov
to populate the %al register with some immediate value. Then, this value
is extracted from the inline assembly and feeded to an if() c statement
under the form of a variable. So, I check precisely for a mov %al,0,
followed by test and bne. If I don't find it (due to gcc optimizations),
then I leave the original immediate value there. I start the pattern
matching from the address of the movb instruction, which I extract from
the inline assembly. So, about the EFLAGS : given that I first change
the jne for an unconditional jump, I just don't care about the status of
the ZF : jump does not change the EFLAGS, and it does not depend on any.
However, it is still valid to leave the mov and test instructions there,
because ZF is considered "live" by gcc across the test+jne instructions.

Then, I patch mov and test in any order, because we just don't care
about the status of the ZF, or do we... ? The only limitation is that a
given imv_cond(var) should only be used in the following pattern :

if (imv_cond(var)) ...

Trying to save the result of imv_cond(var) and use it in multiple if()
statements would cause the compiler to duplicate tests and branches on
that variable and the pattern matching would not see that. I think it's
what you fear. Now that you speak of it, it might be better to leave the
movb and test instruction there to make sure we don't kill the ZF which
might be needed by some other code.

> b) there might be a jump into the middle of this instruction sequence?
>

If we change that, as discussed above, so the liveliness of ZF and of
the %al register is still insured by leaving the mov and test
instructions in place, we end up only modifying a single instruction and
the problem fades away. We would end up changing a jne for a jmp.

Thanks,

Mathieu

> 	-hpa

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
