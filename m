From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 09:06:37 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu>
 <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864AbYDYQJZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 12:09:25 -0400
In-Reply-To: <20080425154854.GC3265@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 25 Apr 2008, Andi Kleen wrote:
> 
> So all these checks can be just removed.

Quite frankly, I'd rather tighten them up. All the callers actually seem 
to do just a single-byte one.

So I'd suggest really tightening it up to require total natural alignment 
(rather than the weaker version that required that it fit in an aligned 
unsigned long or whatever). And I'd suggest using FIXMAP's instead of 
vmap. Maybe something like the appended (TOTALLY UNTESTED!)

		Linus

---
 arch/x86/kernel/alternative.c |   32 ++++++++++++++++----------------
 include/asm-x86/fixmap_32.h   |    1 +
 include/asm-x86/fixmap_64.h   |    1 +
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df4099d..6172e40 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -508,24 +508,24 @@ void *text_poke_early(void *addr, const void *opcode, size_t len)
  */
 void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
-	unsigned long flags;
-	char *vaddr;
-	int nr_pages = 2;
+	static DEFINE_SPINLOCK(poke_lock);
+	unsigned long flags, bits;
 
+	bits = (unsigned long) addr;
 	BUG_ON(len > sizeof(long));
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
+	BUG_ON(len & (len-1));
+	BUG_ON(bits & (len-1));
+
+	if (core_kernel_text(bits)) {
+		unsigned long phys = __pa(addr);
+		unsigned long offset = phys & ~PAGE_MASK;
+		unsigned long virt = fix_to_virt(FIX_POKE);
+		phys &= PAGE_MASK;
+
+		spin_lock_irqsave(&poke_lock, flags);
+		set_fixmap(FIX_POKE, phys);
+		memcpy((void *)(virt + offset), opcode, len);
+		spin_unlock_irqrestore(&poke_lock, flags);
 	} else {
 		/*
 		 * modules are in vmalloc'ed memory, always writable.
diff --git a/include/asm-x86/fixmap_32.h b/include/asm-x86/fixmap_32.h
index eb16651..1f6df95 100644
--- a/include/asm-x86/fixmap_32.h
+++ b/include/asm-x86/fixmap_32.h
@@ -55,6 +55,7 @@ enum fixed_addresses {
 	FIX_HOLE,
 	FIX_VDSO,
 	FIX_DBGP_BASE,
+	FIX_POKE,
 	FIX_EARLYCON_MEM_BASE,
 #ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
diff --git a/include/asm-x86/fixmap_64.h b/include/asm-x86/fixmap_64.h
index f3d7685..75e6004 100644
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -37,6 +37,7 @@ enum fixed_addresses {
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VSYSCALL_HPET,
+	FIX_POKE,
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
 	FIX_HPET_BASE,
