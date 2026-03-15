Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D5236E462
	for <linux-ext4@vger.kernel.org>; Sun, 15 Mar 2026 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773590122; cv=none; b=MO6qNXgnr+cdOTZXH0qdRAZ3h5Z0hXwc9J8z2Q6U/IHqKqrd3U823vxDQkBWYYiKIvlqK9eHEqtEKK8vJTqjYInM32SxTx/2kCEqNZLocUp0YRRkmTWYk7x8mZKh8GdNg+28paE2OqJ06wchhr1jQRJr6Am8mUjJgVNBkFjVjW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773590122; c=relaxed/simple;
	bh=2qTLxckE9oMDjwMxGCBaza0lbBYLuX0cOOAxPmFeG0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ogpyK1vQleZvyST8Ao16uldZ61hD8HprUQ41gXwopR7hUvPGXu6KNirZ/cqw6QblQzUFT/zE8Pn7VeXqPDv71LAmAyo80MERNpyv4EqqJmmXWfB5lu3ObnXB3DSCvG+wqx5J13WYIhbVKz4HYNMG5AuvD9d7Yxv/dwCAcvRJ9uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TEZCmtp5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=F+2ZAl0y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TEZCmtp5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="F+2ZAl0y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773590118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xQ3rAvJPMukjRlEJsiY79XXn5O5j6UdqZxcxui6ZZRY=;
	b=TEZCmtp5XdXy37uK8/+x0d8O5li6Wed62J8h1pxFmJnWVGiSh2dhgOFOaZQz81Oa/IA1gp
	pgTsZhVa6FZp4xRI3mTxgM2MpHmB9U/JlS+NPgzNykviJKT2/two7ShTTH/QENAz6h6hB6
	nkHsvSMP/Gn4K+Y1SGZAkoFDpTtBP8k=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-wAqYyiv9P1WZJT58VQdHkw-1; Sun, 15 Mar 2026 11:55:17 -0400
X-MC-Unique: wAqYyiv9P1WZJT58VQdHkw-1
X-Mimecast-MFC-AGG-ID: wAqYyiv9P1WZJT58VQdHkw_1773590116
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2aec784479cso223795195ad.3
        for <linux-ext4@vger.kernel.org>; Sun, 15 Mar 2026 08:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773590116; x=1774194916; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQ3rAvJPMukjRlEJsiY79XXn5O5j6UdqZxcxui6ZZRY=;
        b=F+2ZAl0yeFz29YJNQWKx8AbT6mMBx/3iserbsufjJib9A5R0ZiGwyfe/0Y1T4x6Afe
         v94+LclcBsr+V85l0yfk7jswguN//VMErIiTu55GvEWSdWSd8W8FqH1PteOm52euJt8K
         5u8koHdOUZ1pthQguz9N/95OOVqhzrFEH/Y3NXmpU3v1Wrv0sPzw2WkSoI5L/WVVIcyP
         q1zIkDyadboWs/gSLaFwX68fXVTfY2d5MOOIA4oBl1J0UCG+dRABUNaVGgvG8CdmWk7H
         rRwu+T3DMYYR4+qMPfHIFtwo/21IkZiouqgEylXFjq76Tqz0XtikKIau5md9+Yssmar2
         cRkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773590116; x=1774194916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xQ3rAvJPMukjRlEJsiY79XXn5O5j6UdqZxcxui6ZZRY=;
        b=ktsLgI7Rba7hmruEjKN3rAQEG3v2cFQgxfQjomqHgr1c0XkdAc58W9j8VBtzBx3o9j
         xw9J9nlceBcG49NAtjlMcyC3tfBwCrfR+gvwjP2EuJKzW7m5Ek2H94cdrPI4dvtDW+1O
         kCwKQAIBm5Ud67NGIZ3d6XDJPF2tRZClLck/du1E/XqzZcgHLBJzIFuYiGINPsiubeRX
         bmtBE/+et5IJHc8koL11W7U6O35+UFMkdeo/iR22V9tuesJBMBZ7x6AgVfw8lnzaOjGP
         QNm8GtPQeFjPVbt71SIyCE05EWIOT9aJ6IY72YOa7+fKmQwKCHLoXDLr/vMRayokpQGh
         jzHg==
X-Forwarded-Encrypted: i=1; AJvYcCVOPTCQlqU25pdl9ZGxbKanWou6BqnIrxSCVh+XEnD8JeKzN4WGXh1QLfuS+v5I0x6Jedt37SIy9ROm@vger.kernel.org
X-Gm-Message-State: AOJu0YxNAOEH2IIHLUl8uWK/jCVqp3rO22fK4VR2gQQ7/GJsL1TnLSOZ
	NR5k5gS8rfYzl9sBqLxTumwicAicyECv8NK6mgAjXWOml81hg/A0Xx4dH9QjqF3VYSbRzCuXPSB
	tXRlxK2c3c/N5HncmB6HUDYiyykCfNnrxj8bbI05Bq57sLClFXCUyHJZg+xBpL5w=
X-Gm-Gg: ATEYQzwdPPD41quBWDG09BhTvkNuaZQ64ArXV7bUNi2/FOW3Lck/ECN7v76ZXlioD4Q
	bZtjr2gebVViijuGitP3y47OU10Oyg21ZyLOO0/8vMQZsU3aGJlmewKK79Qq6Q0N/s+VYva/EdT
	rFlt1k5Czzf5jTYJrAPCIblyPqNxF1PWdVOMuRm5ppi3rYrNPtno+BXXzAaEajQl8PnefjWI4A1
	2ytq2WYTeFivLORFStnlha7IqQ6WLWr0ftu6aVBOfb2q8SlAgo8obZv0xqq5fe+XyVBFrdQS+rF
	ZLvcqQatzlebf6Hw5gmIXQykg7OdNUhO9uQWNkq5bncWO2CBM5zxcspwA3deunlJX/3ZxY6c+rw
	LB7nIS3OBTFaacI2TYg==
X-Received: by 2002:a17:902:ea06:b0:2ae:4b91:8407 with SMTP id d9443c01a7336-2aecaaa861amr105927355ad.34.1773590116469;
        Sun, 15 Mar 2026 08:55:16 -0700 (PDT)
X-Received: by 2002:a17:902:ea06:b0:2ae:4b91:8407 with SMTP id d9443c01a7336-2aecaaa861amr105927135ad.34.1773590116029;
        Sun, 15 Mar 2026 08:55:16 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece62c701sm106718375ad.37.2026.03.15.08.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 08:55:15 -0700 (PDT)
Date: Sun, 15 Mar 2026 23:55:10 +0800
From: Zorro Lang <zlang@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>, stable@vger.kernel.org,
	Akhil R <akhilrajeev@nvidia.com>
Subject: Re: [PATCH] crypto: tegra - Add missing CRYPTO_ALG_ASYNC
Message-ID: <20260315155510.myp3i7jhzs654zr2@doltdoltdolt>
References: <20260314165515.9678-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314165515.9678-1-ebiggers@kernel.org>

On Sat, Mar 14, 2026 at 09:55:15AM -0700, Eric Biggers wrote:
> The tegra crypto driver failed to set the CRYPTO_ALG_ASYNC on its
> asynchronous algorithms, causing the crypto API to select them for users
> that request only synchronous algorithms.  This causes crashes (at
> least).  Fix this by adding the flag like what the other drivers do.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Closes: https://lore.kernel.org/r/20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Cc: stable@vger.kernel.org
> Cc: Akhil R <akhilrajeev@nvidia.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Thanks for you quick response, Eric. This fix works on my side. With this patch,
same reproducer can't trigger that bug anymore.

Thanks,
Zorro

> 
> This patch is targeting crypto/master
> 
>  drivers/crypto/tegra/tegra-se-aes.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
> index 0e07d0523291a..cb97a59084519 100644
> --- a/drivers/crypto/tegra/tegra-se-aes.c
> +++ b/drivers/crypto/tegra/tegra-se-aes.c
> @@ -592,10 +592,11 @@ static struct tegra_se_alg tegra_aes_algs[] = {
>  			.ivsize	= AES_BLOCK_SIZE,
>  			.base = {
>  				.cra_name = "xts(aes)",
>  				.cra_driver_name = "xts-aes-tegra",
>  				.cra_priority = 500,
> +				.cra_flags = CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = AES_BLOCK_SIZE,
>  				.cra_ctxsize	   = sizeof(struct tegra_aes_ctx),
>  				.cra_alignmask	   = (__alignof__(u64) - 1),
>  				.cra_module	   = THIS_MODULE,
>  			},
> @@ -1920,10 +1921,11 @@ static struct tegra_se_alg tegra_aead_algs[] = {
>  			.ivsize	= GCM_AES_IV_SIZE,
>  			.base = {
>  				.cra_name = "gcm(aes)",
>  				.cra_driver_name = "gcm-aes-tegra",
>  				.cra_priority = 500,
> +				.cra_flags = CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = 1,
>  				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
>  				.cra_alignmask = 0xf,
>  				.cra_module = THIS_MODULE,
>  			},
> @@ -1942,10 +1944,11 @@ static struct tegra_se_alg tegra_aead_algs[] = {
>  			.chunksize = AES_BLOCK_SIZE,
>  			.base = {
>  				.cra_name = "ccm(aes)",
>  				.cra_driver_name = "ccm-aes-tegra",
>  				.cra_priority = 500,
> +				.cra_flags = CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = 1,
>  				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
>  				.cra_alignmask = 0xf,
>  				.cra_module = THIS_MODULE,
>  			},
> @@ -1969,11 +1972,11 @@ static struct tegra_se_alg tegra_cmac_algs[] = {
>  			.halg.statesize = sizeof(struct tegra_cmac_reqctx),
>  			.halg.base = {
>  				.cra_name = "cmac(aes)",
>  				.cra_driver_name = "tegra-se-cmac",
>  				.cra_priority = 300,
> -				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
> +				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = AES_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct tegra_cmac_ctx),
>  				.cra_alignmask = 0,
>  				.cra_module = THIS_MODULE,
>  				.cra_init = tegra_cmac_cra_init,
> 
> base-commit: 1c9982b4961334c1edb0745a04cabd34bc2de675
> -- 
> 2.53.0
> 

