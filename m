Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F88341930D
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781010523; cv=pass; b=TNlICbFHtFdxKwnKR5c48a9A5vrav5et4LwXUtdEIXM/j228ZWmN/PMzFRuHNjLZ/W/0df2KV7Qm0BZw/l8na98AfLQtNCsHrzlTVx/xM6yFETGHNdu2PxhvBm2gbneX1imOX7gNK5wU03MC3dc+6Qe+KojOFn9sA5Ftmh7o1UE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781010523; c=relaxed/simple;
	bh=p1w4dDG43UhRDLwUBFWbpr/Q0ulJgmdjjjGOiAAhk8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=arTxzpbNYmlT4Ds/bzKpPX132hBVvtNlFH7OXLqZv7/hSMw+5I2Y4qsenty6zUlRsc//3C5//Fb9KghHsbnyhH6Oh9n+qscPon52k3gzz9xzCjadh5pfWi59fxCcUpWErGG2ts2Wjc5TB7dTRMKjTVoS36zaf9wy0klJ+SYc27o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=novlLNgo; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="novlLNgo"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-becfa735b9aso744550066b.1
        for <linux-ext4@vger.kernel.org>; Tue, 09 Jun 2026 06:08:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781010521; cv=none;
        d=google.com; s=arc-20240605;
        b=FTflQMO9JvnSLXxlDLxQa/VJ7ZioyLhjtjXuRusgwHZOmyJL+V9s8yeAgyU7BS6Gvo
         RAjBkcIxlZQLD+6ImsRlSc5Omub1SQ5XtfVY3ZVgL/wFsenQn3/Pr2O5a81nkyau4ss9
         ubUaqGL91nCQ3huLA4LgT8/YXamtUlp6iv/eQatGvlNT2y1GZnAPF6/l/SZzJa02kUdW
         GCzOoc7KuGLGIfmOfFdT5kNgU18XwGKW50LWTjUcWr8DeqFBWa4sx05PXiPax4DZBGAi
         CWt1Q0Pmij1vV/1+oboPj/X6ruGt4b81b6jiNoQXCssJmf+d6/9iBhhWGBZLkaxgl1W+
         5ICA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=p1w4dDG43UhRDLwUBFWbpr/Q0ulJgmdjjjGOiAAhk8Y=;
        fh=advpllnjB1v6VtfZm+DJ3JJoxipbzrtEX2UX16wi6DY=;
        b=P8JuZoMKhd34oeTaW6sqaK9kfHBlFPO9wa23hRLxl9iWRvjrgt/5XdWIc6C7V//ZlH
         0WO5Vol+p8CXino9j121lMx+/zVi5g2VcCVPHjIlDkSdmuUQjDdmNYHszTY+vDr1O4Pe
         wtcycDOrz40k6cE8zqlm3dU3/+OdlVDVl+NyaYAI6QxJYPGHCnYxD1QBg95lVDHK3Nr+
         lT8fx/NPefI/YSJpG4GZuteQf54kVxEAkbYCWuKDWS4v8HoqKd6RJ6/V7we7ABKHMF/d
         2vyeCftPhMs24qxK4Ibphi1D2D7J/xEes6vB0elUWYZ2U0W7zaOH9NLhnR6GYvoydPuJ
         AqBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781010521; x=1781615321; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p1w4dDG43UhRDLwUBFWbpr/Q0ulJgmdjjjGOiAAhk8Y=;
        b=novlLNgo139N4KYKWd1pLMmBRO5YQxLdpA9SedHTEsANokt8VN6MCWSRPznpkp597L
         MX28AdtmdpzoWdBEcJyGBfynMLXa4lil5gZr7y2LpzTEEL9rCJJC43i+X+y7KgvUdAdJ
         9pkBllI9dSAipMs7USpVv8nuODkypAjXJvfigtoZ3Lg9WrjS2UsORulK/c7vGF4u3+eF
         eFvurU08Cg3deoGvMDIzxs44I6RiH8r5LQQxe/eU1ndO561c3RmMxwE+uo1LDg5bntT+
         IiTybDXXOkXNKQ2svlMBBjYh7yAZJR0PUODNggRPvRvGem79ViQIwlSw5zLzQeLpLUKv
         RPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781010521; x=1781615321;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p1w4dDG43UhRDLwUBFWbpr/Q0ulJgmdjjjGOiAAhk8Y=;
        b=sAtRD8JTk6TjbsMIhdYU8aHLkqExfj3IaQS9hyT9Zc8/u6CG7UVMxtxY0ITeSVmwTz
         JfjQB4QTVyCgBiblsA2pVQkMX36eWperFxbx0ANO7YOPKa4FF6frpFQmoWGcH0n6vSA7
         xAq25v3tl3O6QMpbfc26OaaxvdfVAsni5UAEJ7AIy3WPCju2PZzXOw/X9P1iYCC5P3+i
         x/EW0wRn9hmI+xoLW7425fkFeExtVGi1WMUyA1c0mdqkt/PEEOI2gwFZVjNJkgjHAQlH
         gcP5hmUD9fAn81V6pCOy+fdwuCQEpEuZ8rB7IhX89QY2ygw2f4JBpW6LpnRU4WGhaSdM
         3WAg==
X-Forwarded-Encrypted: i=1; AFNElJ/iD2UC1RXbIlReWLPNiEblO+Dg28toCyeT+5C7oMhUeMjjadTaAgjcvUZutpio/dKf6V3rD4AcWKG6@vger.kernel.org
X-Gm-Message-State: AOJu0YzHBIoMNyg54hGx88JMLleIVVvGGtSOivvfcvYzWCH5voRBxeD2
	uiX7dBACvWiNUcFXzQRInqbXmhCv7V4V1oyfIGp5yQMsJgnZIslQA2kARGjtYvWBk0CUC/kWow9
	drbkDSRZGg1Ky9sbBoPq/HB3KLLCdFD8=
X-Gm-Gg: Acq92OH1MLm0OJm4or4sd2z7j5Pcs6SG+3RzPFUvE5eQV99dFRdYYCV3VpjP6MZ8cjY
	vxChaScboSEANp3miLWwKF6ULqquNa3T+Hrh++DywoyAGRskEmJuLfDNgfsTQgdlvmluCkXIdtl
	l3q7NxVbKvwpt6ct+YUEDxadk3couct9TvC907FwGlbcx/rmkDaqSQXpT+HrzMrfL8Km74vz6Ea
	B+CbZFVZIRz5NwxB0mCORTiulbSzLlOic+PDUickzNldROkel8+0QcLD8LFIf6zxm84W7FqZVhd
	5xeZKOQ45T68aM+1RcqAOwq3LbzPBnuCHoDkzlvoDt+FpuezbQ==
X-Received: by 2002:a17:907:3f07:b0:bdc:ac75:73b9 with SMTP id
 a640c23a62f3a-bf373a032a0mr1102504066b.43.1781010520517; Tue, 09 Jun 2026
 06:08:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609062005.1702-1-aditya.ansh182@gmail.com> <o3k4wongcbuacu4rjsb7h2utzsrhpnun55vzdnp46imnlbn5x6@matvyu6j2xhc>
In-Reply-To: <o3k4wongcbuacu4rjsb7h2utzsrhpnun55vzdnp46imnlbn5x6@matvyu6j2xhc>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Tue, 9 Jun 2026 18:38:27 +0530
X-Gm-Features: AVVi8CfZC1RqwwBADreq6qsprBnJ703dxJwRvA8K-MP701ezqTH9LpeReoFjIWQ
Message-ID: <CAK5ssPPArwEQyU1+icZXJMrd2zmkJwzOSov-0iQ+TVRpU-g9yw@mail.gmail.com>
Subject: Re: [PATCH v4] ext4: fix kernel BUG in ext4_write_inline_data_end
To: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	sashiko-reviews@lists.linux.dev, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Jan,

Thank you very much for the incredibly detailed review and the design
insights!

I completely agree with your suggestion. Rushing too many fixes for
complex, concurrent race conditions into a single patch makes the
code harder to review and risks introducing subtle regressions.

Let's go ahead with the simple and straightforward v1 patch (which
has your Reviewed-by) to fix the original syzbot crash for now.

I will take your excellent suggestion to use fsdata for state
communication between write_begin and write_end, and I will work on
formulating a separate, cleaner patch series in the future to
address the remaining concurrent locking races you mentioned.

I will withdraw this v4 thread for now.

Thanks again for your guidance!

Best regards,
Aditya Prakash Srivastava
