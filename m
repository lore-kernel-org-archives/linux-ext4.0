From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Sat, 26 Apr 2008 11:59:38 +0200
Message-ID: <20080426095938.GB17905@one.firstfloor.org>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151747.GA3265@one.firstfloor.org> <Pine.LNX.4.64.0804251235550.6337@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:46205 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYDZJxl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 26 Apr 2008 05:53:41 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804251235550.6337@schroedinger.engr.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 25, 2008 at 12:36:33PM -0700, Christoph Lameter wrote:
> On Fri, 25 Apr 2008, Andi Kleen wrote:
> 
> > > And we should really add a lot more sanity checking there.
> > 
> > A debug mode for virt_to_page(),__pa,__va et.al. would probably make sense
> > and would have caught it.
> > 
> > I used to have that partly in the x86-64 port with VIRTUAL_BUG_ON.
> 
> Good idea! Do you have a patch?

Yes. Appended. But it just enables the old NUMA VIRTUAL_BUG_ON()s, more 
work could be done e.g. by instrumenting pa/va and the non NUMA and i386 
case too.

-Andi

---


Add CONFIG option to enable VIRTUAL_BUG_ON()

VIRTUAL_BUG_ON was used in the early days of x86-64 NUMA to debug the 
virtual address to struct page code.

Later it was noped, but the call kept intact.

Add a CONFIG option to enable it as a BUG_ON again. This would have
likely caught the recent text_poke bug.

Signed-off-by: Andi Kleen <andi@firstfloor.org>

Index: linux/arch/x86/Kconfig.debug
===================================================================
--- linux.orig/arch/x86/Kconfig.debug
+++ linux/arch/x86/Kconfig.debug
@@ -245,4 +245,11 @@ config CPA_DEBUG
 	help
 	  Do change_page_attr() self-tests every 30 seconds.
 
+config DEBUG_VIRTUAL
+	bool "Virtual memory translation debugging"
+	depends on DEBUG_KERNEL && NUMA && X86_64
+	help
+	  Enable some costly sanity checks in the NUMA virtual to page
+          code.  This can catch mistakes with virt_to_page() and friends.
+
 endmenu
Index: linux/include/asm-x86/mmzone_64.h
===================================================================
--- linux.orig/include/asm-x86/mmzone_64.h
+++ linux/include/asm-x86/mmzone_64.h
@@ -7,7 +7,11 @@
 
 #ifdef CONFIG_NUMA
 
+#ifdef CONFIG_DEBUG_VIRTUAL
+#define VIRTUAL_BUG_ON(x) BUG_ON(x)
+#else
 #define VIRTUAL_BUG_ON(x)
+#endif
 
 #include <asm/smp.h>
 
