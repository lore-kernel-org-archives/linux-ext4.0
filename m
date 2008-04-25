From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 17:19:32 +0200
Message-ID: <20080425151931.GA25510@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:48719 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbYDYPUw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 11:20:52 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 28 Apr 2008, Jiri Slaby wrote:
> > 
> > Thanks. Bisected mm down to git-x86.patch, bisected git-x86-latest 
> > down to x86: enhance DEBUG_RODATA support - alternatives The patch 
> > below fixes the problem for me. Comments welcome.
> 
> You're a hero, Jiri.

indeed!

> And that also explains why I didn't see it - I don't do modules.

neither does my auto-test :-/

Suspend/resume goes from SMP to UP and then back - and triggers all the 
instrument patching code. I suspect we should/could have seen similar 
problems with a pure CPU hotplug stress-test, on a modular kernel.

> Thanks a heap.
> 
> > The 0xf0 pattern comes from alternatives_smp_lock: text_poke(*ptr, 
> > ((unsigned char []){0xf0}), 1);
> 
> And we should really add a lot more sanity checking there.

yeah.

incidentally, this bug was fixed by Mathieu yesterday but the full 
impact of the bug was not realized. Below is that patch from 
sched-devel.

i'm wondering what the best sanity checking would be. What we want is to 
be sure the patch we modify is truly a kernel or module text page.  

Perhaps we should start marking all kernel/module text pages with 
PageReserved? That way we can not corrupt any userspace/pagecache page. 
(and we'd clear PageReserved on module unload)

	Ingo

------------------------->
Subject: Fix sched-devel text_poke
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Thu, 24 Apr 2008 11:03:33 -0400

Use core_text_address() instead of kernel_text_address(). Deal with modules in
the same way used for the core kernel.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

Index: linux/arch/x86/kernel/alternative.c
===================================================================
--- linux.orig/arch/x86/kernel/alternative.c
+++ linux/arch/x86/kernel/alternative.c
@@ -511,31 +511,29 @@ void *__kprobes text_poke(void *addr, co
 	unsigned long flags;
 	char *vaddr;
 	int nr_pages = 2;
+	struct page *pages[2];
+	int i;
 
-	BUG_ON(len > sizeof(long));
-	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
-		- ((long)addr & ~(sizeof(long) - 1)));
-	if (kernel_text_address((unsigned long)addr)) {
-		struct page *pages[2] = { virt_to_page(addr),
-			virt_to_page(addr + PAGE_SIZE) };
-		if (!pages[1])
-			nr_pages = 1;
-		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-		BUG_ON(!vaddr);
-		local_irq_save(flags);
-		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-		local_irq_restore(flags);
-		vunmap(vaddr);
+	if (!core_kernel_text((unsigned long)addr)) {
+		pages[0] = vmalloc_to_page(addr);
+		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
 	} else {
-		/*
-		 * modules are in vmalloc'ed memory, always writable.
-		 */
-		local_irq_save(flags);
-		memcpy(addr, opcode, len);
-		local_irq_restore(flags);
+		pages[0] = virt_to_page(addr);
+		pages[1] = virt_to_page(addr + PAGE_SIZE);
 	}
+	BUG_ON(!pages[0]);
+	if (!pages[1])
+		nr_pages = 1;
+	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	BUG_ON(!vaddr);
+	local_irq_save(flags);
+	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
+	local_irq_restore(flags);
+	vunmap(vaddr);
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
+	for (i = 0; i < len; i++)
+		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
 	return addr;
 }
