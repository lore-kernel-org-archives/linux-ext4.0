Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FCF2DC792
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 10:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776335451; cv=none; b=ALDUdKU1V6EiYpeSxyMKVd3jJTVJbIxe/9P0L9S0EpfX25jMUcUD9o8NAAXAwGrzuhtywP0a0EEAREJzfmXK7jJ68yQ2q9gF2gEa3cun7sqXIjA6OYGXgl2zb/6qI213Lqsf2D5ocw+OuRMcrPZWa2UmGWThzCqKwFhKaN7Fv+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776335451; c=relaxed/simple;
	bh=Il5EilNKbQmVM1qv4XgxLAe02Z9+zxydkwUqJc2BPRU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kEYoXPIWe+o6lKg8hWQj2LDbNRaVcZ0hC9PsRAA6XG1M2sM2XeO5Pvl0B/BWeWwXTIp/MlbRFGig1a+ZYa+R9NeUQcZ2wbTc1libTLLc7kP4Wg2uWuUHo6TiolN83A/0bs6A2FEm+3y//sGrUlEKShqO04+vzD9lR2aLbCkepGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7dbdcb85067so6554361a34.1
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 03:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335449; x=1776940249;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z9HEDsaws+1AaPEcUyrGjtCss1Kv3jZQFAB8Oib7mmY=;
        b=Sg4ATQHxlDMJHahwf0LbmUBwi2FkCxN1dGBEWGTCDJn8AdA7V36D3fodcnMye5jua3
         4DcwJPBB5w38d+PyJ+dSLwJEYdieGy9M0fDEnPTKoZtGMW7YD/JWYPsLn1bSBtGgohLF
         2fNtlTF1rbvYk9Gfui2aWbgeIAWHqy3NSHvcftV+BSuNhYJ3h8iydGhL5tV+XTI+qA8T
         bU0KVK/BmYe4XuY90cxcIPbQePT8OyhrjbjKumapnRSqOnyG64D1cZw4i4u3zkz2YmeQ
         Lk/kDzuA2F+zrsFCDOouWgxiQsFY0CNYE71zsEQgoD1yZX2XkDB5wFsped2tb9XssIwN
         +fOg==
X-Forwarded-Encrypted: i=1; AFNElJ+2bgg4QnntY01JODv/YQpZmJOFeZb4eaotFiTv4KYPpv9qlo2BO2quXWTR7ikaStgAnZVMbnOjBn6m@vger.kernel.org
X-Gm-Message-State: AOJu0YyrE3Rwdzlodw/aCf7+bG9Heo5lxGo5ho/mY3PTNhAny/fBeWK4
	ttuUUx7ZCpGrCBPWMx9PLmKlVVkUzavhEl9+f3EhvHTLO5t5TmbIHH2abLQp/2o9
X-Gm-Gg: AeBDiet2WY3jXkhKz1YmXRNEFT2TsgqlfC+VTMXad27fcGGXhpGFqUGWoVpIQJ6NTZa
	1EI+h7baEyDrHeKfzhgbUZWq0JJh11LfEzSpV8pXb8QWtPHA4Nk3Ki85TZN64pGNhNED2hk0xSA
	t8TX7v6a8EY6MXZxVn7srMrDGUyatzuMYN5NFv1R6GyBF8z5gRqT3nPtWa4jjMuMRr59Nadimz0
	TYk3JOJtJstFfPnKQ1h0QZT6i5R9n8+BAbF9I+ht+2ZV8D2QYRWb6ad+lUklTV88cKdyf4SAdTQ
	N+O7ezbRCCfipM9TkDeQJor26QP+WmfQk21v38mP9jJYQ84FhlDZ5WHnhOU/GSyC6VIq3OiU3N/
	akKIE+f/SdGj7eoka42tsm0BVqQRqez04u0IIz7V5FJZ0mRkDYk0RSWij5EM8DV+kRrlEXBDRw2
	t3v+A8RneecOM/iz8iHUzOyoWMaIQJiXtpdnQ6kT4ETKU1o7Bapuw+2+mC65S1dvjNGttLSA4=
X-Received: by 2002:a05:6820:4c14:b0:67e:1e52:6e05 with SMTP id 006d021491bc7-68be86e246fmr13816312eaf.48.1776335449174;
        Thu, 16 Apr 2026 03:30:49 -0700 (PDT)
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com. [209.85.160.52])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6932ac8b833sm2343994eaf.3.2026.04.16.03.30.48
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 03:30:49 -0700 (PDT)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-40efc77933fso5167493fac.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 03:30:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8yVe5LO3IachWPJIHiLGK3Db3Ls2MGFGgmPUU4mEdJl88SfgdPXO1UmP89sxgJVtFsHtL3kkODimzt@vger.kernel.org
X-Received: by 2002:a05:6102:c48:b0:608:cd24:354c with SMTP id
 ada2fe7eead31-609fe9b0d22mr11966750137.3.1776335071251; Thu, 16 Apr 2026
 03:24:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120318.794680738@kernel.org>
In-Reply-To: <20260410120318.794680738@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 12:24:18 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVerN6Pz07CQH+hcvT=-ZD-r9VNrSrGzTQZBEsuecK_ig@mail.gmail.com>
X-Gm-Features: AQROBzDRGGELVSySTko37h6zEj8YoV3p6pwZDCVQUlUW6sZbw_W5mbJzFIh35nQ
Message-ID: <CAMuHMdVerN6Pz07CQH+hcvT=-ZD-r9VNrSrGzTQZBEsuecK_ig@mail.gmail.com>
Subject: Re: [patch 18/38] lib/tests: Replace get_cycles() with ktime_get()
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
	Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev, 
	Michael Grzeschik <m.grzeschik@pengutronix.de>, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-crypto@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org, 
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Thomas Sailer <t.sailer@alumni.ethz.ch>, 
	linux-hams@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Richard Henderson <richard.henderson@linaro.org>, linux-alpha@vger.kernel.org, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Thomas,

On Fri, 10 Apr 2026 at 14:20, Thomas Gleixner <tglx@kernel.org> wrote:
> get_cycles() is the historical access to a fine grained time source, but it
> is a suboptimal choice for two reasons:
>
>    - get_cycles() is not guaranteed to be supported and functional on all
>      systems/platforms. If not supported or not functional it returns 0,
>      which makes benchmarking moot.
>
>    - get_cycles() returns the raw counter value of whatever the
>      architecture platform provides. The original x86 Time Stamp Counter
>      (TSC) was despite its name tied to the actual CPU core frequency.
>      That's not longer the case. So the counter value is only meaningful
>      when the CPU operates at the same frequency as the TSC or the value is
>      adjusted to the actual CPU frequency. Other architectures and
>      platforms provide similar disjunct counters via get_cycles(), so the
>      result is operations per BOGO-cycles, which is not really meaningful.
>
> Use ktime_get() instead which provides nanosecond timestamps with the
> granularity of the underlying hardware counter, which is not different to
> the variety of get_cycles() implementations.
>
> This provides at least understandable metrics, i.e. operations/nanoseconds,
> and is available on all platforms. As with get_cycles() the result might
> have to be put into relation with the CPU operating frequency, but that's
> not any different.
>
> This is part of a larger effort to remove get_cycles() usage from
> non-architecture code.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Thanks for your patch!

> --- a/lib/interval_tree_test.c
> +++ b/lib/interval_tree_test.c
> @@ -65,13 +65,13 @@ static void init(void)
>  static int basic_check(void)
>  {
>         int i, j;
> -       cycles_t time1, time2, time;
> +       ktime_t time1, time2, time;
>
>         printk(KERN_ALERT "interval tree insert/remove");
>
>         init();
>
> -       time1 = get_cycles();
> +       time1 = ktime_get();
>
>         for (i = 0; i < perf_loops; i++) {
>                 for (j = 0; j < nnodes; j++)
> @@ -80,11 +80,11 @@ static int basic_check(void)
>                         interval_tree_remove(nodes + j, &root);
>         }
>
> -       time2 = get_cycles();
> +       time2 = ktime_get();
>         time = time2 - time1;
>
>         time = div_u64(time, perf_loops);
> -       printk(" -> %llu cycles\n", (unsigned long long)time);
> +       printk(" -> %llu nsecs\n", (unsigned long long)time);

While cycles_t was unsigned long or long long, ktime_t is always s64,
so "%lld", and the cast can be dropped (everywhere).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
