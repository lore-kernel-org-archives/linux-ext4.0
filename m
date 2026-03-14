Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4014F881
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 12:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773490874; cv=none; b=VnWe1Y6ZcedkFK3UKSgYGK17PhAECt2B6k9b005EvxwW/C4SIp0kRjS2Xweu1ZP+aVzCG4XkrOnuHNH69EcKAqoO2t2vOwoBAJV4E8XVL0zPHO9U3QA3vOTdL2iIVV2aHwfMvgVTEqdSXCBAQUKcwvFi34spr6F/EHVGgYtmsaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773490874; c=relaxed/simple;
	bh=+6ml1C2KvRNXRxPEHcQmr1cUrOR2OkSmgi0bMb30TjA=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=oVtKjNi+LMf5+UoffYgcyFRAlLy8Q3BF7XTECv1CrZTKlhOAHQmPs+HNO0LDGnOqPnD+WBl0ypYVuecs2HNz0n0Uv1NGg5ETFG1CXBAelbP30pU0t2qYlkssFKLDYwFFUliLhnL7NS/Sp0vIa/A7ycGRu5eMVazUo5lG49ANAqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J3ifoi9D; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J3ifoi9D"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82985f42664so2029269b3a.0
        for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 05:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773490873; x=1774095673; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lvLIYM4SgRPQEZjyXICCgMieK2yQ4yjpdMgVIh9TMK0=;
        b=J3ifoi9DQgnKMd+E6NkCUNSXl4srOR7boDFErdcClJS+02PLWVh6WP9EdlE7qGJadb
         X0maY7mxhcFu/5+P4rYYuB0+z/Csf03lFtYSlt9UyWVHnLGJ3K298a+MRYNIoXO7dnPU
         j1l/Y5g99aK04rgj+HvDazFO5zNPCc/DyJz3IDEhpZbtaIw7wKpT+MHCLy3SH/haoqnh
         C+9iUWRmvd8KQoOQk1wT4d9Fx5k2DNgsFW/6ShwMLO/BR7DzOvGmwiQcnxKoQ2i8ivXh
         XSkHo+2ODsknVGy7nQqDBXS0FLKiKQLtMfXPwnJzYfbrEGqs354/tWdPggmJ96tyf9Qi
         GCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773490873; x=1774095673;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lvLIYM4SgRPQEZjyXICCgMieK2yQ4yjpdMgVIh9TMK0=;
        b=Qe9sxM/xwuImW5mgkY1VeE3iOT2f6oR2uILHCpRtcToygcz9fpxdg/ksgs/qrKc+84
         PwcUNZdrg9aty6nmAjrVAPoXowguyCiRvfO/XqKlORBbPNBEzNqrj579st0rD3Brtk8w
         iQdyFgWFgeVFhShlbXcTnnHXv/9lfQUSc9EH8jvBrgA5kEPqPLPANp/0mBBNX1QaVb23
         gB9u2vZITIhrH2zk3DONrwaCLCtsL2/84CZD5md6/aJWFyuUos9xpHlTuktgmMzojVe7
         h+ebvx/7ZWVQxVdRJE+1FIQ0vbcnhNgmuYPsLUZbRdmqtF0RFC9gAfqx8KXlZ/fDJUzB
         n+Xw==
X-Forwarded-Encrypted: i=1; AJvYcCXw9+VkslIJUl5GV1z+IMf/K97Khp5unCZLpgDZCNr4VTXc3TtRuCrkq15g3nv/SHdcZyN3xQ3MqaKT@vger.kernel.org
X-Gm-Message-State: AOJu0Yze87hu0QYtJErfKsR9NygosupLsq9i1+ltbLqdGhAQiE79bER+
	AYpeBIF+Y5DZDEP5zIDBV9+O4Gom6KTdCx92BANAAiNCr5kd4mKzLUwR+srmzXvj
X-Gm-Gg: ATEYQzwrupxZlTHqHDcZoJlTPktMOqUlcJkJ+LMEQ635ohqQ1TSxOV9W14jg3lSdXTn
	1yxdnl7wl0ywo3q/Yqpstx0n4Vib9/8BOeMd3Z57Btw3dq13JzAsvFRhmZl4o/1/L0D/yaVSLML
	lnc8QOM0rK8waxUa7SwORWliMnzoJs3mgKhYUb6FemE1bLVF0DHN0/Z0CNe7dCDsU47QrHuBNCH
	Uqi7GY8SsoFTlQY5Ob2S0Se1mgtVPxdMhpxoaxkLOcSIuo//K3m6C/rmGqnbaklTkeQ07dzbO/V
	Z0Djip7K1yRTZwUQOORKmWgDje0X3C0Ei6WQ+4WMBmP/SFxyk3mfpeYv3bLIz+mBSMQ2ClJc7to
	VgG8AuEGBKV3lPJfQCslhxg++gD3qu1FugEIoXuUWx1/fnUWEV9//cNfICW90qFhoD65FdM6RTQ
	+tGCr8wtg/LoDdbTa95X+xFA==
X-Received: by 2002:a17:903:37c6:b0:2ae:aca4:b163 with SMTP id d9443c01a7336-2aeca941df4mr70908725ad.7.1773490872625;
        Sat, 14 Mar 2026 05:21:12 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56cca6sm56973705ad.3.2026.03.14.05.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:21:12 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH v3 1/5] ext4: call deactivate_super() in extents_kunit_exit()
In-Reply-To: <20260314074903.1314851-2-yebin@huaweicloud.com>
Date: Sat, 14 Mar 2026 17:49:02 +0530
Message-ID: <jyvetxhl.ritesh.list@gmail.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com> <20260314074903.1314851-2-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> Call deactivate_super() is called in extents_kunit_exit() to cleanup
> the file system resource.

yes, since _init() routine call sget(), we should call
deactivate_super() in _exit() routine.

LGTM.
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


>
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 5496b2c8e2cd..e3d23e3cda87 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -146,6 +146,7 @@ static void extents_kunit_exit(struct kunit *test)
>  	struct ext4_sb_info *sbi = sb->s_fs_info;
>  
>  	ext4_es_unregister_shrinker(sbi);
> +	deactivate_super(sbi->s_sb);
>  	kfree(sbi);
>  	kfree(k_ctx.k_ei);
>  	kfree(k_ctx.k_data);
> -- 
> 2.34.1
