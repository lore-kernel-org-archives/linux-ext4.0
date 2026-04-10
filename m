Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AEA63C5DAD;
	Fri, 10 Apr 2026 12:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823658; cv=none; b=ZEldeZxOLnwzAEhJNgCmawkApWi8+0MI5DMdQZALV4vsfdw1mpOiBZVtW7dmk927JdOMTfaP4DePDrip+nBXipxnMTNni62cxw6mQPXokpx6kC0JOmFDI1pA9dq3Cc1I/WJhYx+lgUBZCHE/XnNaV1yHYrFZK/nuTSHJNLtpWy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823658; c=relaxed/simple;
	bh=Hb2dziS1cUz3f0ZYnY6mq4QP/VKrKM0StdHMUX+1BaE=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=jQnJ82OSn/FN29TdO9PkImnhnvK28RqxmczoU7cyaAoVE2ThwL+InDbU9pAIsAXJ64tQHxINgvIPzfq66+yNDz4Wd8peDPyaEmKDK5sdx29PBoVkIXk5vDkVXmHDTso+WG92u/zaesfy+SxGN4MEmwxuGlr1ibUnNYu1zmQZ33M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmyBeAjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmyBeAjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82685C19421;
	Fri, 10 Apr 2026 12:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823658;
	bh=Hb2dziS1cUz3f0ZYnY6mq4QP/VKrKM0StdHMUX+1BaE=;
	h=Date:From:To:Cc:Subject:References:From;
	b=RmyBeAjX6h1L2rIRLcz+AgNEdpyqYQZZkX4kYkgxpR9ZJA0/rvdow263wov/8PVOr
	 hb2QUP5GwQZouavgtAcs0bwbkCd8TxgfCVh6LWoo2a7HWknstglzPKB+9aabXFzH1J
	 rP1F6gK8dqeRn0JBTKdTohI1oCqed+5PigWBVmbAA5ah3505CMSHrUL7HPCCN4sGiu
	 NHT4954Kmifvfva6Jx9l4xaRzDUJEaSzZYxXiP8aChKSe2ykT1tpUU6RYxqauW7DoH
	 p3wDa9fQGCdDGL4OtStOnSEjWIThdsFEIiYqSYDvCq0zlNoVlLTrCjuWlgc/BYNO1M
	 jFsY3AL2zO6GQ==
Date: Fri, 10 Apr 2026 14:20:55 +0200
Message-ID: <20260410120319.593798781@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
 Arnd Bergmann <arnd@arndb.de>,
 x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>,
 netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org,
 David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
 "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
Subject: [patch 30/38] openrisc: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

The only remaining non-architecture usage of get_cycles() is to provide
random_get_entropy().

Switch openrisc over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Add 'asm/timex.h' includes to the relevant files, so the global include can
be removed once all architectures are converted over.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: linux-openrisc@vger.kernel.org
---
 arch/openrisc/Kconfig              |    1 +
 arch/openrisc/include/asm/random.h |   12 ++++++++++++
 arch/openrisc/include/asm/timex.h  |    5 -----
 arch/openrisc/lib/delay.c          |    1 +
 4 files changed, 14 insertions(+), 5 deletions(-)

--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -10,6 +10,7 @@ config OPENRISC
 	select ARCH_HAS_DELAY_TIMER
 	select ARCH_HAS_DMA_SET_UNCACHED
 	select ARCH_HAS_DMA_CLEAR_UNCACHED
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select GENERIC_BUILTIN_DTB
 	select COMMON_CLK
--- /dev/null
+++ b/arch/openrisc/include/asm/random.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef __ASM_OPENRISC_RANDOM_H
+#define __ASM_OPENRISC_RANDOM_H
+
+#include <asm/timex.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	return get_cycles();
+}
+
+#endif
--- a/arch/openrisc/include/asm/timex.h
+++ b/arch/openrisc/include/asm/timex.h
@@ -9,13 +9,9 @@
  * OpenRISC implementation:
  * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
  */
-
 #ifndef __ASM_OPENRISC_TIMEX_H
 #define __ASM_OPENRISC_TIMEX_H
 
-#define get_cycles get_cycles
-
-#include <asm-generic/timex.h>
 #include <asm/spr.h>
 #include <asm/spr_defs.h>
 
@@ -23,6 +19,5 @@ static inline cycles_t get_cycles(void)
 {
 	return mfspr(SPR_TTCR);
 }
-#define get_cycles get_cycles
 
 #endif
--- a/arch/openrisc/lib/delay.c
+++ b/arch/openrisc/lib/delay.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 
 #include <asm/param.h>
+#include <asm/timex.h>
 #include <asm/processor.h>
 
 bool delay_read_timer(unsigned long *timer_value)

