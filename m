Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA1B7261C;
	Wed, 15 Apr 2026 06:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776235688; cv=none; b=VC0HeiIeyPbFiMPlht12nkmj1sOzpLciXiWZzrfVe3CdzIDzMfGMaDd4M9L7dXoPu3Xn17ZUfQcJCs35e/vkLuPElTADpam7hW9ZdfalSZYuAhmiQqdJ7c/HhXIdK+9QX8sAGO4oLasX4Xd8bYeefuH1BEsNhE7tRPAWAVjp08w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776235688; c=relaxed/simple;
	bh=uO1fFgRaYkEaX03uIGSllbIp0KmN4e8uhrxbiL7j6JA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b0DifANz9TAza/g0YGWlyJzT5cmj1b9jAXrEuvQudqCfl5mh8pMN2VV1x2+/jiRPgx0WazlQLhgh7ibkcQI/dZwKq6QLErIeBGUQOPa+o9gTiX1e30B7xxARW4oG5XxFubH77edrD36djPekrUkEd9FvBvlIzw0rcZJWWysSLkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wn6Hr/rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wn6Hr/rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1D1C19424;
	Wed, 15 Apr 2026 06:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776235687;
	bh=uO1fFgRaYkEaX03uIGSllbIp0KmN4e8uhrxbiL7j6JA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Wn6Hr/rv7RQ0mjmBpBGnHzSLGoawtRWrJKf8Yulby+TTpp7z1W2m+/e3q+cBeZYn8
	 9EULstKmB1P1aIGBA/hM7NfdL90zPADnWSMrSZUOJgfBI2Y0gYKo15ZH/8SN+3BCpi
	 LFdpD3kIOkfmc5kLWHOPn/7qJv2G9rdoWFZcqmWwEJGa7DK0r7DBeorJlYNCKX5hcM
	 Q22Qw/tg/rR1esDPVyaYxqkxnFQnTVF5/bVWUROMriQiIMAWyo9xVZRAIqfM9NCvMV
	 JvPvhMbjPkTiWVz5ZUzK2DMWWd8bbim3aFcilo4uxvNCEcTYhNnaiu0tF2t4jRv/Q5
	 DezCa9n7clYBA==
Message-ID: <9c33afea-7a64-456e-aa2f-bdcf7459b567@kernel.org>
Date: Wed, 15 Apr 2026 08:47:55 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 33/38] powerpc: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>,
 Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org,
 Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
 linux-openrisc@vger.kernel.org, Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org
References: <20260410120044.031381086@kernel.org>
 <20260410120319.789114053@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260410120319.789114053@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 10/04/2026 à 14:21, Thomas Gleixner a écrit :
> The only remaining usage of get_cycles() is to provide random_get_entropy().
> 
> Switch powerpc over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
> and providing random_get_entropy() in asm/random.h.
> 
> Remove asm/timex.h as it has no functionality anymore.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/Kconfig              |    1 +
>   arch/powerpc/include/asm/random.h |   13 +++++++++++++
>   arch/powerpc/include/asm/timex.h  |   21 ---------------------
>   3 files changed, 14 insertions(+), 21 deletions(-)
> 
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -150,6 +150,7 @@ config PPC
>   	select ARCH_HAS_PREEMPT_LAZY
>   	select ARCH_HAS_PTDUMP
>   	select ARCH_HAS_PTE_SPECIAL
> +	select ARCH_HAS_RANDOM_ENTROPY
>   	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
>   	select ARCH_HAS_SET_MEMORY
>   	select ARCH_HAS_STRICT_KERNEL_RWX	if (PPC_BOOK3S || PPC_8xx) && !HIBERNATION
> --- /dev/null
> +++ b/arch/powerpc/include/asm/random.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_RANDOM_H
> +#define _ASM_POWERPC_RANDOM_H
> +
> +#include <asm/cputable.h>
> +#include <asm/vdso/timebase.h>
> +
> +static inline unsigned long random_get_entropy(void)
> +{
> +	return mftb();
> +}
> +
> +#endif	/* _ASM_POWERPC_RANDOM_H */
> --- a/arch/powerpc/include/asm/timex.h
> +++ b/arch/powerpc/include/asm/timex.h
> @@ -1,21 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef _ASM_POWERPC_TIMEX_H
> -#define _ASM_POWERPC_TIMEX_H
> -
> -#ifdef __KERNEL__
> -
> -/*
> - * PowerPC architecture timex specifications
> - */
> -
> -#include <asm/cputable.h>
> -#include <asm/vdso/timebase.h>
> -
> -ostatic inline cycles_t get_cycles(void)
> -{
> -	return mftb();
> -}
> -#define get_cycles get_cycles
> -
> -#endif	/* __KERNEL__ */
> -#endif	/* _ASM_POWERPC_TIMEX_H */
> 
> 

