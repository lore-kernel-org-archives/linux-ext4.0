Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE015C613
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 12:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773492555; cv=none; b=j+oMYve/jpgY9Xp4LMpUdUtBEHZArtIIG6oEcLvPFS6lbwVnFfZpQIcdPPe1fInoiOKEjHWWZuV1ScaJzvNXqQM5WsgFcMq94/NQ6K4JoeGA6h2nLoX/nQalXMb6Uu7BXvlgkeyxJOImNgaD2viMCKqkiy5O6pySCTvtUbBPXY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773492555; c=relaxed/simple;
	bh=Dx6XengnVP/eiWEZEMuaeZ5sN28frz94uc/SGpuuurI=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=L91ZysK5Q07p5p4C4qRQ2bq8ZJNv/Tf5azRZEAJ1WgK+v+mtl1/x4w5/yJV3wCLDl++nEGs39/LCJwyraX7OIjd2410sbqRItpcsbyS+3ETljlJ4wsEmuEmv4TntvDEX5JB0E9j8VxU+Stw8TeE99h2kzhPxFAGrPl8vDOgxb70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WyrdVp50; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WyrdVp50"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-829781b2b01so1992710b3a.2
        for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 05:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773492554; x=1774097354; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cO37Y5ApoDvMF4pGPJ0hVf19dy00IYGwgNOMMHyIBqM=;
        b=WyrdVp50Mtp2F0NdfzaL+dpybyaBXIHdcRoivrONsWc4NFVhYkveaZHsxxCMzrRBkG
         96eMHI5uvJUFz83rGAqSJOuQuyDMg0T0n78qMx198rsZCHp5tc7toZtISNoWQ9XhG/KH
         BK1DTmhj1FSS1zS446tGLRuDY7mlI40xYGf+Tdkg8lM5U98ZQPvTik5djfsRtZbE4haj
         OqOTQtfvLFgquOwypQwqSROHPc8slvpp5D90c2FrrfJj8n8rOxNOKFD+cTNVqqBughEb
         a/W7EQ4NaU1drDggKdfv4ISCYx+W3kfQNNMjxXOm4b52EHxo1yYbcIPi0hC79zyAz9oR
         FtOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773492554; x=1774097354;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cO37Y5ApoDvMF4pGPJ0hVf19dy00IYGwgNOMMHyIBqM=;
        b=CVHlMij/gsefvSkG4lA7Tf5XFrgqAwz8oLW3EgXxVMcmJr5Y9mADmyY5086RoxOxcr
         7v47mLKpsh40bX39YpfvUDYx7WTgENWEVDoCz0sxW29SXbEhNepbZSEMHb2wENTRwfDX
         3XRWARFOy+t+u+H0r96LNYQddYzBISxBjVcHuQ0609+nXrsilshR96TvlqFoVDQoH3J+
         yIyVs/9AFNt1VEZK2smdyJN6qsl39cgpfSkAkKMYXJNZg/c+WQr16/j5qHL2/gvqhpDK
         iFIdKRb2P1byCRnLMkZKbhrqz7QY/GhwJNbxlqEbMj+StdyfwhzbnlzTWjOANdDEtjhq
         FaXA==
X-Forwarded-Encrypted: i=1; AJvYcCWP7x+kdU48aKQ167ZLfylrrqZBvXZd7w80kUUzYnm7ceJDq2gULHSiBLmux3d+RJum/cTuSQX4irzb@vger.kernel.org
X-Gm-Message-State: AOJu0YzczVCxadzAMjznJFOaFuzYQp01phdLkq4OTa5ULyEmUPcF2GIE
	TD7QQB6GskBW2vSO96SLSa4tvSK+xrJFJYaY51j+sDc63qiLgteLGA7fwmVahSZq
X-Gm-Gg: ATEYQzxloCKVqZEIJ2voaY1NHmXvIaS0UHD+mNIivP0hya2yMDPBNXFYnsgDGvehxxo
	4gwWNgdbOCC/pmGVGkGPx+eNEFXD5UXK7K3vDl3poO0zoQnhqW4CN8D6Te1PKSbyoWf3X70JnfE
	u/6am41QaudYJZca17asOT7sbJ+vPNLpimyC61vhDB5GAyA6CVEQQkvX5FEcHjM+ukzzPGmekge
	uNHzayYGdR18H7XEK0NKXMZM4MWoywfYApgXKXn/Hk7Yd5jBYU3bFNqMX0PKj8Nwi+TZN4qj4rA
	K2mZdsz6GpOJGpRpwNsg4R2cRCoTD/7vde1JEUMBsDeRKLTXPfdJrMQleLQf99By1nsosYHeLl9
	Sbqf9hJzZBFfqlqekiyJTmq5WGH9QkrwBrJP35XmUCim08gNW6mH2JSTWRrnAGKAoZdMKHvQM7k
	E8qwBxZpY4lP8uo5nZQgJAbg==
X-Received: by 2002:a05:6a00:3389:b0:823:1d05:1660 with SMTP id d2e1a72fcca58-82a198e35cfmr6353534b3a.52.1773492553664;
        Sat, 14 Mar 2026 05:49:13 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07240f25sm8611358b3a.5.2026.03.14.05.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:49:13 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: David Timber <dxdt@dev.snart.me>, linux-ext4@vger.kernel.org
Cc: David Timber <dxdt@dev.snart.me>
Subject: Re: [PATCH 1/1] filefrag: fix fibmap error message
In-Reply-To: <20260303115637.453629-2-dxdt@dev.snart.me>
Date: Sat, 14 Mar 2026 18:18:11 +0530
Message-ID: <bjgqtw50.ritesh.list@gmail.com>
References: <20260303115637.453629-1-dxdt@dev.snart.me> <20260303115637.453629-2-dxdt@dev.snart.me>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

David Timber <dxdt@dev.snart.me> writes:

> When an errno other than EINVAL, ENOTTY or EPERM is returned from FIBMAP
> ioctl, the negative errno is passsed to strerror(), which only accepts
> positive errno values.
>

LGTM.
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

> Signed-off-by: David Timber <dxdt@dev.snart.me>
> ---
>  misc/filefrag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index 4641714c..d45288cd 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -517,7 +517,7 @@ static int frag_report(const char *filename)
>  					filename);
>  			} else {
>  				fprintf(stderr, "%s: FIBMAP error: %s",
> -					filename, strerror(expected));
> +					filename, strerror(-expected));
>  			}
>  			rc = expected;
>  			goto out_close;
> -- 
> 2.53.0.1.ga224b40d3f.dirty
