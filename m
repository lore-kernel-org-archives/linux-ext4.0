Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59043DA7E4
	for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 15:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775835133; cv=pass; b=BRAtL2YvK04RMzcRHrf87+xnCMA0/feTq6wu/MDZDoiuEwWEeSaYThuJzxzg3Dc00raLY81wKZeQzVroNQcwScw9sI0czw7QJXsrIQXf13nmnO4Ea4pNjk5kh99dUBeMWf51B/do11RikIYXawGlTKU9jueE/mrtXKMd7QEWK6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775835133; c=relaxed/simple;
	bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mQEcVluRzq/5194PqeO3Fq4KS1hdM8QQklAzH6EXvmELEJOkk/1IUrKU/qYvXcFoet0d7se4RccrkB3GE7w5l5NDLSDXahzDWE1z8wKbl6vuv4Rsp5wqhp1cDf/GG8hjmUgB7vhWZJOYcUSC97IsNhhQLdRZektrrlB+M938yqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com; spf=pass smtp.mailfrom=0x0f.com; dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b=cs+zJ0r8; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0x0f.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b="cs+zJ0r8"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1271257ae53so9590761c88.1
        for <linux-ext4@vger.kernel.org>; Fri, 10 Apr 2026 08:32:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775835131; cv=none;
        d=google.com; s=arc-20240605;
        b=fR7IBFx6PFGw93QzSGTcFsqHEMUKobtjCLcL+c4zsalESRXW5SOcq8PrOJkO1sSOQp
         IVIiilq34TJI6kuiYAl3PzuXqoVyO9v/AQ2GZBEcU2i35n8MixsV8yOdK5pneuVTbR92
         z0f5FMcR4hJwD7+f3j8IhGINZWsVni848yu79rk5lINquXiuRlNbUhARDQXFgXjsnUA9
         EMIAcDdKV4VghWkkeZ/8V5EPLCwZm2wx6JQklnxmug8EjqwSwngaqDpdvnzzdwFKWILg
         3jNiGLb62xjr+dNyE0tnH+rwrCcB0Xl0iRo+81/zj8k+sFmCfa+rQwz4JsYTf302ppNL
         8yGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
        fh=r837CK6k+G2t0Brh1EzbtupXqLBIxjCbReTlQOdhSHM=;
        b=fF/avPVmdfM8Qm5yL8XjqHLjHORMH94N3oJujEWUlR4uDZ6ueXy1Xq1INwZYqeAAWA
         lJgMeTHLFz4LwxIF0IKxk/bvA/DCOUTC1VE0dtKyB3tvDiMQSUekpvsiMK3mu69U5KZf
         XBBK/JdGu0XXZvMPUy1ZWarQBo66B6y/0NT9XJB9nsY2zc11Z3J1pNNy8hDuCtG2KGXu
         3RvYpRWFjVEl8lGen6xbK2Rg1m2ZV4BgrOfY0fLkDIo38KVu3SqW6apKqCTYev1zhdQH
         V92QnEY7MjdkFKXo/Pj1ILlfX6DMZvlML6iYhT7XHjIWmpq8/QiMyrgitrz1pe8bvka8
         8ZZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1775835131; x=1776439931; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
        b=cs+zJ0r8E1VxbeERL/6orYDfRzBNN0xV+FBDuuOmam2/EuHZ7scxaUctzZ3REo2LBr
         KdQSu4tLtUeUQ/Am7PGmtjXBLQ/7knpdVClf5erC+tpkhYxe59BfVvuW88STHDIDr49T
         TpKPrBeobAalm+DfnxseCj+mCeyPg4AFXq4Ow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775835131; x=1776439931;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OBQJPBhzAm5teFuL1it4zrQEsej5woZw67yMwyO4d8U=;
        b=bqHvwB6dju3K6KprknlXjL2gCe5MsC7T5s2NficZvKY7tRAxg+Tib1gF6iy7ih8jDA
         xQeAQLPZ3m2/9Vmh1wtvaWdbkSjGQ3GUx6YphZBfwWRmFHhUuftQWb9mfBw+wG5t5hHZ
         Yi988q2apjR6xqU4XIfa93j69e9nGIKt7alWGAuwnsb8C0FbJtP+il6OejlZ+mEu8Goq
         RKuXKASQvTG5OjY3u2O8NpNMkX+OUP0MIFbEgKo1K0dGrx7Fj17L2aRqTJbygjqyShu5
         OyoONrcfXwAHDA622w6XMC1s/9ohAZ3tWlc4F5TUKNemxUt2HDriHmyJKNGLb7lDR5dK
         /6ag==
X-Forwarded-Encrypted: i=1; AJvYcCWXwOjnkWAspYwT29/R9MwcwN9sT3qSllNgvMmDus0v3SuwfzYIIZ58pYXbR7XFU6nWZLXPEDqtY/hB@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9LcSgU15sAGVBNYqrB3aLR79dNqewFl4SJmoZ9JyR+tYKFc0q
	zRiL/aoW5hwv0WhFKDBaPcYp1u1l5n/S2pQxvK1jf0Q/93jUQipUNWHpU7bTkvOf499NaYGNmYY
	1WvlMqDvwe/a3d6DS5ZDRRD26eIhR9oEPcBGQM1NJ1A==
X-Gm-Gg: AeBDietqedz6T4wmv+07HUosuo5bfUV6uVl/SiIC7A/iAWShc/RpAh5QbM4T6KFqk80
	n3JSriNvsE1BFnddRf6apcVpkvz9n3lFg4H8TeJTQd26yyImX6UerHIurG7Z10/HlZ5k7hjrHJy
	KwmNfRQNCVwQoqcr6P+izmHKchKvvk2DvwFG1OBuCbgmui13SAvPWXNH2yvrh8gHKS+Anu/I77v
	F8KElcg72vpzspJwOWZ5rby0BNzPRz49MoXAaIwDIE673/OVf5MB7lkw/TR7o/eoEc1D95/X1Ky
	nqCB
X-Received: by 2002:a05:7022:6097:b0:128:ccb7:7fa3 with SMTP id
 a92af1059eb24-12c34f069f8mr2159203c88.34.1775835130696; Fri, 10 Apr 2026
 08:32:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120319.397219631@kernel.org>
In-Reply-To: <20260410120319.397219631@kernel.org>
From: Daniel Palmer <daniel@0x0f.com>
Date: Sat, 11 Apr 2026 00:31:59 +0900
X-Gm-Features: AQROBzAnX-XEClLFV-qWYFUzCuq4P43sNZviESiWFI1yCPXm2VtVZ2QkaUGJoPY
Message-ID: <CAFr9PXk7qK8-2JWrrfgXHoS9JWTRL+WobLjmAesyCE9VLL8ZyQ@mail.gmail.com>
Subject: Re: [patch 27/38] m68k: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-m68k@lists.linux-m68k.org, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi

On Fri, 10 Apr 2026 at 21:39, Thomas Gleixner <tglx@kernel.org> wrote:
>
> The only remaining usage of get_cycles() is to provide
> random_get_entropy().
>
> Switch m68k over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
> providing random_get_entropy() in asm/random.h.

I have built and booted this on my Amiga 4000 and it apparently still
works so FWIW:

Tested-by: Daniel Palmer <daniel@thingy.jp>
