Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907A13C1978;
	Fri, 10 Apr 2026 12:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823531; cv=none; b=mDk65ggUWxBydJz3x0nmAdBCnQndeaYnQKXnClJqUUV6bkEAVoeHA80K4p2Fx/uJTGO32qIXUsVOAUjri6/tmjrsFcrqmMkTpzO5vEmU2z/I6x0zGdRqgGz1yRD2PD6hEPumvDcWq2A5XqI1j+8+451p11y2kVF9Y6XP0fECaVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823531; c=relaxed/simple;
	bh=d9g4tptgi4bHAMeSUYU/X2RKjwFUxFqrN/mhP3KVNVE=;
	h=Date:Message-ID:From:To:Subject:References:MIME-Version:
	 Content-Type:cc; b=CTZdikNibaQEV3BkLOvgJp6nd2ucYLrNkwoLfv53ZSbsgmd9LCo+FovOPxRqiAhur5rSqEqY7JCKVMAMF/TVF2RCRmT2uQSycsVcwjB//O3Sr4gxGsD71sRmD50Kx8c+peSKwPwDTiNpyHXi3WHncVew8GxsZgppktAAkHZzwLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C95dlBh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C95dlBh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41928C2BCAF;
	Fri, 10 Apr 2026 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823531;
	bh=d9g4tptgi4bHAMeSUYU/X2RKjwFUxFqrN/mhP3KVNVE=;
	h=Date:From:To:Subject:References:cc:From;
	b=C95dlBh11sE1EDcg7WkfMi8fo/Gu65tTzE/T1Srv47O6KGVj91UAmlXjU/FculsKY
	 awynI69i3I7OzFyIZRoLHG74aENkFw6rGItybhxSqe437lYLBTdjTVnjO/BdcaqFmm
	 BXfUg/n2zRCzaQYn/z/fsuHLl0WmkcWVFMRkJhLQ5RkhTFRVvrz/UodergNNz9SIp4
	 BVs5UNoonypUPXLwnttDKrM12mG46vN5EiYmDA6MeZqU6JoMxzzH1xMf+HYNN+Suws
	 7vEfC+JysbP6o62RQk33gA7qFJeSKzf6pdk/9/gi1eWOgpyfVkfoVSPrkQiIoyiqxd
	 pjPaBhdVrzMKA==
Date: Fri, 10 Apr 2026 14:18:47 +0200
Message-ID: <20260410120317.843419270@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 04/38] x86: Use PIT_TICK_RATE instead of CLOCK_TICK_RATE
References: <20260410120044.031381086@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
cc: Arnd Bergmann <arnd@arndb.de>,
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

CLOCK_TICK_RATE is only used in x86 but defined all over the tree for no
reason with comments that it's scheduled for removal for more than a
decade.

Use PIT_TICK_RATE for registering refined jiffies to get rid of the last
dependency.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
---
 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1268,7 +1268,7 @@ void __init setup_arch(char **cmdline_p)
 
 	mcheck_init();
 
-	register_refined_jiffies(CLOCK_TICK_RATE);
+	register_refined_jiffies(PIT_TICK_RATE);
 
 #ifdef CONFIG_EFI
 	if (efi_enabled(EFI_BOOT))

