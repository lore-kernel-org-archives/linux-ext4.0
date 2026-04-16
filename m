Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598E13815F5;
	Thu, 16 Apr 2026 19:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776367969; cv=none; b=mJgvB5HoJocH0W6lg7G0i6CoMNqKQ58k+mqwgI9Y2ptNK8IYowac/UY5rF9KYybph0clkQgGW2k5LU+Gfvt+UQioUnBxVvu5lIdj36LSWEMfVXdpHTUgzujv1YimMqq2zF4x3CrhscbIuUUEdeyLko+6nK8H42sVUb7Uzitnrv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776367969; c=relaxed/simple;
	bh=92ERkl7IqZ3D3ZBskV2Dg9cLo0xCsyjyPbt0J7jJ1bo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Scxh1NkGaNsvnzbXZfibAYa+946n0CpefIf5Mgu+BOTisye8zhAzeCYGYYEL4DGIfd+Rpn8MaAuu0f9hnQrF0yvb2EJxnZnDdkH1PsESrffjsIwKWgqDiUvrNejj+dAn9N5JuKRIeBnRtrWzT17kYU6QBi2SDM3STPHXpLMXQQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rw1vIfWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rw1vIfWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E8AC2BCB0;
	Thu, 16 Apr 2026 19:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776367969;
	bh=92ERkl7IqZ3D3ZBskV2Dg9cLo0xCsyjyPbt0J7jJ1bo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Rw1vIfWy5g39RTrQBVfk7P8+0yZErGWNG5UA9/vEtpQjlFkvwDTSfy9DcHen7/CI1
	 yvB26rPsstyEixHeRP2kRFTYsbED9hoqdAx8pp9JCjVGtqsECj0BmLbEADz/j0Ea1z
	 cuKaCVwjWLvXDg/CryubhnWhKyfuiuUjmH8fhvqeL/w/0cvoWWHyuhgdCpeuqDPtkC
	 KhOKnJGX3lMBUei6zDvHwn/e429dg5HpUaKZZFagDf5a9Cwpgy1mEmtIvUBtm2UV8a
	 d3rsfZkg4WL5nt8ssrtLumcRxpUUuH7CR13mk1NCsH3yKQQbT7v7wh+ISgR1TJLd7z
	 vH5LnF1y8pygA==
From: Thomas Gleixner <tglx@kernel.org>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, LKML
 <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu
 <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, Michael Grzeschik
 <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
 linux-mm@kvack.org, David Woodhouse <dwmw2@infradead.org>, Bernie Thompson
 <bernie@plugable.com>, linux-fbdev@vger.kernel.org, Theodore Tso
 <tytso@mit.edu>, linux-ext4@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Marco
 Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev@googlegroups.com, Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Richard Henderson
 <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, Russell King
 <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, Catalin
 Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, Jonas
 Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, Helge Deller
 <deller@gmx.de>, linux-parisc@vger.kernel.org, Michael Ellerman
 <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, Paul Walmsley
 <pjw@kernel.org>, linux-riscv@lists.infradead.org, Heiko Carstens
 <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "David S. Miller"
 <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [patch 07/38] treewide: Consolidate cycles_t
In-Reply-To: <0758843e-8f75-4c82-b9c0-25fab502e62f@kernel.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.045532623@kernel.org>
 <0758843e-8f75-4c82-b9c0-25fab502e62f@kernel.org>
Date: Thu, 16 Apr 2026 21:32:45 +0200
Message-ID: <87v7dqem5e.ffs@tglx>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Apr 15 2026 at 08:43, Christophe Leroy wrote:
>> -typedef unsigned long cycles_t;
>> -
>> -static inline cycles_t get_cycles(void)
>> +ostatic inline cycles_t get_cycles(void)
>
> What is 'ostatic' ?

That's a really good question :)
