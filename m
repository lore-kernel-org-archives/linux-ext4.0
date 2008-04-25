From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 14:37:48 -0400
Message-ID: <20080425183748.GB16180@Krystal>
References: <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
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
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:33341 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762207AbYDYShv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 14:37:51 -0400
Content-Disposition: inline
In-Reply-To: <20080425170929.GA16180@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
> > Mathieu Desnoyers wrote:
> >> Yes, the immediate values, in general, only need to do atomic writes,
> >> because I have taken care of placing the mov instruction in the correct
> >> alignment so its immediate value happens to be aligned in memory.
> >> However, the latest optimisation I did to change a conditional branch
> >> into a jump when the correct code pattern is detected :
> >> mov, test, bne short
> >> into a
> >> nop2, nop2, nop1, jmp short
> >> or
> >> mov, test, bne near
> >> into a
> >> nop2, nop2, nop1, jmp near
> >
> > And how, pray tell, do you deal with the fact that:
> >
> > a) the EFLAGS may be live on exit;
> 
> Actually, not only EFLAGS can be live on exit, but also the immediate
> value itself.
> 
> If we take the mov, test, jne short case into account, I force the mov
> to populate the %al register with some immediate value. Then, this value
> is extracted from the inline assembly and feeded to an if() c statement
> under the form of a variable. So, I check precisely for a mov %al,0,
> followed by test and bne. If I don't find it (due to gcc optimizations),
> then I leave the original immediate value there. I start the pattern
> matching from the address of the movb instruction, which I extract from
> the inline assembly. So, about the EFLAGS : given that I first change
> the jne for an unconditional jump, I just don't care about the status of
> the ZF : jump does not change the EFLAGS, and it does not depend on any.
> However, it is still valid to leave the mov and test instructions there,
> because ZF is considered "live" by gcc across the test+jne instructions.
> 
> Then, I patch mov and test in any order, because we just don't care
> about the status of the ZF, or do we... ? The only limitation is that a
> given imv_cond(var) should only be used in the following pattern :
> 
> if (imv_cond(var)) ...
> 
> Trying to save the result of imv_cond(var) and use it in multiple if()
> statements would cause the compiler to duplicate tests and branches on
> that variable and the pattern matching would not see that. I think it's
> what you fear. Now that you speak of it, it might be better to leave the
> movb and test instruction there to make sure we don't kill the ZF which
> might be needed by some other code.
> 

Thinking about it, there could be a way to insure limited ZF and %al
liveliness: adding an epilogue to the expected instruction sequence
formed by an asm statement which clobbers the flags (flags are clobbered
in any asm statement on x86) and clobbers %al.

>From that point, we just have to find a specific signature that gcc
could not imitate to put in this asm statement, so we can detect if
other instructions have been placed in the middle of our sequence by
gcc. Actually, I think the best thing to do with this asm statement is
to put the instruction pointer in a special section, so we know that
this code location marks the end of ZF and %al liveliness. There would
be therefore no added code, just asm constraints.

This epilogue should then be used on both branches of the condition,
like this :

if (unlikely(imv_cond(var))) {
  imv_cond_end();
  ...
} else {
  imv_cond_end();
   ...
}

Where imv_cond_end() would look like this :

+/*
+ * Puts a test and branch make sure the %al register and ZF are not live
+ * anymore.
+ * All asm statements clobbers the flags, but add "cc" clobber just to be sure.
+ * Clobbers %al.
+ */
+#define imv_cond_end()                                                 \
+       do {                                                            \
+               asm (".section __imv_cond_end,\"a\",@progbits\n\t"      \
+                               _ASM_PTR "1f\n\t"                       \
+                               ".previous\n\t"                         \
+                               "1:\n\t"                                \
+                               : : : "a", "cc");                       \
+       } while (0)
+

The pattern to test for will therefore become :

mov, test, branch, address following branch should be in the
__imv_cond_end table.
The address of the branch target site would also have to be in the
__imv_cond_end table.


> > b) there might be a jump into the middle of this instruction sequence?
> >
> 
> If we change that, as discussed above, so the liveliness of ZF and of
> the %al register is still insured by leaving the mov and test
> instructions in place, we end up only modifying a single instruction and
> the problem fades away. We would end up changing a jne for a jmp.
> 

So, if we do is I propose here, we have to take into account this
question too. Any jump that jumps in the middle of this instruction
sequence would have to insure correct liveliness of %al and ZF. However,
since we just limited the scope of their liveliness, there are no other
code paths which can jump in the middle of our instruction sequence and
insure correct ZF and %al liveliness.

Does it make sense ?

Thanks,

Mathieu


> Thanks,
> 
> Mathieu
> 
> > 	-hpa
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
