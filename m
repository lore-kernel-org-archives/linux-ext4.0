Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553FB36682A
	for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2026 13:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782050228; cv=none; b=XfHIzzgL/9bHD418Uo40NyDgWL6YXIm8/6XDjStxxIelBBOnr2BtO2KETamx+LLwC14BLMXcwndp4NTj6Z6vKTjCf155dma5oAwZotYS/IXOnuQT5bM850FuI/xVbOhoJcXXfD0p/DzmZ8+uFHvqsCFGs9FJQpki0C+9tCDbSas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782050228; c=relaxed/simple;
	bh=fvPxhb+XWNbU46fPY8gMPSLeWrRsc2z5sSGUBkotAr0=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MwkDkRQ06RZAterPvPgX5IGt75HgeX7hTkzS5PyiCp4i5RcG3U7DJ7BhY81IPTy6eAUNJrtifkcjDf4P2lzgCh57x+D0D7ZSTok71ShXmmX78PREQq7JF+8Wf5Nr6dJP/HUgpRniIx1JEhT6dPVyN6MTMMCI8l2NelL3BZXkkeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IDsgn9Lb; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IDsgn9Lb"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-80236b44a1dso12485697b3.0
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2026 06:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782050226; x=1782655026; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Sv1dki/80aNeWwp+36abGEnVJza7FGEeP7NOY9gPTvc=;
        b=IDsgn9Lb23KedjXNwjRfloquBvpRj0dwvFPGPAQDtjR5tCjOlIZyxGX8LZYKD7D22S
         +fP0YJVtDS6L66zOfEcfzPolWDTcyfNlcNO1LSEJnD92yZGoL/OCS9MzcPtB9YHA5uaX
         MGlL7tW7+31ijgJzSFwabHABzodNxMxv+oEctyDgfvXJiw6HowI/qHOxN7oS0+xh7Ke6
         7VlPJ3ja67RAZVkdDMP+SpeVM0/uL6ruLNMY+JzszK4GcENw/vay9RFT/XolJrMFGBFO
         UB7ig/YBSzOPqaDSD35HVVMbr01R4ktSpk0esy3xlU7S83jBukJBPPHRDXIXxUwgoA23
         n22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782050226; x=1782655026;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sv1dki/80aNeWwp+36abGEnVJza7FGEeP7NOY9gPTvc=;
        b=IYgQ5ncNSWlNXjYHdhcgnIskvXHBIxOO9FwFe+DcBTAqv5H7yZYOP1U7qHxZr8vi8l
         TxK6xEu9tfYazK+i8JpaKmJNiTvw1x39ECUdh2e8Dmw+WdZbblRO4sg5VXajBrBlcF/f
         Xb59IsFPUBigriXO8CExPyDPrnA/1tC3ugbl3yGfC+oASXJAHcoYiE0K3He2zv7W6PWp
         wceIKTBr4zFJFVjgnruMeKZK1DRuuc86cguJ4gneikojOnYaGkYUwNaZwX2AcKFsAn73
         ApgnP3Psfa7fPENhRMM+lsvxTnca0hO0FXtn7OoJsqziJzjCyLbUaZ7vbz0/AgdUQJ8w
         FOnQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr8Ov6YkU5B94T4/LRYIU43BCP9CLhcIHMhbjr2RFvCWDDHR3PNhlwALiUYZT9gsyxx41eDbRMpfhWu@vger.kernel.org
X-Gm-Message-State: AOJu0YxaFYCBN2e2GWUPUsGr52vUjjHMNDQdKpDm2IzQxtSp6cdeoSkZ
	Z+w3ixy/C3hDH8YwlVgCV31GMjYvAwETF5UVW+0JsmH5useDWacNyano
X-Gm-Gg: AfdE7ckO268l1ZECxppua/TwjolWi1qcRSQ6/TMrFiRjWDlj7MD75s72RQ5BPZWyYhU
	UbzugfSyk+i6fyF4JTE3Gf4n7gxCyMgks+m1RPK/T3MbgsWkU3l749guIXQGkKTi3H31wQwtqz6
	yWCxIND4IG41aN2K7LgI/yB9OM4QMjIPk+axEfhp4kB79jfiH05hg+0qJS7CpFtmtjjfBTRvfMQ
	hjaWF3lEYWuSffqfdRELGdoLyTDkqR5e1chGCJuZPvWgIt0+1mQ55c0bMoyqOQw/cW88HEc9QOY
	WwxwURdwH3sHd8IzihDZZmtysNxf01pN/1iI1O70yN2zcEEhsB2RC7ocXFfpIZA6ynUz+8+VcUF
	UETl3fSFTXg8Mwb7IOhPjKlr9qnhXku8HdFIFiQNOzCW1L/ZO+8RZh9wgd4VYjT7HTtaetDHSIF
	5LNgHCOhZZSi87PlTDUcZtHp0qU9B7CBcbcS0=
X-Received: by 2002:a05:690c:4b8b:b0:7c5:f6c:d311 with SMTP id 00721157ae682-80131d97bdamr100779827b3.13.1782050226417;
        Sun, 21 Jun 2026 06:57:06 -0700 (PDT)
Received: from localhost (user-24-214-85-55.knology.net. [24.214.85.55])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8025c96fdb3sm21073127b3.1.2026.06.21.06.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 06:57:06 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
X-Google-Original-From: Yury Norov <ynorov@nvidia.com>
Date: Sun, 21 Jun 2026 09:57:05 -0400
To: Yury Norov <yury.norov@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	John Ogness <john.ogness@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Julia Lawall <julia.lawall@inria.fr>, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org, kvm@vger.kernel.org,
	intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 2/2] tracing: Add CONFIG_TRACE_PRINTK_DEBUGGING to clean
 up kernel.h
Message-ID: <ajftsRwe19fPTP1r@yury>
References: <20260621093430.264983361@kernel.org>
 <20260621093811.168514984@kernel.org>
 <20260621054721.7cde38f0@fedora>
 <ajfphe4Z8BrfYoUX@yury>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajfphe4Z8BrfYoUX@yury>

On Sun, Jun 21, 2026 at 09:39:17AM -0400, Yury Norov wrote:
> On Sun, Jun 21, 2026 at 05:47:21AM -0400, Steven Rostedt wrote:
> > On Sun, 21 Jun 2026 05:34:32 -0400
> > Steven Rostedt <rostedt@kernel.org> wrote:
> > 
> > > Instead of having trace_printk.h included in kernel.h, create a config
> > > TRACE_PRINTK_DEBUGGING that when set will update the CFLAGS in the
> > > Makefile to allow developers to add trace_printk() without the need to add
> > > the include for it. Having it included in the Makefile keeps it from being
> > > in the dependency chain and it will not waste extra CPU cycles for those
> > > building the kernel without using trace_printk.
> > 
> > Bah, I only tested with the config option enabled, and missed some
> > dependencies with it disabled.
> 
> Yes you did.
>  
> > For instance, rcu.h also uses ftrace_dump() so that too needs to go
> > into kernel.h.
> 
> No, it shouldn't.
> 
> > I also need to add a few more includes to trace_printk.h.
> 
> > OK, I need to run this through all my tests to find where else I missed
> > adding the includes. But the idea should hopefully satisfy everyone.
> 
> If you include it under config in kernel.h, to make the kernel buildable,

I mean: in kernel.h or in Makefile.

> you need to include trace_printk.h explicitly where it's actually used.
> IOW, apply my patch v4-7.
> 
> Then, developers who use trace_printk() on their development machine,
> will be really frustrated when their debugging code will break client
> build just because CONFIG_TRACE_PRINTK_DEBUGGING is disabled there.
> They will spend a day, at best, communicating with remote managers,
> and end up with adding #include <linux/trace_printk.h> in the files
> they touch. Is that your plan?
> 
> If I was one of those developers, the solution would be simple for me:
> don't use trace_printk() at all.
> 
> Thanks,
> Yury
