From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 10:05:26 -0700
Message-ID: <20080421170526.GC9153@linux.vnet.ibm.com>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <20080421011855.GA6243@gondor.apana.org.au> <20080421020806.GL20138@linux.vnet.ibm.com> <alpine.LFD.1.10.0804210810180.2779@woody.linux-foundation.org>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:54971 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbYDURFi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Apr 2008 13:05:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804210810180.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2008 at 08:49:58AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 20 Apr 2008, Paul E. McKenney wrote:
> > > 
> > > But I do concede that your version looks clearer, and has the
> > > benefit that should prefetch ever be optimised out with no side-
> > > effects, yours would still be correct while the current one will
> > > lose the barrier completely.
> > 
> > Agreed as well -- compilers would also be within their right to bypass
> > the rcu_dereference() around the test/prefetch, which would allow
> > them to refetch.
> 
> That is *not* the main problem.
> 
> If you use "rcu_dereference()" on the wrong access, it not only loses the 
> "smp_read_barrier_depends()" (which is a no-op on all sane architectures 
> anyway), but it loses the ACCESS_ONCE() thing *entirely*.

Yep, "compilers would also be within their right to bypass the
rcu_dereference()", which as you say, has the ACCESS_ONCE().

> Accessign a local automatic variable through a volatile pointer has 
> absolutely no effect - it's a total no-op apart from possibly generating 
> slightly worse code (although if I were a compiler, I'd just ignore it), 
> since the compiler is totally free to spill and reload the local variable 
> to its memory location - the stack - anyway!

Agreed.  The only reasons I can think of for doing rcu_dereference()
on a local variable are as follows:

1.	The local variable is passed into a called function that is
	also invoked on shared storage.  In this case, the use of
	rcu_dereference() on a local variable is the cost of common
	code.

2.	The address of the local variable is published globally
	so that other CPUs can access it under RCU protection.	Yes,
	this is generally insane -- the last time I did this sort of
	thing was in the early 1980s on a PDP-11, where it was necessary
	due to that machine's 64K address space.  (No, I didn't use
	RCU on this UP machine, but I did publish locals -- malloc()
	choked badly in this case.)

> So the important part (for sane architectures) of rcu_dereference() is 
> that ACCESS_ONCE() hack, and it _only_ works if you actually do it on the 
> value as it gets loaded from the RCU-protected data structure, not later.
> 
> So forget about the prefetch, and forget about the barrier. They had 
> nothing to do with the bug. The bug existed even without the prefetch, 
> even in the versions that didn't have it at all. For example, look at the 
> "__list_for_each_rcu()" thing - the bug is there too, because it did just
> 
> 	pos = (head)->next ... pos = pos->next
> 
> where both of those assignments to pos were done without rcu_derefence, so 
> the compiler could happily decide to use the value once, forget it, and 
> then re-load it later (when it might have changed).
> 
> In other words, the thing I objected to was something much more 
> fundamental than any barriers. It was the fact that "rcu_dereference()" 
> simply *fundamentally* doesn't make sense when done on a local variable, 
> it can only make sense when actually loading the value from the data 
> structure.
> 
> In short:
> 
> 	pos = ..
> 
> 	rcu_dereference(pos)
> 
> is crazy and senseless, but
> 
> 	pos = rcu_dereference(pos->next)
> 
> actually has some logical meaning.

Agreed.

> Now, all this said, I seriously doubt this was the source of the bug 
> itself. I do not actually really believe that the compiler had much room 
> for reloading things with or without any rcu_dereference(), and I doubt 
> the code generation really changes all that much in practice.

Agreed -- you would have to have an uncommonly aggressive compiler to get
this to happen.  Seems like it would be worth trying the patch, though.

I did take a quick look for improperly freeing dentries -- unhashed
dentries are freed directly, so if there is a code path that somehow
unhashes dentries and then d_free()s them without a grace period, we
have a problem.

Hmmmm...  This could happen if someone called the final dput() on
a dentry that was hashed.  If this can really happen, the crude and
untested patch below might help.

> (In fact, from a quick look, it seems that the only thing that 
> the incorrect use of "rcu_derference()" did was to force the "node" 
> variable onto the stack, since it did that volatime memory access through 
> its pointer - and fixing the use of rcu_dereference() just means that 
> "node" is kept in a register over the whole loop on x86-64, but the 
> compiler still needs a stack slot, it just picks "str" instead. Which is a 
> much better choice anyway.
> 
> So what the incorrect use of rcu_dereference() really resulted in was just 
> this insane code (which is also seen in the BUG code):
> 
>   14:   48 8b 45 d0             mov    -0x30(%rbp),%rax
>   18:   48 8b 00                mov    (%rax),%rax
>   1b:   48 89 45 d0             mov    %rax,-0x30(%rbp)
>   1f:   48 8b 45 d0             mov    -0x30(%rbp),%rax
>   23:   48 85 c0                test   %rax,%rax
>   26:   74 18                   je     0x40
> 
> and notice how insane that is, and how pointless?

Yep.  Ugly as sin.

> First it loads %rax (node) from the ->next pointer of the previous value 
> of 'node' (which is a stack variable at -48(rbp)):
> 
> 	# node = node->next
> 	mov    -0x30(%rbp),%rax
> 	mov    (%rax),%rax
> 
> then it saves that to the stack and immediately reloads it (because of the 
> volatile access on "pos" in "rcu_dereference(pos)"):
> 
> 	# rcu_dereference(node)
> 	mov    %rax,-0x30(%rbp)
> 	mov    -0x30(%rbp),%rax
> 
> and then it tests it for being NULL:
> 
> 	test   %rax,%rax
> 	je     0x40
> 
> and notice how the only thing that rcu_dereference() did was a totally 
> unnecessary store and load to the stack? But also notice how gcc could 
> have done the accesses to "node" *before* this entry as multiple loads 
> from the original because there was nothing really holding this back.
> 
> (But also notice how there really isn't much room for that in practice, 
> since the code that actually uses "node->next" isn't going to do a whole 
> lot of exciting stuff with it).
> 
> With the corrected version, the insane "store and immediately reload from 
> stack" goes away" and diffstat on the assembly language actually shows 
> that there are two less instructions (most of the changes are just 
> compiler labels moving around, but there are a few real changes that 
> actually makes the assembler code look a bit more natural too).
> 
> So to recap: I don't think this mattered in practice. But the code was 
> buggy in theory, even though in practice I don't think it would ever 
> generate any reloads on that "next" variable simply because nothing else 
> than the loop logic really used it.

Rafael, does the following (crude, untested, probably does not even
compile) patch help?

						Thanx, Paul

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 dcache.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -urpNa -X dontdiff linux-2.6.25/fs/dcache.c linux-2.6.25-d_free/fs/dcache.c
--- linux-2.6.25/fs/dcache.c	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.25-d_free/fs/dcache.c	2008-04-21 09:57:53.000000000 -0700
@@ -88,11 +88,7 @@ static void d_free(struct dentry *dentry
 {
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
-	/* if dentry was never inserted into hash, immediate free is OK */
-	if (hlist_unhashed(&dentry->d_hash))
-		__d_free(dentry);
-	else
-		call_rcu(&dentry->d_u.d_rcu, d_callback);
+	call_rcu(&dentry->d_u.d_rcu, d_callback);
 }
 
 static void dentry_lru_remove(struct dentry *dentry)
