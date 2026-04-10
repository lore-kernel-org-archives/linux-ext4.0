Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C075E3BF677;
	Fri, 10 Apr 2026 12:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823609; cv=none; b=fYKHoVuCywDnRDrT3jXANcox+cmjE8gx34yzXJr5NC4KTFnBXIrfsII8PTnWJLKJrskisrlCQyVh4nMpYrBPN+HOYbIBmwqR7sHJplBjxVBhq7FTBGCJdbVrAltZbJyYKy6u8JTIWv2X8mhtkgw8WKOb3u+mmHBQgcdnMluhGP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823609; c=relaxed/simple;
	bh=UKj6WoZFsTQfNpLsa4hK9AJwWp/c6TyAgfAmmgBM2Aw=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=Q5Dk+UZYkVYtIgMsX39fEcffPAkPHN9RhmTxmsnqL0JNu/qL2eCjOpy6m3IoDttALBoXQyBCDFVSTcnUU8XyFxwxgfa1GSVv6QAz+/R/mBM6ArzLqqHcTMqRe3+UnI5f+G1GLAwsSaDDVG7hFKkqxSGmsKruQK2Ems1h7xrEcgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEmycwX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEmycwX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CA3C19425;
	Fri, 10 Apr 2026 12:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823609;
	bh=UKj6WoZFsTQfNpLsa4hK9AJwWp/c6TyAgfAmmgBM2Aw=;
	h=Date:From:To:Cc:Subject:References:From;
	b=SEmycwX5s0//+gtSPktg47GJS+8sJlwAPsv65Bq7Wv5tg7uQL3Gpghd9FaOczcWIN
	 ZQaCuA/qh+jNH/riNYpmVLmwYhqyjM2JbqnNtt1yhbGBg3HT7iCiqP6g94wS0wTPIA
	 99ougHo5Nu9h67SjSnTNqyHC+/lIAAGR6p7tHCAck6aAnXmlbTDue5R1sT+DZ/waOZ
	 GXIvFpg3p1ueseORBf9eozHpgJ3jpkMWN+atB0UvtcxRk8vKXhCteFgdwrDai6rThh
	 FHU0CtO/nkzQnAaFOlH62oLpy9zcH9gwc0II0cebCdnPQhGplJ3L9nz1drcdz9bKdB
	 3Oc5+96qoKgtw==
Date: Fri, 10 Apr 2026 14:20:06 +0200
Message-ID: <20260410120318.929806643@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 kasan-dev@googlegroups.com,
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
Subject: [patch 20/38] kasan: sw_tags: Replace get_cycles() by
 random_get_entropy()
References: <20260410120044.031381086@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

Seeding the random state with get_cycles() is functionally equivalent on
the architectures which provide get_cycles(), but it does not make sense
semantically.

Use random_get_entropy() instead, which is the proper interface.

This is part of a larger effort to remove get_cycles() usage from
non-architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: kasan-dev@googlegroups.com
---
 mm/kasan/sw_tags.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -41,7 +41,7 @@ void __init kasan_init_sw_tags(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		per_cpu(prng_state, cpu) = (u32)get_cycles();
+		per_cpu(prng_state, cpu) = (u32)random_get_entropy();
 
 	kasan_init_tags();
 	kasan_enable();

