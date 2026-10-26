Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793009349;
	b=v3iEPZJqZ7o5Pe5kzslqhW9ejQ2mUdK55/7Lqux9KjGC8vw4VxQ99aHb5cTI3XLGD2gn
	 M0jlNjwMExA8AsvUpqCFValNQs5DvzDFdC/d+VOzauNacdynaG9hc6UgJRanljCXpE+Pd
	 DiKxRsRwEdrIgnBEgt7KG+TR+i7lyZw4ufCtMtz7TdLKA+Vvs2/dqri2/HJBA+hQpZL81
	 zHQJ8xETY6Xzdyb0E4hU5TQazs15It3xHWIaUMEvBvw5zWWimSJcBi9ZCi3ZMnhQXgRJT
	 oTBrmVe0TJ9sTv2aFCspZMJMvQqIPURRhbnc6fHamX/ZQXlaQ0SZUsk8AUt9c0/AdKQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793009349;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=lqgswGVrjDSSdxxGQJBHiCq23U2S/DjC2jo9ZomP9DE=;
	b=xuvOv3WYOzWw0IkdHe+BjGOErXOeDMkGftS6dT942EMOIH1dnAn36APq5Uv/P6yxfcQd
	 FL4Dn+60Q7umn6SBy/876LN3MdKrn318F4N46XOrRJmdwwuChPPQK31CwGsEXoWQqRFHy
	 K5f4XxQesxSO6fgELTpAfdhQrn7ldE/TnNRCgnJBm2YB9vA/S6/hyvXzAQTUT8yJPSCzv
	 8y2bQjH/+a5aKjuJElpf6zjIV2jp+RTiytuyZ1o9hCVnLsVSQUFCj2Y1oyL8FyRfJG3K0
	 PLi+lMUfD6gCLSi3JuKpXyGZjOKILo8DZcd90AGd+yurmUAY7brvohwv42bFi3ETZMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=FA9FnVWw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233F5606A324
	for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2026 10:09:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 233F5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=FA9FnVWw
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-19305bcb72cso1853320c88.1
        for <linux-ext4@vger.kernel.org>; Mon, 26 Oct 2026 03:09:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793009348; cv=none;
        d=google.com; s=arc-20260327;
        b=TsKWK84nXKyXAME9tVBaxFdC44s904ZPG+b1y3S9J4kR3lxlBGBqkLr5PRzzTg5ybu
         iaKsO9Y9Zb0uAcxOUYaF6nryw4dxyyJpU0/X8pzEn/kyV59BKiBP6U0/ZmrLLXDZiIUH
         MTn5B+iuF+zcefU01kXpiNarlXHzGQ0YKi7A/ueYoXpPS7lPXaRicMAlfmyLxfp7TrZ2
         5YJnobW+sv5oZ+gbliJ5b6VX/D1AdocdTvhv2GbHJoyiy7gbanzTdBf1ZsAoPKajRlSx
         ieDLLBjjkm5Yr0/6SL4uenTw1Kbgr1llcY/WLYndCRODaOF3Tf6Gd0iq9lrBychp/V7w
         +dqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lqgswGVrjDSSdxxGQJBHiCq23U2S/DjC2jo9ZomP9DE=;
        fh=lCpeH6ZYJiLKa3QwhNYgO7e/IwPJkj4640rs+9QcDhs=;
        b=SQMCyk0QF+Nk07SOEqLrNNAioDO4lXMOnsaPpaPF4pjig2m9FvRoohU1SRoeIFa4A2
         AY8E1YcuzaLBnV7j3mhH71cpIfcaQvBO3qRVqlfnz7nVQdQJdy6ifKTdGw5RjN8JahR1
         OKEXILf521eRqYDiP6bWNuJ28xcEqpR851W02hC2SnBbDS8a9Oyc+K/3DVTAhhxwhb2H
         1QyoaPJuvUF9qV+ivb4/yTdr8jEygQmZUK5AJiCrynYgOwgsl8kjf8REWrMQ2hZaI5LG
         OpFmvUwpAEdbPuGw2LJYJ3cv43AEqEz0ycwPh8v8If/EdrJOUqmjX3aerzUTCQX0Nbi3
         nFQA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793009348; x=1793614148; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lqgswGVrjDSSdxxGQJBHiCq23U2S/DjC2jo9ZomP9DE=;
        b=FA9FnVWwCzdWrl5dV9KBXUQ3q/f90Hear2GGjarskzOfwkVUVPV6siYWJQontuDlOi
         Zq3A8r5uPTrQgMDAT19fKl9rXfnAZkHtfh1Po5ZYIQQ71cb402idibkLMf/GrR30/Rhi
         EzyAAdOiqk34LFtcB+e3UUVDZfpbjuwmBiJ0ZOgqbJ1heUfuVzgWYzPL+afcs00qrc4e
         EudXjDayGsbqhrqbu+PajSpOJs5+XabNWAACixIsIksf+LWI7O8YAEc2dVlxwfoe8EiA
         0Xsi9J2mPnHnGU1sM4QuegJ91CNkjHk7SAhv/Tz4XrXHd+EeLNQLSUV8s09z6Ij+V2mO
         KoYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793009348; x=1793614148;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=lqgswGVrjDSSdxxGQJBHiCq23U2S/DjC2jo9ZomP9DE=;
        b=u2ja99Qp7yqc/NX7opvE9gUdUk6KhvoSTEUh4YJKr8pcvJtoZw9GAxllM4pXmjCl/6
         A5QMN4k+uHldW9IVYM4BhJ9SAuFN1iBm2sWbBgSmv3NRQC6vGepIKR3asgjazlJUNPmQ
         g3kAKJZUWfrTyjFLzLQXy4DcCVH0Womgy0LLCdlTXdHvc4rvA8B1/QQoEi9Mgt3u4A6v
         MPFAlCQfOiZ3J7A/Dgnv6r636z7ZHms1DnSwsrAXRgo4am+ddfrJhszCx3qRfaRBSahJ
         m20Esv/6HkHx0bdCoWgQTKJNswT0iEfyqTs+cOsDjwZSGup+wQiEf0bnjPkDcpx6clZf
         NrRA==
X-Forwarded-Encrypted: i=1; AKwUvBxwRcNaxnbBNJfkXduOu4uSfKIePblZ8UBAuLtxyAblW/UYBwynz+Rz9mz/dLdhPEaBgc3n2mKpxayM@vger.kernel.org
X-Gm-Message-State: AFq9FYKTmf4egceqq8+5Gjgf5A7QtvW/7jeNQZC0uWLQA9b5F2brIpsk
	aSAl1sWOdcQcp87KV/NiVwjVHtj7oZrkRN0GF41hAiRvKmR91udM8DSlTyeIa8eTvNxZMhdzd9L
	fb55kbT1tZDU49paS1H+GCe3kCi9MtYKahybzLqLAwVUVRjOKOJPEaQ72
X-Gm-Gg: AYBFou0ukFcWF2vmUg1znrzFT/AB6Lg+fd8i+Ct+fYeDLjUi7P0i3aVRdv1Tcwx/2xN
	JtuNLNC74pyWXL0MNiuVo7cAEBP3powyMlNKmqbwIhBkWKGKSO+7MM+5zlaLooTJTtjpL8FzhVW
	0gPl6JmtZEe5gLFnTqa0/8Sliy24mDs9NQ/hZOlsxZDy7QQkfsbYMzgsbTQ1Hjeb3KVo42I+hF9
	ZJvmlyPuuXzy737oWy9+3ziFgbpvyOo/l4GUEPAD2/SBbueY+DGEV7YrEmCb6e2GsiFVt8hzdL+
	v1PicxkpaTIBwzg+84Rq4KnhI48nXHVf3+bA9Iky8QRIPTixwDd+M6fLJQOOJqpM2hOqHNKYHrO
	osOtRMk4uLARb7cbJsl5BPyc4043agcMnIC6NIHPDqKc+d6XNM/PIXxkd2D2AC79C2knW
X-Received: by 2002:a05:701b:230e:b0:18c:640f:7f48 with SMTP id
 a92af1059eb24-19936b56ab7mr8768054c88.44.1793009347392; Mon, 26 Oct 2026
 03:09:07 -0700 (PDT)
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023-ext2-fix-context-analysis-clang-24-v2-1-a33961453899@kernel.org>
In-Reply-To: <20261023-ext2-fix-context-analysis-clang-24-v2-1-a33961453899@kernel.org>
From: Marco Elver <elver@google.com>
Date: Mon, 26 Oct 2026 11:08:30 +0100
X-Gm-Features: AclHuK-_bb8psGiBbD_JTWNAC_hBLtM-Cc7GOo20LnSEwgov2hxqFzjQ2_-lDFU
Message-ID: <CANpmjNODG_MBuSJvRkzUjwWqeD=hSQLWtHkre8=9Z6-3ZmTKEA@mail.gmail.com>
Subject: Re: [PATCH v2] ext2: Make sbi an proper alias for EXT2_SB(sb) in ext2_fill_super()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jan Kara <jack@suse.com>, Timothy Day <timday@thelustrecollective.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 23 Oct 2026 at 23:25, Nathan Chancellor <nathan@kernel.org> wrote:
>
> A recent LLVM change to fix parsing and validating __guarded_by on
> structure members [1] reveals a couple of warnings in ext2_fill_super()
> from the annotations added by commit 023051c2d0f1 ("ext2: mark
> s_mount_state as guarded by s_lock") and commit c23746524faf ("ext2:
> annotate s_rsv_window_root as requiring s_rsv_window_lock"):
>
>   fs/ext2/super.c:1040:7: error: writing variable 's_mount_state' requires holding spinlock '_res->s_lock' exclusively [-Werror,-Wthread-safety-precise]
>    1040 |         sbi->s_mount_state = le16_to_cpu(es->s_state);
>         |              ^
>   fs/ext2/super.c:1040:7: note: found near match 'EXT2_SB(sb).s_lock'
>   fs/ext2/super.c:1138:8: error: writing variable 's_rsv_window_root' requires holding spinlock '_res->s_rsv_window_lock' exclusively [-Werror,-Wthread-safety-precise]
>    1138 |                 sbi->s_rsv_window_root = RB_ROOT;
>         |                      ^
>   fs/ext2/super.c:1138:8: note: found near match 'EXT2_SB(sb).s_rsv_window_lock'
>
> Context analysis does very minimal alias detection [2], so it is not
> able to figure out that sbi == sb->s_fs_info == EXT2_SB(sb). The only

Right, though function-local aliases are resolved. We just aren't able
to figure out aliases that propagate through non-local variables.

> reason there were no warnings before the above LLVM change is because
> the annotation was not parsed and verified correctly.
>
> Rework the allocation and assignment of sbi to have a direct assignment
> of EXT2_SB(sb) to sbi so that the analysis knows that sbi and
> EXT2_SB(sb) refer to the same object, clearing up the warnings.
>
> Fixes: 9708538ba204 ("ext2: enable context analysis support for ext2 filesystem")
> Link: https://github.com/llvm/llvm-project/commit/217e229a1f32785fccdd3b3f51429f0d309dea45 [1]
> Link: https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#no-alias-analysis [2]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Marco Elver <elver@google.com>

Additional note: This was uncovered by an unstable Clang 24
(unreleased) change, which was meant to make the analysis more precise
[1], yet stumbled over this. This change is needed to prepare for
Clang 24.

Thanks!

> ---
> Changes in v2:
> - Fix allocation size (Sashiko). I thought that I checked that they
>   were equivalent but I guess not :/
> - Link to v1: https://patch.msgid.link/20261023-ext2-fix-context-analysis-clang-24-v1-1-2b35c33cd0fa@kernel.org
> ---
>  fs/ext2/super.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index fb217ef2d69f..bde5b433776c 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -883,17 +883,18 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
>         __le32 features;
>         int err;
>
> -       sbi = kzalloc_obj(*sbi);
> -       if (!sbi)
> +       sb->s_fs_info = kzalloc_obj(*sbi);
> +       if (!sb->s_fs_info)
>                 return -ENOMEM;
> +       sbi = EXT2_SB(sb);
>
>         sbi->s_blockgroup_lock =
>                 kzalloc_obj(struct blockgroup_lock);
>         if (!sbi->s_blockgroup_lock) {
> -               kfree(sbi);
> +               kfree(sb->s_fs_info);
> +               sb->s_fs_info = NULL;
>                 return -ENOMEM;
>         }
> -       sb->s_fs_info = sbi;
>         sbi->s_sb_block = sb_block;
>
>         guard(spinlock_init)(&EXT2_SB(sb)->s_lock);
>
> ---
> base-commit: 782654a3e9c4065dea2e9f10539899d348b7a1fc
> base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> change-id: 20261023-ext2-fix-context-analysis-clang-24-504b5dd53038
>
> Best regards,
> --
> Cheers,
> Nathan
>
