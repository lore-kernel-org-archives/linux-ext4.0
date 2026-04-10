Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DBD3C8731;
	Fri, 10 Apr 2026 12:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823585; cv=none; b=uDIIzPl6EkdrzAYSzLENkCYTsuG60ORaXJERlu2PfC7G0ivYQbrYCGMG0VEaeojnUO/mrZQnrjCZhiiGISh9/0LtebmMzKN2PU4rApAmNQaKgY50FHw3BgbaVTBs5yqBdUaCdk6a32IhLmcexUD8zz3/Ku3hCVM+SwDObMbU2Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823585; c=relaxed/simple;
	bh=QeSclCuMiRAS5wk6lWoviUdmtawCgYPJK7955XSCrpk=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=XD9CRe/CrB1xSZMARoEF2zB19OwDGKRmcG+xcIIm3i5PksMiNFlffOU+8CRA8JOrWyJ7Xc+hCsD1LYtnM4K33gViWPZ65NExz+c08nGUSA8bh062gHltzvUT0bC1FUXruCHxWRazERHqUvkgwYLbP4p2IlZzdFc9NWyToXXJ/6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lx7PSe/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lx7PSe/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F75AC2BC9E;
	Fri, 10 Apr 2026 12:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823585;
	bh=QeSclCuMiRAS5wk6lWoviUdmtawCgYPJK7955XSCrpk=;
	h=Date:From:To:Cc:Subject:References:From;
	b=lx7PSe/PjadVTpIMwJdhAJBLt/wkFkRfbRhizAqdCmT18BPcbSlnMFeRTECetW5Mz
	 e18kIbNIOdNmzSRNcljN5MiUEDzdauvDtZpRrKPYAQq6HuU0ixY90WW/AT9/9BP1TE
	 G0pmyVH8DHnvheD/Jtznb1TEyB0LG5ezsRLYR23JSrj8T1XCNh6BmAZvkaj4VTBCOk
	 FjtLvndHPm1jEFcE8PqfK7D9YifyYmXQkYky/wPITICuSdRrICGnLkZ3jZxe25sBaP
	 q8ggvP1HMAsaRRMlhxP+iwStOOzZHUsvv+/U0DMMTE0lc38vp99aMg2cqhdxuGrXAu
	 mqm2UYpSfgZaw==
Date: Fri, 10 Apr 2026 14:19:42 +0200
Message-ID: <20260410120318.592237447@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
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
Subject: [patch 15/38] ptp: ptp_vmclock: Replace get_cycles() usage
References: <20260410120044.031381086@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

get_cycles() is not really well defined and similar to other usaage of the
underlying hardware CPU counters the PTP vmclock should use an explicit
interface as well.

Implement ptp_vmclock_read_cpu_counter() in arm64 and x86 and simplify the
Kconfig selection while at it.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 arch/arm64/Kconfig                   |    1 +
 arch/arm64/include/asm/ptp_vmclock.h |   12 ++++++++++++
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/ptp_vmclock.h   |   12 ++++++++++++
 drivers/ptp/Kconfig                  |    6 ++++--
 drivers/ptp/ptp_vmclock.c            |    6 ++++--
 6 files changed, 34 insertions(+), 4 deletions(-)

--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -112,6 +112,7 @@ config ARM64
 	select ARCH_SUPPORTS_SCHED_SMT
 	select ARCH_SUPPORTS_SCHED_CLUSTER
 	select ARCH_SUPPORTS_SCHED_MC
+	select ARCH_SUPPORTS_PTP_VMCLOCK if ARCH_SUPPORTS_INT128
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_BPF_JIT
--- /dev/null
+++ b/arch/arm64/include/asm/ptp_vmclock.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_PTP_VMCLOCK_H
+#define __ASM_PTP_VMCLOCK_H
+
+#include <asm/arch_timer.h>
+
+static inline u64 ptp_vmclock_read_cpu_counter(void)
+{
+	return arch_timer_read_counter();
+}
+
+#endif
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -135,6 +135,7 @@ config X86
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_AUTOFDO_CLANG
 	select ARCH_SUPPORTS_PROPELLER_CLANG    if X86_64
+	select ARCH_SUPPORTS_PTP_VMCLOCK	if X86_TSC
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if X86_CX8
 	select ARCH_USE_MEMTEST
--- /dev/null
+++ b/arch/x86/include/asm/ptp_vmclock.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_PTP_VMCLOCK_H
+#define __ASM_PTP_VMCLOCK_H
+
+#include <asm/tsc.h>
+
+static inline u64 ptp_vmclock_read_cpu_counter(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_TSC) ? rdtsc() : 0;
+}
+
+#endif
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -131,10 +131,12 @@ config PTP_1588_CLOCK_KVM
 	  To compile this driver as a module, choose M here: the module
 	  will be called ptp_kvm.
 
+config ARCH_SUPPORTS_PTP_VMCLOCK
+	bool
+
 config PTP_1588_CLOCK_VMCLOCK
 	tristate "Virtual machine PTP clock"
-	depends on X86_TSC || ARM_ARCH_TIMER
-	depends on PTP_1588_CLOCK && ARCH_SUPPORTS_INT128
+	depends on PTP_1588_CLOCK && ARCH_SUPPORTS_PTP_VMCLOCK
 	default PTP_1588_CLOCK_KVM
 	help
 	  This driver adds support for using a virtual precision clock
--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -28,6 +28,8 @@
 
 #include <linux/ptp_clock_kernel.h>
 
+#include <asm/ptp_vmclock.h>
+
 #ifdef CONFIG_X86
 #include <asm/pvclock.h>
 #include <asm/kvmclock.h>
@@ -144,11 +146,11 @@ static int vmclock_get_crosststamp(struc
 			if (systime_snapshot.cs_id == st->cs_id) {
 				cycle = systime_snapshot.cycles;
 			} else {
-				cycle = get_cycles();
+				cycle = ptp_vmclock_read_cpu_counter();
 				ptp_read_system_postts(sts);
 			}
 		} else {
-			cycle = get_cycles();
+			cycle = ptp_vmclock_read_cpu_counter();
 		}
 
 		delta = cycle - le64_to_cpu(st->clk->counter_value);

