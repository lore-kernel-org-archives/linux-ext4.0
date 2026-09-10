Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C7638DC6A
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 15:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054619; cv=none; b=cw9Yt/LF9P1FfSm0n5wNgh3D47uTBRglgUfUsTYEETn/aZNKqYpO9UMB92GriRpMMJHnX/YAGWmt/H8GLscmQR7rLJR68/VeB51uu5fR+9QZL2hc9r4YXuSAawuMxpfUK6Dch62bY1D60bYOJU5efFNLOGui96189IaVnSKNkDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054619; c=relaxed/simple;
	bh=ne/18jJwunErzC93U7NYEDHzT1ZsdnplET8lJOBaKNc=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=dFYfCVl0v59MDJOR3Ck7Mj5VtJA2EXNNzUAgRPkDVCW/ebYpD020JkwcXLob+BdH0yqpV3i8FYiGqoHLtyT4pjUR1Kg2hRENnHIgInQo+dZCrwFk2iZiFf+ridCElxAqsy7bwJLtZQ/KS0v7McXrPF28et7D0Aq3O5AgU37yaQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GpD6KfgE; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GpD6KfgE"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-39675172593so6109709a91.2
        for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 08:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789054616; x=1789659416; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=DIgpOKRYCUUpFOUc/uu4SOV6NFrhwbO9ScLDEv6VJus=;
        b=GpD6KfgEsOOWjTQtvsFjmVaeevQUIvnWsUqhN+UJgUkjTCScIcXba6NJEWZ/XAcvf/
         B4Yclf0+di3FsrJgmN6h+5MQ7bxbUfVPTApIRL20oE5AKFcEcNYUaQhZF6Fd0GHYNPVa
         aqci3fuTVDwFpgrZ+TGYEsdsJPxCkxmpKC864oIZ5eHN5cTpTADWNONtja4Zfz/iuR2k
         GUcXynA5e6dieyh8lKSAaY1JBi5bcVUzhW9Jc0316/3RhwU8ZjOUCZYGV9NSGPVM3uhk
         Gp7O5nJgDrukEgiJIgI9EM9anlc85tUN0etbQzZfN3z3n+PVg0zlQvQFZZYT9bZZHLmf
         Y7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789054616; x=1789659416;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DIgpOKRYCUUpFOUc/uu4SOV6NFrhwbO9ScLDEv6VJus=;
        b=a+s2rYzM/OvG8Rh6oy7bnDlzW2YWl0FlT2OkJDA1QTTma2vgfkHuiHp5LJ96I1UGEv
         KTgdSyGA4VYff9a57PfON6+mvai8q0Z+vRGJ2yfCEooNER3br/Va4uXAAe/bNbdWTboV
         /XRCprnQVCevI0OywCyicGHL9e+m8wDCRzzUVXd1ux0Elge3e+fTnEHgyQgno5gGRq3T
         6MihXitcjSJ6i7WEhhEP/I53TYFXNUZo4pSO/rIQ5+GHGZd4Ar0RFjX/mjA01dndL4Q+
         dFukLUpqtqL7w6qBfg2KTzOom3rLhMZ7aOAHW1jV+WK6fT27CF5Q/mubnua4IBxaADqB
         xbEQ==
X-Forwarded-Encrypted: i=1; AKwUvBxiXRCYXkLFEAOoOdHoeGSMvFm2g14OoNGhmcVW+6GrHvKXA0/9Ye5c6Bdx29EPxcbYOaqDHb6AYwb1@vger.kernel.org
X-Gm-Message-State: AFuF++m65OoNYZKDJpYXnu7px0rr43vRflvyQ47vIZIcSdynCQMe72PQ
	0sVfxgSgAatNXiyqfmvyXj6l6rzuB7M2IlbC00cKdMJ54EzY1IA47tzR
X-Gm-Gg: AYBFou06TmVy7SsnsAkIHgrFq28JVVdaBevJrYRxc9maNV0um/TLotlKgJZsi1Ze873
	aQi3Wspb6j8V8XLTRrC9qPSONKLwS7o1I5YB+wN2nLTlFRhYgWEh8gEr4ceRutD/Qbkp14Gb43Z
	lN1t0FQJyJHSobPhHa7bhdb9mbJKVIe7/KPif4+9hdXnstJWZ4pv5FjBitYwLZW9gZIsiltiake
	jpShMpvx7iskX2wnPdd0pekgT/+B0olJKgQ6OoA/VH+QN3gqs65aJXoT3IP0e0PdOyiuNjZDvHp
	YNvgtngm7ao5Xu4p/YZ6L5tiNEwI11NDwZjIN6aVkI3lu4doUyqpyebgJe/o0Dh5YIeOG9MCxBE
	7gIoDA6ystD3GieE9GvuN2CYfn6utYVv+vmjQX4QczYR4ty2FnGqCWs0YSf84S56bDODN3wfhmn
	pEo7wjYXUPMRkVZyGq28bmhPCTh5bg2eks+1vJ90or4xC5TwlHXZQ6q0KCP/EDMW0K1MpgHrTl+
	fkQA5TeZ3wnabSUERg6mXAUlfZR9VjFCbw0rDq1ZezRoRHp+kKgWnQ=
X-Received: by 2002:a17:90b:3ec5:b0:398:9c00:29ed with SMTP id 98e67ed59e1d1-39b26277673mr60283294a91.21.1789054616410;
        Thu, 10 Sep 2026 08:36:56 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3342af0bc08sm53586516eec.17.2026.09.10.08.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 08:36:55 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Pankaj Raghav <p.raghav@samsung.com>, 
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Baokun Li <libaokun@linux.alibaba.com>, Zhang Yi <yi.zhang@huawei.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Pankaj Raghav <p.raghav@samsung.com>, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: set awu_max_opt to awu_max
In-Reply-To: <20260910100829.2532894-1-p.raghav@samsung.com>
Date: Thu, 10 Sep 2026 20:45:16 +0530
Message-ID: <y0d9yw6z.ritesh.list@gmail.com>
References: <20260910100829.2532894-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Pankaj Raghav <p.raghav@samsung.com> writes:

> commit 5d894321c49e ("fs: add atomic write unit max opt to statx")
> added atomic write max optimal to statx. As XFS can support large atomic
> writes through SW, max_opt exposes the value that will be HW accelerated
> atomics.
>
> As ext4 does not support SW atomics, set awu_max_opt to awu_max.
>

As per the man page the awu_max_opt=0 means:

    A value of zero indicates that stx_atomic_write_unit_max is the
    optimised limit.

[1]: https://man7.org/linux/man-pages/man2/statx.2.html

But the value of 0 isn't wrong either. Jan, added that it might be more
clear to report awu_max there instead of 0. So, if are going to do it -
let's add this info to the commit msg. So it doesn't look like we were
trying to fix anything here ;)

btw note that bdev_statx() still reports 0 for awu_max_opt.

With that please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  fs/ext4/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 26f0f9714f03..93056c971e74 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6304,7 +6304,8 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
>  			awu_max = sbi->s_awu_max;
>  		}
>  
> -		generic_fill_statx_atomic_writes(stat, awu_min, awu_max, 0);
> +		generic_fill_statx_atomic_writes(stat, awu_min, awu_max,
> +						 awu_max);
>  	}
>  
>  	flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
>
> base-commit: d5ba62a0b130441bcabca59c2fd2d59e65360234
> -- 
> 2.51.2
