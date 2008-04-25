From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 20:19:24 +0200
Message-ID: <20080425181924.GA6076@elte.hu>
References: <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425162215.GA16273@elte.hu> <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org> <20080425164509.GB19962@elte.hu> <alpine.LFD.1.10.0804250950360.2779@woody.linux-foundation.org> <20080425170237.GA24472@elte.hu> <alpine.LFD.1.10.0804251009340.2779@woody.linux-foundation.org> <20080425175333.GA25276@elte.hu> <alpine.LFD.1.10.0804251108370.2779@woody.linux-foundation.org>
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
Received: from mx3.mail.elte.hu ([157.181.1.138]:40050 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528AbYDYSUR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 14:20:17 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804251108370.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 25 Apr 2008, Ingo Molnar wrote:
> > 
> > no strong feeling either way - but i dont think there's any 
> > cross-CPU TLB flush done in this case within vmap()/vunmap(). Why? 
> > Because when alternative_instructions() runs then we have just a 
> > single CPU in cpu_online_map.
> 
> Ok, fair enough. Without the IPI, I don't think there's a big deal. 
> And you have the numbers to prove it. Consider me convinced.

great - i've lined up all the fixes into this git tree which you can 
pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-x86-fixes4.git for-linus

this has Jiri's fix followed by Mathieu's vmap logic cleanups, plus a 
bit of extra checks and the API extensions for set_fixmap (we didnt end
up using them but they make sense nevertheless).

Lightly tested though, so even if you agree with the changes you might 
want to wait an hour with the pull just in case some trivial build issue 
slipped in. Shortlog and diff below.

	Ingo

------------------>
Ingo Molnar (4):
      x86: make clear_fixmap() available on 64-bit as well
      x86: make __set_fixmap() non-init
      x86: remove set_fixmap() warning
      x86: harden kernel code patching

Jiri Slaby (1):
      x86: fix text_poke()

Mathieu Desnoyers (1):
      x86: clean up text_poke()

 arch/x86/kernel/alternative.c |   39 +++++++++++++++++++--------------------
 arch/x86/mm/init_64.c         |    7 +++----
 include/asm-x86/fixmap.h      |    8 ++++++++
 include/asm-x86/fixmap_32.h   |    7 ++-----
 include/asm-x86/fixmap_64.h   |    4 ++--
 5 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index df4099d..65c7857 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -511,31 +511,30 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
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
+		WARN_ON(!PageReserved(pages[0]));
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
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1ff7906..b798e7b 100644
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
@@ -173,7 +173,7 @@ set_pte_phys(unsigned long vaddr, unsigned long phys, pgprot_t prot)
 	new_pte = pfn_pte(phys >> PAGE_SHIFT, prot);
 
 	pte = pte_offset_kernel(pmd, vaddr);
-	if (!pte_none(*pte) &&
+	if (!pte_none(*pte) && pte_val(new_pte) &&
 	    pte_val(*pte) != (pte_val(new_pte) & __supported_pte_mask))
 		pte_ERROR(*pte);
 	set_pte(pte, new_pte);
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
index eb16651..4b96148 100644
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
@@ -121,9 +121,6 @@ extern void reserve_top_address(unsigned long reserve);
 #define set_fixmap_nocache(idx, phys)			\
 	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
 
-#define clear_fixmap(idx)			\
-	__set_fixmap(idx, 0, __pgprot(0))
