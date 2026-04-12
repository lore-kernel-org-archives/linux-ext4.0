Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DED737C913
	for <linux-ext4@vger.kernel.org>; Sun, 12 Apr 2026 13:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776000186; cv=pass; b=p/1PHYFojbuus4T6ht+X3/0kDnhiBe/3GpxjzXBuRRJjCREbww3AirSfW4Q22zii19QfatR4wfQOY7mvOkEfeEjoWuw95rUMXRmasHZrN0nwkfBc5g3kRo9RQesJM9pknoRNqBU6yVS4okzXy3LKKj1RO7J5qCPOGdW0eTIByWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776000186; c=relaxed/simple;
	bh=1p6x7PvyQL+5PGqdAnx23TY8v0cVXdqCOnUZdmPD2Po=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lSPq1Z8/fHxarQ8dip4s6M3AIHb3v5FPCwpjj7UPOA9tk+zMAlfQuYxN1fU3GXqGOPflLR6paLHXdB4R11veCwXlE5wHkjpjvCDV2N/pgjy9cLqAJKjOUdislADP465nJLbfUyDHo0HtHTX5P4m0swRi3tCxMb5cK8oF2HkM4zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dccArJm9; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dccArJm9"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9c1da7ac63so541556866b.0
        for <linux-ext4@vger.kernel.org>; Sun, 12 Apr 2026 06:23:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776000183; cv=none;
        d=google.com; s=arc-20240605;
        b=h/M37WpTvlTYFDFaH24xEWMGPhpXOxpsFW9cXVwXONUC7jFVUOB9KvkVgjCVJxcCWT
         dp4sk6IlivE1tpteAD7x/l88iR/wxfHW1LOvMPmKbkfwbn8OwVclZnpKQgLuLTm5QcYA
         ZtuF/i8bypHrQNJ84Dc1gjVP1bAeJ7p6HBD453NW6jGBNDmXxn8atjffn8lFLp1r4yO3
         VMtPh4y0Z7cFM/vSPH94AZJ6vKU5DVpeu7TkR8VXgoPtfuHW7JxfaIAGaMO2/jkM1RKt
         EOPLM95esOZY0plt6H5Hhda5fy6o6f8VwWnFL+2N3cjTMDjy20Mta4BAKCeegIgHNVi4
         NRdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
        fh=L23EPR13QgZKU6HJVb+ZxihuSGezFYqhq5OTy4hcDHA=;
        b=YpgDW1XLgiuT+KyuhZ/cFdDZxRWoCRX2340NrB3EoRhhuIJ8mpH35egsTxQa+2x0v5
         UJHlGCVyBRwwCq52rvT6/o5Fljfl3qvobujiRJXgs+sBfvgRskxhU96/V2NiG8aJvWqp
         mbtCTi3Wshfm3talHi13WAAkWzfN04z8stk2tXgOi1jd+aomEkR2aMFO+koXRuna95tB
         zNQXydKzhfyMDHml4PbUot/FXamRrs/mvofVnRnLHIu6bVedQUS5oN2l23NVvLvwVlyp
         yv0/WyTj/CTUAZ4cFYRXzX587uIboxN60jXBc3R5HowGyvAh+RBbZRtRgGUbLXa4SyKH
         7SKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776000183; x=1776604983; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
        b=dccArJm9v6h9Fdk8lDGNWZnQG14AQ9ZokHDnv7DAL1GW0R6BDoMR0waR0wHnO++sNY
         YJPJSDf/Eo4Jqw4GQ8Gz/T/rsLkNap5uTZ+EpwANfeQ1dFGXyG88+fN/49+h4JvC9C7c
         2+asFn0yzVsL4n2hJqrH+GINWtCINsNrMCDz6yHqeLWKks0EsNy7ssNes4vhdFLCd+tg
         k2Ys2/EuxonOOeyCkSNs/L20e6zSdmHhXIY25hzHxXat+VjZowRiCo0VNk9bdjlPvxYt
         DV9owUMCQ8VWv/4Ldm8HtUCj9QQlhYJyZr8JnJBv87EbzYIfO7KpnQu2sRPezsHrfV9J
         1U2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776000183; x=1776604983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gDdA9vu4Fz00bgurrj0mXlyC2hJ8rRfiuCUxuR8xwe8=;
        b=hvE54026xCuuoai4f/hbFIJRePB6k50fe4CoL/aWTYza4QjwmWYndkQNJelDwzX/LQ
         dX6ecs0jyczjcm7KRAYxCOI3IwC7bOHVae3Fsc9fClZsfvPNalR+5mgYqxU/SXzN4nNo
         YolzOYp+W3cyj453JoBZ9iSRbH2BeRPPHp+voc37cSyVHUurF+Hx1OT5a9Dgb6tYJm2j
         lcXs13p2dcwC1GlZHzRmDgNFzYejMNvAgLEIkWTN7+WAFboPUFRp1vpyz/rO8SVAp04w
         1dxS923mwiOGXhuccYvAnprf1PHhsqLCpmkfeSorvJWAFNxXmGgXGBq20PcjMjWEmlPK
         avAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB2pPmmEP/u1DeZuc9Oz+Q9O0jI5ReMwf2Uwue7WiWp0Mzx+Utgsvon9YbptV81YW/vYqnsH2FlNBo@vger.kernel.org
X-Gm-Message-State: AOJu0YzTecTjMGP6xV5whB4Ke7pnGoy1VG0+CdYeqTxs28WNLs8LHJh4
	hnUBQ0EVyigU2rUKAI5Z+dSOPEGI1wqYopAKzdEd5ZtJFOIIsbl4Z0Uoa3w8JatYOu/67qiscKt
	kukj0HmR0cbB+lyZkP58745DIIJGkX74=
X-Gm-Gg: AeBDietJ4wB4WtX82PfBoebJ/M+WuAXyX1SvvKKrIphx7q/zp2Fxv0cI24SzkKSY4xN
	yJ8Pi2cmhNYh+N5J4Ivb41GZNMYLdaLLUfKnj3w1Ei6Xv3az0X+D2Bcbkc49e5pqkGXrLjbDTcl
	3urvHnkAc+tNdXFMlK16tvb1JnfCM7tygEv4habXC76BqRULHlwwZb76bbxJKZZ0gfdDCsuAYVV
	DbO/rE33EkQTE73VzlP85h9bMpUC7TUry0GNap1PRU8eOYz6tSIXJt+voXd+V3UcgbnZ5ha+xw/
	vZ2krcadzdKHpTiVXzEKhsxDUHkrjaLHL1VuKRmJ
X-Received: by 2002:a17:907:e113:b0:b9c:6ef1:ed18 with SMTP id
 a640c23a62f3a-b9d727aa4fdmr352963766b.25.1776000183133; Sun, 12 Apr 2026
 06:23:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120319.131582521@kernel.org>
In-Reply-To: <20260410120319.131582521@kernel.org>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Sun, 12 Apr 2026 15:22:51 +0200
X-Gm-Features: AQROBzAeMsaeSVePCJ__tEd4f2rWAY6MixXzp_fii2b8vyUpLt4xjSbtYzENFaw
Message-ID: <CA+=Fv5S68wZQapeaYTspOfsuGk=nBj60sx-ojHBSqrxV59Q+ZA@mail.gmail.com>
Subject: Re: [patch 23/38] alpha: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>, 
	iommu@lists.linux.dev, Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>, 
	Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2026 at 2:36=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:
>
> The only remaining usage of get_cycles() is to provide
> random_get_entropy().
>
> Switch alpha over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY
> and providing random_get_entropy() in asm/random.h.
>
> Remove asm/timex.h as it has no functionality anymore.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> Cc: Richard Henderson <richard.henderson@linaro.org>
> Cc: linux-alpha@vger.kernel.org
> ---
>  arch/alpha/Kconfig              |    1 +
>  arch/alpha/include/asm/random.h |   14 ++++++++++++++
>  arch/alpha/include/asm/timex.h  |   26 --------------------------
>  3 files changed, 15 insertions(+), 26 deletions(-)

Hi,

The Alpha side looks fine to me.

I've applied this patch on top of v7.0-rc7, built a kernel successfully,
boot-tested it on an Alpha UP2000+ (SMP) without issues.

Acked-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
