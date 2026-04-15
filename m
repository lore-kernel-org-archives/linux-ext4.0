Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7048637E2ED;
	Wed, 15 Apr 2026 06:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776235117; cv=none; b=AgFZeuskP2O4SM3devXZMXFwhIOaBacACY0XUqQf1Qp/OogjqXqVctLR2T6ghOFFBjZ7sp3frQfVVRIcXE8nMWzqt23g+cglVzPYdA+4HUDTEhSwYroagHu7eNOVThvpIq9/Ux2SbJzImJkBWcKg2+Ok2GHnTE+nauN859mt3os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776235117; c=relaxed/simple;
	bh=oJA3I+zKvq9KD+ojZoVICzDS05lI3MCnC5Rlh6cn04Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jXjA0y5dHh8PQl81mmJoFRpXX7f1Fb3QKw1gPRR6LwyQEumT7Vng6SaFRUko6bOsur0xqrQuc2ybgALkH7j8SCToK8v++V1FvEViXVoYdQF1l3RqbyOYUfoFWEVaUJy3xVLGI9+XvHf5+P58E9+8xUG0WcWc8sLImnXC3M4k/Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CW1zPJNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CW1zPJNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4603C19424;
	Wed, 15 Apr 2026 06:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776235117;
	bh=oJA3I+zKvq9KD+ojZoVICzDS05lI3MCnC5Rlh6cn04Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CW1zPJNSJCGtniBmy6uyWDY71JAL0i4dK/N5qkFlNYs3kz0wXN03HHuHTh1S4hKQi
	 e2yWcwq5RclCcCVX6A0Lopstyv1iJwvVwNRsKmdSs6NBxbKPvhq3apDF5Mh9EQ73Js
	 q6/zItY3OOkWbN+i3+Ng0jCLJkMAwhrFhYQnM+LI0mETHNwewJwuPg1EQX95XcPKNN
	 j2R4mf89jj4nr2TUgQRoKIUpiIuUlriELzBuol0ebMztd/ZZRtnQ1qtW+tQ2/QgIAp
	 oYZF1auoZqP0e9mHU9TqSeeI5ff2Bxo+lnB6gCW6VWEs5KrEifF6NFFvP+OSWCop4o
	 Cz3scEaJinP/g==
Message-ID: <f6e6f630-07f1-46b4-888d-324a62a41070@kernel.org>
Date: Wed, 15 Apr 2026 08:38:24 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 32/38] powerpc/spufs: Use mftb() directly
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
 <20260410120319.723429844@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260410120319.723429844@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 10/04/2026 à 14:21, Thomas Gleixner a écrit :
> There is no reason to indirect via get_cycles(), which is about to be
> removed.
> 
> Use mftb() directly.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/platforms/cell/spufs/switch.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/arch/powerpc/platforms/cell/spufs/switch.c
> +++ b/arch/powerpc/platforms/cell/spufs/switch.c
> @@ -34,6 +34,7 @@
>   #include <asm/spu_priv1.h>
>   #include <asm/spu_csa.h>
>   #include <asm/mmu_context.h>
> +#include <asm/time.h>
>   
>   #include "spufs.h"
>   
> @@ -279,7 +280,7 @@ static inline void save_timebase(struct
>   	 *    Read PPE Timebase High and Timebase low registers
>   	 *    and save in CSA.  TBD.
>   	 */
> -	csa->suspend_time = get_cycles();
> +	csa->suspend_time = mftb();
>   }
>   
>   static inline void remove_other_spu_access(struct spu_state *csa,
> @@ -1261,7 +1262,7 @@ static inline void setup_decr(struct spu
>   	 *     in LSCSA.
>   	 */
>   	if (csa->priv2.mfc_control_RW & MFC_CNTL_DECREMENTER_RUNNING) {
> -		cycles_t resume_time = get_cycles();
> +		cycles_t resume_time = mftb();
>   		cycles_t delta_time = resume_time - csa->suspend_time;
>   
>   		csa->lscsa->decr_status.slot[0] = SPU_DECR_STATUS_RUNNING;
> 
> 

