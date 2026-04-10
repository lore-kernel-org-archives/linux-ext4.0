Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C698E3CBE65;
	Fri, 10 Apr 2026 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823614; cv=none; b=t4K9uvE2lenawvNQFIvyFrdwoqhWlX9npbKVfQ7CnttX0eZYkSa/IFEvD+SbWBbgDcqLoAzUP2A1RnC6+DDEQgcgpzy1lWVVByUhevTYL9bZHz+mksvDQFis1TxnyrWpvFtW7Eh8KM2keghzBraEw0O3JAvbrKX9Cq3SDuGCHPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823614; c=relaxed/simple;
	bh=fBmKDE903B55aOazdk1fgTYrHTdJzb3m7rYXj49+TyY=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=lN4YwviANod8j/9WlTq1QNr84ZfIuxr2+KdFyq7P8l1IEJXBri/FuOl+oIqBzobyi57ZByif+l0ikZlii7y3jyKPscDNlIdgw7OHLEtI+q47LljBNPhA0Jlh3GPNRh+2k5OYIzZgLYMLR54UXuSxwiW6HRLHEBQC28jpw+Ev/TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K9r3LlHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K9r3LlHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C840C2BCB0;
	Fri, 10 Apr 2026 12:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823614;
	bh=fBmKDE903B55aOazdk1fgTYrHTdJzb3m7rYXj49+TyY=;
	h=Date:From:To:Cc:Subject:References:From;
	b=K9r3LlHrTcCOkcDztBL2sK/tQ+yi3dZzcdFnxujOK2CvaNmPXdlKrSDZTOaDJVW4S
	 4mOX2OGTBKQ54SjOZcfKwdFhqUqz7KSUNqnVJajtIbXp/GGLFwlU7bEb8zVF3NgHwH
	 1PaUWksbUVEp48mOHI3J4/UWYuvo5lLJzmYA1j3FTzptfyaQ68k1o579nPzwBiXUsC
	 3DfIec/NNOEw9ut9tg7BENSlBdgvHCyF+4+WEDfTHmiMcBanB5cN+csJSB4d+fA+Ka
	 C4Vf48Goy0kDdmbaemETnL+HfFRh1XMMUZS6QyYOK2+NJ2yf87fs8P9lxl4UXibsda
	 2J390A/pMX1Ag==
Date: Fri, 10 Apr 2026 14:20:11 +0200
Message-ID: <20260410120318.997202495@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>,
 linux-hams@vger.kernel.org,
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
Subject: [patch 21/38] hamradio: baycom_epp: Remove BAYCOM_DEBUG
References: <20260410120044.031381086@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

The whole code guarded by BAYCOM_DEBUG is only writing debug values into a
datastructure, but there is no way to ever access them.

Remove the pointless ballast.

This is part of a larger effort to remove get_cycles() usage from
non-architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: linux-hams@vger.kernel.org
---
 drivers/net/hamradio/baycom_epp.c |   51 --------------------------------------
 1 file changed, 51 deletions(-)

--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -44,7 +44,6 @@
 
 /* --------------------------------------------------------------------- */
 
-#define BAYCOM_DEBUG
 #define BAYCOM_MAGIC 19730510
 
 /* --------------------------------------------------------------------- */
@@ -191,18 +190,6 @@ struct baycom_state {
 
 	unsigned int ptt_keyed;
 	struct sk_buff *skb;  /* next transmit packet  */
-
-#ifdef BAYCOM_DEBUG
-	struct debug_vals {
-		unsigned long last_jiffies;
-		unsigned cur_intcnt;
-		unsigned last_intcnt;
-		int cur_pllcorr;
-		int last_pllcorr;
-		unsigned int mod_cycles;
-		unsigned int demod_cycles;
-	} debug_vals;
-#endif /* BAYCOM_DEBUG */
 };
 
 /* --------------------------------------------------------------------- */
@@ -259,26 +246,6 @@ static inline int calc_crc_ccitt(const u
 
 #define tenms_to_flags(bc,tenms) ((tenms * bc->bitrate) / 800)
 
-/* --------------------------------------------------------------------- */
-
-static inline void baycom_int_freq(struct baycom_state *bc)
-{
-#ifdef BAYCOM_DEBUG
-	unsigned long cur_jiffies = jiffies;
-	/*
-	 * measure the interrupt frequency
-	 */
-	bc->debug_vals.cur_intcnt++;
-	if (time_after_eq(cur_jiffies, bc->debug_vals.last_jiffies + HZ)) {
-		bc->debug_vals.last_jiffies = cur_jiffies;
-		bc->debug_vals.last_intcnt = bc->debug_vals.cur_intcnt;
-		bc->debug_vals.cur_intcnt = 0;
-		bc->debug_vals.last_pllcorr = bc->debug_vals.cur_pllcorr;
-		bc->debug_vals.cur_pllcorr = 0;
-	}
-#endif /* BAYCOM_DEBUG */
-}
-
 /* ---------------------------------------------------------------------- */
 /*
  *    eppconfig_path should be setable  via /proc/sys.
@@ -621,13 +588,6 @@ static int receive(struct net_device *de
 	return ret;
 }
 
-/* --------------------------------------------------------------------- */
-
-#define GETTICK(x)						\
-({								\
-	x = (unsigned int)get_cycles();				\
-})
-
 static void epp_bh(struct work_struct *work)
 {
 	struct net_device *dev;
@@ -635,21 +595,17 @@ static void epp_bh(struct work_struct *w
 	struct parport *pp;
 	unsigned char stat;
 	unsigned char tmp[2];
-	unsigned int time1 = 0, time2 = 0, time3 = 0;
 	int cnt, cnt2;
 
 	bc = container_of(work, struct baycom_state, run_work.work);
 	dev = bc->dev;
 	if (!bc->work_running)
 		return;
-	baycom_int_freq(bc);
 	pp = bc->pdev->port;
 	/* update status */
 	if (pp->ops->epp_read_addr(pp, &stat, 1, 0) != 1)
 		goto epptimeout;
 	bc->stat = stat;
-	bc->debug_vals.last_pllcorr = stat;
-	GETTICK(time1);
 	if (bc->modem == EPP_FPGAEXTSTATUS) {
 		/* get input count */
 		tmp[0] = EPP_TX_FIFO_ENABLE|EPP_RX_FIFO_ENABLE|EPP_MODEM_ENABLE|1;
@@ -673,7 +629,6 @@ static void epp_bh(struct work_struct *w
 			goto epptimeout;
 		if (transmit(bc, cnt2, stat))
 			goto epptimeout;
-		GETTICK(time2);
 		if (receive(dev, cnt))
 			goto epptimeout;
 		if (pp->ops->epp_read_addr(pp, &stat, 1, 0) != 1)
@@ -700,7 +655,6 @@ static void epp_bh(struct work_struct *w
 		}
 		if (transmit(bc, cnt, stat))
 			goto epptimeout;
-		GETTICK(time2);
 		/* do receiver */
 		while ((stat & (EPP_NRAEF|EPP_NRHF)) != EPP_NRHF) {
 			switch (stat & (EPP_NRAEF|EPP_NRHF)) {
@@ -734,11 +688,6 @@ static void epp_bh(struct work_struct *w
 				goto epptimeout;
 		}
 	}
-	GETTICK(time3);
-#ifdef BAYCOM_DEBUG
-	bc->debug_vals.mod_cycles = time2 - time1;
-	bc->debug_vals.demod_cycles = time3 - time2;
-#endif /* BAYCOM_DEBUG */
 	schedule_delayed_work(&bc->run_work, 1);
 	if (!bc->skb)
 		netif_wake_queue(dev);

