Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594843C553F;
	Fri, 10 Apr 2026 12:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823639; cv=none; b=BGbamn3AoFohtPeEoP6Jdg2hAdG8IBa3v0O1xGbsu+2M+yzJHakECAHrxCLvJcf4qVbmvQTdd4ZzWfx3Jdjo2tY6RNpCsjLkie3cRHnV2MgZE6YcJK2e7kOFhqoqGcVM4Vq4Rhwjf6b5657bKACOEV08YV5DgflZKVmnyWjQ9io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823639; c=relaxed/simple;
	bh=xuHY9CZoFUC3Uh1usl17ZiiMpll/sjP+R8Uwlr/gPtE=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=XYnNZannps4q1ybrfqgIngbqbqnA8TLF2ro7Ksc9JAeF7b+UU+aooamKn7raVG4h+aDrhuHOQi3jUi7K5h4qdFwzR8sUveQfFdkjclR3xfXc4BBOCUq0xL/E3faeFN6ExilT96HA0UnxJUU5gT4rii8tXHNRJkO151LaJrep3pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q1INVKXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q1INVKXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1D3C2BC9E;
	Fri, 10 Apr 2026 12:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823639;
	bh=xuHY9CZoFUC3Uh1usl17ZiiMpll/sjP+R8Uwlr/gPtE=;
	h=Date:From:To:Cc:Subject:References:From;
	b=q1INVKXpZHtktKQFtR7J0+4UmhxfrqTk44NJDJ9JcHhB06YLNiRtKSdKF4mgJVuJK
	 SbcmSgsMKGBRlcg33rDyUOrFSOUDUDhFVtStbWiiXhg+24Wo0rvXGROWGoPGbTgWpY
	 1QIfeqOqXuPtKqCTAnTH/4z6y5eKaf0+C4alVsAJYiVtcktTob8TzqOeasZ85w0p7X
	 BtZas6qdu0vK0vHim0/6rol7iQm8En5aXNu+7ovbB+IOTj4HSKX+ow5cG7qCECZo1T
	 4BmBLkbX+cyQgBzFeuQcBUbwDEtuOB2nQvII7+MypdiMTP4ticoX+aM+zON4QU+Q9r
	 WXrWSNCF41x9w==
Date: Fri, 10 Apr 2026 14:20:35 +0200
Message-ID: <20260410120319.330598126@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev,
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
Subject: [patch 26/38] loongarch: Select ARCH_HAS_RANDOM_ENTROPY
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

Switch loongarch over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
and providing random_get_entropy() in asm/random.h.

Add 'asm/timex.h' includes to the relevant files, so the global include can
be removed once all architectures are converted over.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: loongarch@lists.linux.dev
---
 arch/loongarch/Kconfig              |    1 +
 arch/loongarch/include/asm/random.h |   15 +++++++++++++++
 arch/loongarch/kernel/syscall.c     |    1 +
 arch/loongarch/lib/delay.c          |    2 +-
 4 files changed, 18 insertions(+), 1 deletion(-)

--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -26,6 +26,7 @@ config LOONGARCH
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTE_SPECIAL
+	select ARCH_HAS_RANDOM_ENTROPY
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
--- /dev/null
+++ b/arch/loongarch/include/asm/random.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
+ */
+#ifndef _ASM_RANDOM_H
+#define _ASM_RANDOM_H
+
+#include <asm/timex.h>
+
+static inline unsigned long random_get_entropy(void)
+{
+	return get_cycles();
+}
+
+#endif /*  _ASM_RANDOM_H */
--- a/arch/loongarch/kernel/syscall.c
+++ b/arch/loongarch/kernel/syscall.c
@@ -19,6 +19,7 @@
 #include <asm/loongarch.h>
 #include <asm/signal.h>
 #include <asm/switch_to.h>
+#include <asm/timex.h>
 #include <asm-generic/syscalls.h>
 
 #undef __SYSCALL
--- a/arch/loongarch/lib/delay.c
+++ b/arch/loongarch/lib/delay.c
@@ -5,9 +5,9 @@
 #include <linux/delay.h>
 #include <linux/export.h>
 #include <linux/smp.h>
-#include <linux/timex.h>
 
 #include <asm/processor.h>
+#include <asm/timex.h>
 
 void __delay(unsigned long cycles)
 {

