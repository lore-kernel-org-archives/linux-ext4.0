Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA3A3BE65E;
	Fri, 10 Apr 2026 12:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775823595; cv=none; b=rBi0/ZK3F0bl+yH1eAL6M8C88TNWsdy8XkHdOHzChHkqsyoJSTi+PixSrDpl/QFvfMrxSg4K60Sxq8yGdJm9DV27NT2VMxrCJlZ1qpmfjOoQVDlTT6MBDS/vqIToxuxPJDWw1i67rdcn5qD/ZOxUeahPnqxCwC/yNcD8x3oA/oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775823595; c=relaxed/simple;
	bh=QF8xu2w1ekYQn9h8hXu1i+73iAYxDniq8hK08qkXVok=;
	h=Date:Message-ID:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type; b=H5qg6XHWjf+fn2L34l8+P3Qu0WIK1gUSW9Jwt3xg4tAKJTKCSqEzpkL7/NflayGEEwhEYujzkVKYQgjeXaQwE6JvC3AMwHYCxULov0SXihTr55OtVZ6fgVusQhw4Zl2WOSY7zHU4uLr7t3FCTM2yqeookhtAVFXFEgmYW/wq1pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jdPhw8GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jdPhw8GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B407C2BC87;
	Fri, 10 Apr 2026 12:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775823595;
	bh=QF8xu2w1ekYQn9h8hXu1i+73iAYxDniq8hK08qkXVok=;
	h=Date:From:To:Cc:Subject:References:From;
	b=jdPhw8GNcCbidbYQHfvNnynlBMQ6C8yak4JEVkjtLiGZL97Y3Kg6hDMEq3+pAZn9l
	 eebAKa8zdYjNIUhQRVD9BnFcdpgh+r9+oY8nCOOBP3TXDWg59J0yEe49bjDh/j5GY1
	 J/+Mrsj5Z9JlM/AmirqGD8HvbUDB7O2+WSvwYb2Dt2w8mdLS3mlRSvEUCA//cm+I50
	 T3lnhTwlF7Ll8vkIeV4joWfasbaLJDpe8kQqwYnenbDJtbX6i3a/y8coaGgKPKMk+y
	 /Al4CmKTrbd6SuhGXm70yx904ODj2E0CWQ5/8mFozaTW1DKtHUVqiCNDO1sI7Gfirg
	 PX6BMdDjfEFyw==
Date: Fri, 10 Apr 2026 14:19:52 +0200
Message-ID: <20260410120318.727211419@kernel.org>
User-Agent: quilt/0.68
From: Thomas Gleixner <tglx@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Theodore Tso" <tytso@mit.edu>,
 linux-ext4@vger.kernel.org,
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
Subject: [patch 17/38] ext4: Replace get_cycles() usage with ktime_get()
References: <20260410120044.031381086@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8

get_cycles() is not guaranteed to be functional on all systems/platforms
and the values returned are unitless and not easy to map to something
useful.

Use ktime_get() instead, which provides nanosecond timestamps and is
functional everywhere.

This is part of a larger effort to limit get_cycles() usage to low level
architecture code.

Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/mballoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1289,7 +1289,7 @@ void ext4_mb_generate_buddy(struct super
 	ext4_grpblk_t len;
 	unsigned free = 0;
 	unsigned fragments = 0;
-	unsigned long long period = get_cycles();
+	ktime_t period = ktime_get();
 
 	/* initialize buddy from bitmap which is aggregation
 	 * of on-disk bitmap and preallocations */
@@ -1328,7 +1328,7 @@ void ext4_mb_generate_buddy(struct super
 
 	clear_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
 
-	period = get_cycles() - period;
+	period = ktime_get() - period;
 	atomic_inc(&sbi->s_mb_buddies_generated);
 	atomic64_add(period, &sbi->s_mb_generation_time);
 }

