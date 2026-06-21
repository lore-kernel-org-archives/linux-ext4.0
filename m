Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AA436605A
	for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2026 12:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046537; cv=none; b=LSx4+AETyh+zpx1t3RAILzJ3rhNCIbL8wc2MSiGJ70FY20AnT1TfPMTGr4eVV92wdQX+lJP+OWcNgqGtmjMAXaZOHaMpGumJF6D/zXDKOCMcvufEU5RI6PhNj2b0c7nGssI/1xGvbtbJDCKCA70sTNCHm3Bb0KvJITkkj9sIV/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046537; c=relaxed/simple;
	bh=FrBpf/gkssNS0FzrmeyqCp0e1iIN10xNwwkHFwdCrQE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UzzBQMfA9qo+Di7ZRTIOHn+FbQp85i0admouad8QiXXijnVSWPNK1oo3a9snUKtWLTVkFrIsYaCqgY8JTPswXA/2Lz1RhT+0cTLHaY8YhrGmgnioQqesG4AikAr7ClMahD7Np+k1R4GtFwrwQebjpKuNNgrTlvdA4zU8eJscghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEPnlA7i; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEPnlA7i"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490c0c92cffso23475815e9.2
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2026 05:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782046534; x=1782651334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WU+6TPSMrQeQnOmPDKoUDmLIYSzXbxEWNqGQFFhaaZU=;
        b=HEPnlA7ilq5cBLXmRCRdE+fi/N7aST+SdfMD+MJXNx44EBemiG9rjXiFv70GGeXSoz
         OL+YA0wO4DZ+Vojg0dtpiA/+jHjShkgs9abDLGW3cDtqvdjyeSWyTCBZv9ntyUJ8YgkF
         2LlW/c9NPd35YBu9qUTAvTzk/cctdfAz/26y+X+lPsuttpW4Px8uT6A7LWPw6p25qqh3
         LN5ymox0l7svelgtmlOUVvfqkISw+y7pTMmkNCOhS+m102IwN1RYhV1E2cNi38XRGRkb
         7yoF60g0aJidx7f0xIQvNERu2I7c6x6JhnU0pe9CGHXzsLJzdkQSpMm4duLjoPK4meQd
         64yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782046534; x=1782651334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WU+6TPSMrQeQnOmPDKoUDmLIYSzXbxEWNqGQFFhaaZU=;
        b=lNUKWCVPexZO7pGZxJ2juzA+Fk7Ujkugy6vLyHe1odiKwCeaKg+++VNsNplaGEQ4/q
         +SxGO6506L1SHChIumZkHTxstJpaRi5ePL1GMgPhVwhE20nZ0sRsuidD0+AvqeZbvjij
         DtISuFXvtWIaV/vt6yrm645yXYlrcVgw02OIJGTA47CkgUjJPgTMhcfRa1giUsmhRtz6
         CDL4I6BgOjvusLovFrZiGDkaZ7dz5gH9VogzyDvI89J2/hVz43cKGbO6knwllc1FwtLc
         ynaWAPIyW4sUGxtZZ+G2tzPNhHcDjI3Fe8ZPgLhwAA7mV6vtYv98TDETRibVjrFQO9gB
         pQLg==
X-Forwarded-Encrypted: i=1; AFNElJ/wg7uc1qf0z9bdfr/jmacTfXsQZ6vOz5k0/5fpWAgJ5zcMVzeHoXX0krGglcC7qXDxyfipyJSoKbiq@vger.kernel.org
X-Gm-Message-State: AOJu0YwnSYkUOs5yTdZKv7HYHoM39PhLB6DWboIQ1uMJGgl6NLI3zwUG
	rtHdoe5wVKEXqoKbvEPXrA7MV6kcwFf+evO3Tfe0sLiFgL6ljDM0reRy
X-Gm-Gg: AfdE7cnchL21WIdZc5VBTI/K5jNFWVDdb0fH3wybxbZVKPjAfNit0NQ8bS+CQLZS50b
	Jkl4hPXoKaEyBV1C3wyOD6CPlYUDYAqOGdFkx2tb6LHxEkljG7x9bTNfd1mKwsMin0Bo6dCc9mA
	Yd0JDeJGWizTI7HPqJ1OTX/xk08iPG/ZCTrOjhey7v8uRJ1sh6yPuuEpprU9ZTxYvE0xqsHTejM
	UX8yVQ3I73vI1VmnnCLNh+nsgWiheXb58Y7x750mVYp9KxVQ/6HTSRh0yVi/jQH8ZBUCiHbmtbo
	7NdKyni5IbEO+Se3wmdYyMRddMnv3pUnVQsGx3PTiOgNujTMSzwDDvoMpSMM7GREnsk6R4x5Qd3
	vhIT8wKkcxT1YMzaemv2lq/qruP9NQzwnzoOzZkdCofNoO7oH98lw7OYuX3LcaaL4eOBFMZ6B2+
	qElo+7LY30HC7SBlCcyp5vqIxvoMW5uv6Wpu/s5OXZA1As82Ie9Q==
X-Received: by 2002:a05:600c:e547:20b0:48f:d5b8:5b07 with SMTP id 5b1f17b1804b1-49240e81b22mr113459545e9.20.1782046534244;
        Sun, 21 Jun 2026 05:55:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49249238900sm129230375e9.4.2026.06.21.05.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 05:55:33 -0700 (PDT)
Date: Sun, 21 Jun 2026 13:55:31 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: Steven Rostedt <rostedt@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, John Ogness <john.ogness@linutronix.de>, Peter
 Zijlstra <peterz@infradead.org>, Julia Lawall <julia.lawall@inria.fr>, Yury
 Norov <yury.norov@gmail.com>, linux-doc@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 dri-devel@lists.freedesktop.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-nfs@vger.kernel.org, kvm@vger.kernel.org,
 intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 2/2] tracing: Add CONFIG_TRACE_PRINTK_DEBUGGING to clean
 up kernel.h
Message-ID: <20260621135531.243375d9@pumpkin>
In-Reply-To: <87ik7cmcb7.ffs@fw13>
References: <20260621093430.264983361@kernel.org>
	<20260621093811.168514984@kernel.org>
	<87ik7cmcb7.ffs@fw13>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 21 Jun 2026 12:13:00 +0200
Thomas Gleixner <tglx@kernel.org> wrote:

> On Sun, Jun 21 2026 at 05:34, Steven Rostedt wrote:
> > Instead of having trace_printk.h included in kernel.h, create a config
> > TRACE_PRINTK_DEBUGGING that when set will update the CFLAGS in the
> > Makefile to allow developers to add trace_printk() without the need to add
> > the include for it. Having it included in the Makefile keeps it from being
> > in the dependency chain and it will not waste extra CPU cycles for those
> > building the kernel without using trace_printk.  
> 
> IOW, you make it worse just because.
> 
> With the header being separate I add the three trace_printk()s and the
> include to the source file I'm investigating. The recompile will build
> exactly this source file.
> 
> Having to enable the config knob will result in a full kernel rebuild
> for no value.

Indeed...
Isn't trace_printk() just an extern?
Having it defined somewhere isn't going to make any difference to build times.

	David
 

> 
> Seriously?
> 
> Thanks,
> 
>         tglx
> 
> 
> 

