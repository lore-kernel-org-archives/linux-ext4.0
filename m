Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7222773E5;
	Mon, 13 Apr 2026 05:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776059269; cv=none; b=QeSSnTQ5WCx2Uj3fQdKD5vClqnMl+kAXwHmoQSJ7Xs9dksD57pMKsWjzf8ew395QnU6gG7A8xHfQ/5HRlSo+Ooelzk2PAceFZkBb0WVjZnWcwVm+2JFeL9NF5PCSnBjDXXtyzGERfi8IpNVFQRf0vUsE4RLqWnt795LtRmapbk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776059269; c=relaxed/simple;
	bh=YxepDZzylg7DLxJ1UuKV5wvO8y/p14MplYX7PzmcQ08=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MWbOo9tARfrBcn9eCmjchtLcu1r1J5lRuBc0zX4vTTkBRHjrM005QWIXYzagKgVmbOA1+vcY/1KRpr+8fALLgx5V8fd5yZ9xvRcO92MT2JFxDdxJKKXegRxQ3RbBl/dgtmtyV2UHqPH0cPMUsH8IqkMp1AyutpAbh+2ZqvUfQSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 2FA4892009C; Mon, 13 Apr 2026 07:47:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 283D292009B;
	Mon, 13 Apr 2026 06:47:45 +0100 (BST)
Date: Mon, 13 Apr 2026 06:47:45 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Thomas Gleixner <tglx@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
    x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
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
    linux-parisc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, 
    linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>, 
    linux-riscv@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, 
    linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
    sparclinux@vger.kernel.org
Subject: Re: [patch 28/38] mips: Select ARCH_HAS_RANDOM_ENTROPY
In-Reply-To: <20260410120319.462206386@kernel.org>
Message-ID: <alpine.DEB.2.21.2604130638270.29980@angie.orcam.me.uk>
References: <20260410120044.031381086@kernel.org> <20260410120319.462206386@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 10 Apr 2026, Thomas Gleixner wrote:

> The only solution for now is to uninline random_get_entropy().  Fix up all
> other dependencies on the content of asm/timex.h in those files which
> really depend on it.

 Oh dear!  I'd yet have to fully evaluate the consequences, but offhand 
this has clearly turned what compiles to a single CPU instruction on the 
vast majority of MIPS platforms into an expensive function call, possibly 
also changing the caller from a leaf to a nested function with all the 
associated execution penalty.  Is there no other way?

 Cf. commit 06947aaaf9bf ("MIPS: Implement random_get_entropy with CP0 
Random").

  Maciej
