From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Mon, 21 Apr 2008 08:49:58 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804210810180.2779@woody.linux-foundation.org>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <20080421011855.GA6243@gondor.apana.org.au> <20080421020806.GL20138@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439AbYDUP5Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 11:57:16 -0400
In-Reply-To: <20080421020806.GL20138@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sun, 20 Apr 2008, Paul E. McKenney wrote:
> > 
> > But I do concede that your version looks clearer, and has the
> > benefit that should prefetch ever be optimised out with no side-
> > effects, yours would still be correct while the current one will
> > lose the barrier completely.
> 
> Agreed as well -- compilers would also be within their right to bypass
> the rcu_dereference() around the test/prefetch, which would allow
> them to refetch.

That is *not* the main problem.

If you use "rcu_dereference()" on the wrong access, it not only loses the 
"smp_read_barrier_depends()" (which is a no-op on all sane architectures 
anyway), but it loses the ACCESS_ONCE() thing *entirely*.

Accessign a local automatic variable through a volatile pointer has 
absolutely no effect - it's a total no-op apart from possibly generating 
slightly worse code (although if I were a compiler, I'd just ignore it), 
since the compiler is totally free to spill and reload the local variable 
to its memory location - the stack - anyway!

So the important part (for sane architectures) of rcu_dereference() is 
that ACCESS_ONCE() hack, and it _only_ works if you actually do it on the 
value as it gets loaded from the RCU-protected data structure, not later.

So forget about the prefetch, and forget about the barrier. They had 
nothing to do with the bug. The bug existed even without the prefetch, 
even in the versions that didn't have it at all. For example, look at the 
"__list_for_each_rcu()" thing - the bug is there too, because it did just

	pos = (head)->next ... pos = pos->next

where both of those assignments to pos were done without rcu_derefence, so 
the compiler could happily decide to use the value once, forget it, and 
then re-load it later (when it might have changed).

In other words, the thing I objected to was something much more 
fundamental than any barriers. It was the fact that "rcu_dereference()" 
simply *fundamentally* doesn't make sense when done on a local variable, 
it can only make sense when actually loading the value from the data 
structure.

In short:

	pos = ..

	rcu_dereference(pos)

is crazy and senseless, but

	pos = rcu_dereference(pos->next)

actually has some logical meaning.

Now, all this said, I seriously doubt this was the source of the bug 
itself. I do not actually really believe that the compiler had much room 
for reloading things with or without any rcu_dereference(), and I doubt 
the code generation really changes all that much in practice.

(In fact, from a quick look, it seems that the only thing that 
the incorrect use of "rcu_derference()" did was to force the "node" 
variable onto the stack, since it did that volatime memory access through 
its pointer - and fixing the use of rcu_dereference() just means that 
"node" is kept in a register over the whole loop on x86-64, but the 
compiler still needs a stack slot, it just picks "str" instead. Which is a 
much better choice anyway.

So what the incorrect use of rcu_dereference() really resulted in was just 
this insane code (which is also seen in the BUG code):

  14:   48 8b 45 d0             mov    -0x30(%rbp),%rax
  18:   48 8b 00                mov    (%rax),%rax
  1b:   48 89 45 d0             mov    %rax,-0x30(%rbp)
  1f:   48 8b 45 d0             mov    -0x30(%rbp),%rax
  23:   48 85 c0                test   %rax,%rax
  26:   74 18                   je     0x40

and notice how insane that is, and how pointless?

First it loads %rax (node) from the ->next pointer of the previous value 
of 'node' (which is a stack variable at -48(rbp)):

	# node = node->next
	mov    -0x30(%rbp),%rax
	mov    (%rax),%rax

then it saves that to the stack and immediately reloads it (because of the 
volatile access on "pos" in "rcu_dereference(pos)"):

	# rcu_dereference(node)
	mov    %rax,-0x30(%rbp)
	mov    -0x30(%rbp),%rax

and then it tests it for being NULL:

	test   %rax,%rax
	je     0x40

and notice how the only thing that rcu_dereference() did was a totally 
unnecessary store and load to the stack? But also notice how gcc could 
have done the accesses to "node" *before* this entry as multiple loads 
from the original because there was nothing really holding this back.

(But also notice how there really isn't much room for that in practice, 
since the code that actually uses "node->next" isn't going to do a whole 
lot of exciting stuff with it).

With the corrected version, the insane "store and immediately reload from 
stack" goes away" and diffstat on the assembly language actually shows 
that there are two less instructions (most of the changes are just 
compiler labels moving around, but there are a few real changes that 
actually makes the assembler code look a bit more natural too).

So to recap: I don't think this mattered in practice. But the code was 
buggy in theory, even though in practice I don't think it would ever 
generate any reloads on that "next" variable simply because nothing else 
than the loop logic really used it.

			Linus
