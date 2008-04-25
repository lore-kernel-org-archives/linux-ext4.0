From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 17:32:07 +0200
Message-ID: <20080425153207.GA2280@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu>
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
Received: from mx2.mail.elte.hu ([157.181.151.9]:34184 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbYDYPcw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 11:32:52 -0400
Content-Disposition: inline
In-Reply-To: <20080425152650.GA894@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> > > > The 0xf0 pattern comes from alternatives_smp_lock: text_poke(*ptr, 
> > > > ((unsigned char []){0xf0}), 1);
> > > 
> > > And we should really add a lot more sanity checking there.
> 
> something like the patch below? (untested)

the one below even builds and boots.

this assumes that all modules areas are allocated via PAGE_KERNEL_EXEC - 
but that is generally true on x86 due to NX. 32-bit uses vmalloc_exec(), 
64-bit uses __vmalloc_area(..., PAGE_KERNEL_EXEC).

Jiri ... if you have any desire/stamina to still test this code - does 
the patch below produce any warnings if you unapply your fix as well, 
during suspend/resume?

	Ingo

--------------->
Subject: x86: harden kernel code patching
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 25 17:07:03 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    5 +++++
 mm/vmalloc.c                  |    3 +++
 2 files changed, 8 insertions(+)

Index: linux/arch/x86/kernel/alternative.c
===================================================================
--- linux.orig/arch/x86/kernel/alternative.c
+++ linux/arch/x86/kernel/alternative.c
@@ -518,6 +518,11 @@ void *__kprobes text_poke(void *addr, co
 	if (core_kernel_text((unsigned long)addr)) {
 		struct page *pages[2] = { virt_to_page(addr),
 			virt_to_page(addr + PAGE_SIZE) };
+		/*
+		 * Module text pages are PageReserved:
+		 */
+		WARN_ON(pages[0] && !PageReserved(pages[0]));
+		WARN_ON(pages[1] && !PageReserved(pages[1]));
 		if (!pages[1])
 			nr_pages = 1;
 		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
Index: linux/mm/vmalloc.c
===================================================================
--- linux.orig/mm/vmalloc.c
+++ linux/mm/vmalloc.c
@@ -391,6 +391,7 @@ static void __vunmap(const void *addr, i
 			struct page *page = area->pages[i];
 
 			BUG_ON(!page);
+			ClearPageReserved(page);
 			__free_page(page);
 		}
 
@@ -507,6 +508,8 @@ static void *__vmalloc_area_node(struct 
 			area->nr_pages = i;
 			goto fail;
 		}
+		if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL_EXEC))
+			SetPageReserved(page);
 		area->pages[i] = page;
 	}
 
