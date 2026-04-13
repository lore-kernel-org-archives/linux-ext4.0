Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1615332AAA7;
	Mon, 13 Apr 2026 13:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776087972; cv=none; b=Ne0lbnZgcjB69/j9mqnPGjdeU9F50Eoq4D856MJ2Cw6c8H1YTRIwTg1+eA5jlbG+HuxwF10eZMJ/AVVN7RC5teqXskbOeoPVucDyvOp5ga59vpyEGDFRHpFHwEexkwoS6I6Ksz+inkfYw+5scaDtUnaBqmudRAqdFIMVmqlxBTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776087972; c=relaxed/simple;
	bh=oJltz7AJrAszH5NkylMptNLavhPpBeWeTGj56+4UuNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y1Pl8/DYl5swgABM+VcA815jM6zMn457GWRVYROyqKo2CdnpiPDrhPIkaXzfNWrAizTc+J49TjueXSUW8MlusjvNWKOvezGAllWyCo33gn326i1OzG2x7gSDSPM/C7lT6HlgYdnRLMJzhmbQoDk4xE1pFqFNRmUHQxt8Tr+iBh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W1c4yYbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W1c4yYbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1BFC2BCAF;
	Mon, 13 Apr 2026 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776087971;
	bh=oJltz7AJrAszH5NkylMptNLavhPpBeWeTGj56+4UuNQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W1c4yYbXInfelp0eUQAv9gO8+XT0Sbrv81Gm0Adb5EvlP79aa60vW1qyaRs6863hq
	 ywlFwnEXs2N+Csj1t8AT44QeeKBJG/F49Idi2q4rc2RmYot0SX7HMiTlvtWvn/yDH+
	 7trrgahjvxasFZ1G1mSZHuMwpN/FLXdUKO5A3DE4xduSAFmVqypbzmuyI1rt6S5Skg
	 mnVOocE28OqrI3sV0A1xJA4AMsFJUmV+SiC9+WzESG+evlqCHSH4Q/iOf94U+BkWPk
	 AcZh4PrKZrOg/knioNZ+bkeabHdk27YLf4Gl2MWAVIr2/8lUMYASANuBHtyTuYAsV9
	 CyYJUfeUbdazw==
Message-ID: <ed8cf7e9-4271-48ab-a410-d7c0e2832020@kernel.org>
Date: Mon, 13 Apr 2026 15:45:59 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 14/38] slub: Use prandom instead of get_cycles()
Content-Language: en-US
To: hu.shengming@zte.com.cn, harry@kernel.org
Cc: tglx@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 arnd@arndb.de, x86@kernel.org, baolu.lu@linux.intel.com,
 iommu@lists.linux.dev, m.grzeschik@pengutronix.de, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org, dwmw2@infradead.org, bernie@plugable.com,
 linux-fbdev@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, urezki@gmail.com, elver@google.com,
 dvyukov@google.com, kasan-dev@googlegroups.com, ryabinin.a.a@gmail.com,
 t.sailer@alumni.ethz.ch, linux-hams@vger.kernel.org, Jason@zx2c4.com,
 richard.henderson@linaro.org, linux-alpha@vger.kernel.org,
 linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, chenhuacai@kernel.org, loongarch@lists.linux.dev,
 geert@linux-m68k.org, linux-m68k@lists.linux-m68k.org, dinguyen@kernel.org,
 jonas@southpole.se, linux-openrisc@vger.kernel.org, deller@gmx.de,
 linux-parisc@vger.kernel.org, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, pjw@kernel.org,
 linux-riscv@lists.infradead.org, hca@linux.ibm.com,
 linux-s390@vger.kernel.org, davem@davemloft.net, sparclinux@vger.kernel.org,
 hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev
References: <20260413210252672ZfdcegJLJtyvlYdFAUBlr@zte.com.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260413210252672ZfdcegJLJtyvlYdFAUBlr@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/13/26 15:02, hu.shengming@zte.com.cn wrote:
> Harry wrote:
>> [Resending after fixing broken email headers]
>> 
>> On Fri, Apr 10, 2026 at 02:19:37PM +0200, Thomas Gleixner wrote:
>> > The decision whether to scan remote nodes is based on a 'random' number
>> > retrieved via get_cycles(). get_cycles() is about to be removed.
>> > 
>> > There is already prandom state in the code, so use that instead.
>> > 
>> > Signed-off-by: Thomas Gleixner <tglx@kernel.org>
>> > Cc: Vlastimil Babka <vbabka@kernel.org>
>> > Cc: linux-mm@kvack.org
>> > ---
>> 
>> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>> 
>> Is this for this merge window?

I'd say it's not intended for 7.1 as it's not in -next and v1 was posted
just before the merge window.

>> This may conflict with upcoming changes on freelist shuffling [1]
>> (not queued for slab/for-next yet though), but it should be easy to
>> resolve.

Indeed, it's a simple conflict.

> 
> Hi Harry,
> 
> Would you like me to wait for this patch to land linux-next and then
> rebase and send v6 on top?

Just send it now based same as previously so we can finish the reviews, and
we'll deal with it after rc1.

