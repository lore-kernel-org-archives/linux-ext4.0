Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1813C4566;
	Fri, 10 Apr 2026 12:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823619; cv=none; b=UaqxFWRQ7jNL7xiUzaFSyabXxWIh1sHjcFZ5L0YIGwKPoryc9DJzNlmf22kexVU3g/SObgPjChXC0vag52rdD1wI4wIxzyPhqBB+Q3FdRZ1+srMBKYLBYLYZO5Lnztr3KJVWPUfUJPFNLc1Qs3imud9HU0P+9REPyuB25co+vPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823619; c=relaxed/simple;
	bh=qm3xQcBXEr96lL4hegVcj0UIOMtgXH0StGBPsgVLlKQ=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=pwhTH/LlUysvxt6vG27EW+1KliR/E+ys+ncaLsBtCQpNsutspYmuCZ/dM1/T0l1bMcgxe8mnNNNiGytS4ehowhA381vCThIj6rRzvr/dbzvxnhM10vjC2fit5bhUabiuDCFUYWFrZF7EGkGvX4DH+g2Z1iTk/1akeJKEL9fok4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7az2CYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7az2CYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E21BC19421;
	Fri, 10 Apr 2026 12:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823619;
	bh=qm3xQcBXEr96lL4hegVcj0UIOMtgXH0StGBPsgVLlKQ=;
	h=Date:From:To:Cc:Subject:References:From;
	b=C7az2CYXx68wjErxLRkuWTeHqh2CiNCWSqYoEW7CDASKgYcRJIgZbMFxC0wyGwYuo
	 q2wWS5Il3rSZIvkXMrziJDymJeOKDwzCu+GiLTUQ15ObFw+7EBHLm3ubP5lL1H6hxr
	 ReCtVW/VKZ0Y6HBv+Xxa78vZHjPEyhGg6WzSGQLG1W0Tyuqe7kgGZgc8KKs+JzIX6a
	 qzTQ3qBxeH5MKjO5ANy/+fOcCKNQ7HWyamJ7hE6VNKzzJsl13+xyi236101/gCvlT5
	 hn6GusmLxuTParC929bCg39takaaNPRV5A3bS+11CTndJSbqW1MjcdkxKmUqQfmLua
	 lqUqNEa3EnLWw==
Date: Fri, 10 Apr 2026 14:20:16 +0200
Message-ID: <20260410120319.064561422@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
Subject: [patch 22/38] random: Provide CONFIG_ARCH_HAS_RANDOM_ENTROPY
References: <20260410120044.031381086@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Chasing down to what random_get_entropy() resolves is a 'spot the mouse'
game through a maze of #ifdeffery. Also the placement in timex.h is
non-obvious and has just been chosen because it provides conveniant access
to the underlying get_cycles() #ifdeffery.

Provide a config switch which is selectable by the architecture and a
temporary #ifdef guard in timex.h. Architectures which select the config
switch must provide asm/random.h with the architecture specific
implementation.

Update all usage sites to include linux/random.h so that the gradual
conversion does not cause build regressions.

This is part of a larger effort to remove get_cycles() usage from
non-architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
---
 arch/Kconfig                     |    3 +++
 arch/loongarch/kernel/relocate.c |    1 +
 arch/mips/kernel/relocate.c      |    1 +
 crypto/jitterentropy-kcapi.c     |    1 +
 include/linux/random.h           |   15 +++++++++++++++
 include/linux/timex.h            |    2 ++
 kernel/kcsan/core.c              |    1 +
 7 files changed, 24 insertions(+)

--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -370,6 +370,9 @@ config ARCH_HAS_CPU_FINALIZE_INIT
 config ARCH_HAS_DELAY_TIMER
 	bool
 
+config ARCH_HAS_RANDOM_ENTROPY
+	bool
+
 # The architecture has a per-task state that includes the mm's PASID
 config ARCH_HAS_CPU_PASID
 	bool
--- a/arch/loongarch/kernel/relocate.c
+++ b/arch/loongarch/kernel/relocate.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/printk.h>
 #include <linux/panic_notifier.h>
+#include <linux/random.h>
 #include <linux/start_kernel.h>
 #include <asm/bootinfo.h>
 #include <asm/early_ioremap.h>
--- a/arch/mips/kernel/relocate.c
+++ b/arch/mips/kernel/relocate.c
@@ -19,6 +19,7 @@
 #include <linux/libfdt.h>
 #include <linux/of_fdt.h>
 #include <linux/panic_notifier.h>
+#include <linux/random.h>
 #include <linux/sched/task.h>
 #include <linux/start_kernel.h>
 #include <linux/string.h>
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -42,6 +42,7 @@
 #include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <crypto/internal/rng.h>
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -139,4 +139,19 @@ int random_online_cpu(unsigned int cpu);
 extern const struct file_operations random_fops, urandom_fops;
 #endif
 
+unsigned long random_get_entropy_fallback(void);
+
+/*
+ * random_get_entropy() is used by the /dev/random driver in order to extract
+ * entropy via the relative unpredictability of when an interrupt takes places
+ * versus a high speed, fine-grained timing source or cycle counter.  Since it
+ * will be occurred on every single interrupt, it must have a very low
+ * cost/overhead.
+ *
+ * If an architecture does not provide it, then use random_get_entropy_fallback().
+ */
+#ifdef CONFIG_ARCH_HAS_RANDOM_ENTROPY
+#include <asm/random.h>
+#endif
+
 #endif /* _LINUX_RANDOM_H */
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -66,6 +66,7 @@ unsigned long random_get_entropy_fallbac
 
 #include <asm/timex.h>
 
+#ifndef CONFIG_ARCH_HAS_RANDOM_ENTROPY
 #ifndef random_get_entropy
 /*
  * The random_get_entropy() function is used by the /dev/random driver
@@ -85,6 +86,7 @@ unsigned long random_get_entropy_fallbac
 #define random_get_entropy()	random_get_entropy_fallback()
 #endif
 #endif
+#endif
 
 /*
  * SHIFT_PLL is used as a dampening factor to define how much we
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -18,6 +18,7 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
+#include <linux/random.h>
 #include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>

