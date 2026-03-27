Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5886129BDAD
	for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 12:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774616057; cv=none; b=X+AqG8STk5VSD/2SLQbOakbYFY6vHP6CVfw9eOqlTCKCnAGMphdvVWC0BUtDS6Gm+LLPlJ8ypYbOatVJKuBpWp3dhqmE7dwV++nvfE95OLd2+fK1R53JJgKbBZvccJVG/HHlZT8vZHl/C0K7do3XwuBG6NQTp7HXSgurrx8dsIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774616057; c=relaxed/simple;
	bh=6ZmWzoiPWI4sfjxJDpoZaYpggHRWOG4HcGBuMBQRlQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hS0SzWxSgTHh+AbcyZYKxWHT+E95s3AF9EnHlIm4eMxLJlP4IR/K+/QtdNjc4+I4eRQXv9E+c8rXD175jbSNQE5yM4tNm+wtBVj8Yb2ZXqo9KsGRpkklVmqqd2SMKNGdhcBgyXV21hkFK29R26RmzDQFT8NXNnGBR1uzqSz39mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p4CjPFMg; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p4CjPFMg"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439b2965d4bso1575312f8f.2
        for <linux-ext4@vger.kernel.org>; Fri, 27 Mar 2026 05:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774616055; x=1775220855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmx1qsG7j5cuwdW89z4WvnegLEikYMgYgB9M2OzDn90=;
        b=p4CjPFMgcl2OfO9skINvUE63BB4aFCjh+xBNvFdp0/nEy0DTlXxsTRTKj98G5oraJo
         TpIQpeV/7G8JbXO1cby0Knf4Rdl7O1kQNo0svlrHlTnO4GqkkPL7S4b8ZOPWInoGqADj
         sNKy13ZH33f+gePq5yte1L53p5e14e3IBD4HbqgcqkXZdETU0CcUhPob8q197zyaQzTb
         cGjTxWXJny5bjZF4awBBuLv9eTo+5+ZYejhqGDkLXsPVe1/zOpBHcrLqo0CE7P+NMeDI
         3xsUPPtc1jchKTbf4inUPqr+6XSQCQf1WU2ABBrMRyJGfPZJg/knbvp2VEV2JRGW1d4h
         S1iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774616055; x=1775220855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qmx1qsG7j5cuwdW89z4WvnegLEikYMgYgB9M2OzDn90=;
        b=GUxaFFv2G3GRIimDv/Q1YZ+UCq2Vl845swYV3uNr/QDGOJTs5CTbNO+DN7jFsw5QNu
         iEosohrxhiniWQgMyi+PqIIk8fd3Tnxat1NafGFj4vc1iRKsbp2H5b9O7qpJ2y3oActC
         G3FYFl2iAJUzgnRikDNeBn6JpRPjtx7glF7bDr2086OU3ldMSdll2BeZlQVr3YM959Mv
         FZDIAXyPpTZ5DBagVNC5E/LCfRpR+Esl6eqmfVdlsr00uVhG/NvIrlepWPc2YP9M5Lvb
         FSRZmnyw6euPLbN6p0lOPZJZecL2ALFw7twkhwxosH0PV6f+UhWWh6kw8pKR/AzSnCKN
         g+7A==
X-Forwarded-Encrypted: i=1; AJvYcCVv4hgR3KI2f1bAT2h9sNOJcw9UwFJtlJtTa13jErs1o3NAt7yAL1dJdehb8yxOEwoPXcpbofgTgrNT@vger.kernel.org
X-Gm-Message-State: AOJu0YwxyRMHWY3L1fynz012qIxf6GaE5riw2/h3iZqFcISVXMqZEuqg
	squgXMcq8IDhksBtYvU40p4fAAWqirCfuTAzGdsqxZ5d+PKFOMB/BYua
X-Gm-Gg: ATEYQzybbIFLJAuwOtG/YRSrBqi82Vf1R7LFmiAvgAVZP3wvqVUbNxrY+4s+JDeg1u5
	c0lJjT6pbYIgUXMGug9eaWeihGSWyMoH1D+ChyP63HgpviJi2+rQwjQsfgTtqzMyZLWlAfiZqM9
	RDGKB4/f/DXWN/YmSlpMfEmImquBAc+Kfh7nT5saVxoQmlpQ57583zmNlDe/YSvXAZAL/Pv27fF
	LMI+HH9KlpImHlNWGm/OYo1/LpWlw94oYXTMj963r7fP6Eh817oniBYAITBlIBOcRu1tDQsST4T
	EBCDmFyxjn7j4FCve+gnBRtgQWt2IU4Bav9/9qvhrX7HAROaA76gCwQL15Azy/cLBBTxeGUUhaI
	Bh8SUOZy9U/6dYxFMB6uB62Aa768Ce5JVRH3X61sJVzX3Bo5kAEcCsx5Q74eTTKUJHhujuJ17el
	ZWjLtX2qlDeWUQli61rDIwTuU3HA0F2dCD2JNHMvzzrevV0NBgZ+hJZ7p4bbtAaADa
X-Received: by 2002:a05:6000:268a:b0:43b:8fa4:1958 with SMTP id ffacd0b85a97d-43b9e9d6039mr3783134f8f.4.1774616054426;
        Fri, 27 Mar 2026 05:54:14 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919cf5aesm16281717f8f.24.2026.03.27.05.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 05:54:14 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:54:12 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger
 <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Petr
 Mladek <pmladek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] ext4: Fix diagnostic printf formats
Message-ID: <20260327125412.47944386@pumpkin>
In-Reply-To: <acZgmKv38HLhky6q@ashevche-desk.local>
References: <20260326201804.3881-1-david.laight.linux@gmail.com>
	<acZgmKv38HLhky6q@ashevche-desk.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Mar 2026 12:48:56 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Thu, Mar 26, 2026 at 08:18:04PM +0000, david.laight.linux@gmail.com wrote:
> 
> > The formats for non-terminated names should be "%.*s" not "%*.s".
> > The kernel currently treats "%*.s" as equivalent to "%*s" whereas
> > userspace requires it be equivalent to "%*.0s".
> > Neither is correct here.  
> 
> This entire code seems was never tested properly and it's a dead code
> until one defines manually DX_DEBUG. It also has tons of plain printk()
> calls that may behave differently if the first character is not printable
> but maps to the level of printk().
> 
> I'm not sure how your patch helps with all that, but apparently the
> printed data has to be NUL-terminated, otherwise I have no idea how
> it was ever working without crashes.
> 

I noticed that as well.
I suspect it way have worked for the person that wrote it because the
name strings all happened to be NUL terminated.
There is certainly likely to be a '\0' before you 'fall off' mapped
memory and crash - so maybe they just ignored the extra characters.

Clearly the other option is to delete it all.
But regardless the format string is wrong.

	David
 
