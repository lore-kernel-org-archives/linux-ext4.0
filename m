Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD99539098E
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773404971; cv=none; b=qYBr6KblHZCnEhUl3hRlIJACB9C/ibfDFccm7h6yD5o4Yy6u7rILID3U9IEUqzp9U+lXCZcejoh63m5d3kNc1qT6+cSggtyntaSRMvVCCkPEr59oYa6axmuV46aFRVyrXYavgSQKflpfoGqSJ/63/CGzldcfHZNfyyFf8A0vkxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773404971; c=relaxed/simple;
	bh=ObQFvsGUB7wFByJtUcF3gfSmIdiKZwxgr3jr4/PwBp0=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=tooV1sfWtmbGQns0CfVV9i83zuwplFKNkcSAcVGW/LD0Pt+9ztQQTb4mbe5ARz+tTqiFCc0z3JvoYY2Q3jee2sYUfvR1CIS84oWTopD6hy4hp5Ya9rz9sbDgws9MRAPWqtMyxtnQgfRFxHfu76Xn3o/fj6B7RPF6TtTUR99Kv64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EjNxHY8H; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EjNxHY8H"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c739561f0d3so1329003a12.3
        for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 05:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773404970; x=1774009770; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8jkbLh+SmMmP0v5Qq99bQ89OtXCOWtHq0dDfsPCiqe0=;
        b=EjNxHY8H/xa1pl4YXBMX7x+iJqnha6XqlKnLkkwLrqfxIUBSD30XWsR/vZ40JX/opj
         +X31JXGOrGfEhgSYBPOzOgdMMonWbw2ZPSaoN2yOVXzC/MKzcLwmxzX6Snz/wfTmZAdi
         zeXZ4WLR1SCkQADpLw4EQWZC4syp/t42jvoXNDR+J2vw0QbEhqUEWygVVqmeBYnovZvM
         983F1Mjr9YsNkqqEeQ7TFCT/8HFGq48TIJPk8Tz3So02VSA+w1tSwvozyviCe6ScTTNv
         GHXVo+XwW72gPfv4jRocc7ZO6lG18KIzzu+H1vetA2ARKUYUpVjpd2kaYZ12ApbNy/Ye
         siLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773404970; x=1774009770;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8jkbLh+SmMmP0v5Qq99bQ89OtXCOWtHq0dDfsPCiqe0=;
        b=baEYth/sBYVLqd1FYc0CPHepnAg8NRBDIJd2/wxAUN6PT/xEgZ7koj52MLreG6IDMo
         UoWDxd1AAJYUr0K0zUQsjcsMxRTlQORC7rHABlfCUCxuU1pzFju0jAdM+4BdVqGBKv3p
         C1Ss1j7F/cSNxmz9LQNUtQnavdjBr3ouPA/2NYvTGHKp4v5L5k/gFOxTG48kBKOGDMO2
         8HjeIZ3jw109H8EJ95SPydL8p+qKIrn13m21ikTL8ABikfhPvES5reh2cHszZ6KLv70q
         VfmkYRO5EaYMulXFJof3N2UkW4CVm7PqLpyyOrgktRHtHHVvll8vKOI/8t+6g7N/76f/
         cwJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXySEHuvEC76ponlCDF8Qw6FZuCBH1no+0X3vBqyCBqtUr8VLkmw8Q5yK+y+QUqpLtmoCpWHFdql8Jv@vger.kernel.org
X-Gm-Message-State: AOJu0YyaK/llpXUEmwLG40gPz/89qMzCRL351QRmsrxHnzcOIUOuMXy+
	dFxRIjI1Hk3OCnofLL+JQqjIN5IsA+cwEM4TzqnbUlMFDdGNfsq7V4cZnTanP7FQ
X-Gm-Gg: ATEYQzz7LXAhpeGA0rqdGPSv70jAGQB2IrlBMrg2TihVKZ953m/sjt1spQkbIyPDqJY
	25qhIMN92pxaoVkw24zkVi8N5LvZjQzJzurn4Vc2KT8zjJ/Xe+aJVSiBnqL4Re5TAzk9Z5ivCh/
	9NMmtKT2Bg0TDMINtH0uuAXn1Z3eFedqKrcY/d2G2/ykdbW+8mNufq0FeimZCHeqb8eTZZzcAz3
	Ny8pyh+2yegp2xHj7TT7+ipWb1rKJdAAxPEmKJ+8nb+SiDBzod9Cl6xs9jUG8aRR9ZL803PeqfN
	YCJ2rObJ3IWs/Z6oizrM+rzCJJ+v2u80cpm04gSuqw6OisFovWToJRbsvVvHIyajXVOPdKycHgV
	57Mv+EzADJ6uO3UBOcfiQ0Q/2LJqdsQJu0YrGhSxs7vSbSqS/gjnvx6luJUeM3gVfo6XzpUoOzI
	daurr0MmWQrEqCX5JfUTDT1TcvcvG5GIPO
X-Received: by 2002:a17:903:2f8c:b0:2ae:4c9f:4a63 with SMTP id d9443c01a7336-2aecaa382ffmr30701395ad.18.1773404970140;
        Fri, 13 Mar 2026 05:29:30 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece85e9dfsm21214365ad.87.2026.03.13.05.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 05:29:29 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH -next 7/8] ext4: fix possible null-ptr-deref in extents_kunit_exit()
In-Reply-To: <20260310130412.3156753-8-yebin@huaweicloud.com>
Date: Fri, 13 Mar 2026 17:57:36 +0530
Message-ID: <qzpnud6v.ritesh.list@gmail.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com> <20260310130412.3156753-8-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> There's issue as follows:
> KASAN: null-ptr-deref in range [0x00000000000002c0-0x00000000000002c7]
> Tainted: [E]=UNSIGNED_MODULE, [N]=TEST
> RIP: 0010:extents_kunit_exit+0x2e/0xc0 [ext4_test]
> Call Trace:
>  <TASK>
>  kunit_try_run_case_cleanup+0xbc/0x100 [kunit]
>  kunit_generic_run_threadfn_adapter+0x89/0x100 [kunit]
>  kthread+0x408/0x540
>  ret_from_fork+0xa76/0xdf0
>  ret_from_fork_asm+0x1a/0x30
>
> Above issue happens as extents_kunit_init() init testcase failed.
> So test if testcase is inited success.
>
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 7e2796f72d45..b1ea37e74f12 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -142,8 +142,12 @@ static struct file_system_type ext_fs_type = {
>  
>  static void extents_kunit_exit(struct kunit *test)
>  {
> -	struct ext4_sb_info *sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
> +	struct ext4_sb_info *sbi;
>  
> +	if (!k_ctx.k_ei)
> +		return;
> +

Make sense to me. Feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
