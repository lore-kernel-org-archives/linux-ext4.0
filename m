Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0433737FF41
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 12:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773403971; cv=none; b=RVRqKIOB4nWMrl9GrRZ4mNCY6BJWrUPxY1nsYMJR6SQlIUDsRpx52Omde8sFCRRR8T6BsnPNY9rDkH36aA52IP7tej7kn1ubOQXRwT3APeh4seohwiGuTZX4TiF0AY+8hnH8IrZtVSPGv+NcUse8Z30yM+M9baM5KN8HBmDkU7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773403971; c=relaxed/simple;
	bh=JP+CFHBjv3YuDTMJkMB/00fDHpNmzRs3nZReLzGHFw0=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=j8EBknqGHzin62WD/iqtwV5Y81zI05x3c619c0xAP0ZC89nfDmSelsOfb4dWKbB+e0P49+ekhduFgK5uOEI0BmMHEjKESNz0fkFgo8GSFW+9E5zZ5LVLeC8kXc6LFnXYz2SKYgFIQHUYfNTPdIayR+jUJ1B/bYj+vaBWshNFALc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KPf3q2uA; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KPf3q2uA"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2aaf43014d0so14087715ad.2
        for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 05:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773403969; x=1774008769; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jaloUKqRHWC1bPqdP4FMixbCKBzohPVj59nGROhMWNY=;
        b=KPf3q2uAE3Mhbu5HEDTjA6ySuzKh6uf9UFYC2GXbSt2mYxAE7TtzuiUbICjFcAxSYs
         j0rQJhsqbJRZNPG9+edCR4SUCy8IIt9ii6e6nUmqySFyodC4H+c+bCc77ZqQWChhcm5E
         xYX2Pns66bOQTVC3seXqvSVfN8TX1z6yUE+05XN31RJ8UE1JJu4tub63uOWh6WjwjeUO
         CnsU6IVBiH++X3FIOyKop7+U13Mllq3U8rv5Gp77KHOfEMWdQBxFO3deD7/KyslnLJkB
         EhjqAsEfUZaBv/bUGKJjk5CPkR8UQYJu4xUPj7mrMxLVRDi90Uxzk1OZfZ7pj5BVZCQy
         PEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773403969; x=1774008769;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jaloUKqRHWC1bPqdP4FMixbCKBzohPVj59nGROhMWNY=;
        b=kFjnjgfdh0Ju6d0nCKVdM6EzJYEVfkvBKyrRh2e6VtamuQ3nuUrQ6a5uCYhixbxraC
         owWiIAwJ0I0695wH9Pt/nLvjzMMQuGJbE61iC9A/t7gHiiHzbd2XiOqsQg8wkbCYtqq7
         5wm+5CrImY2ZFUf1oE+HGB16tgTWnGnxykAHhnxGn6iKP9qM/2itxjotVBQmQuSwKC5Z
         16ku0uL5dxv6EiocnPxadsibqsgLWlqFU3+82Ho1EvZ4NqmK25DM3GB0voxAwZ7jnLTN
         iJuw4aAgbnKxOwckBR2WOQ+WMj0GKIf7DXCBSc08xf2R/wconwW5nqbJ0V40ct1PrUYk
         H22Q==
X-Forwarded-Encrypted: i=1; AJvYcCWpdIVyWSG0rxWy07v7GxxoifS2N2A71zZc5LXh6vlmCwwRsIwWL0pPxy01tEG/FA4gJtJY9W9fEFE4@vger.kernel.org
X-Gm-Message-State: AOJu0YyU1ZyHRAq1MltdBr/DbooRLrPTMxVL/KVaTDwxCIAtkparWxpE
	3/Fuhw4kAp7JGm1m0bgbGnqJUKfOf7wCpqypmUD44fQHNvNOkRq+sryvJU+ZXt9A
X-Gm-Gg: ATEYQzxEdiiflHxYTkdM7tCZAg8Dg+YJA1roWnf7M52bcMi2C88lKdlYvsf+gL8fFoT
	clFlyGOgfHXUbatVJANJG2jbbuSBF5NNkjHlNpKw/DSdQef+2L1rhSK7dksm091PTFXgqEhADfD
	hTt+o2LjKMj4hajZTWJejNEI89LXAQ0IkNF4FNRaXD2ouNC2XgppOI8JoGI85EpvWW54+Nss4J9
	YePCU5iucRx4R4ZRHLQfC65OTDJAI6xEq8smDzzByMYy4Ey+b6ZMschtBF6TcDVrm8db0+0dcAh
	p+pkbCLOAm7Da0mlnkdVmRAmnd2/Xvvr5ygV1eOkSaVSLMuTVMfqvW+RYm3iiB3aR5i3HmDhooi
	oOQ+276wwyQ/smg7zqN5K5vOpR27Qm8vl5sUgBv2IkIwZGOVOkSUIopxqlT6TkxKlxL5Ye5fIUD
	y8Kic22xo4tjjs6l+E51/S1A==
X-Received: by 2002:a17:903:2f8c:b0:2ae:5745:f0e9 with SMTP id d9443c01a7336-2aeca940e65mr30991735ad.3.1773403969084;
        Fri, 13 Mar 2026 05:12:49 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece56c097sm27676675ad.14.2026.03.13.05.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 05:12:48 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH -next 5/8] ext4: fix miss free super_block in extents_kunit_exit()
In-Reply-To: <20260310130412.3156753-6-yebin@huaweicloud.com>
Date: Fri, 13 Mar 2026 17:33:15 +0530
Message-ID: <tsukszr0.ritesh.list@gmail.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com> <20260310130412.3156753-6-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> There's issue as follows:
> ODEBUG: free active (active state 0) object: ffff88812f2d68a0 object type: percpu_counter hint: 0x0
>  <TASK>
>  debug_check_no_obj_freed+0x3d9/0x4d0
>  kfree+0x2bb/0x6c0
>  extents_kunit_exit+0x65/0x90 [ext4_test]
>  kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
>  kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
>  kthread+0x408/0x540
>  ret_from_fork+0xa76/0xdf0
>  ret_from_fork_asm+0x1a/0x30
>
> The above issue was caused because the super_block cleanup process
> was not properly performed.
> Therefore, deactivate_super() is called in extents_kunit_exit() to
> cleanup the super_block.
>
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 5a5016ea1ecc..70d84c0a18e2 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -144,7 +144,7 @@ static void extents_kunit_exit(struct kunit *test)
>  {
>  	struct ext4_sb_info *sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
>  
> -	kfree(sbi);
> +	deactivate_super(sbi->s_sb);

This doesn't look correct. We don't have sbi->s_sb->s_op->put_super() registered, so
kfree(sbi) never happens. Maybe it will be good to check with kmemleak
too, that this could cause a memory leak.

I think we can do:

  ext4_es_unregister_shrinker(sbi); // already taken care in [1]
  deactivate_super(sbi->s_sb)
  kfree(sbi);

[1]: https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/

-ritesh
