Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45A73B14B0
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 13:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782133912; cv=none; b=C9yee4LLw5kB9NrSZz1UpVp83oaoF8WgxwEOXXvipHgb+eWHZAQG8Ht4xDYhIMoCALpd/LGGLrGjAfn8qgpqJ5ewaStvG3v0tgmjT6rhUAYWsTvas4BWtci2AJ8dtmwN7Hq/B9tZYV6JkLECaXE0M+R9vr4riOTE+GN3EB94XbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782133912; c=relaxed/simple;
	bh=HQz5Bgb9Ix6CxIn/K74tfrlANhIDMynRIFpNpd4eCGE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9/OiXKWSFullYGHCcIya2u5dzuop4OQbpffCsWdRyslZ8TKv/IhQTLCEK23sz5N4tyMdoJNAyUi33h+BEkizwLX+zCzuUeZy0tP5nnuiPHqEkrTPecRlQ2tq3/Tjekc2cZervCFYy03XVVgswAC5csDBMfYZKrxamJGY6Z1S9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/i5uTze; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/i5uTze"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66043ecf6b3so3874414d50.0
        for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 06:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782133911; x=1782738711; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XkaEWxUJkCuHp/17+ud4oWXJ3qqAKnltzqopfMTtFIs=;
        b=k/i5uTzeJQR4+7Wet36cQgSo4sxL7JHnWkI80+xtkrP/9oBTFyHZ8X3t1Q2CnMTDp6
         Psigzn+fygxUIibpKJV8vugNaeMafjx2dbtYSsLvity3z1Woqbw59/7qieJHFyH4Adan
         iIRyDi8CMOCz/az4EFMKhiAYGCpfEhizDTOzb65ymOvZsLNvI1F9BvcwvMSLbbcXXmc6
         lyPBLK7m1zPmKDIwdT1nVVOesfeemXdJZa83ea/kP7geAEZB8UZ24UFkA43weVCRdqNX
         kqhXI7Jym8KGVdZHNk1qUH7mqWCLBnaTI9Bl96kF6LQYh6lfzYB59dUz5+jAHbpHTf5O
         SP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782133911; x=1782738711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XkaEWxUJkCuHp/17+ud4oWXJ3qqAKnltzqopfMTtFIs=;
        b=U1yObjh4/RBNfOKKTVJf/FyvRC7p356lUeAMMfzpxh22CcYnCfzkST96GAkZ4r0Y6u
         XfacbAtKIKA6fE5iYDq6+rZXDY2zZ4jNPr2kb+Po1HyCb9d5wlzONghVPHXjAfwxA753
         p2ChRLYeb1O8iI/esCdiJMtmVJxzF/M6a71kvSqRCxnv/T54nLuC+4ejprgUbPDpeaXm
         LnqN/XFDVzyZgNdUHTrDlKRF69xiHN5tjo9QNyGt7aFxSZUEDFDvYFUdAZ+eB1tZoLM1
         3KPV59leYp0eIcOuUQT6X5Pj4IcgSNhsOAm0J4Vsk6dOa80ADxHHUBA8jUZGEpkGlCBZ
         Wskg==
X-Forwarded-Encrypted: i=1; AHgh+Rr1pvQGC7dvoT5mij0TTw+vQk+VNMWsx+ckHmmKuPo4bt6IpD08osnCsuNBDoSVkS55CP8vBKyta+VN@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs5q6IDmoMIrL5l7BOFPghNAU/SlWTWTYn+/woAuxUr8IWN2Lu
	MxDIbBDK+lNOXEB+kwCqaNyr9zQva5MTaeEX3mgZXjEGUJwOAtJ5x7FJ
X-Gm-Gg: AfdE7cnE3fYBQuyTWd6i5C5UqUVTEHMa+mjXd2s9saCxIXONOb9HM160tnLQYIBxhJg
	8hoFotIkOHuB4svwEh54pIAwrjJ1drGAn7cvhsPS8rRtNvHld3VQFCiTUbVlEq5yrU9rXcoEekk
	BvELkr5IbZEF+YSqbdREOOhyY+RIMpDR1u2R0kTh2MQidCw2qIMphCuz1qiG4OKHYsY4b0d8YxW
	YATtrbrDkJQrcda3Z5qdkprmWLEKPquHjdJBMfQqTmRdtr8LE1q+N+fdkb6Jm8rktCtsw9IQ07W
	4XRh3OTPfTDvbet9ZMiLfl/B0wAfjOIW9tqbcnykJ8ZQoETxn2RtY48wV+Z/NU7SE6Ojn9s0nY3
	WUsheWQRBAuc4p4Slg8qrFujIW9qHw6EMieOpMvDEY7iH7h00Pbzyzw4+uCVDFUYqxstzZEgQ8F
	V0dYTHXkg=
X-Received: by 2002:a05:690e:120c:b0:660:54e4:5dd1 with SMTP id 956f58d0204a3-6630333ac1bmr11505521d50.44.1782133910591;
        Mon, 22 Jun 2026 06:11:50 -0700 (PDT)
Received: from localhost ([38.101.158.131])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66314ac3f96sm3600882d50.1.2026.06.22.06.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 06:11:50 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
X-Google-Original-From: Yury Norov <ynorov@nvidia.com>
Date: Mon, 22 Jun 2026 09:11:49 -0400
To: Steven Rostedt <rostedt@kernel.org>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	John Ogness <john.ogness@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Julia Lawall <julia.lawall@inria.fr>,
	Yury Norov <yury.norov@gmail.com>, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org, kvm@vger.kernel.org,
	intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 0/2] tracing: Move trace_printk.h out of kernel.h
Message-ID: <ajk0lT9P0SeuD94j@yury>
References: <20260621093430.264983361@kernel.org>
 <dbb5915e-6587-4de9-87f3-76bea5024da8@kernel.org>
 <20260622090826.20efadb3@fedora>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622090826.20efadb3@fedora>

On Mon, Jun 22, 2026 at 09:08:26AM -0400, Steven Rostedt wrote:
> On Mon, 22 Jun 2026 10:05:13 +0200
> "Christophe Leroy (CS GROUP)" <chleroy@kernel.org> wrote:
> 
> > > There's been complaints about trace_printk() being defined in kernel.h as it
> > > can increase the compilation time. As it is only used by some developers for
> > > debugging purposes, it should not be in kernel.h causing lots of wasted CPU
> > > cycles for those that do not ever care about it.  
> > 
> > Do we have a measurement of the increased compilation time ?
> 
> I believe Yury does.

I re-run compilation is a more strict environment, and the difference
is negligible.
