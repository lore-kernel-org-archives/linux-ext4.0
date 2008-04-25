From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 15:23:56 +0000 (UTC)
Message-ID: <1209343883-7991-1-git-send-email-jirislaby__24542.498359415$1209137078$gmane$org@gmail.com>
References: <20080425.021301.193689806.davem@davemloft.net>
Cc: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:45082 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751108AbYDYPXg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 11:23:36 -0400
Date: Mon, 28 Apr 2008 02:51:23 +0200
In-Reply-To: <20080425.021301.193689806.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

David Miller <davem@davemloft.net> wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Fri, 25 Apr 2008 19:10:37 +0200
> 
> > I'm going to bisect it, will be back in few hours ;).
> 
> Thanks for all of this hard work and investigation Jiri!

Thanks. Bisected mm down to git-x86.patch, bisected git-x86-latest down to
x86: enhance DEBUG_RODATA support - alternatives
The patch below fixes the problem for me. Comments welcome.

The 0xf0 pattern comes from alternatives_smp_lock:
text_poke(*ptr, ((unsigned char []){0xf0}), 1);

I grepped for it a long time ago, but not in a form of coumpound literal :/.

*Never* more :).

--

kernel_text_address returns true even for modules which is not wanted
in text_poke. Use core_kernel_text instead.

This is a regression introduced in e587cadd8f47e202a30712e2906a65a0606d5865
which caused occasionaly crashes after suspend/resume.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>
CC: pageexec@freemail.hu
CC: H. Peter Anvin <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 5412fd7..0b074cb 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -515,7 +515,7 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	BUG_ON(len > sizeof(long));
 	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
 		- ((long)addr & ~(sizeof(long) - 1)));
-	if (kernel_text_address((unsigned long)addr)) {
+	if (core_kernel_text((unsigned long)addr)) {
 		struct page *pages[2] = { virt_to_page(addr),
 			virt_to_page(addr + PAGE_SIZE) };
 		if (!pages[1])
-- 
1.5.4.5

