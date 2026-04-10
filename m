Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26D63CCFA9;
	Fri, 10 Apr 2026 12:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823625; cv=none; b=T0fGOea6MAaefT2KzJspzb+reflcvhJVce+XVTZfa7d7IwRgCMJjyUY+i+kbIyB3wqYDexUKre57TKZyXseHbf4COa+x0BmIGXqWHJbGxUKbkP0YQt2QYRuj/9eEJB6CcFRya20v8bHCcFxoUEFpsbiTmDZm6GSLKs1TVPELT14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823625; c=relaxed/simple;
	bh=oFanz67wDB6XocOAPDGw4dDZpTIkPCesLmisdDG6nxo=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=hAoJOvRcRD5SIXTv2D+n1Y9KsY8ltJ1I/PQLZpQXXd+UWxGF5vNxB3ysr2p7ZhRMhFLgIrQTPVSCaOE1OopMxj3YmAK0YRAHzzXSf5mcgrjs4xiwXhYkiqCHkwTyCsmkB3fTJTBa7B/puxbTE0KM8HEZiJcpn1WlCTP7QOmvLzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0dC5Jtr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0dC5Jtr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8D1C2BCAF;
	Fri, 10 Apr 2026 12:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823624;
	bh=oFanz67wDB6XocOAPDGw4dDZpTIkPCesLmisdDG6nxo=;
	h=Date:From:To:Cc:Subject:References:From;
	b=c0dC5JtrlZ2hDwVhQHVakSSF0GbYurUcyOeInN2NikRGB2GB116TXZbw4nZgMtYST
	 +trrlORaNRGlhOHpfrC+lW1HFBRAEy8GyOUXKZu1wlydXKozlVO6l7tAEsojNrD9kY
	 z8EDy3AU6BDmVg1em2KMGfc38GeNfIIV9PZdmIDh6XXPID1ZvpPfEKL37BFIXkriEy
	 vg9bLTMeocXCte6TCzTTMg21Eh6HrXJDyZdGV1tmWvL/lAElJukNPv/QpJCLNXioOw
	 AQtioNlgi2FcvW/yMQPolJ5GR/97GritVQBv4kElLuN4ah4YH0PTQC3eZtbzxU1vfd
	 IORnVjKLVUNIw==
Date: Fri, 10 Apr 2026 14:20:21 +0200
Message-ID: <20260410120319.131582521@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org,
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
 Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org,
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
Subject: [patch 23/38] alpha: Select ARCH_HAS_RANDOM_ENTROPY
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

Switch alpha over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Remove asm/timex.h as it has no functionality anymore.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/Kconfig              |    1 +
 arch/alpha/include/asm/random.h |   14 ++++++++++++++
 arch/alpha/include/asm/timex.h  |   26 --------------------------
 3 files changed, 15 insertions(+), 26 deletions(-)

--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -5,6 +5,7 @@ config ALPHA
 	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DMA_OPS if PCI
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_MODULE_NEEDS_WEAK_PER_CPU if SMP
--- /dev/null
+++ b/arch/alpha/include/asm/random.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASMALPHA_RANDOM_H
+#define _ASMALPHA_RANDOM_H
+
+/* Use the cycle counter for entropy. */
+static inline unsigned long random_get_entropy(void)
+{
+	unsigned long ret;
+
+	__asm__ __volatile__ ("rpcc %0" : "=r"(ret));
+	return ret;
+}
+
+#endif
--- a/arch/alpha/include/asm/timex.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * linux/include/asm-alpha/timex.h
- *
- * ALPHA architecture timex specifications
- */
-#ifndef _ASMALPHA_TIMEX_H
-#define _ASMALPHA_TIMEX_H
-
-/*
- * Standard way to access the cycle counter.
- * Currently only used on SMP for scheduling.
- *
- * Only the low 32 bits are available as a continuously counting entity. 
- * But this only means we'll force a reschedule every 8 seconds or so,
- * which isn't an evil thing.
- */
-static inline cycles_t get_cycles (void)
-{
-	cycles_t ret;
-	__asm__ __volatile__ ("rpcc %0" : "=r"(ret));
-	return ret;
-}
-#define get_cycles get_cycles
-
-#endif

