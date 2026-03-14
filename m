Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8884286405
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 09:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773478910; cv=none; b=BxOaxCzoy7CXwbq9vfo/qU2zjkpGtzAauAn5Hkho/wMTwGQwT0UIWdkHiCswYX0zbOctesPNwU3a4mb5WF+vNUS8L0Ra9Rhv9T4Jlb7xnszexwmuNoPyHM5nqsp1V1ujB1cLKmI1Qn1TaOQMWQqBYFuv0mFKrS992CUXrtB+5gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773478910; c=relaxed/simple;
	bh=b9pHDghe3HgNUkI5Z3PDAcVoOgGw56VGLEj5E/H6pxw=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=SZm0ydxakzTnPjUSKOzJwVCZQZ+fO+Kxl16ukHwhbvGZFrolCpCpp3OEFcV098pvQCxK+eNFA3S9lEBt0syo0KdfpsVqHoKqJ/NDw8jhI6xZ5Sh0uCPVKOCcQeKRQpQR41Yv/mdgq2O+izt0f9H7BnYw/sJDJa6/OQTEsllKgqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MvWouYw6; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MvWouYw6"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-829b8b6c4d0so2474261b3a.0
        for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 02:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773478908; x=1774083708; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cQ9Bv4ugujHo1aalxUq7gHFDwLe5TnC5mhJlHl/OIwQ=;
        b=MvWouYw67VVy7NaprwusdTG2AzIJ02B9o55ulo6eBcPCpIptaQuX57JZqrBDrsxwjv
         F+QesDm9/CUgeq9GqgmS++JWjYyZ+eEEKNNXq9aVVgJPB0AtleIPyp75rx+wu941+aKb
         ZAY9OjHWW1N6z5WocHWrIZhO4s1SAwE2K4umDFKAhMoIULed9s9PDeuQ/8HolYVgNnr1
         dVoYPzgMgc2MowbjkUbv8mIu0MOW3Wc9dVYMrddwhoMSuk3p+UN4ldN9i7SnOhpO7jRW
         0tSn5DwiQawA6H5YYKF3DnvZfs7GNegF2wTu7iEK1gNTP6Dteql6hCpepvWW/pVD7Hs2
         Rd2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773478908; x=1774083708;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cQ9Bv4ugujHo1aalxUq7gHFDwLe5TnC5mhJlHl/OIwQ=;
        b=D7pVR/l5G1FvjbT7ZMqGP1u/AexBw1r/AwokBG+zNgfHylXeRTkWB76QVPC9zZsbOL
         f5ICcasggzPQS0pxZL51XNSM9ZHn5GPGfLZX/6h+XeNwSUygQ8PafaMzuIA8JuRUWnnx
         9B7qZjBIwyaqjndLBNJRvZHCYXbBQlUi/5ccfpbCPIYyLPu6NsyIX+ln4VK5JoejPSI8
         iLilI4FBarm6z/+BFrFz46lxp3PVBZIqlXzgbn1tTlHFXWgjomLMRkv3b+Q8wVqAoR2x
         nOUSY4ygayK2Q5iNIUiVLf+UKneT9b/X0c6N4RKXPH+HY6KQzuYcnpvvsgNyJ6XH5ixo
         rqcA==
X-Forwarded-Encrypted: i=1; AJvYcCUSNKV2vsJo5edXp86nZMMB1XB4FIyZgJF3SHFfDXEjHrZ1H8TWoR/pZis4H9JHHqXYJXd0edmAF7wu@vger.kernel.org
X-Gm-Message-State: AOJu0YyetSawuKzw8Hi9V3iqXceCummps7hNxaMDd7fuOTFM5Y4oFheu
	XuiByW2ACIQr1A2zXwQP765ryTv3nowpP9wLiHPB/mLqQakLd4jWsZC2
X-Gm-Gg: ATEYQzwG0gQWyJYn3iuw5M9oOCbpk1a4cBOgapc0gNfS92zUYSZDsV+RmdB6s+IuExA
	qpiXt6X4cIEM46qcDKF56jYu+fs1kD80zdE79NgBV1tEeA9DyO1BZcic+NgfSsKxFt7Lq8juRuM
	r/OkvjU6BdJURoVHC6LZ4lo5yod7Q2jb+tkJxQLmY85cUuwYv4uEhcj6WadNGrTGm8eb6oodVhB
	g8emx/w8KZacaZtdY0Yd9aJkk5/gfIvCdICMS27ocPfNWkhQP8Xgex6fRVsJaB2rsNk9xf+PFr2
	EaQtzSFaA5yyNRgr+EMVszDh/shtgs6yp/xJLc1iHqf7fwaSrp8h5gCfPqHsXe4H++/r+XTys8N
	SbUdUHeqx0F1QBgrOWb+fDGC2pJ2WCDW5GR9LovcJn0oYr12zxo6ApJ7ZGpvkt1LRsVh+HFzQ8b
	eB1wpgJat+tv6KV238WZahoQ==
X-Received: by 2002:a05:6a00:2481:b0:829:8af4:5eb0 with SMTP id d2e1a72fcca58-82a1986c35fmr4254757b3a.26.1773478907742;
        Sat, 14 Mar 2026 02:01:47 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a072603c0sm7695922b3a.22.2026.03.14.02.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 02:01:45 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH] ext4: avoid allocate block from corrupted group in ext4_mb_find_by_goal()
In-Reply-To: <20260302134619.3145520-1-yebin@huaweicloud.com>
Date: Sat, 14 Mar 2026 14:09:12 +0530
Message-ID: <ms0au7nz.ritesh.list@gmail.com>
References: <20260302134619.3145520-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> There's issue as follows:
> ...
> EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
> EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost
>
> EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
> EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost
>
> EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
> EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost
>
> EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 206 at logical offset 0 with max blocks 1 with error 117
> EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost
>
> EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 2243 at logical offset 0 with max blocks 1 with error 117
> EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost
>
> EXT4-fs (mmcblk0p1): Delayed block allocation failed for inode 2239 at logical offset 0 with max blocks 1 with error 117
> EXT4-fs (mmcblk0p1): This should not happen!! Data will be lost
>
> EXT4-fs (mmcblk0p1): error count since last fsck: 1
> EXT4-fs (mmcblk0p1): initial error at time 1765597433: ext4_mb_generate_buddy:760
> EXT4-fs (mmcblk0p1): last error at time 1765597433: ext4_mb_generate_buddy:760
> ...
>
> According to the log analysis, blocks are always requested from the
> corrupted block group. This may happen as follows:
> ext4_mb_find_by_goal
>   ext4_mb_load_buddy
>    ext4_mb_load_buddy_gfp
>      ext4_mb_init_cache
>       ext4_read_block_bitmap_nowait
>       ext4_wait_block_bitmap
>        ext4_validate_block_bitmap
>         if (!grp || EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
>          return -EFSCORRUPTED; // There's no logs.
>  if (err)
>   return err;  // Will return error
> ext4_lock_group(ac->ac_sb, group);
>   if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info))) // Unreachable
>    goto out;
>
> After commit 9008a58e5dce ("ext4: make the bitmap read routines return
> real error codes") merged, Commit 163a203ddb36 ("ext4: mark block group
> as corrupt on block bitmap error") is no real solution for allocating
> blocks from corrupted block groups. This is because if
> 'EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)' is true, then
> 'ext4_mb_load_buddy()' may return an error. This means that the block
> allocation will fail.
> Therefore, check block group if corrupted when ext4_mb_load_buddy()
> returns error.
>
> Fixes: 163a203ddb36 ("ext4: mark block group as corrupt on block bitmap error")
> Fixes: 9008a58e5dce ("ext4: make the bitmap read routines return real error codes")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/mballoc.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2341489f4d0..ffa6886de8a3 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2443,8 +2443,12 @@ int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
>  		return 0;
>  
>  	err = ext4_mb_load_buddy(ac->ac_sb, group, e4b);
> -	if (err)
> +	if (err) {
> +		if (EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info) &&
> +		    !(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY))
> +			return 0;
>  		return err;
> +	}


So, if we had to load the buddy info and if the group's block bitmap was
marked as corrupted, then we always return error, instead of
seaching for free blocks in other block groups (even for non-goal-only
allocations).

This patch fixes that path..
Nice catch! Was this happening as part of some xfstests?


Feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
