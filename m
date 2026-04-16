Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242623A75A0
	for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 11:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776338874; cv=none; b=beNoY0gF61GRoPVerddOJ+ysiTF/GtVDEpAF4kMMUC7lv3Am6N2Q4wl7ZjqDrEh/4lbOIhZ1OZJUjHQcULJwDPOkPIYXGD5MaWwZau7N17LKxfnIrOdqXTL2g9ZWli2r5DZ4WPUG3A686DaQXNs0O5/w+PpiVrm7NeLboiG6SNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776338874; c=relaxed/simple;
	bh=5RcGmn3E6IkK/4PLTUVN24XJ2jAiV11BodM4t9S5uGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=llFySlJ6KGnP1fQP4jZnVuq6gdKPXGoBAnfbWFj3BreWDTVc+qtOCBA1h0OtPiiINrVVsOVosNB3DpBJtbaKQ1T7cVhyWWDyfCczU5UEbA9otjSWzz8M1NP3jCTzjoyi8Fek3kGBpKCP8lEuXcNjb+ePBH9wLghAt+izN2UhwFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50de80b9567so38440081cf.0
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 04:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776338872; x=1776943672;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6jqlHRyBmHp78NPQbVn/INUSPCxYZ/sUXVIyq1nXfE=;
        b=jj3G1oFVr+DRQOwOOWU1tiPQskDSlnRWvIrDeSxk77d2vejIytCve8RbQqrM8Dgpnp
         Sb6I01DTn2zCjY1j0qHrtj81bAl+baSzo97ODv1k/ZkmeqQCuIBChtNFFMD2XiKoZLya
         SR/Rlqc9zH1/7OwGbralf+pw8TTeajNRpu7Z3PqceNgag4hcuH0xSNYbjhBKIXbPmwp6
         bswPVQPeuYqvpt9WZNpRt24tf94BHdz09JcRxyQw8B2H8EsM9Aed+FAwvimO5/bqVcf2
         ShIZAywrUV2T63UCh5fmHFDKzoCbWoM/xhx+jDLRG18Q5mEF4YNAwqB2zOGmxJ79IxOR
         OSQQ==
X-Forwarded-Encrypted: i=1; AFNElJ9HfJzbto/w5MnOj2Nke0V1bkYHZEBSvUCnuRngHQ9pOWsuIlgP3hsSEK3dRkw5yG/GIBo6VEU09C0c@vger.kernel.org
X-Gm-Message-State: AOJu0YzkQgvoHRUyVw2xh02rkjKZZet5SuWvw6QRf3NK2sqSorBuMQvB
	LGwXksr169G0LUbX4/mQj32FuNDigaw5vhEKfmtjHWtUgx9AWjV72/wf7mGN9tbr
X-Gm-Gg: AeBDiesUoM8pxA6x1SOJk4j77ymovYtHnufIjAybA+M8la9UAHAvooZAlUz1QHxlo0i
	apd4uijfwznIAXzfaQzZPVb/SO7hKTKY43qhIW5I+AW4Zrc7wl6rNLkvd9riUi1dfHdRJvx7epN
	7A+tuWAGZHjdsIEtjyQ+2yAaBoMIa9yv1ZJEA/i/jcXLPkebdA/QBU2o0kzzkuqMjPnVMDY1obK
	Xuo+RimVpjrR3AzBf93Vf5BMxEgX6qnaJCWpHUwbkPe0FpsXsKeBpaP3wJBa1wmZVF2jw8oMnmw
	LlOFNO3cTxpGhk7xdOaip1gJcZvXufRGEIZYEH86L+iJvhWg5c3PO3X/I8F0bfsWQvst+wQb56Q
	LoBAzY7cH4HOCnyzruwM/g9g1sa5vrRuyI4y1CDI++3w9Yhfg724z3KMqDD1i+TTJi/HVDHpbAN
	lkt0eDpOlk3hMo09nti1Ei45UNrQHhJDtCCXbDbXRV3f0Zq/TP1fx8YMOA0zAEHBDKz3xrhard0
	Mo=
X-Received: by 2002:a05:622a:4015:b0:50d:7fe9:aa8a with SMTP id d75a77b69052e-50dd5c3e042mr381337291cf.31.1776338872025;
        Thu, 16 Apr 2026 04:27:52 -0700 (PDT)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com. [209.85.222.176])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e1afecf5csm36390361cf.28.2026.04.16.04.27.51
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 04:27:51 -0700 (PDT)
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8d428da4300so872490085a.3
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2026 04:27:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8YB7qWsd5mqUpBicIyD5HGU1p9pZPLY3WSg0t1LdX520NEsEQKAXaXgMozoiqRrT+TkbGaWBEPkjhL@vger.kernel.org
X-Received: by 2002:a05:6102:6044:b0:5ff:c64d:2283 with SMTP id
 ada2fe7eead31-60a0157295cmr11348128137.30.1776338547396; Thu, 16 Apr 2026
 04:22:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260410120044.031381086@kernel.org> <20260410120319.397219631@kernel.org>
In-Reply-To: <20260410120319.397219631@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Apr 2026 13:22:16 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVoo_6i9=2oQj-=yjW7nK8eL4og08bdYvk_EGj=_cQvQA@mail.gmail.com>
X-Gm-Features: AQROBzCJ6rVnwwfhi99PI36wWXAFQ5DEgo1zw3RhVwYNSXoxkTYAcgIxt5Z0K1g
Message-ID: <CAMuHMdVoo_6i9=2oQj-=yjW7nK8eL4og08bdYvk_EGj=_cQvQA@mail.gmail.com>
Subject: Re: [patch 27/38] m68k: Select ARCH_HAS_RANDOM_ENTROPY
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-m68k@lists.linux-m68k.org, 
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

On Fri, 10 Apr 2026 at 14:20, Thomas Gleixner <tglx@kernel.org> wrote:
> The only remaining usage of get_cycles() is to provide
> random_get_entropy().
>
> Switch m68k over to the new scheme of selecting ARCH_HAS_RANDOM_ENTROPY and
> providing random_get_entropy() in asm/random.h.
>
> Remove asm/timex.h as it has no functionality anymore.
>
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
