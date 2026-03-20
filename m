Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF722E0B48
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 02:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773972260; cv=none; b=JgkDG6uTv1UviPQa7Ayvm6/orVp9aOZS+242sVIjW8sd5r6pKKsH2BkBvrXubAKL8mDWdv1FozfllgD4nkZH1r/KkheYOWlMEAvlYlErq7A/GtP5FxWE2L/ALFiGY51VnT2b93ohdH42/OrC+HNh3kRSHaTxHj31eZ0vqBU1lAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773972260; c=relaxed/simple;
	bh=e4O1qswBHehoONgzt/B78p8L7qGsD1GJlEIlnfElYKU=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=pX9oHS466UZb1uH8gRb6E+ZPvoYDT06p37lcq2J3W3V/s6AbJYGsie9e6P1gJo4ttkJK0DXtP6L5/FcJSI4YM307+meJljbGIXahBOGRKwdvcS0e9Ew/ZtytZB0hFn3iqWO2p7jKcvypuZMWjbDBpVPnsYI7RIWmWncpCyWn3P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TYy2JbrR; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TYy2JbrR"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c73fbdd9b53so530124a12.3
        for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2026 19:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773972255; x=1774577055; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DHV98jkPPJadyUUgPILk+xa8pW0vORXFLXmtPXYqpRw=;
        b=TYy2JbrRAyRGLIuLOc8e+anbMYugfNI9wkLH6pwTrFF+47VUkPHU3HaHNlg+FqAzRs
         3K4/uanC0BuhByawLQ2AwNAUlIswjHD0zPD6OCYq9+khIOyK/CQelhahLdfrJ6FQXAXS
         3my26vAy9mFztHVPsnz9OlieoxzP2lkTsfJSNZQhvU/DH8ocazQdqSmK1ycEZRWS+qj0
         GBiREN9TYGWTsb3gDAPHymDyCXuYmKvfgX9Ud54JRhxc0R3yu5/L4r2YMoYeG7XahQzE
         3JaS/12LRIph3Qp/eY60F2tzfR2Bkn3wSUpQk/OOR+fpq/v5fzYzh2rAjDIr+jk8H6kX
         Toiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773972255; x=1774577055;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DHV98jkPPJadyUUgPILk+xa8pW0vORXFLXmtPXYqpRw=;
        b=lBa68QaCz7CHPwIDmK8udO4GdmRJlH5J5ktksqmaLrNy/nNxlRdVUU4sw9TfEOgPj0
         qc0UtXHrKebb//178RhcjRhXVy6xIsFwIeBwoNr14Dmu6RinyJa3tc/7U+PsUtyGpZue
         7fEERZgss/cp+txkgLFw0+6kkFKFd6uvnzYsB/ThV7yHEPrvSOYa3ed+vVcoDih5bXfY
         TNvNLXwMEQm7nDe/PJ/KAWw4aXpTAxhZPCUN5a8buFCjGUqc3/OEQ0BjNXy1q/NWmyvF
         ADCkwP+tnHgL2b4KHXIghWB3i1cWKRq8cW/jKorC/n4a6EwAJsVv0Zw7JxBP5kKeABdp
         KS8w==
X-Forwarded-Encrypted: i=1; AJvYcCVDvl0YN4a9LrZTVvYqdM8A2QkpuynKXeLV9NSkZadXU2MIQu/yVJ7UECdPMUl6rVlX03GgV2wbnFiJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzGek9FReClA7BsqRuMmM20wQ+D/S/JgGBJSccQ1UfHWD3cBbbp
	+vnMaH+vOX50IvWQzu2cvOkOgak5Q03ChthHO2S7MVssylGowhJg+NZXjyIuEQ+S
X-Gm-Gg: ATEYQzzvSG+gxd48qjdd7H21dlvpahaV6XVMvj0cn8yRZfPSTRymf8EAM5dR/bZsjNM
	7/62FrDU+NuGyXO45ERGPcQyJSOUEDbmO1NICTWog1IUIljNfWLkoiE8ighsIG68Vx3VDX6LF5X
	dJiWPaK4PeaKhrZQnzc4iQk+JYUhgcnuMZ1Zlclo922X6orT/w8JI5RdalqCzjw515wgDzHj4B5
	v7GUUH0KDjWVe0LmUbfaWCVH/IfPcnGsegexDxlbjjP87aXdqHfvghBm9IaAN4BobMDRhTyL+z4
	tbBL89SJhzmFPGj70aJKxC1np3mA57+FOEAGK4ML9XVk8/vQcO0Vb6wKb7ITMOslPMIlWPa42Ws
	FYX7Jb2kVQdY/WS1Xo2BNutIibuvUTRh61AXNAKtlq6uCviSLt1W1LR2tJ3NVX9Qf6Gq7oAS2oZ
	QKdR7exUKjJBWtuksor0RamA==
X-Received: by 2002:a17:90b:4b85:b0:355:35b0:8b78 with SMTP id 98e67ed59e1d1-35bd2d105efmr872355a91.27.1773972255362;
        Thu, 19 Mar 2026 19:04:15 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd24f1b9csm305196a91.0.2026.03.19.19.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 19:04:14 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH v4 3/5] ext4: fix the error handling process in extents_kunit_init).
In-Reply-To: <20260319125434.333117-4-yebin@huaweicloud.com>
Date: Fri, 20 Mar 2026 07:26:08 +0530
Message-ID: <ldfnxo07.ritesh.list@gmail.com>
References: <20260319125434.333117-1-yebin@huaweicloud.com> <20260319125434.333117-4-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> The error processing in extents_kunit_init() is improper, causing
> resource leakage.
> Reconstruct the error handling process to prevent potential resource
> leaks
>
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  fs/ext4/extents-test.c | 43 ++++++++++++++++++++++++++++++------------
>  1 file changed, 31 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 3d4663d99eb1..4ce3f81f6409 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -225,33 +225,37 @@ static int extents_kunit_init(struct kunit *test)
>  		(struct kunit_ext_test_param *)(test->param_value);
>  	int err;
>  
> -	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
> -	if (IS_ERR(sb))
> -		return PTR_ERR(sb);
> -
> -	sb->s_blocksize = 4096;
> -	sb->s_blocksize_bits = 12;
> -
>  	sbi = kzalloc_obj(struct ext4_sb_info);
>  	if (sbi == NULL)
>  		return -ENOMEM;
>  
> +	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
> +	if (IS_ERR(sb)) {
> +		kfree(sbi);
> +		return PTR_ERR(sb);
> +	}
> +
>  	sbi->s_sb = sb;
>  	sb->s_fs_info = sbi;
>  
> +	sb->s_blocksize = 4096;
> +	sb->s_blocksize_bits = 12;
> +
>  	if (!param || !param->disable_zeroout)
>  		sbi->s_extent_max_zeroout_kb = 32;
>  
>  	/* setup the mock inode */
>  	k_ctx.k_ei = kzalloc_obj(struct ext4_inode_info);
> -	if (k_ctx.k_ei == NULL)
> -		return -ENOMEM;
> +	if (k_ctx.k_ei == NULL) {
> +		err = -ENOMEM;
> +		goto out_deactivate;
> +	}
>  	ei = k_ctx.k_ei;
>  	inode = &ei->vfs_inode;
>  
>  	err = ext4_es_register_shrinker(sbi);
>  	if (err)
> -		return err;
> +		goto out_deactivate;

Even though the patch looks ok, but still wanted to check if ... 

Do you think we can move ext4_es_register_shrinker() before setting up
the mock inode and on error we simply return err?
That way, there won't be any ambiguity in the error handling for calling
ext4_es_unregister_shrinker()?

>  
>  	ext4_es_init_tree(&ei->i_es_tree);
>  	rwlock_init(&ei->i_es_lock);
> @@ -267,8 +271,10 @@ static int extents_kunit_init(struct kunit *test)
>  	inode->i_sb = sb;
>  
>  	k_ctx.k_data = kzalloc(EXT_DATA_LEN * 4096, GFP_KERNEL);
> -	if (k_ctx.k_data == NULL)
> -		return -ENOMEM;
> +	if (k_ctx.k_data == NULL) {
> +		err = -ENOMEM;
> +		goto out_deactivate;
> +	}
>  
>  	/*
>  	 * set the data area to a junk value
> @@ -313,6 +319,19 @@ static int extents_kunit_init(struct kunit *test)
>  	up_write(&sb->s_umount);
>  
>  	return 0;
> +
> +out_deactivate:
> +	kfree(k_ctx.k_ei);
> +	k_ctx.k_ei = NULL;
> +
> +	kfree(k_ctx.k_data);
> +	k_ctx.k_data = NULL;
> +
> +	ext4_es_unregister_shrinker(sbi);

-ritesh
