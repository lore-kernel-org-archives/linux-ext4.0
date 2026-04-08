Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC39A349B1F
	for <linux-ext4@vger.kernel.org>; Wed,  8 Apr 2026 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775665369; cv=none; b=ErtQwx5iHF42D4NXTAuaVtl8z+sJIhMJKUMFnmoFq5ePJyHhnR/6v4PDnSkBB+099mTgoamM7klMqJrNdzn96oJDfA7f8iQGi/CVgjNwix7G6Syd15+HGKg2QsWK0vhHyylJXDR2x60iczw0RSm/FTEsIl4Uttm7SKAIcUlSfDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775665369; c=relaxed/simple;
	bh=MbK2EhOyylLAxU2Q/eHjdaz1ad4dnrnqpmOeagl6cGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IXcKTKzicFt8Tj8Q0ha/1S47wvKktYmB+p9k0HbsxqeBW5a2xAjntSUtaPL/VmzNvXLyzR2LFbtwiBzFUYQnBFHg03i1Z02aU1uy8B57IA+oq5sMdLreD3ojJzuCn6ePynKOZUS3b7Vtxpi9bsizmcvu6FXRyFYteDeLHJBR84U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fRrx/4uX; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fRrx/4uX"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b93698bb57aso9894766b.0
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2026 09:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1775665366; x=1776270166; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FrJr1968WuvXLCx5E+q3h8WCNbUNL7Em2uQzgCx18+c=;
        b=fRrx/4uXqqu8FVs+LcB5+I88dBlbYd8KacXUkYaa0Va2hEsXqTy3goqfpBY3fJh9Tc
         fWLfDWTTAbpW4h4KhUuq98O0GWVfXP4mtkz84YLszyBxoDZuDhWVs01lVCiiz6fT+bsd
         wk++HSaQWQLzrNf7GJCzQan7iGqEmJhg6mkCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775665366; x=1776270166;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FrJr1968WuvXLCx5E+q3h8WCNbUNL7Em2uQzgCx18+c=;
        b=d/dNZhtYIiObj24nOY9zo2vE1M5MmuIp+Z9A77qAuN0npBgp8VPwvVjNRgG66cdu+7
         U2ZEuU7nwKWM98fb/HF0BU9nueiDW6+QgFquMpc6vT3MqGboo0UBpPpv0tlyvv+gJeV+
         DRgkA4ZflMZqKqb3NuQbJQv7fbOR599c/Gd8p8hVGu6g13G5t8ra7wQE4qmEqPYpdQ8x
         Uvye20OT+ZbB+NrK/st9ddzns+PkKjMNZGzmyUpeG+RUl+7luYtyZOtE5Cm3HMC1fjtt
         xkkKHmah5bkqKckXW2KgKmvoK0GDPsFTGilXGjOByBTvx2cKSJ0WpKR1RtTwCYIgQU5N
         xUoA==
X-Forwarded-Encrypted: i=1; AJvYcCVdHnjkg70YKQqW8dOx5D05m8XmZ+22jjWCJeHgH70dYZxeIZ68GkztvLN2g7YzfOBuPpKAX4faofqi@vger.kernel.org
X-Gm-Message-State: AOJu0YyC422J4PXsnkbYfCkEyQ+4nr+Mq8nSUTacv9hPnH6CjhrYHP0T
	NbfCmVNh4wjw+lqcBylYmVsm86RLERRS/HCdAJc56UZ684pZE9IMc4W7CdMCp0ma+KFvmDsIIkl
	BdbP3x7o=
X-Gm-Gg: AeBDiev/xQiBjNLAtlD3yxR6VVeQrMeXFaR+O5zzALhd7hKNrzZ+BBuWLEVQEm4KrXI
	PHNHhj4VYgM7Nei7txlQKFAz9l4Ux2THF9sp6bxnfrsJhHUGo4ENvWgsXt44prFmWMFVs0qOXuM
	W11KBupP6FDW4EPrLpScSLr4RKhwwDsUOescOfNF48Gz6+9tZl/O1yCR88xP4lw8VCjBoIOSJ6W
	WODx85PBmuE4wenXbif+IFRrUZPaBawYOP+KLqBgCQU4m7g9yDibRiclK2noQRSt+BfZPvVH+FG
	xYJ6os7JDQ15F0oLXHeLVyFJMhF4vCFQhk49HpRcN6U/gaUHqZ5uWiwxObKCRXkTdWYcyJiFr49
	3SV73kx6+b9CYWB+jlYIscViQAUIcdJg/OW5Muv88ExfbeTG6bxOGi60L2PtJDt1FElUsszSzth
	FqXkbK7NcQPf4IgilWXkkEySTMWAQhS5bboX6YSFrRtda0fFbEcmt/PsXKPWUB1ulrbz/ArQkO
X-Received: by 2002:a17:907:9306:b0:b90:b959:4c72 with SMTP id a640c23a62f3a-b9d4605e3e7mr9131466b.6.1775665365994;
        Wed, 08 Apr 2026 09:22:45 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9c3cad1350sm653231866b.28.2026.04.08.09.22.44
        for <linux-ext4@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 09:22:45 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-66d65646c65so60979a12.1
        for <linux-ext4@vger.kernel.org>; Wed, 08 Apr 2026 09:22:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVQeZBgtC/kE7MED77MiidAh8VUhshfTI5acPweXAuf/Ng8DNNk4/CErfibnhAz+v9560CJ5qOlMyo2@vger.kernel.org
X-Received: by 2002:aa7:da5a:0:b0:669:cbc5:db7e with SMTP id
 4fb4d7f45d1cf-6700a57ee26mr52955a12.6.1775665364063; Wed, 08 Apr 2026
 09:22:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <adZTGOjjJrVJOcT8@shell.armlinux.org.uk> <adZfTi3R6jtsjXx-@shell.armlinux.org.uk>
 <adZ9grUg71f518Fg@shell.armlinux.org.uk>
In-Reply-To: <adZ9grUg71f518Fg@shell.armlinux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Apr 2026 09:22:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgvBPt8b204E49qUfK5F3otKzV==4t8Z=6_wXO6vgWqHw@mail.gmail.com>
X-Gm-Features: AQROBzAZ_qhfjZYeQTD5IRVziYmZuTFOofH8RWcCNS0y3LUoXT4zBJ_T9EYFJb0
Message-ID: <CAHk-=wgvBPt8b204E49qUfK5F3otKzV==4t8Z=6_wXO6vgWqHw@mail.gmail.com>
Subject: Re: BUG: net-next (7.0-rc6 based and later) fails to boot on Jetson
 Xavier NX
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	linux-ext4@vger.kernel.org, dmaengine@vger.kernel.org, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Vinod Koul <vkoul@kernel.org>, 
	Frank Li <Frank.Li@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 8 Apr 2026 at 09:08, Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> The rebase is still progressing, but it's landed on:
>
> c7d812e33f3e dmaengine: xilinx: xilinx_dma: Fix unmasked residue subtraction

Well, that commit looks completely bogus.

The explanation is just garbage: when subtracting two values that may
have random crud in the top bits, it's actually likely *better* to do
the masking *after* the subtraction.

The subtract of bogus upper bits will only affect upper bits. The
carry-chain only works upwards, not downwards.

So the old code that did

                       residue += (cdma_hw->control - cdma_hw->status) &
                                  chan->xdev->max_buffer_len;

would correctly mask out the upper bits, and the result of the
subtraction would be done "modulo mac_buffer_len". Which is rather
reasonable.

The code was changed to

                       residue += (cdma_hw->control &
chan->xdev->max_buffer_len) -
                                  (cdma_hw->status &
chan->xdev->max_buffer_len);

and now it does obviously still mask out the upper bits on each of the
values), but then the subtraction is done "modulo the arithmetic C
type" (which is 'u32')

In particular, if the status bits are bigger than the control bits,
that residue addition will now add a *huge* 32-bit number. It used to
add a number that was limited by the  max_buffer_len mask.

So the "interference from those top bits" stated in the commit message
is simply NOT TRUE. It's just complete rambling garbage.

Instead, the commit purely changes the final modulus of the
subtraction - which has nothing to do with any upper bits, and
everything to do with what kind of answer you want.

I think that commit is just very very wrong. At least the commit
message is wrong. And see above why I think the changed arithmetic is
likely wrong too.

It's very possible that the 'residue' is now a random 32-bit number
with the high bits set, and you get DMA corruption.

That would explain why this happens on Jetson but I haven't seen other reports.

                    Linus
