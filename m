Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC394A3C
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 12:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773491791; cv=none; b=b0IbC8RlSYaQkFQ/ED8e/0ZrnANLNGKWYB0k5gnJlAcmltW2fH1+NrfTFuc/4C4sYP0LgQfHFn61aRs5hHm1Xvn/iU//8Aj7z5c+7UWD3KJ9XSBzqQq8tA2vlp3XYz7GFyN91il6vtByzgmY/65b4NK8LI4xbojaO4dxVLH8n/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773491791; c=relaxed/simple;
	bh=3BoHadEVgjWDOdy8v42lGco8VCYa4TRKnC8t/JhAECA=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=bT7CObmiTw3nvCBP7x+TQli8gEAVcpfmfLwg9rWFvfVDDFHY5Yn0sQRjPxgzJwQVfbbgAS0/lHdR7DBV7uOqtvS0BCb7zOJlKYZMooT5XQ1bXciwdb3DQ/UgNuWbSc3LYcX/+KPNRb9BuQ+iH6FpmWF1Sc/PtPMgKvNsa2I5yfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aXXZnW1/; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aXXZnW1/"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8298fad2063so1853132b3a.3
        for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 05:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773491790; x=1774096590; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Jh5ZELJeVYGDdYgQclbbxEHtPzl8lSkZQUBCm4rD3q4=;
        b=aXXZnW1/lAY2+JwoOiTmQo4mnxOBsmhbo2toWdwq9FdSp5+MVx4sl0bOeKVm/3q6yC
         aZy/9U4xdN6AX6tPLy5DkY4EgIopBoYs7yNMHa+gnV0OMuR3Mv+UUUGConRVwPmt4mZ5
         xzMVm2ZJJO7ahS2ZeAHE7ummDH4KIKYFGCMmBK7FhM/t6HrSCzWTI4S3FebVA6QGSQas
         Ay++lGD+8D/Tt8mgP4IH2H5I4+kwYAn9Jbo1MyzF/QkjYo2CWQQ+xD5xf7oFysBfxGkY
         YugN/Q27StFddunwpa+rJ6h+MxxwmtDES6+66bZ/MIr4/xYuxFtTo06sfkxCGvZ7MLkA
         6FHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773491790; x=1774096590;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jh5ZELJeVYGDdYgQclbbxEHtPzl8lSkZQUBCm4rD3q4=;
        b=huOt6lHbIInLiNxF+ovVnRB7zhSVZx38Z7QjCTmn5wdr7LtTcsn2+RDbEP/HUuHYVi
         sCKKPrJzF//lSecv3s8D+4+VW1Kls0yAb5/3tFojrn2IXhCTjyh2p3B0aUSTjhoqbWch
         SKhswN82FvfxgNAIJUT6dumMsoGX5JN5H/3bXWhvHvHmEjxs3xRcXSFnnZpNKCdpC3J6
         CvMw9zRINBHhJsOm6+otGOgiIdUhJQhPNf6xu19NEAthEVdPato4V8Se5z/rYVBeNEU7
         b3tGEv5w0qXUgkimZrRbxPE/sqCPpbRWoV3IcXbATWol3Cy+wuSmW0QU3Oo6zo/bn81N
         ptUw==
X-Forwarded-Encrypted: i=1; AJvYcCU9ue6R4Vpi3XqsIhv/TrgZ9eEFL+1suGCZHrdLr4Taq/udNs4NrMQNKSz9z2m5okcR1ch0Lp9miRw9@vger.kernel.org
X-Gm-Message-State: AOJu0YyqLoDPz1WZ2wkvBfKJLDsYNkuZhpKi/IvuoNWHFSm+blZRXJeL
	nj5Qeq0rV+nu19GQLlUPmz6zkYePE47YF8jD/+8n4SYrEP3PyupPuv9W
X-Gm-Gg: ATEYQzwgyjhKjZwOX9uV/MzeTK/7wJ3z6ER/6jMo4D4L5XyRU4Kgnj0mn0dEETSx5Q9
	0sPelVNomBI9h5+fvb6xqt85sM2/3qgLGgDHBiM+aKXvLAVNVW9aqmN5KhWLYD4wpxMk27JV3Kk
	jgSo4WKBjQsGjHUh0vCjcPosNn/aYsdMyLcSal3GLcusyGOn70mjc+kdYbNJxBFIhA3SNkU963g
	LuV0a9WmmJ2bxsklu3XzcIhdsLDr4d/w3Dem9itD44tVurpaRcZfUzHjrxFd2CD4X97Oryt29gY
	ZYrG7yMwAbyyOXDxMqOYFZE/Etf5Z4MBsub0xpn5sNPSgBV9rS9wMsKge3uy2CdD/fbzalC14JP
	Q0ejXRDG3egI4FTw6WnWdPl+s0eLZ3IsBJYrKDSm/+mgiLV/DxJSo5sd2SzaJ0KH7qbbWxNOo1L
	Ppdn/V1ZNH8g1/6Ayt8OOUNg==
X-Received: by 2002:a05:6a00:9aa:b0:7b9:8142:96f4 with SMTP id d2e1a72fcca58-82a19838a6emr6076131b3a.21.1773491789975;
        Sat, 14 Mar 2026 05:36:29 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a0738564csm7472295b3a.58.2026.03.14.05.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 05:36:29 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH v3 4/5] ext4: fix possible null-ptr-deref in extents_kunit_exit()
In-Reply-To: <20260314074903.1314851-5-yebin@huaweicloud.com>
Date: Sat, 14 Mar 2026 18:05:35 +0530
Message-ID: <fr62twq0.ritesh.list@gmail.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com> <20260314074903.1314851-5-yebin@huaweicloud.com>
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

LGTM.
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 543236a31e13..6ae72986ca9c 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -142,9 +142,12 @@ static struct file_system_type ext_fs_type = {
>  
>  static void extents_kunit_exit(struct kunit *test)
>  {
> -	struct super_block *sb = k_ctx.k_ei->vfs_inode.i_sb;
> -	struct ext4_sb_info *sbi = sb->s_fs_info;
> +	struct ext4_sb_info *sbi;
>  
> +	if (!k_ctx.k_ei)
> +		return;
> +
> +	sbi = k_ctx.k_ei->vfs_inode.i_sb->s_fs_info;
>  	ext4_es_unregister_shrinker(sbi);
>  	deactivate_super(sbi->s_sb);
>  	kfree(sbi);
> -- 
> 2.34.1
