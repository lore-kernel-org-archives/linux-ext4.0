Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12EE3B95E3
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2026 03:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114015; cv=pass; b=Z98UZU2BXAcAPbQhepkNCqn90s9H3SN90xzZj4gROD2LBEdQvClLwh0AsH19qWs0Ab2rifKx9Dq668sJsu7Tc18hMK/lL3XnpXm8zxR/q3Cj/kxG1hrI9Dy6N0mSM5SOax4LOl0hIZLYqu0DeMlsFecBTLfbwe44n8pYC9oqxb8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114015; c=relaxed/simple;
	bh=nrF7vlGYzrNGs/7YHhPH/NnJVLHS4kdieXhq3F5zpFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sNFh9ZMqyhPG1jsVzZVwFgAHrFN8tfifMq31Su7Q8FYOwJfF57Rp3eJuh946dsmixs6qce/w8gpXlnvBTUA/6r2xoSJ36IF0+4UYWGUobCHMzsehC/FHIIoRzNO0XxGB3xhvpTW8fKDaGVovAOj3Q02i4rqWyCQnFo+VFSofz/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDGh/p7r; arc=pass smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDGh/p7r"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c2af7d09533so7915185a12.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 Mar 2026 20:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773114012; cv=none;
        d=google.com; s=arc-20240605;
        b=RymWMXtgmLKPPOdPqSbxj97An9zV09B95z1tRfY/9F4cdc9bRgJl2/0NwuX0CPxE0N
         8Mf7i0t1gDEwZ+b+P5LwB+2jX+QFOA8lKU8Vg6CgcUo2o0sbpM9Tc3JoyZOdZMeeQfGl
         sBbOjlviuR8ZTtIR0rg3xmXdyv06CE4kNp0CnfJpxyf/je/w7Sf2cp1DZl01QlclC/FO
         JmfBSr/jdcq023DQxduigMPXh/S+UNR52IKlEuqN3cI7pCXdAcq6fwnW7+iSJrjuMcS8
         rg9lZgCvH7A4NDz5bRkK+MCO0jHS3yQtRzbrHmuE66SvySwY4DHYLBlT6WF1fh233krw
         B05w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1PR62EF1lAki6+/h7SawFbTNGruJi0XAMWivo94NRLc=;
        fh=lsih9r9OhZnEj9Hb/jtORycHfOBQOJ8F1fSMePMyLtU=;
        b=e+cjmKMdM+j+3WTiJrea5g7kR/j5kBJYY28kGEp/oN4Uh7Q2nl5dnBjHimgld5YCHn
         JUDZUQya+fXsZ2yCyahdZXpgmlzIwR8o/BqQhc15r0uxm79Q5v+Iq2bTKiOvLbweSCpg
         hxNXPo7MPBUqUrNIfJFAgH2zB6jZzclSPXcLrC8pH127EBZnRV31244dWVrXJCWLyPar
         JaImolnvHGdTkbCeFadQ88vcYd4DZki5T55DKGHmQZRKyvKuFOqa766pYfK0geMOabqp
         GGwR/TdshFtCFQbw9Yzv69KNemtaZA7oHmQbGN5lF1ZrKRRNhuQtOMPebESkU2Bye1eR
         vRtQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773114012; x=1773718812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1PR62EF1lAki6+/h7SawFbTNGruJi0XAMWivo94NRLc=;
        b=LDGh/p7r4q4O4SNLhBjYnjbsAWHkfrcHUi/YqyWGyBQCMy8rpaRzIiI8nRaATiFmgz
         WXDg+LaLkXdxnNhVsYRPoomPfBjn9QcTAj0ZW5hBUdzM+ntlWClVGhP+Ai9TI//i4Qds
         uYmAjTuU9IOGx/qaBC3UJ93WjrpKdL464r+HcmOVwaIXypg1fMC/GdVhu2QWEp+EZnCK
         hNm3w6YGZxM8Vy2NmvRUnvtf0HwgJIM9+9Ymn8boWZiQsiUcItdrRpwGMaNdk01Wh3vS
         HcAfLdNtoHGrci7cbcR3NIWZSgpykecmktQp2Frk2R5n4f2C5LosFp2MJQuGjjSFDPL7
         aKJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773114012; x=1773718812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1PR62EF1lAki6+/h7SawFbTNGruJi0XAMWivo94NRLc=;
        b=h7+fDHcZcHtzM/UuA8aj51iv2UzzzqpCvmWqGjXSxc7HFgXp0dGe9AoBL39k09pBpz
         GYFPYFl2YRj4Qg1slm0fhaU+rkjKUQEos6CHdFEY94JQCXK8Rsw3sPWIVKTcodl/IC+K
         rtlK9IkuDY5BBUE9fGXMnw4Ac4c1kt+erGwn9Dlaurnh0Hr4v9Z5TVdleJdEVoNwIhkj
         BQmDRadRBlfQePTE3hL5ienpcwy6/7al7xZWAlKp4ipAC2t5XrR0EY+vSmSr78GDP4aH
         qPbM5srTl77aBmPrVocXVhCRcDZOrgTAAkyfyR1lYIUriIwZyrFemSfP4sgA2F/oazyx
         ZeFw==
X-Forwarded-Encrypted: i=1; AJvYcCWLxdj4nUhZCU4YOYEnipCOzd7QnuDJwV82ixH7CCtIRPOj8vYfepihbyjLe0o7U10rXdtVvpdSX6We@vger.kernel.org
X-Gm-Message-State: AOJu0YxIqcdYSpU4+3erPsghsXKdy/aPBAUbvaqxMeGd2p+wRGbTZFYZ
	wRT4O/QQieKc3xrgjBpZB6nDg+9FxbqyEIgXoqbPdNq5RB12r0xW7sWnGKDW2teELK77i+u6foe
	glnP4MT6d0LoykVVAwA/skyoLgbplwBE=
X-Gm-Gg: ATEYQzyahDDvM1RGbKptHJ3BRu1OZbHjpCQV8wbWqdmYddjLqy5Y2IZ523jrfh07tK8
	yjuNUSw3lw5ci7pMOKoEYouZZ5utZMRmtAHCK6w0NejhBRPCqTjP7auKUMwSzJEj4/JcFA1CVKo
	L7q0UNzeZ6u/099fXjgLoNSEy3TYjqopMU5gPcyLKhA+XKmXuJkGTnYwlpFXYoOZZZPRZkIHUmS
	kuUiHLmqAkHU2lYlbxA9DXJM3o75PE9UBxbLNkDtyBW7og34jXjG+00Blf86ikqRrjo29zE2Rki
	H0ztGKw=
X-Received: by 2002:a05:6a21:9ccb:b0:395:291b:f555 with SMTP id
 adf61e73a8af0-398590ebdaamr11794026637.69.1773114012045; Mon, 09 Mar 2026
 20:40:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aa5NmA25QsFDMhof@hyeyoo> <20260309072219.22653-1-harry.yoo@oracle.com>
In-Reply-To: <20260309072219.22653-1-harry.yoo@oracle.com>
From: Zw Tang <shicenci@gmail.com>
Date: Tue, 10 Mar 2026 11:40:00 +0800
X-Gm-Features: AaiRm51P9s3DC7FjytFC4I2paYZUeQw-qAwJyjCHl-40jBVff_9Gjy4xmE9iqAQ
Message-ID: <CAPHJ_VLzRECge4=L5RRqZyf-Sou8APi=Sc=d0brBAMdj3UC_Cw@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: fix an incorrect check in obj_exts_alloc_size()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: adilger.kernel@dilger.ca, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, hannes@cmpxchg.org, hao.li@linux.dev, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, vbabka@kernel.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	viro@zeniv.linux.org.uk, surenb@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Harry,

Thanks for the patch.

I tested it on my environment with the original syzkaller reproducer,
and the warning no longer reproduces after applying the patch.

Kernel version tested: v7.0-rc2

Tested-by: Zw Tang shicenci@gmail.com

Best regards,
Zw Tang

Harry Yoo <harry.yoo@oracle.com> =E4=BA=8E2026=E5=B9=B43=E6=9C=889=E6=97=A5=
=E5=91=A8=E4=B8=80 15:22=E5=86=99=E9=81=93=EF=BC=9A
>
> obj_exts_alloc_size() prevents recursive allocation of slabobj_ext
> array from the same cache, to avoid creating slabs that are never freed.
>
> There is one mistake that returns the original size when memory
> allocation profiling is disabled. The assumption was that
> memcg-triggered slabobj_ext allocation is always served from
> KMALLOC_CGROUP type. But this is wrong [1]: when the caller specifies
> both __GFP_RECLAIMABLE and __GFP_ACCOUNT with SLUB_TINY enabled, the
> allocation is served from normal kmalloc. This is because kmalloc_type()
> prioritizes __GFP_RECLAIMABLE over __GFP_ACCOUNT, and SLUB_TINY aliases
> KMALLOC_RECLAIM with KMALLOC_NORMAL.
>
> As a result, the recursion guard is bypassed and the problematic slabs
> can be created. Fix this by removing the mem_alloc_profiling_enabled()
> check entirely. The remaining is_kmalloc_normal() check is still
> sufficient to detect whether the cache is of KMALLOC_NORMAL type and
> avoid bumping the size if it's not.
>
> Without SLUB_TINY, no functional change intended.
> With SLUB_TINY, allocations with __GFP_ACCOUNT|__GFP_RECLAIMABLE
> now allocate a larger array if the sizes equal.
>
> Reported-by: Zw Tang <shicenci@gmail.com>
> Fixes: 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from it=
s own slab")
> Closes: https://lore.kernel.org/linux-mm/CAPHJ_VKuMKSke8b11AZQw1PTSFN4n2C=
0gFxC6xGOG0ZLHgPmnA@mail.gmail.com [1]
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>
> Zw Tang, could you please confirm that the warning disappears
> on your test environment, with this patch applied?
>
>  mm/slub.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 20cb4f3b636d..6371838d2352 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2119,13 +2119,6 @@ static inline size_t obj_exts_alloc_size(struct km=
em_cache *s,
>         size_t sz =3D sizeof(struct slabobj_ext) * slab->objects;
>         struct kmem_cache *obj_exts_cache;
>
> -       /*
> -        * slabobj_ext array for KMALLOC_CGROUP allocations
> -        * are served from KMALLOC_NORMAL caches.
> -        */
> -       if (!mem_alloc_profiling_enabled())
> -               return sz;
> -
>         if (sz > KMALLOC_MAX_CACHE_SIZE)
>                 return sz;
>
>
> base-commit: 6432f15c818cb30eec7c4ca378ecdebd9796f741
> --
> 2.43.0
>
