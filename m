Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD102267B92
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 12:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773491887; cv=none; b=PvGBI9G+mkpcKjdJJuoZ3eDaWjZJnbC3NZA/41tFTsXKzqZ/YfZyLf8eVh+QcGLCWEiRA1jOZrt4oMs6TCo4FTeFskWPbNKysi/GaKkuWMJA+7GYeOtgTmd0qud3Lmvv3nFUvO3f5uaFgSgoFfjX+Sq0fFhsT48r/ghYI36jXhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773491887; c=relaxed/simple;
	bh=ZCEEOaPafHwqurXPsIQo6FGAYZwmjo8ovk+MI94B/gc=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=ct1DcIz7QCPVRmd8I30DHE14mH78gkNHkDtgApg7WNo7jOo3kLr/28gVvTxmkbgwa/CFy8HVFARdJI0raKAkml13DOZBMPd7BExPYWcG2FtA5TQpTR1KMt1oTe6UMk8tpAy9TtugDhmSPGRzhIWKAyEq3eH2exI4blPwQBS+heU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nK0vNvmZ; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nK0vNvmZ"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82748257f5fso2383748b3a.1
        for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 05:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773491886; x=1774096686; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DUPmXXIrr8YRFQoWjBEkUhDJ+F9D+Tn4vdIpR/iaghY=;
        b=nK0vNvmZaPkux4ee4d1GkuuaQyHC4OtMbb1aDkUFBr6xd3Tv3AmKeJwjwuWGoMYvgH
         u6XIb1lDpGjsCHmm5vJKqoA0l6I9TcDjoMknWJTyDk97zGIFpKcbXR1PWU3ghen0rUVE
         wuu83F9lhh1TWX1behi3D96XFX0NIMaGLHpCdbB0nVFXQ3p6nXvBPzR9NO6Qu8WT50yv
         esyBuoOHiM9o6vWIK5B+dQD2SHzJfV5qHlggI+1qdL7blvZe0b58qHTSlDcE0+13NUAR
         1b6EM6thCEbCtEXXxKdmZT29jRIJ4pkmFHkY7qPnXs9SpDBY9/FqQ9uN7sUGnWWf64vE
         npew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773491886; x=1774096686;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DUPmXXIrr8YRFQoWjBEkUhDJ+F9D+Tn4vdIpR/iaghY=;
        b=HWb0NxPMMFIVy4c/lwOLm7CADELacl+SceUmqjQ6jbwQeVzUfhWo2c7q0EyXJZqj20
         czMms9ikoWieDfd3m9OQ6ezc8/uuB8cTzMhC5ciu4hv28Op5XyovgU+uNkvvP8cb+Hkk
         Qn8ZWTEdK9TYtCFm+MxzGvYEHTmqL8rkjKZTnqRAGE7EQd+FAg2haBkaUnFm12Ro7tqn
         odGonBdhi87leGEledFFoqCg9p74U47aCFrGCvwd+0Ff9DMENl5DmeO+rdW2JdFDyDfo
         g8rYkbYlbmUcz/BY9430Ck4T2xe/0FM5fE3GHOZIkXMj39f6aGHKJp4i0+PeDsJnG7Dm
         bGhw==
X-Forwarded-Encrypted: i=1; AJvYcCVkFS2ypTLeFWwoV0Wtz7pSTi9oSsabNZozhSA2dtkIf6ryWdPD3c2ls08ld76LdwBUkVuyhes0oNEV@vger.kernel.org
X-Gm-Message-State: AOJu0YzshNA1JG3kIXw3Dn+klEiBSML+HHmDs13dKoMVopBqUBrrTL8e
	rHdQYoWFcD2r+mu3uQJKfwpCdwfJ7ZF6L8MDl685TrMCMYKpa+EEXGgVj9xwbk+L
X-Gm-Gg: ATEYQzzJQpTqiQtpJ/Cwqmx5E3E84f02WNN5Z0uN/V33LYeVRDQkq3bhl1Oi0nXW9Jx
	RgKjjGuYIS0RD/7zFoG6Bp+hMSh+eLus5uAVYSia2CA5UxIVCWDZOf7mzuSE2ysuN48kbqMQ2tS
	HMKO+6jMZbnz43ZyTn8RXDyIJpuro27KvvEIdNOvGQ7ZfANQ33BeUfaYPZGv6Ov70mtALN9DrdV
	YuWqfAM6MzucKvAEyBB4Xuxdi7YEVKnhbL5Gk+KJRBpD37X3+OOtSiVKkaifHL0yPvFcjLkcGgr
	P2j8DGE5+BD2v6/IFP3C6I4XBK8Gs2PiItCyqdQs1bBGWdU0XWOuZ+qQqfg4/unejDw1lhpz8OD
	1HlXQru+9GaTgd7sbgrconXcJk/n0trZcXuQvxrnTiPkSfRl7kwUdTOlHbihNpcCGSeeqKj0S9k
	Dtn42cs9m02i3l+AW78Sdmyw==
X-Received: by 2002:a05:6a21:504:b0:398:9e47:f5e7 with SMTP id adf61e73a8af0-398eb22534bmr6296836637.31.1773491886165;
        Sat, 14 Mar 2026 05:38:06 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73ebaa4338sm4080094a12.15.2026.03.14.05.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:38:05 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH v3 5/5] ext4: fix possible null-ptr-deref in mbt_kunit_exit()
In-Reply-To: <20260314074903.1314851-6-yebin@huaweicloud.com>
Date: Sat, 14 Mar 2026 18:06:58 +0530
Message-ID: <eclmtwnp.ritesh.list@gmail.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com> <20260314074903.1314851-6-yebin@huaweicloud.com>
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

LGTM.
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


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
