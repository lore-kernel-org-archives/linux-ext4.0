Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D2137DE96;
	Fri, 10 Apr 2026 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823590; cv=none; b=dTl4tKcdQ4/iwzVpq5qkkc6IVN7VHh9WEXbfpOT+xWe7EWerc/xv2dvsHM3FNxkgmBMZWCFPAf5+JHSm6m/0l9fGrOCk0uyBQnnR3Lme9CAtLOcsfg3+hQ7zUouQU0AY+QYXoddWCFJCEWrN8hYk+m9N8wpJ6heihZ4+X8T3XfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823590; c=relaxed/simple;
	bh=r17Pe0N1ahBhrB3JYh2nj0lozuwWxFWE8s4wbHnNz1U=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=LaNkLv/JG7BZsfehwcyrh4pS9fsCCcGrRH0IN+S4JTBwN7FfTeOZ7FCztdt3R4jCXe5h2aoqCHUQI1gb572reKNb9m85twmbNWAXUb49vdiauJxQZtBUB31di4FroogJPw5AzzJWclj4y0dW4USXNEpR0ZywVJgZMZBrdhUxdJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okWRwWiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okWRwWiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704BDC19425;
	Fri, 10 Apr 2026 12:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823590;
	bh=r17Pe0N1ahBhrB3JYh2nj0lozuwWxFWE8s4wbHnNz1U=;
	h=Date:From:To:Cc:Subject:References:From;
	b=okWRwWiKRXWxIOYd0Peg6lhswEXmgs6TDBmjhAnD7Q9a6usCqNg9OYWu+roqFftQt
	 CXuq9wugiKbiMxTD+p64hE/DfyXI2OVOyYyt+MQaYOMvBz3HQvYNGX8W9+b4gE14hU
	 1DViHL5lpk9k7rS0TYmec/vPv8+l0l72HHkjevm3yaDtlLwCxfiyVTiYsTY5w9OTh5
	 Ju9iD//e8k54q8KUH3ojDg3WjR+Vu3B/cuQgNtmo0Zn1MW3hNX3wOdJ7kCRM+fO7Bg
	 3Yz29lBDAALUYxAqFMkB8dpm5Y3XPhihE7EzHhldnKqOW+zQ+3nRrzSdk9MbluRvBK
	 0NZT2IviOMPvg==
Date: Fri, 10 Apr 2026 14:19:47 +0200
Message-ID: <20260410120318.658719117@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Bernie Thompson <bernie@plugable.com>,
 linux-fbdev@vger.kernel.org,
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
Subject: [patch 16/38] fbdev: udlfb: Replace get_cycles() with ktime_get()
References: <20260410120044.031381086@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

These metrics are not really requiring CPU cycles and as those are
meanlingless when the CPU is running at a different frequency, this can use
ktime_get() and achieve the same result.

Part of a larger effort to confine get_cycles() access to low level
architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Bernie Thompson <bernie@plugable.com>
Cc: linux-fbdev@vger.kernel.org
---
 Documentation/fb/udlfb.rst  |    4 ++--
 drivers/video/fbdev/udlfb.c |   24 ++++++++++++------------
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/Documentation/fb/udlfb.rst
+++ b/Documentation/fb/udlfb.rst
@@ -156,8 +156,8 @@ metrics_bytes_sent	 32-bit count of how
 			 USB to communicate the resulting changed pixels to the
 			 hardware. Includes compression and protocol overhead
 
-metrics_cpu_kcycles_used 32-bit count of CPU cycles used in processing the
-			 above pixels (in thousands of cycles).
+metrics_cpu_kcycles_used 32-bit count of microseconds used in processing the
+			 above pixels
 
 metrics_reset		 Write-only. Any write to this file resets all metrics
 			 above to zero.  Note that the 32-bit counters above
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/unaligned.h>
+#include <linux/timekeeping.h>
 #include <video/udlfb.h>
 #include "edid.h"
 
@@ -600,15 +601,15 @@ static int dlfb_render_hline(struct dlfb
 
 static int dlfb_handle_damage(struct dlfb_data *dlfb, int x, int y, int width, int height)
 {
+	ktime_t t_start, t_delta;
 	int i, ret;
 	char *cmd;
-	cycles_t start_cycles, end_cycles;
 	int bytes_sent = 0;
 	int bytes_identical = 0;
 	struct urb *urb;
 	int aligned_x;
 
-	start_cycles = get_cycles();
+	t_start = ktime_get();
 
 	mutex_lock(&dlfb->render_mutex);
 
@@ -661,10 +662,9 @@ static int dlfb_handle_damage(struct dlf
 	atomic_add(bytes_sent, &dlfb->bytes_sent);
 	atomic_add(bytes_identical, &dlfb->bytes_identical);
 	atomic_add(width*height*2, &dlfb->bytes_rendered);
-	end_cycles = get_cycles();
-	atomic_add(((unsigned int) ((end_cycles - start_cycles)
-		    >> 10)), /* Kcycles */
-		   &dlfb->cpu_kcycles_used);
+	t_delta = ktime_get() - t_start;
+	/* Avoid a division and approximate microseconds with shift right ten */
+	atomic_add(((int)(t_delta >> 10)), &dlfb->cpu_kcycles_used);
 
 	ret = 0;
 
@@ -727,9 +727,9 @@ static void dlfb_dpy_deferred_io(struct
 {
 	struct fb_deferred_io_pageref *pageref;
 	struct dlfb_data *dlfb = info->par;
+	ktime_t t_start, t_delta;
 	struct urb *urb;
 	char *cmd;
-	cycles_t start_cycles, end_cycles;
 	int bytes_sent = 0;
 	int bytes_identical = 0;
 	int bytes_rendered = 0;
@@ -742,7 +742,7 @@ static void dlfb_dpy_deferred_io(struct
 	if (!atomic_read(&dlfb->usb_active))
 		goto unlock_ret;
 
-	start_cycles = get_cycles();
+	t_start = ktime_get();
 
 	urb = dlfb_get_urb(dlfb);
 	if (!urb)
@@ -774,10 +774,10 @@ static void dlfb_dpy_deferred_io(struct
 	atomic_add(bytes_sent, &dlfb->bytes_sent);
 	atomic_add(bytes_identical, &dlfb->bytes_identical);
 	atomic_add(bytes_rendered, &dlfb->bytes_rendered);
-	end_cycles = get_cycles();
-	atomic_add(((unsigned int) ((end_cycles - start_cycles)
-		    >> 10)), /* Kcycles */
-		   &dlfb->cpu_kcycles_used);
+	t_delta = ktime_get() - t_start;
+	/* Avoid a division and approximate microseconds with shift right ten */
+	atomic_add(((int)(t_delta >> 10)), &dlfb->cpu_kcycles_used);
+
 unlock_ret:
 	mutex_unlock(&dlfb->render_mutex);
 }

