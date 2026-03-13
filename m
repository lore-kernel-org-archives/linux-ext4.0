Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5696F2F2
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 12:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773404390; cv=none; b=E6fKGjNj9Dyu/T1SFa7iJRl1d+2NF7lQTARRNu6iV/tqUPkoWQLcqRw4wNMDk0EERuTsE8Uc1N3Z69He5lAr80iFN0KPz4Dnkjd7Oo0RYEnJLmSaPn9aB20+B0ECpIDDws60KYezcZsqSALCbOsQAa/wI6lHG7WKkMuOCLOABzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773404390; c=relaxed/simple;
	bh=2ZUbXDkfPO8sX0b7dfjmfBbcDiOiEHVrsn5bHIB+HK4=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=Dn1yDM2cTmqVMo8UJvJxlnQAQDvyzAmikluQe0e9kr0P/iv9aOmEtmgozPDbO1AWns/SeNOS6/I/gT8ChqouEhhpBj7IiS4ZMYAN/F58r2NB0lWNBaaFNF6ginI/RwXWeKeuYuz7AI16jX9SzlvOb7tosal1OP+ajVG7l0EC/Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fw0XKsLr; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fw0XKsLr"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35b85613f3fso28062a91.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 05:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773404388; x=1774009188; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+mcbukWYQZGQUnQis+jn1EbShRtU/mN5zw9g90A1hyo=;
        b=Fw0XKsLr+nIZTSngMfBvcQKWB4XyB6qeoViCWrgnMnEV7F2i/Z1YH8AdJygO/HSdl8
         tPqEYh+YSRF70HMukB75DktSA9dyqiD0+Ww02AL9HeGP6/4TG1zQ/XcdjvnV9UX8y0pL
         2G8lHheY6unorrYa6gcOr9oX7iwaKzzwkpVZI3MfkV7cdc0Ao7bWo1H85NHwOCOYzN6b
         OEsXN5pAR4n7Y/F7m8Xd+qzhMNi0gRcXq+3p7aewzaVhv9l0BSNIYhNd0L00z0VPCFR4
         Im2KmB7YruxxQhHh+WXEcoyDYEbB5o+U5ZUw0AKLQep50Xy1pZ+vidcK/Bk437SJHp04
         PIdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773404388; x=1774009188;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mcbukWYQZGQUnQis+jn1EbShRtU/mN5zw9g90A1hyo=;
        b=XwZA+TEnHPc1by3MONvC1z2FMWv/mdxSwZgWiYUEaJcsJnoAQuJeibRLppk2WHUC86
         Ho0J5mEqyHgvC0GmQkPt9ZjiHoDWifF6okcPyQt4YRN4jFqUSrXEXyvECTcWO0gcaFeu
         9yzGw8xxzQXxEWDoQL5+iRBZKgl7xgLyEzShPXk1b6CdQeNjlzrJnm3FeqNZca9/kTK4
         Ut52g+PXdPEEsJLJegoIdIrHrtrm8UD6VOER2MG8ph+ZsYn4S3twEE/RAy1kmskOYAGg
         nW5F28RqNuT6RCVdrQ42SKwfny+xTnpyvDaCWWnUVxvN6w7CnvBctlqwcj+pgyCrgTox
         zC1A==
X-Forwarded-Encrypted: i=1; AJvYcCVKOPDFXtRZqAOJn/DOn8rgZKqlvNhFr/BxzcyExVcwci8IlSReJa9WHst5cUY/q628LuSmnKGgXUZv@vger.kernel.org
X-Gm-Message-State: AOJu0YxCN6hsUm8s6WTx3MDrJFTNpxDmvFKwRD3Qyk9l8JCCrmBRy1TT
	8qlOEsUnjVE1ilFSETThgD1qNt7sAX7QGpO6XIbb1tBePAbv9NpVK5Mh
X-Gm-Gg: ATEYQzwpQ0H++LaLhKhKqE9lZt/UyTY4MCYi8LhDqWYzQtOLJ6sXH9KQtBD5LrSBKEw
	dHn+6CvsdHUFQWz1yyXQ6i+9iZCxWWcL3EMFW4Cwg8QfHeHGi/rx5Oagd4SXl+KqsoHEsMsVNfC
	yLa/45e9XAZiDhwOhWDhuCWi30PA/j/dnj01iyanORpjS0ivzrV1DRT31Wp6fgZMzMF8b95/UJx
	PLvPT5g6mwXgEMzRvMljPwVEpivfeZSoy6FU8e74SwXRCcvSFmA2nFsBUZmyOIbpq5UZBTDo+KQ
	gxOxSUI/xdEE3Tea2Grwxoj7i/WnlSQDWg4GqdHZep57SeXZpoRvxN7H0yHWOPbWLIn33F0dn17
	gtxjfqiC/22Vz9iPzuemb76qFWS0ZDnxTju4hemhHcIbqDOEawvBOx5LEbMgK6k9688Ff4ECTTK
	MNJeVy4vEXnQx9zSIYv7ESlg==
X-Received: by 2002:a17:90b:48d1:b0:359:f43d:4a6e with SMTP id 98e67ed59e1d1-35a21c7d6d2mr3049688a91.0.1773404388365;
        Fri, 13 Mar 2026 05:19:48 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359ffe77311sm9099832a91.11.2026.03.13.05.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 05:19:47 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH -next 6/8] ext4: fix the error handling process in extents_kunit_init).
In-Reply-To: <20260310130412.3156753-7-yebin@huaweicloud.com>
Date: Fri, 13 Mar 2026 17:45:12 +0530
Message-ID: <sea4sz73.ritesh.list@gmail.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com> <20260310130412.3156753-7-yebin@huaweicloud.com>
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
> ---
>  fs/ext4/extents-test.c | 41 +++++++++++++++++++++++++++++------------
>  1 file changed, 29 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 70d84c0a18e2..7e2796f72d45 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -222,33 +222,37 @@ static int extents_kunit_init(struct kunit *test)
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
>  
>  	ext4_es_init_tree(&ei->i_es_tree);
>  	rwlock_init(&ei->i_es_lock);
> @@ -264,8 +268,10 @@ static int extents_kunit_init(struct kunit *test)
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
> @@ -310,6 +316,17 @@ static int extents_kunit_init(struct kunit *test)
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
> +	deactivate_locked_super(sb);

So I guess the right thing to do for now is, what Ojaswin also mentioned
[1].  Let's go with patch [2], as is.. and we can fix all the remaining
issues as part of this series. With that in mind, this patch series
needs to be applid on top of [2]. So that means.. our error handling
should also properly take care of unregister shrinker and freeing sbi..

[1]: https://lore.kernel.org/linux-ext4/abPh6GX0t22m628D@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com/
[2]: https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/#t

-ritesh


> +
> +	return err;
>  }
>  
>  /*
> -- 
> 2.34.1
