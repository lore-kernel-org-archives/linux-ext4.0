Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8199C38C2D1
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 11:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776338891; cv=none; b=trU1ylh26XdrDYvjMIRbtEhwab4tzjWPS+45wgCa8FuOqrtVd1i+eNSmYfaO3AR8445hrHzMRvfN+1EFPYqHWFYKu6FkVLX32myc2SZmak7W5elKFOM4M3kjCKCLhpOxsZHQywRKR8jT43ImJzvp5n7vnZloLq5YNFkJOlvobmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776338891; c=relaxed/simple;
	bh=FSgVIzpnraycKQsxAztrNgNSM9On/XU1ftEj+pCL/gg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NOUJ896kgMU9ZhX/T0MRlFWaYHrtXpmbGEbbwjv4whV5bmoymR0U1pUl16kiuoCkHcbgToP5mZiaAxIJaOCKZZwrL8Xjn817Gyn2WM07Guj8Jb31F9ei2YiDtfFPTgy9KL7Qwg64yvTJQ9vOsIBRiePlg2ADP7ycMOBe5/mtoUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d7ebe11bffso6531576a34.0
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 04:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776338887; x=1776943687;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AptjVPQ97g683jPGYCmYUacoTRTAG/3/TQY5t1TSdkk=;
        b=J1B0zAt6wkL9WVyWM97xJfxmcUsyolQKWxYL+txgb1vel8b7U5s92EBa1pxcMYpE+l
         fSzQZYCMmlxcD6oylKb3tEciKrHXf/370LGU+bnKPkEgJMW6oHWDs+Zcahq7EcNT0oqY
         CJkBafw1Mi3OM0VA3Eu2epJF9hITr+x3Fv0fwZo6LyAKHRW7xBPoVTw+pihqEuemxAam
         HOkNvc++GuOOG61VMEw/R4BKO2Nicg1erjmYebsm56S633N2i+flYZj8MG1RBoyAgTNU
         gnye0QXe+oydEQ3lhihWeQUPxq/mNfvN+RjimhmF3RBm84OJhW6dWoSakkHvek3y9Sp2
         tGjA==
X-Forwarded-Encrypted: i=1; AFNElJ88bOrPhqVtNy0JL8swNAlyHddmaHTlE6SdzIiKUHn5iN4rNB+lwVdMm5PrCLNzRIZUdhi5XwT+Uhd/@vger.kernel.org
X-Gm-Message-State: AOJu0Yww0L9OZjl7Xl0hdMEyr0PW/ssZVEs7QeiVOwfFmLWZ5e/rEeRZ
	5wYbktFJTU0SYuiHqewVCgut0rhhX/noCkuizSIkgwTHDDxl76S+GM68y8veZ8+H
X-Gm-Gg: AeBDietVy7D9pNKu6WJTuhfe0YurhNgC+Udx6/Mt5bLd9U5RPGKxol7BV4EdI/mT39I
	tjHGUQDcS9v4VajUrBcw7Zr2UAuLd5s6J1g+sucnStYmPsgeSgb0R6V9KSCT1lqLDpGqsjr20DZ
	6lbkgBS+2LouyvEKOGgaUQkFMFeLTkJIk7drBymH1xb4gdkRSMVwlJgr57rGTSL1kP9raqU5TpZ
	5Cckm6KcNEpJuI4gMHwF0l4ROCQ29VFTZJzycPCHK4CdPiVogHF7HxfGlcjIfr/P/GT57eeLqcT
	YInlUcLXvNJ2kqcWWlv4v8W6xqopQyL8miUJWRDdI3GrBlakmpSYNCzqssBzHnIIKyjGQLfxiVi
	cLeIgxMfCtEwWbT8cMdTkrLXYmMYk+/n2PweMA6po3oWQ4DaqXgmuAJigN2LFJmL4bhR/RZ8qFU
	LTQMp7f9ZuuHx1TloyTM1+11jsuI688l7Ua/6JouF9bUc4nIJHjeJLv5ouDcGcEmSe0qtJ09+rU
	Sw//dtLH7lgiA==
X-Received: by 2002:a05:6820:60c:b0:67e:4258:e100 with SMTP id 006d021491bc7-68be6333fc2mr14173587eaf.17.1776338886834;
        Thu, 16 Apr 2026 04:28:06 -0700 (PDT)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com. [209.85.167.176])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6932dfb8a2esm2357179eaf.11.2026.04.16.04.28.06
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:28:06 -0700 (PDT)
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-470145d7df5so4673400b6e.0
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 04:28:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9cxNUVX/TifFhFiMz41hpw2qnjd3yt6Fm8+IdSYQP5V2bXkPWkLfw5VF6c4xKaHFCAbLtkVCGrkfAU@vger.kernel.org
X-Received: by 2002:a05:6122:788:b0:56f:1ed6:1d29 with SMTP id
 71dfb90a1353d-56f3bca6059mr11244615e0c.9.1776338533353; Thu, 16 Apr 2026
 04:22:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120317.910770161@kernel.org>
In-Reply-To: <20260410120317.910770161@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 13:22:02 +0200
X-Gmail-Original-Message-ID: <CAMuHMdX1aShz8esbYzJ7T-0Na6++_Yi315aCiUx0Cnsgod5uUg@mail.gmail.com>
X-Gm-Features: AQROBzBwwjc8yd10cT00Tu5Dl2qrCYQStWr3Lcobhh8coMrpPeCH9vhBSNokYJk
Message-ID: <CAMuHMdX1aShz8esbYzJ7T-0Na6++_Yi315aCiUx0Cnsgod5uUg@mail.gmail.com>
Subject: Re: [patch 05/38] treewide: Remove CLOCK_TICK_RATE
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
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org, 
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
	Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org, 
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Apr 2026 at 14:18, Thomas Gleixner <tglx@kernel.org> wrote:
> This has been scheduled for removal more than a decade ago and the comments
> related to it have been dutifully ignored. The last dependencies are gone.
>
> Remove it along with various now empty asm/timex.h files.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

>  arch/m68k/include/asm/timex.h       |   15 ---------------

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
