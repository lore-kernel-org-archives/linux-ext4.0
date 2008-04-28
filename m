From: Christoph Lameter <clameter@sgi.com>
Subject: VIRTUAL_BUG_ON()
Date: Mon, 28 Apr 2008 13:24:42 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804281322510.31163@schroedinger.engr.sgi.com>
References: <20080425.021301.193689806.davem@davemloft.net>
 <1209343883-7991-1-git-send-email-jirislaby@gmail.com>
 <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org>
 <20080425151747.GA3265@one.firstfloor.org> <Pine.LNX.4.64.0804251235550.6337@schroedinger.engr.sgi.com>
 <20080426095938.GB17905@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.171.30]:37283 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935326AbYD1UYo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 16:24:44 -0400
In-Reply-To: <20080426095938.GB17905@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 26 Apr 2008, Andi Kleen wrote:

> > Good idea! Do you have a patch?
> 
> Yes. Appended. But it just enables the old NUMA VIRTUAL_BUG_ON()s, more 
> work could be done e.g. by instrumenting pa/va and the non NUMA and i386 
> case too.

Hmmmm.. No hooks yet? I have some pieces here that do something similar:

Subject: Add checks for virtual addresses

Add checks to insure that virtual addresses are not used in invalid contexts.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/mm/ioremap.c     |    1 +
 include/asm-x86/page_32.h |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.25-mm1/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6.25-mm1.orig/arch/x86/mm/ioremap.c	2008-04-25 23:17:31.872390404 -0700
+++ linux-2.6.25-mm1/arch/x86/mm/ioremap.c	2008-04-25 23:37:43.202391820 -0700
@@ -25,6 +25,7 @@
 
 unsigned long __phys_addr(unsigned long x)
 {
+	VM_BUG_ON(is_vmalloc_addr((void *)x));
 	if (x >= __START_KERNEL_map)
 		return x - __START_KERNEL_map + phys_base;
 	return x - PAGE_OFFSET;
Index: linux-2.6.25-mm1/include/asm-x86/page_32.h
===================================================================
--- linux-2.6.25-mm1.orig/include/asm-x86/page_32.h	2008-04-25 23:17:31.882389317 -0700
+++ linux-2.6.25-mm1/include/asm-x86/page_32.h	2008-04-25 23:37:43.202391820 -0700
@@ -64,7 +64,12 @@ typedef struct page *pgtable_t;
 #endif
 
 #ifndef __ASSEMBLY__
-#define __phys_addr(x)		((x) - PAGE_OFFSET)
+static inline unsigned long __phys_addr(unsigned long x)
+{
+	VM_BUG_ON(is_vmalloc_addr((void *)x));
+	return x - PAGE_OFFSET;
+}
+
 #define __phys_reloc_hide(x)	RELOC_HIDE((x), 0)
 
 #ifdef CONFIG_FLATMEM
