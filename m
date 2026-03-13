Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9810939768C
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 12:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773405444; cv=none; b=gDgTOLAzCRX/qvqf98MeCnfG4mzJkl9UVNbuD8bBaLDOtPPMmL+xXoFJKwr7eL8CYKSwSxxSIpFQtmfHXkN9OMz4WqmIPHGw5iaKK0H8BlBxROdPvGJbi4Hd+atKrgPKsvaZTvUxPgSMTIfpA5PPyaWdMtIFPnFhp9fqPesyupU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773405444; c=relaxed/simple;
	bh=fM7X5TA12DpAt8qqtEynfU2Wg88Rcp22AT1zItjryaA=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=mH35XXrBhKO6WdnEKWVLBpxpaBM0RIxLreOCB1iXQ9QNRTjSf7gHuF7d34vkM7TNX7nEYqO9zM+WGFooXFEyZLZLFIDjuSNJVkhb53kslgQ2UpjHVP3VVx8IBxM11p3M9rw0dgLwgkk51YubULrIjaARxvGqHzV0JeRAPROCNco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GaUgXRM/; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GaUgXRM/"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ad9f316d68so10202105ad.2
        for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 05:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773405436; x=1774010236; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ldKaRFlP8XpUPwtacQx5HHn1nICLm3U4gQre7nmBFoU=;
        b=GaUgXRM/Z/+rDW9lB2Nx6G+qFhheo6E7i+bqJgfhHLGDLaock1mgmabr6apwrA1zyR
         14Zf9uIvuPWBTPkx0Pea7gUyJq1TOwI+JulHMr7BW+qvukvHU4zNvS7GeKoEmQruIK1x
         v5Sj9oufjQD4QoySb0KEziyJyMWaQaLnJlRUDZ2itQveCRy2jT5gamz5CS8xDuzgyHOv
         o8utuBfSdLP9xfQ/e+frD0DQtt7WrKd0CvW5J2b0GUQPBi+kC4GLpagAMX6aFQBJoI2L
         th1Vvi2NeZHvebE5QD2rkNqRaH0/3NToox69ANCF1ev4YbcA0OYxg+Od285uZ/qSwlMc
         H2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773405436; x=1774010236;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ldKaRFlP8XpUPwtacQx5HHn1nICLm3U4gQre7nmBFoU=;
        b=GZyrJJipb9nU6yZWelKdW7VA0S16m4sGh3momkYvcCTGCplwPkEYhIGwfjK1aUoOHe
         PbJ3IHJWWUy6/idl2Kt4gaW5c+7wpPdD3qeYilSwpX6/AB7HSnVJ/2daxNl8mXBUY1jW
         VU4AVjaDTGhLZ/RWUoq80jXl8NwMOOT2IUzMmlDrgm1Ulz9ZtobpGqoPh4SUJ613ppJ/
         gfwquvnLAWeSeRqRQo06LWsqM7r0XttbFZHSYNEr0xxaHpjZeagQ4UDCI3S0542KoKcC
         pVUQJ8j0p9bddTK3KClCAi5/RX+BQvmtjPurcO4g+9IS/KyxNc9G0qNiq+0diYZT90H2
         dQBw==
X-Forwarded-Encrypted: i=1; AJvYcCX4kMXOqtmANFFh3mH/AJp4UV2pucoTdK5wtBZ/op3uvDjxrCaL+CMKZe6xpFk5+Mh1ep8p1vrDiccN@vger.kernel.org
X-Gm-Message-State: AOJu0Yzot2r6YgUW9lZrwsWJUWh7kaNzYKFG0Gq4oYSqxUlxAufOl54w
	/DI+2F9/SqtHbL6xq7SVsKCbdTIeJBbn8z5SCPx2ZXj51DdaroxBK+DU
X-Gm-Gg: ATEYQzwnzOMaI5snpVwvKnUIUvQ/fE/0ghq3aBpFxSFP3qohUPtBtGSmUk8zbmERR7e
	6Oy5w9Ns/Go5Pwy0lR6LwAZHcOqwqy231gX2O40ZSoGhIeOcEka/y2mT71etx1Io+C6ngzVerSx
	w3agcl0InxSQCYDemJGV2wLGVE+cfGQqcrW5jtTRqT3IBiI064t4Houup2CBnMCZIb3FC4rxnFK
	2cVmJZYb+oz/pr7irc61DM/GJRBnXMyKVVq4vWj59DwGoaifjRR4noXZ8QfTffrIriEIpBkRyBH
	EzC0Chj2PYrHJO9/G4hm9bd0eN5JoEMAnBiVljymGLXOgzHgirk3Rpkd0X+23ebCL+q1N4LGENy
	ps5PsE6RkaIUTtl7pdExNbSHNEW891f/DR5HrfCaZxL1P7ek3PdarJgkQJPl/+fncvNNqC5ZweP
	TTJfRjBvJ+UXNjv4mlJqbtmQ==
X-Received: by 2002:a17:903:2c06:b0:2ae:b807:da61 with SMTP id d9443c01a7336-2aecaaf6429mr27481895ad.35.1773405436246;
        Fri, 13 Mar 2026 05:37:16 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7edd1fsm30703505ad.47.2026.03.13.05.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 05:37:15 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH -next 8/8] ext4: fix possible null-ptr-deref in mbt_kunit_exit()
In-Reply-To: <20260310130412.3156753-9-yebin@huaweicloud.com>
Date: Fri, 13 Mar 2026 18:03:28 +0530
Message-ID: <pl57ucx3.ritesh.list@gmail.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com> <20260310130412.3156753-9-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> There's issue as follows:
>     # test_new_blocks_simple: failed to initialize: -12
> KASAN: null-ptr-deref in range [0x0000000000000638-0x000000000000063f]
> Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
> RIP: 0010:mbt_kunit_exit+0x5e/0x3e0 [ext4_test]
> Call Trace:
>  <TASK>
>  kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
>  kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
>  kthread+0x408/0x540
>  ret_from_fork+0xa76/0xdf0
>  ret_from_fork_asm+0x1a/0x30
>
> If mbt_kunit_init() init testcase failed will lead to null-ptr-deref.
> So add test if 'sb' is inited success in mbt_kunit_exit().
>
> Fixes: 7c9fa399a369 ("ext4: add first unit test for ext4_mb_new_blocks_simple in mballoc")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/mballoc-test.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ext4/mballoc-test.c b/fs/ext4/mballoc-test.c
> index c75b91ae0cf0..90ed505fa4b1 100644
> --- a/fs/ext4/mballoc-test.c
> +++ b/fs/ext4/mballoc-test.c
> @@ -362,7 +362,6 @@ static int mbt_kunit_init(struct kunit *test)
>  		return ret;
>  	}
>  
> -	test->priv = sb;
>  	kunit_activate_static_stub(test,
>  				   ext4_read_block_bitmap_nowait,
>  				   ext4_read_block_bitmap_nowait_stub);
> @@ -383,6 +382,8 @@ static int mbt_kunit_init(struct kunit *test)
>  		return -ENOMEM;
>  	}
>  
> +	test->priv = sb;
> +

So, I see that "test" which is of "struct kunit" type, is always
initialized locally on stack, so test->priv by default is always NULL.
Hence this make sense to me.

Feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

>  	return 0;
>  }
>  
> @@ -390,6 +391,9 @@ static void mbt_kunit_exit(struct kunit *test)
>  {
>  	struct super_block *sb = (struct super_block *)test->priv;
>  
> +	if (!sb)
> +		return;
> +
>  	mbt_mb_release(sb);
>  	mbt_ctx_release(sb);
>  	mbt_ext4_free_super_block(sb);
> -- 
> 2.34.1
