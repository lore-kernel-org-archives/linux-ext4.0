From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 18:52:45 +0200
Message-ID: <20080425165245.GC19962@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425162215.GA16273@elte.hu> <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:51010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759904AbYDYQyH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 12:54:07 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But there was actually a much worse problem with my patch: 
> __set_fixmap() is __init. Which means that my patch was just totally 
> broken.
> 
> What I really wanted to do was to just follow the page tables and mark 
> it writable temporarily over the whole loop, and get rid of the whole 
> mess.
> 
> (We'd need to make __set_fixmap() non-init, and probably return the 
> pte_t pointer that it used, so that we could then just use 
> "native_pte_clear()" on the thing after having done the memcpy()).
> 
> I suspect I should have just kept using vmap(), even if I do dislike 
> just how insanely expensive that likely is.

clear_fixmap() is OK. I've made a tree with all these fixlets, in the 
proper order and with the commit logs tidied up:

  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-x86-fixes3.git for-linus

[ i integrated Jiri's commit to before your fix because he really 
  deserves that commit (and more) for his relentless debugging effort. ]

below is the full shortlog and diff. Minimally tested on 64-bit so far.

	Ingo

------------------>

Ingo Molnar (3):
      x86: make clear_fixmap() available on 64-bit as well
      x86: make __set_fixmap() non-init
      x86: harden kernel code patching

Jiri Slaby (1):
      x86: fix text_poke()

Linus Torvalds (1):
      x86: clean up text_poke()

 arch/x86/kernel/alternative.c |   35 +++++++++++++++++++----------------
 arch/x86/mm/init_64.c         |    5 ++---
 include/asm-x86/fixmap.h      |    8 ++++++++
 include/asm-x86/fixmap_32.h   |    8 +++-----
 include/asm-x86/fixmap_64.h   |    5 +++--
 5 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df4099d..2e39830 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -508,24 +508,27 @@ void *text_poke_early(void *addr, const void *opcode, size_t len)
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
+		WARN_ON(!PageReserved(virt_to_page(addr)));
+
+		spin_lock_irqsave(&poke_lock, flags);
+		set_fixmap(FIX_POKE, phys);
+		memcpy((void *)(virt + offset), opcode, len);
+		clear_fixmap(FIX_POKE);
+		spin_unlock_irqrestore(&poke_lock, flags);
 	} else {
 		/*
 		 * modules are in vmalloc'ed memory, always writable.
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1ff7906..7a81dd0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -135,7 +135,7 @@ static __init void *spp_getpage(void)
 	return ptr;
 }
 
-static __init void
+static void
 set_pte_phys(unsigned long vaddr, unsigned long phys, pgprot_t prot)
 {
 	pgd_t *pgd;
@@ -214,8 +214,7 @@ void __init cleanup_highmap(void)
 }
 
 /* NOTE: this is meant to be run only at boot */
-void __init
-__set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
+void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
 {
 	unsigned long address = __fix_to_virt(idx);
 
diff --git a/include/asm-x86/fixmap.h b/include/asm-x86/fixmap.h
index 382eb27..5bd2069 100644
--- a/include/asm-x86/fixmap.h
+++ b/include/asm-x86/fixmap.h
@@ -1,5 +1,13 @@
+#ifndef _ASM_FIXMAP_H
+#define _ASM_FIXMAP_H
+
 #ifdef CONFIG_X86_32
 # include "fixmap_32.h"
 #else
 # include "fixmap_64.h"
 #endif
+
+#define clear_fixmap(idx)			\
+	__set_fixmap(idx, 0, __pgprot(0))
+
+#endif
diff --git a/include/asm-x86/fixmap_32.h b/include/asm-x86/fixmap_32.h
index eb16651..e5db7d5 100644
--- a/include/asm-x86/fixmap_32.h
+++ b/include/asm-x86/fixmap_32.h
@@ -10,8 +10,8 @@
  * Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
  */
 
-#ifndef _ASM_FIXMAP_H
-#define _ASM_FIXMAP_H
+#ifndef _ASM_FIXMAP_32_H
+#define _ASM_FIXMAP_32_H
 
 
 /* used by vmalloc.c, vsyscall.lds.S.
@@ -55,6 +55,7 @@ enum fixed_addresses {
 	FIX_HOLE,
 	FIX_VDSO,
 	FIX_DBGP_BASE,
+	FIX_POKE,
 	FIX_EARLYCON_MEM_BASE,
 #ifdef CONFIG_X86_LOCAL_APIC
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
@@ -121,9 +122,6 @@ extern void reserve_top_address(unsigned long reserve);
 #define set_fixmap_nocache(idx, phys)			\
 	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
 
-#define clear_fixmap(idx)			\
-	__set_fixmap(idx, 0, __pgprot(0))
-
 #define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
 
 #define __FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
diff --git a/include/asm-x86/fixmap_64.h b/include/asm-x86/fixmap_64.h
index f3d7685..ba80e6b 100644
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -8,8 +8,8 @@
  * Copyright (C) 1998 Ingo Molnar
  */
 
-#ifndef _ASM_FIXMAP_H
-#define _ASM_FIXMAP_H
+#ifndef _ASM_FIXMAP_64_H
+#define _ASM_FIXMAP_64_H
 
 #include <linux/kernel.h>
 #include <asm/apicdef.h>
@@ -37,6 +37,7 @@ enum fixed_addresses {
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
 			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VSYSCALL_HPET,
+	FIX_POKE,
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
 	FIX_HPET_BASE,
