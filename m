Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921993AAF7F
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 20:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788382371; cv=none; b=hOR0PwzVkun8DYzvNtbzSjl1Ui3jt0QISHh8EZPGXYGctQzRzX+/aWgCJqU17i4Dqqqt4xrtTjwaHERfiFPuEn5INPDV7PBBFoiFYKnv5DbR9Mfrp2S1Ug4o3PpeGnWSPRAJzFQ5x8y78e4SqpYHa1miJUDNj4k7xi6F2lYmTCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788382371; c=relaxed/simple;
	bh=/BadFUsA3OstmHGhfK99QbnF/NkulvL8khR/iLpaHno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JY1sRI9jpeLaovGSNMtKQMkBolQ605LLz97Kz9zSTxSoDjMHRk2qkJLTRq5KDcKUQiuZQNqRqiQkoKnzgl+qLMZgpl+5t28z2r5OMi8jliwnn9HKKjepz6zwxa5Q/i+funDDPDcz5fPhsCXJY1JU9jE6QZfhiuxCBNdamPDTFhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C1xFPzzy; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C1xFPzzy"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84e04df8c46so2223806b3a.2
        for <linux-ext4@vger.kernel.org>; Wed, 02 Sep 2026 13:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788382369; x=1788987169; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VXjufAEosIj1q8FXumUFsTj098OQ/YAIZCUC7EsihNw=;
        b=C1xFPzzyJe6Xcw5H6uguX8gbdFiLTeqdfE9McpcpgiEBn2hdYvKAsXzJL5s+fovqf5
         mozyYL3r+hSAeBLzk4kiCl1wbhoKyeUqD6c3Kv/zvn0IdxSppVDB15XxF1WdAf9rMpr3
         J4RRJh0XZKkLpxWSzPl9qwGSLRgui6DIrPcuIOfELYBimO88NOIEkjNNmFY5dtl8sl8Y
         lESZSUcj8+r8afHpEXPHolYRXgFaPpAq5GIqz0UJ1kfQU1g19gN1XTaHmHIf8LuBT1A/
         bwEDhecpph8l5aVYn19tXLnRTZePi9WpseEUHzvn2M0Te5HvmbpcqgEWEKXmL5pF4xx4
         M6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788382369; x=1788987169;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VXjufAEosIj1q8FXumUFsTj098OQ/YAIZCUC7EsihNw=;
        b=HW8auHRcaoDc4TTltU6Sy0V/Ko277nBVX1z0OcHfyMV8CEfiUxyerAtod1U89bWHk5
         +nCJ9g53cpdFm1yaC5l7Zox2cQ6yLJS51zrrbWZjsfQXExAoI8gwlO0G8P7bD5a8oc/G
         xzNWBYJ1TFQt9cAq8VO8VATDHJtjg9N557/nmrvR6UACZZFcpSeX/9XyIcrNhHM1ZY7n
         tdeaoBo8UBbL7KvEeTPFacdOM9UmJl1u8z5t4l9cJy4n9/Zd32g2hOWcRA6MTgaIY+Yv
         8Zi/oauCWv5HRb2xusofc9y6pFBxYYyHtUM5mxdQUnodQ+33tqpL8046nOcKOj7aFHff
         o3ZQ==
X-Forwarded-Encrypted: i=1; AKwUvByVyF2cVYFQ78WUdSCyRHpbzk/Aywf1nmeMe+moJooZ77EMn2SinH/SWwp62Z7Qndg3tbYuFaa1YNuy@vger.kernel.org
X-Gm-Message-State: AFuF++m8+ZQuFaXh2A81lYDIJr13LrT5mR7GRbg639G9Uqr7cb/bd1bU
	otEOVv1nZ5sXtuEV1fCTCbjkcFFToqNjPCu0fouQuo3/JdUgXfpZ6JQy
X-Gm-Gg: AYBFou3ohQSfDbXOMnmQwa4i4+20mgtRW0qhBEolwolO/5SHG4ZaLeXgWS1EF/bsTLy
	IxoYwWDG3J/G2+Oe7xyvnfqWlm7XN5mviYE0uJ60iOsR0nwWgl2JtuhoOcIOUi0doOCkpaicOQm
	aZIsjRVdy/wAAdEA5HWPo/8wbEOYzzU90hj7InVDBeq4WZLf5ouC0hJjkSK/YzT0v0xnJ6QZ3T4
	HXKbC1y6QBvkwVW0GRkZv9nziy2vFqx71/UvlTYUu2sJZXg4bB52qASuyWcP9u9Q84NBFVfuIvK
	oO4O7xWKe0Fm5hXOS1h9sMsVSSdeKtgu6s26EX9+78Om8fQjpoLa15MswSmpQlKPJxzezn5vRKt
	vu4AHwdbPp7VLu6BqPyONvhFisHIJLr0UnJsiKz5m8oPX9BlAxfFwP/a/gfFkQweJjkKj54NpMA
	SLzJKh76yysy7P51+bT+OsYnb/RJAS23bsF2wl6zvIWpsVHSM6XByYf/hRrJ2yce9B
X-Received: by 2002:a05:6a21:6004:b0:3d0:88f5:f813 with SMTP id adf61e73a8af0-3d9b05238admr12663995637.11.1788382368648;
        Wed, 02 Sep 2026 13:52:48 -0700 (PDT)
Received: from user ([2405:201:c052:b00b:4bb2:9d5:1e62:39c6])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3325592d9c5sm642702eec.11.2026.09.02.13.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 13:52:48 -0700 (PDT)
Date: Thu, 3 Sep 2026 02:22:24 +0530
From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Srikanth Aithal <Srikanth.Aithal@amd.com>,
	Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
Message-ID: <apiMiLlwujmqyYLP@user>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>

On Wed, Sep 02, 2026 at 09:33:57AM +0800, Joseph Qi wrote:
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.  Submitting such a buffer during journal commit oopses:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>    jbd2_journal_commit_transaction+0x932/0x1b10
>    kjournald2+0xb2/0x250
> 
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=writeback.
> 
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
>
Hi,

I was working on a fix for this syzbot report [1] and didn't realize that you were
already working on it. I noticed your patch on the mailing list, so i won't
send a duplicate patch.
 
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")

Could you please add the Reported-by: and Closes: tags from the syzbot report
to your patch? This will help syzbot associate the patch with the reported
issue and track the fix.

[1]: https://syzkaller.appspot.com/bug?extid=41453ea05ab61c075f1f

Thank you,
Pavan

> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/buffer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +	    op_is_write(opf))
>  		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  
>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))
> -- 
> 2.39.3
> 
