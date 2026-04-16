Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF9D3A6403
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 11:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776338926; cv=none; b=QdEHwrc+iBFTQHmQQq0mABQJpubql69eVzPa9IyUyFxUug6XAEONkxvNsGp2u586t1BEHBr5L+/pHbySsMDa7LhAz8QNiHoBYb7X1UV/838G28A1DxxN9akoqQ/4VbwQWF7bsZybVZSJOBPT0TuSqEYgFdOs+i5vXsvxiV43ads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776338926; c=relaxed/simple;
	bh=onL90hyVAUlPY0ASaWQwK2lX8QEYr5m106IAfPoIE0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ruQe/4q2UrvMqGFT/788l3LxHKHnDdCnT31KKn+ZuFTYZ4j6FQuf7iD7ebDboY7BwcnxDq7pnp5TSwpPWdIRhMbaCtcdBOGXu8bxjHYmmg498m2KIuQKdJ7gQRBkgdPpLIA+kIOkSXIteblZsMTPZVJm3j8JeYpjUo6SSpLFZI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50da9a7928cso64475531cf.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 04:28:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776338923; x=1776943723;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0N28AiHhMQm9a3ncbvMl4jwXcNZbOrN6OiiJm2DjJOE=;
        b=ZeqXK5qqVRNwughD2wqti866g07cVw0IpDEwD9UI3RSecti28HC7AuIO8ZXU3eaW65
         YABXCoeR3hx0EvI5mP4wraBjGkDNehF4SjIlBrR7hbqDMQW/Ggs5/gWMhmNyHx4T+grw
         8Yc8IboUXhtPTn/lU4QYvApnb2L90/RMrNwmg+4cs7xucliZtzHAqZ85UpYyWamjgW02
         POJT4V2Pq3NySxwWzyqN3VOTfpE8rQZJzRDmIQDujM6XCvQsXyPUDX/RrXy3X5OMdbdA
         xo+Lpd/hiFSZFXXITFJWi4+Mtudf/9oVoFJSZHzNSs0RQEzjiV/93TtAT0pq+3gW8rmt
         XRrw==
X-Forwarded-Encrypted: i=1; AFNElJ8JBgUbP7Soe+Z+VPW8sLeQABwQsgi9cQsMO+yDZ0oXIZ28rEG30b+NF6fIH93SjfPq6Rn96CQGsIK7@vger.kernel.org
X-Gm-Message-State: AOJu0YwRo+abHnh5kVQ12pEYZQgtvVb8UHugFzlw7ZtHeCxiRTEeuLqn
	cO1ySzbMDv+Itbp/Eq8R8Kw9aOLjQ7//RkKHwEieGAVHJWN1yubseZaYv5lniKSR
X-Gm-Gg: AeBDieuDJh43FmoQ7CYy5nBi8OCuV1SQ6XpJdpg79csJNhjuoSlN3NWw7tkkYT0k4jc
	MWhftFcTcm9HrJMm7aTvpD/hRidBLLGbak3HzSpfU1JvOVUckquQleBY7OVmWRq917IVpUseykH
	qzNd6cC5iwcNcqv7ZSjQm3LdWBCSdlc7vBqhe6aLqoSnS0SkyM0ooj9O4klSRPKmWEcGBRcPbAz
	kazDbms9BrZNSB9UQs1KrEuvV+c0YEGSb9oegnPNAnuYjDihU4lTXSLcGqPrxeNuV35F0+TDQfu
	JU7z5sJO5I8929yNZgGG4K1b4nvbu60tN+lSbhKBvD/I383tP4DXR85OcU2YXa83vQYuz/5lkfu
	7xDThe6WdrzJnQWvbmm6vAWba90vbJ3ag44/fhxns+DFHAyqRTdxPiFuTRUJpLifGfHkdlIt2JZ
	yrlFGZ/LzKE4bUeG+B5fOkQJwpsYB4vQcfLsfB0C2A42AbeOBmaUvhVQpatPzb52uHCyYqljtLq
	4U=
X-Received: by 2002:a05:622a:1c1a:b0:50d:8172:714d with SMTP id d75a77b69052e-50dd5aab407mr382625901cf.13.1776338922828;
        Thu, 16 Apr 2026 04:28:42 -0700 (PDT)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com. [209.85.160.180])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e1afbcdd5sm45316961cf.20.2026.04.16.04.28.42
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:28:42 -0700 (PDT)
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50da9a7928cso64475431cf.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 04:28:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/eBFBdKeR07+3UCGPTBlovZUgpp78AbGHv58cEtOQPd04rtNQSB01Xo+2yhX/p+id1PSu0m2Rn8iI7@vger.kernel.org
X-Received: by 2002:a05:6102:3fa2:b0:608:1b6e:f4dc with SMTP id
 ada2fe7eead31-609ff0c50e9mr11028119137.11.1776338540828; Thu, 16 Apr 2026
 04:22:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120318.045532623@kernel.org>
In-Reply-To: <20260410120318.045532623@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 13:22:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXtR7T62Wf+yDM=J0+96C64qRws=ffX_xXbfzfbS0Xz8g@mail.gmail.com>
X-Gm-Features: AQROBzCyA8BqoTVnHFn7fWQMKVWyMF2wrQlYn44P8f0X0RsdCOwGnnxui8decDA
Message-ID: <CAMuHMdXtR7T62Wf+yDM=J0+96C64qRws=ffX_xXbfzfbS0Xz8g@mail.gmail.com>
Subject: Re: [patch 07/38] treewide: Consolidate cycles_t
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, x86@kernel.org, 
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

On Fri, 10 Apr 2026 at 14:19, Thomas Gleixner <tglx@kernel.org> wrote:
> Most architectures define cycles_t as unsigned long execpt:
>
>  - x86 requires it to be 64-bit independent of the 32-bit/64-bit build.
>
>  - parisc and mips define it as unsigned int
>
>    parisc has no real reason to do so as there are only a few usage sites
>    which either expand it to a 64-bit value or utilize only the lower
>    32bits.
>
>    mips has no real requirement either.
>
> Move the typedef to types.h and provide a config switch to enforce the
> 64-bit type for x86.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

>  arch/m68k/include/asm/timex.h      |    2 --

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
