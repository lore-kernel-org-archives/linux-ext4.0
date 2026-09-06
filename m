Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF6035C181
	for <linux-ext4@vger.kernel.org>; Sun,  6 Sep 2026 05:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788673861; cv=none; b=Eyrob3dsBLys+RBAmY6YFu/m9HWdGikJWh5yIt2n/YSea9jsoHwhd2+JmvApU1J5twEsxg0ci9FFpzElnrgBWQY4R9BudU+x4x56XBzgQ4Pe1/uwMKW3kH8dCTJ/JTu77wHzkoxnq7mAH4PxNWxqTF3BMqpRxXK8WkClBh6KWg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788673861; c=relaxed/simple;
	bh=viWJnjrbhyky0K4g63DpQdEAEtLqeMnC3TLX78qmwLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yl7H4Ub3Q7Wjfyp7gi/GoVYplx94l28zE8bovE0pQK0cT1V0PBbfQWV8Lu/NkqrQA0IvVV/eIdql0ZpBPz90f9oHv/sJyMCCwuorDaidW3FmKZ9C/et8+ZlzG0dm0FVgnWpltlcSId5YqX9wKN401Sg6ANdS0SrWC6AGGDDKpb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LdCSwfLb; arc=none smtp.client-ip=74.125.227.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdCSwfLb"
Received: by mail-pj2-f8.google.com with SMTP id d9443c01a7336-2db33361b2fso4793985ad.1
        for <linux-ext4@vger.kernel.org>; Sat, 05 Sep 2026 22:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788673859; x=1789278659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uFG6XNGVyqJ8z6Dlrx8ujL8nDyq9SaEpffEn7E3UykE=;
        b=LdCSwfLba9JKVGcSBkmiXnSngjzqAwDp031bVN/XJvK6Mi6oAk2BGbw0ZFynSOU27I
         5bHaj9A5ecq6myaVdx9W/PCQtamhjV9tp+9AZlHfi2pLVQo5N07F4ouO/jgazB9rP7gm
         j5++faPym8//sLqlytPm2u9R8bErb4aG5/KEdxYFFjNiMSYm8nMpyYylpHDG+8FgIDlp
         cMAkOrvYZ6vluCxO2hIlvEAj8ktpY0hhnMzayKcRoV/Ph8+PnwVF91Oq+mkXOqJYouPF
         9vUPpjgOkZMeZvnwyh1B51Tn5iwqzEXm7S35lTNNAm4EvuqCx4tkOwnRSqSb+plcYQM2
         HyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788673859; x=1789278659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uFG6XNGVyqJ8z6Dlrx8ujL8nDyq9SaEpffEn7E3UykE=;
        b=hcjTTf/IZk5KapWhjphLpgJXNTH6L5grc7PaLvx4GbKiyy9XWKTXwRcVNyMLcYgy+X
         ZaVMy3ADr+H9+Z1uWXR1+xuAL6S91U+6zZky6EsZSLC/29kMy7wwYfDLu1dbJCTwAsPB
         s1v/voiTAsKIlLL9pKr7/z1izNLppsdpAL+QdJVt6GrLonJJlWWx6jslyqoZk78MPveH
         IS2tBfUB8z0FCzdAfSPBloWw8KK+20pubPyIaMMY4LYjuMrAsxEEm20rbBL51M/87VDg
         nM6OXuDKhRDHqELoZgZbxsLqiF4XIQXH3I0isMgQd4mJ0XcYLfwfcAzqCyL5Imi0q5yT
         1aIA==
X-Forwarded-Encrypted: i=1; AKwUvByApgWrCpEOKNSLEdlRD2FH1DzyyPHHdq/bd9i1Se/liklaICF2mvOWAftms8cSA2fivaC3aA2wtGDj@vger.kernel.org
X-Gm-Message-State: AFuF++kCl1MDfWqzGtYGSIW5q4F8o8hx3qjMjFa3mM5H49lSTDOeB03G
	mckNqdGu0IoeC3tssxvn0hy2P3A5dhXE7rZF71RUQmnqbzuKEE42fWwT
X-Gm-Gg: AYBFou2ikNuegQeOwPbyXFqBopBghH0LVYpLlU/rEEDlakmUayWOf04pJW+2WSrtMls
	4M3llYA2WlUeWvTVf5Ns4LrKZtcSf8IhMs56s1M4Hf56R04CHI0BbImTBgDfryeGe2RWO9FnrN2
	q4Nji9A4jlzzQcBtctdsAgxn7cSoBqFDmLikAwWIHf9twjtLxIkwM5vZd0zmkZLtTIqk0if4uQp
	UH9MyRLPxXZH7+mL2KZKJTV/NYeGsxwiOmGZDBDti9aWI+HBn0ozyoQaEZTpXzL6XP1M71fQeZR
	9U+FQ79n037grrADtNpOql3nFIvtZ16lFV+GKw0kwmZbd8W9kcxbHt35qV7ssiREjSj9jaOTH3W
	1G3DgbKguMYay9nBkbWRMBk2tY8qOtoDh2gSg1lXj3sDHMzhUpSW49vl39aYn5ss9wHX8ymACz3
	sGbDkmE9B/ololyiQQ2k6TRbLBky2kKxsMpA9oLKUYd0Y3scTCd1/o4ENf7mEOfrFHa6G0V9q7
X-Received: by 2002:a05:6a20:914f:b0:3b4:7e2d:a3c2 with SMTP id adf61e73a8af0-3da3a03e965mr23968702637.18.1788673858878;
        Sat, 05 Sep 2026 22:50:58 -0700 (PDT)
Received: from localhost.localdomain ([111.199.57.231])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc45e15604fsm2225263a12.0.2026.09.05.22.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 22:50:58 -0700 (PDT)
From: Gong Shuai <gsh517025@gmail.com>
To: joseph.qi@linux.alibaba.com
Cc: Srikanth.Aithal@amd.com,
	brauner@kernel.org,
	jack@suse.cz,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	luca.weiss@fairphone.com,
	ocfs2-devel@lists.linux.dev,
	Gong Shuai <gsh517025@gmail.com>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in __bh_submit()
Date: Sun,  6 Sep 2026 13:50:32 +0800
Message-ID: <20260906055032.3005936-1-gsh517025@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---


Hi Joseph,

Thanks for the fix.

On the OrangePi RV2 single-board (SpacemiT K1, riscv64) I hit the NULL
pointer dereference while testing other patches on top of linux-next
(next-20260904).

The jbd2/mmcblk1p3-N commit thread crashed in __bh_submit() when
submitting a journal shadow buffer whose b_folio is NULL. On this
board the crash reproduced reliably, roughly 3 minutes after boot,
under normal filesystem activity on the ext4 rootfs (buildroot-based
minimal userspace).

After applying this fix, the same kernel/board combination has been
running stably for several hours with no errors.

Tested-by: Gong Shuai <gsh517025@gmail.com> # OrangePi-RV2

Best regards,
Shuai


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
