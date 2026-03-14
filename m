Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1372C42050
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 12:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773491676; cv=none; b=gt9YcnUtcsm08WwtCGSXoQ1Tz43Wi8xDk/UrAnJkx2eB0P9BHCssZPuOKpRpEogKGrLnEqwdQ0Q2KT5lwcOCaKMw2EzSXeMorVArdHOSyjBhosOJmFLqwuWFUBaBSDho0YzWDMTnicICMveUPOb0PZjgUWcEhH7IpmsSXf+Hql8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773491676; c=relaxed/simple;
	bh=xS6hNX9VhN5lnOejmpSufG/MuZHTI6oJ07QGjumd4LQ=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=UKfJtdZyGEVztvKNQ22eAWO8W6oS1rsNGXPXnzdy/AwU1jALsfjKfJGyFsI3k5CRA5BAIBrQH2O8dm3jIyJs/23yAcFqIpPBm+5Ub3cVLpefczu/PrYyBk2FC0W8ETT14syufu8Zz/YWaYh+gz5+gXOIXc1dHW+WbSMICGTunfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ee7hpJLp; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ee7hpJLp"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ad9a9be502so18886485ad.0
        for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 05:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773491674; x=1774096474; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H1VhISShyDoYe84twz9OuGp3Hr1WFGfuBi01CLXAnvA=;
        b=Ee7hpJLpfqc9B5cVmwOT/Lq+rJ4YNieiX+qexihsXOxuOsiAAoDi40N7tgYQtkMJNr
         buMoaPkfph5thKpP1ub2VNVSCIsy4nTcAQUxJgBEOaSgDpUKdJSUj6cmO3Z5BrMMlFzF
         z5czLB+qs+XbPP2L3+FV/QtqyGAqLaZyheF+XtY9Yt6ybjTCQayUim4SZUeOQMJ+em+I
         TWRTYIL998YSZAnUDpRe6vN95LDWNJqYfXvJKz6JKHtCt70gyhRMLCkUWwwbEfPz6+rJ
         Je5wJRjmY6wfG4wy1CDolqBr2mL58zPrsv3iUXBv/0xFS3NDVgOf9Mm7JMyIbZa8iLt3
         Ry0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773491674; x=1774096474;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H1VhISShyDoYe84twz9OuGp3Hr1WFGfuBi01CLXAnvA=;
        b=VSOIrlAwmfi+AoKaZpZHTxZcNtyGunypEdqWtSjNJS5SNVbLsktyyUt2siq6h80r0a
         2huGI6+iC7RaYFKCnTM4bTvzSyUeY+XH89roIDG5giD4a3g/YvtjlZnwM3ycp+Wapp4+
         ZtQek3venTmgJydtlfLB4tDOqFY+VBOgi4eK/CJMzVPSqfVYxrIAMjIHm1QjPZFtIBkN
         7GUKyyt4v5oe8IzqLR5MNsX+OzTKESkPrBcRZV2fiQBbJ4ja4M40BnXklwDlqizXsono
         fGAP+tdnld0kAPPaTX84eLMQhdUUOGNuo90+3DBCIr/xGdn153Pk4XfqcoJCRbcIyQBp
         z+ow==
X-Forwarded-Encrypted: i=1; AJvYcCX5p4mH5ZptuUW9mCyopWnkoSYpx2tlGn2c04YrOtksH9BgOSTn3UpZq86YDJGR5P8t9sWcw3UKZlD2@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlw79WP7h+l+Ktobwdbp2Tpf5fDUKCtA8J/4DtMcF4r7EJ661u
	trv19sn+3I+D94tjIHBKMOwxbo2sBPVW5V/JH8ih5Enlq+js5+rTuMTS
X-Gm-Gg: ATEYQzw97CswC9vwB956gK6fvWmoLMB0xAKn8aNCm1MyLbsuYBQ9YF135Ox32H5VE+W
	iV18I7qpN52Lpahjr3aqANSF1JzyDFCAGp3hOKCQ31MjYq84tXSZZtmCwYwZuzIj8FbjaFd+TLV
	Bl5rgfzspDBY4/6vjXAPJUUJwtCHFx9O/DgYQXze8MYzv5omXSf9nKp67JFCP/u75F7VVJpeq45
	uyQv++FTL0fK7oBg2O+DRtx5xSYW89b4wnK+B9rEmo6ueOzoSY51yq6TUYDaaOXOA1YBpzXTBXO
	QnxnfDKMf8ADVxv1gsAzvBgKhUPL7H8nxtq3LwfIJMV1g9OOs5KDh6VivtdRov3MlWIf88g81xf
	bcQTaya2pDBvwROHG2aQw8zfd+NUIJNmcLQGpsT4JuXfD3SX0/XG78WkYeCX/97Z5nd0eKx1jyf
	Jmw7QYzKNpKHRIDf4qzcAmrA==
X-Received: by 2002:a17:903:124e:b0:2ae:abe9:b391 with SMTP id d9443c01a7336-2aecaa9515cmr78694545ad.24.1773491674348;
        Sat, 14 Mar 2026 05:34:34 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece60e6f6sm51887755ad.28.2026.03.14.05.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:34:33 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH v3 3/5] ext4: fix the error handling process in extents_kunit_init).
In-Reply-To: <20260314074903.1314851-4-yebin@huaweicloud.com>
Date: Sat, 14 Mar 2026 17:59:42 +0530
Message-ID: <h5qitwzt.ritesh.list@gmail.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com> <20260314074903.1314851-4-yebin@huaweicloud.com>
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

Minor nit.

> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 44 ++++++++++++++++++++++++++++++------------
>  1 file changed, 32 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 3d4663d99eb1..543236a31e13 100644
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
> @@ -313,6 +319,20 @@ static int extents_kunit_init(struct kunit *test)
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
> +	if (sbi->s_es_shrinker)
> +		ext4_es_unregister_shrinker(sbi);

I don't think this extra check is necessary.
ext4_es_unregister_shrinker() already has checks in place.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

> +	deactivate_locked_super(sb);
> +	kfree(sbi);
> +
> +	return err;
>  }
>  
>  /*
> -- 
> 2.34.1
