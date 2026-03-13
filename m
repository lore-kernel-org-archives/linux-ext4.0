Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D48C1DD525
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 12:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773403363; cv=none; b=R4GPc5N7LvvyY0TgQ4FmBTpWFHyul5V2k+BWGrw+SSOkXjNiUvwpvqkgVZ1ClRVdiVJ2swZ9Mf4k9yLHkERu2SHCNGihUfV/Swgill1MKVMls1p0EH+RTSb84xDxHPfUnRQr4IW6rANxhFhaXqvMLW1VZzveI6SIKl2ptmqE8cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773403363; c=relaxed/simple;
	bh=BnqSoenq0YZy+twPSrNb1gS+XY7pKHv71bmgHQaQVuw=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=NUPJN8p0C8p/Zby80pBg06j4nKz56oCcaxyEb0UsIDNZxUPDp1lMN5cqRH4kcyGNa2jQ92yQbzBKcxC2JHKo4mrVf/WkLF85DPyDRfZRmIRb59Rkxm81+R/9Wgxl2yJnzYWG27lHra7l96KaRuY5iXlIb0oX7cQeGuTEeCbPCGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Od/CyrEE; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Od/CyrEE"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2aecefc7503so3930945ad.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2026 05:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773403362; x=1774008162; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mz6naISo0agNsbyOZ5kwqUlBksXOn//ktWXY9HR+/20=;
        b=Od/CyrEEcRQ5uO6srxc32vEoHjZxGu1fRuVNxMepTj2nEhiYVAy4cnu/m4wuBwmVBR
         l+txTkxNxQvdhUKB5ydJbfjIng8eX7LdgWNL+XRDgZTyeCslLkWnLYEWYe4lb9Nsqj7D
         KEl+xo0bE9fpbHHaCMrVL5cvEKPKW2SYydDUDvf25jY8/2Fxw5twwXaP1dlPovRYUzJg
         nr2aSk9slD3zp1U2eVEFCba12JcuUmWu8sGzdo4+rWXRfj/baSkTywER6kLy4CIpKRRu
         qv9TF3Fs1sTf9zDK104NSz4beFSIZO8LSVXZMFwEpSv5g4QxZSYI88apCU1HcKjGc8kS
         sTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773403362; x=1774008162;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mz6naISo0agNsbyOZ5kwqUlBksXOn//ktWXY9HR+/20=;
        b=qwS9z9jfPJCIfKz4abr11sld8gmXChLXEKfHvXY6QCZa6GGNlDHvEi0kvxnihR1PCw
         f+daEGOuG7mX9WkBq/YQAJ4dgB4wOQs/o6HDjfT3s5xENoKA3HEVIhN5w4TSkcrEeuYg
         YquDS6OpNIXVKyfORz32uzH8cOcrju3TrN6LPnSenotr3ymRe4/seZh2BpcnUva53OHS
         7lZRNbjk5U9OQkBhKBFweuzMVo/iLL0E27nK5ph8b+WOX+6ADnMmXm+n/Exyx7FDA8TU
         6Q9AFb3onq9dCUkv0sKNSMjVCUMvajIvEhExqusqyAEnrWq6obizeIPXj4XlXMrCO6ts
         6AWw==
X-Forwarded-Encrypted: i=1; AJvYcCUgnrPU5jN5aalIXLPzW1FIqGta8OhMS0XJltzeuGn4ihU3/uyO+FGGzwQ99Lt+QxcByzh9kgizpfiJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp1XNdaNAOyEBlfMN9GI5FDu9bjFo+Go2tYMQNG7WJEu8mxN98
	zobAdSVlI4ys+WWNs1RX+Wk4Rbk8g6qf0bOcTS0tg2XeIcVKHM1wQdh/
X-Gm-Gg: ATEYQzwHc9gemQk7zgvNtg0bqHelGOyAhT1uSKei1hxN1vAvWLAjZeMaPG0EdecCSP6
	IpHtFNeRhd/uVWlKdz76DBgn8RE8w7GCPORitykpCDuy82t3iD/SiRiu3HyxQdOSrLcSqFg42Lf
	QHJB+a4f/rLatehgfPsPfuKCHRk3zB7+R/dpCXFmlcInyhq28EzYrpqn4dmuY1A/9fwTGrZX2uJ
	X0h2j7YKqegNaQyN4Vc6MMrbpQHwtM3MuG+M8hNeaKuC8+OFsmWhLH0ZJmbRFQtD0ISIJeFJtsM
	wkA9zhqnae+sSEfdvIdqqj13swWbRdws42Y/2VBx4C65Pqlk4HE6HQBjZkTgGPZrSx0F2eOUC1+
	y1/NUMbxljQz4ilOQciwDlhXEeZ/jX+1PnpDUVJ7pFpUwwDI4dL0LLf84Nolbhc0XfIvifkXYG9
	8Xt0TQnfER9OCzHaFQ8UBecQ==
X-Received: by 2002:a17:903:174e:b0:2ae:5eab:132e with SMTP id d9443c01a7336-2aeca92c3b6mr27451055ad.12.1773403361609;
        Fri, 13 Mar 2026 05:02:41 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece8093casm20785575ad.61.2026.03.13.05.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 05:02:40 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Ye Bin <yebin@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Cc: jack@suse.cz
Subject: Re: [PATCH -next 4/8] ext4: fix miss unlock 'sb->s_umount' in extents_kunit_init()
In-Reply-To: <20260310130412.3156753-5-yebin@huaweicloud.com>
Date: Fri, 13 Mar 2026 17:02:08 +0530
Message-ID: <v7f0t16v.ritesh.list@gmail.com>
References: <20260310130412.3156753-1-yebin@huaweicloud.com> <20260310130412.3156753-5-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Ye Bin <yebin@huaweicloud.com> writes:

> From: Ye Bin <yebin10@huawei.com>
>
> There's warning as follows when do ext4 kunit test:
> WARNING: kunit_try_catch/15923 still has locks held!
> 7.0.0-rc3-next-20260309-00028-g73f965a1bbb1-dirty #281 Tainted: G            E    N
> 1 lock held by kunit_try_catch/15923:

Strange lockdep didn't complaint this for me.. I had lockdep enabled in
my config.

>  #0: ffff888139f860e0 (&type->s_umount_key#70/1){+.+.}-{4:4}, at: alloc_super.constprop.0+0x172/0xa90
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x180/0x1b0
>  debug_check_no_locks_held+0xc8/0xd0
>  do_exit+0x1502/0x2b20
>  kthread+0x3a9/0x540
>  ret_from_fork+0xa76/0xdf0
>  ret_from_fork_asm+0x1a/0x30
>
> As sget() will return 'sb' which holds 's->s_umount' lock. However,
> "extents-test" miss unlock this lock.
> So unlock 's->s_umount' in the end of extents_kunit_init().
>
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/extents-test.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index 9e055f399167..5a5016ea1ecc 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -307,6 +307,8 @@ static int extents_kunit_init(struct kunit *test)
>  	kunit_activate_static_stub(test, ext4_ext_zeroout, ext4_ext_zeroout_stub);
>  	kunit_activate_static_stub(test, ext4_issue_zeroout,
>  				   ext4_issue_zeroout_stub);
> +	up_write(&sb->s_umount);
> +

Can we re-arrange these patches please?
Let's bring the error handling fix first (I think i.e. patch-6 in this
series) so that, s_umount lock also gets unlocked properly from the
error handling paths as well.

With that, I agree releasing the s_umount lock is the right thing to do
here which is taken in:
sget()
  alloc_super()
    down_write_nested(&s->s_umount, SINGLE_DEPTH_NESTING);


So feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

-ritesh
