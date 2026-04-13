Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC6C3AB29F;
	Mon, 13 Apr 2026 09:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776070869; cv=none; b=sz8or/idaWNXS0ZdAI5vWWdJvimix8yif1vkPpD7F4ERQkjLY70T7L7FNW2KsTYCQIRJ7W0DrWqK1caziNzZvnfU3ZFU3XK0I1tkcXed+E076WiOp8fHPFGYOSdtPXrANXRSucDHV1fntpNaZ6t2yAYJxQYjCTupPDZLv5bZT2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776070869; c=relaxed/simple;
	bh=NmWTXdFZa2PXaXxihxiBwP6/fcqhMPMR8Odd5UUj3qI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pogm6Dfb4hUByDnqPXpZyHDFnFKFNSi6VrhjpQH4WlgmrMIYXn5GzHNty6rZNKOHDT8LBJgXxDBoz9+wMojxmdok9I81MwuPv2nz5QmkBVJtmrU0/8QcC2MEITRQaqBA2LjfdECNZjtleXn2UiDBu9yegOwk/YnV+/KkNFvalUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfyW73rE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfyW73rE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57513C116C6;
	Mon, 13 Apr 2026 09:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776070868;
	bh=NmWTXdFZa2PXaXxihxiBwP6/fcqhMPMR8Odd5UUj3qI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bfyW73rEx6WunGZVvr1kdbuQhIZW0auQdr185ZFOdqezYfVI8EqIl4RV+jZMHErnf
	 HHqywW91vp7CVLzZ8tl9LuEsJL2nKmijW0OQ98WRnNBsFsW1LYo4ZFpZLLA1RAeRqi
	 fLF9xsDW37jcs+y2EAiBEgZnfjWYwDz/hvRsB2Ow2oVioAmoaeXLVkxbmWKx3ILDyy
	 OFKArZB3La00uc7rhVgunFkOn3bZFgPE1fuUov3rdMuNp+wqIMsO2YWxMIl1vusQFL
	 bBAU79v+8ddAl2Ytb2JX6K5ckn/0H32ur+wYUjKyGCCdFu1O+cEC54vJcUyB4ZJ+rF
	 y0fFboG7dTA8g==
Message-ID: <67c579d4-4e7e-4b3a-a2b9-7ba669664bdf@kernel.org>
Date: Mon, 13 Apr 2026 11:00:57 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 14/38] slub: Use prandom instead of get_cycles()
Content-Language: en-US
To: Thomas Gleixner <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
 Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
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
 linux-parisc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>,
 linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 sparclinux@vger.kernel.org, "Harry Yoo (Oracle)" <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.525653921@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260410120318.525653921@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/10/26 14:19, Thomas Gleixner wrote:
> The decision whether to scan remote nodes is based on a 'random' number
> retrieved via get_cycles(). get_cycles() is about to be removed.
> 
> There is already prandom state in the code, so use that instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: linux-mm@kvack.org

LGTM.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

