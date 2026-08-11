Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392DE3BBA03
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2026 02:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786416906; cv=none; b=gnc+dpZLWMLHO7R/e07MMiHLX12pb8b/PyHoohgRgQgN8llVmQoTnupEDfoF9b5tBGDXKoFH/0WkzMI8iNstjKSKb3Ch4KkicJxnGhdz0SMIn1dAt3O+HnZKhIicrLWKZGK/JtkDhBpjhhUIWyu1IHz2ZsMA5HmScZv7SAZYB3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786416906; c=relaxed/simple;
	bh=YmfmUQLDb3l+7s1j1ocN2ORQuYUiCg/HyHTRArKEq6k=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=V8+FWN/6ZRJV7fMG1eUnTKofHkVWFFItenGoEEcojZLvRcWHvYsbgju/IB+AC6Gu5/Qycx5NNjvRQtkEMz6yyXokeMgU6PSbUYsE9Aq9KQMfXxQ/ZAz/SlER0vR0v5fwoe9/+IbNDU2d3HLQb+91t+EedlPv6RAY2p0epd1Yjgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=De4Vz6+n; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="De4Vz6+n"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ceaf8a1265so39947735ad.2
        for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2026 19:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786416904; x=1787021704; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=7f7P6+Mg6gW/zIFPZnZ9O0n8HYHX0J4ooE2hsII09M4=;
        b=De4Vz6+nBjxph8C49DQUHUViBTk9Sfkfbu57l1cEocM/xBcRkKb+DcX9vXWr1HZ7SD
         OzdeepwtEHJA+UvcwXWVkAZcHVLKct9DhsXDtwizsA4QnnhcPTWcIq0zdzSufSU5KpO3
         aLPVZplZzw167UgFiA/gdMvx+n4R3FRUjRcNlLEcMEtuZXrePwxSpQbDdvJKGNdwgbI9
         mDKk3NAhbLadM45jPLqzrDA8hKH4dLRjmDzn1VgpkzKbVX8NBNI32S9nZOiPRqR81JRQ
         ym+GSSb70RbGywq7ZJxeYUcC/328clScP1w/rJSrpQ+22gIsEp/gZm10+to+ERVq32/r
         4bFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786416904; x=1787021704;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7f7P6+Mg6gW/zIFPZnZ9O0n8HYHX0J4ooE2hsII09M4=;
        b=QCb25cwBF/rFncaFn4ud02uoTQUAPJkxg3b3P+cSeEHZNoxH3JSNV/nmXLTkedsmjV
         2gD6R+SB9slOozuVhGxwfOpvNpO34BeE4+G/xutn9nRWHlAUmZlFDrEoEnFgzGBEo42X
         5gzp2AgEpqHOWrYit3cVS6ep357Sj9235WMqbzKfMODm+gZ6cJNl/wDgBDxNiIbqEZG6
         WfMX2hdwPkJcKQ1FgaX/X6hDOtIRX6D7WvTcJ47Cbv1sr1tI0odztpMebKcIXlrasu/N
         xo7POjXhywr+2nm5oBXoOIbavAByki+EN37tfn5SNRmpRrocMnETvB4Y2JGbaiAE+Jil
         34kw==
X-Forwarded-Encrypted: i=1; AHgh+RoRWfiY1g+vRmAhRQ0bUARB4qnIG4Wq76mNmwv9ZId+JDXa6RGpiMDb/zwL+SjjR0uH8/LUDl/OH+ei@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6Aq4kjnyqaibGedsq2ZNnkk2+0H1N5x6ggWTQkD17cgiut6I6
	k+jOZtVQUj7c7YX55gPzGF7BFZXTzBNl9d1djLK0qNw4frNw6aV7CDhX
X-Gm-Gg: AR+sD12aqqp+Ki42fS9JRW9uF19ltI+2u1oT93DPXd2Z8ofa8A/Z6Vk9qCY1Tsam3oN
	RzCnJFeSuaZ5W+J9cJzR4ZsMCkq/HL3Q+C38cS1P7oM2Zu9jB3ZHfb/ywYEENngNBasLDKkrWug
	lrvAL58tgPr0Ni+NYCFETFvzXGmBxKkSPUruqwID0aSotTIdtkdZSYRhXZy0ePkfc0/vlPiWkzP
	3/u8Vu/QQWliaze3Dp6LWdM1xKBcD4QyinvonwDI4ORBtGMLUbaouGansiMXTFJOPOoX0gkFia9
	Sl0XXIWLgzaO8UZgQSdpPe26m/GK8UnMDg1ho4sJEr2RD6+fX73hPD8SXQnhZoj/rLjTcYakgHa
	gsRO7/AkdAQN+Xg1ER2mleyz3WTcqIBe7ygWkBtJPW3TbGpU3OX4yeryKBPEZ/8yynDiz7xwPz/
	cxT+X/U51Bsm8stFltcyUnRvKpZWj7BJ1d6cR/e6aySZnkhcVbselGyPooJ9NWpLG2DOaFsWE=
X-Received: by 2002:a05:6a21:1fc5:b0:398:8870:b58f with SMTP id adf61e73a8af0-3cc2b872b58mr583456637.14.1786416904467;
        Mon, 10 Aug 2026 19:55:04 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec128a0sm55473900eec.25.2026.08.10.19.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 19:55:03 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: guzebing <guzebing1612@gmail.com>, tytso@mit.edu
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, guzebing <guzebing1612@gmail.com>
Subject: Re: [PATCH] ext4: fix reserved group initialization
In-Reply-To: <20260811021848.1821435-1-guzebing1612@gmail.com>
Date: Tue, 11 Aug 2026 08:20:32 +0530
Message-ID: <tsp1jrpj.ritesh.list@gmail.com>
References: <20260811021848.1821435-1-guzebing1612@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

guzebing <guzebing1612@gmail.com> writes:

> ext4 initializes the in-memory reserved uid and gid from the on-disk
> default reserved id fields during mount. The s_resgid assignment
> accidentally uses ext4_get_resuid(), so the reserved group is initialized
> from the reserved uid instead of the reserved gid.
>
> As a result, members of the configured reserved group can be denied access
> to reserved blocks, while members of a group whose gid matches the
> reserved uid can be incorrectly allowed to use them.
>
> Initialize s_resgid with ext4_get_resgid() instead.
>
> Fixes: 12c84dd4d308 ("ext4: add support for 32-bit default reserved uid and gid values")
> Signed-off-by: guzebing <guzebing1612@gmail.com>

This was posted before [1] and looks it already landed in ext4's dev
branch [2].

[1]: https://lore.kernel.org/all/20260727104103.28916-1-liujiazi@amazon.com/
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=c87abbab6147dcc5aa1fd8f2a61734d58d8b99ec

-ritesh

> ---
>  fs/ext4/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 245f67d10ded3..63de62a75a543 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5369,7 +5369,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  	ext4_set_def_opts(sb, es);
>  
>  	sbi->s_resuid = make_kuid(&init_user_ns, ext4_get_resuid(es));
> -	sbi->s_resgid = make_kgid(&init_user_ns, ext4_get_resuid(es));
> +	sbi->s_resgid = make_kgid(&init_user_ns, ext4_get_resgid(es));
>  	sbi->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE * HZ;
>  	sbi->s_min_batch_time = EXT4_DEF_MIN_BATCH_TIME;
>  	sbi->s_max_batch_time = EXT4_DEF_MAX_BATCH_TIME;
>
> base-commit: 06cf61899d6498b33e4b7c87d99d5bd471ccc375
> -- 
> 2.20.1
