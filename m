Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD05F3CE49F;
	Fri, 10 Apr 2026 12:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823643; cv=none; b=Q0WPyJ6wSs6O9DWelRkA4IcZHpNvlNpSzR2KcVVbd0uLM27CTQX7CcaT1VqvPBKRhVM9yMkvV4uhcMAuX8TuAGvjT2KFe5mKpdvekr+llW1bYVfdd5SUSyqnTSekb/2dMcOyYF09JWYADtPVEGc42wGXZQAGv5R/AYF7BbvYtO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823643; c=relaxed/simple;
	bh=ZI1DuZTKY+73ZiUZu5YDxjD9E28Vsj2HJPMLgb9lTAs=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=spLgXQaa+XupczNPwiNYwEeHk6m5I6nGYOyrVU8LmezS6TD5KiJKQ2no9x+g8xc+wIIr3p/jAiubKz7WFPNgCJtXdWrwJkPVkAZfgkQ+LN0cvncn/rylGA+0lAEYj8z5jO2eFCt9/57KXWrZaIXkMU2Oof2gY7bfONcqzp4mip8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aKc8BIj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aKc8BIj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04A4C19425;
	Fri, 10 Apr 2026 12:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823643;
	bh=ZI1DuZTKY+73ZiUZu5YDxjD9E28Vsj2HJPMLgb9lTAs=;
	h=Date:From:To:Cc:Subject:References:From;
	b=aKc8BIj04xl8fMPMfIdxvFnc9Be7sg+HcqnW4NP8XAVA8CoHWWZUH1TGoEDd3vKKD
	 FNpRo6Iom4qBRwumLXapTj7hfgRDejsC7j6E+L/Vx4C85D2LE1/deOAcMcctONxvIo
	 HMR5AMjZPk8wC2GcrGQEDXlt0rYZP0bNeTIqA2wyhnF5OK38Pv/q09G+oh4E6MeUyG
	 /IRrdxDk2wKuJ9eIif/wOJjQhHy2AsumkYu8PWY0TnTc6wXQmoLW+lJrShxrt0E6Gb
	 m+nyDRqFv+r0pZBlp7wkM/XjcKkMGym/WCszxlys26yMLXsGUqt11/GgfHwii1mXtv
	 FSYiSRKkHgM1Q==
Date: Fri, 10 Apr 2026 14:20:40 +0200
Message-ID: <20260410120319.397219631@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
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
 Dinh Nguyen <dinguyen@kernel.org>,
 Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org,
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
Subject: [patch 27/38] m68k: Select ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

The only remaining usage of get_cycles() is to provide
random_get_entropy().

Switch m68k over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
providing random_get_entropy() in asm/random.h.

Remove asm/timex.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/Kconfig              |    1 +
 arch/m68k/amiga/config.c       |    1 +
 arch/m68k/include/asm/random.h |   14 ++++++++++++++
 arch/m68k/include/asm/timex.h  |   25 -------------------------
 arch/m68k/kernel/time.c        |    2 +-
 5 files changed, 17 insertions(+), 26 deletions(-)

--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select ARCH_HAS_CPU_FINALIZE_INIT if MMU
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DMA_PREP_COHERENT if M68K_NONCOHERENT_DMA && !COLDFIRE
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if M68K_NONCOHERENT_DMA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select ARCH_MIGHT_HAVE_PC_PARPORT if ISA
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -36,6 +36,7 @@
 #include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/config.h>
+#include <asm/random.h>
 
 #include "amiga.h"
 
--- /dev/null
+++ b/arch/m68k/include/asm/random.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASMm68K_RANDOM_H
+#define _ASMm68K_RANDOM_H
+
+extern unsigned long (*mach_random_get_entropy)(void);
+
+static inline unsigned long random_get_entropy(void)
+{
+	if (mach_random_get_entropy)
+		return mach_random_get_entropy();
+	return random_get_entropy_fallback();
+}
+
+#endif
--- a/arch/m68k/include/asm/timex.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * linux/include/asm-m68k/timex.h
- *
- * m68k architecture timex specifications
- */
-#ifndef _ASMm68K_TIMEX_H
-#define _ASMm68K_TIMEX_H
-
-static inline cycles_t get_cycles(void)
-{
-	return 0;
-}
-
-extern unsigned long (*mach_random_get_entropy)(void);
-
-static inline unsigned long random_get_entropy(void)
-{
-	if (mach_random_get_entropy)
-		return mach_random_get_entropy();
-	return random_get_entropy_fallback();
-}
-#define random_get_entropy	random_get_entropy
-
-#endif
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -26,12 +26,12 @@
 #include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/irq_regs.h>
+#include <asm/random.h>
 
 #include <linux/time.h>
 #include <linux/timex.h>
 #include <linux/profile.h>
 
-
 unsigned long (*mach_random_get_entropy)(void);
 EXPORT_SYMBOL_GPL(mach_random_get_entropy);
 

