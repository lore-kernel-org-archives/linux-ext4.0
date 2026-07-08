Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFB73F58C2
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 21:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783546222; cv=pass; b=MfUE1DCdc6xuiZHrNyXK3OTwDuMCesyrcl4o2qwXy2IfsZEAA4JVuxXs/2WoB0hHDLevo5DbBtE0D+OZU/kBUQphTmgkXcDlLkePR/nz3jysECKmVeVVZx76/pRVHUm928uN9gQkd79b7qwkWgcn5XydtU+B7YTZy0IOuYIN6ro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783546222; c=relaxed/simple;
	bh=kgvdwCop/aLSvgkbu/K8xvwikDak1ekolcORsUSIrk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z1JCqnrjvZxLaihyLU3t4wwtn8TG92If32TcgiekRYsS8MWYhIx7l6l6rShf1SEYHKjFbAJ5T28m8u7CO2J8nQyAQfSXeJNH46CfZDFYnAlAP1s6+RyNFr9OrJ/PNhfX2gqtYXSwEtUssIrDJajiF0bleri12TLNM5EqGOhVHCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJQy0fpJ; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJQy0fpJ"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso812595f8f.3
        for <linux-ext4@vger.kernel.org>; Wed, 08 Jul 2026 14:30:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783546220; cv=none;
        d=google.com; s=arc-20260327;
        b=WSdy8RTLhpwHNYsfVUrj7Ay64Q/6i2FYiJnIKSFbsIkav8QGkSM0gamHRAwX6OKyC6
         Hsh7rJhxhrWcmAUC4oreYuBpdaw8scrESZZ54CRHyOdzN0f1sHARfg3nYufSWQ38NmD3
         R0SrPrUSlMN0utgryyFPOi5GPucgYofXM48hrojOjjzPI1WH7of9It2eErih6IJvUyh4
         YiNMV7M06SdZn2eXML9bdPvdtIfXNNIwiuxovtPuo/cm1irMEI8iL5mBk9f0NOo1/yfV
         4oEmPBrvRbcVVSBlLiPMh5SMtD5UjWuFcgAP5w8tcXsXJLQ0kWl8xErwiTcOZInRqSNb
         7RiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oysFZq6tAMslUX12xXRG6mkqYiMd4xCFaT2TvkVCwfg=;
        fh=N+GL6h0Qw7Sr9dY7GysjZvwI+fb4yeIvSr7bU0y8Kl4=;
        b=bnykf/X1wbPqmR2ZqQnB77DDfRO9BNpa/YXXqyrMhI3ncgGi7b1Dw6X9XrEhx3N75V
         wigUA1MU28oUuD1Zd94428Ty9aOq+/UHedukGIhvd6kOX7yJcmwdgVvKvmPXxCIxf8Rc
         HkDUimaXcIxZh4OcmbzCMiwIid4sFpPOzbjxZC4Nux2ulVUWUN4cNikkqWhRHUqERba2
         Ieh5MUUvB+qyqYtRw8f6xbArpxXFVmG3HHGfo6Tz/kRsJyS+L5oPzuN1flz31hyEsOKy
         WPLjR75E2Cr1bsNBEe52vlHh0BAJY5VhkNVpWxEBUrA7N+ofZ4uN6XzzqNtH+04zCG1c
         d/TQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783546220; x=1784151020; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oysFZq6tAMslUX12xXRG6mkqYiMd4xCFaT2TvkVCwfg=;
        b=RJQy0fpJv3jey4oVW3Jth+gMCS0D+qKWsZcVqK3QeSsQ16gmCFNS9CbpLD60E8A3K9
         TR6GMD4UmkmNdFvZaOPUhqUGwikiGSeaCAju2UOUhlbPWVCZVPLnjZPMxBSXi54koZ0F
         2H+qXyoHa9QRiF3yaFUfz0g1NU7tN9rNwXzcIDLuh2QKElrAlPHNL/LWqpY6p/+HyKWS
         AIrIDoqIE6vUo0+XdOw4g1DKMIynTJ3oZ9ud93GyU4yZ1+ig5asjfElCGEFwAh3LMI3N
         m3WEVBmDXtAAcC1nFvf5FzcJRztFbfE/O0sNannv8vHK+RwGLDhGQ9m+DluCnjakM9GY
         Ew5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783546220; x=1784151020;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oysFZq6tAMslUX12xXRG6mkqYiMd4xCFaT2TvkVCwfg=;
        b=olygjmfQ9yIDvWmmYBWuzCBoRakzoN5+muRqDWXTi8sCjoIE0U/nKqmg5tk/B6Mr3q
         p/9eQZ0DJ8zWAMXBzXtaUZOnfDG4ZUVbiz8Y4Rhhs0R3QxtrayBRaqKysNexTt3ST8Zc
         wOtMSVOmw88qpraJpfHiqRp64TMCZki8GDYv9X8V18jPs5+pKfQYe+sCfRe7CW2DGF3u
         9Xx5JU2UzrMicgJldqHjmaumv/4vpQX8VviClPNUgvTlavO7pMHbVdhvUA3Bt661AdXw
         Z9ozLfcnsGEywS1rjSCAssX0t1bwKW/MV05hj0EvTnbswMZnJoEyouoKxxEmYybFl2PK
         9GlQ==
X-Forwarded-Encrypted: i=1; AHgh+Rphx3TADwZNIzl3nuuzFx6H5TLiZKkC6gifaY+PigwhaTseJNzfrAfYo+cazKicuv17FkpqQWhx2Min@vger.kernel.org
X-Gm-Message-State: AOJu0YyMEcri5eJTkXuQ2gZ0b7NnKniddoU47P8tKSLwW6s7DF+4LTu0
	8o/2+vDHFOUNHa5dmVafgJv71xopCwDHFL2UiE4dej00pRP93CXTYU7YTrjN3Fx5OR8SbkhQHxG
	4Qqgfrhd83xkkiupfRyxw4fWw9/AONLY=
X-Gm-Gg: AfdE7cnLcWP6MPM/LOicgN/xDfq/2GnupV7dVSIto2nHorYKgMftkH5ShVkG8+4yTRX
	9BmMhvq27cqC0QlkGs4zPOmzSLv6/Nzl63ACNs2Nois9vS70zyP4TUWt4zwxe7mheHTDeDe6zEQ
	W14/je2VtFTXPsGzsskK0+cEBhFdep1K0OHfmaRXw7NoL7BAiSFRAeIojuTW5BAqTjm4PfXiJCy
	hTB3w45UyPPvPdUraYTzvCN7q2/4YqAkMSQTfJBkDI3of3mhCmhknmtz5Y5pmqQJHmsyY59jEIj
	0VEPPJBEIfQo63C0gvSqNehF+RWMBJVabHBLLEIkglethkeRW84H
X-Received: by 2002:a05:6000:1a8d:b0:46e:997e:b4c5 with SMTP id
 ffacd0b85a97d-47df07318ebmr4686335f8f.18.1783546219649; Wed, 08 Jul 2026
 14:30:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com> <20260520030357.679687-3-yi.zhang@huaweicloud.com>
In-Reply-To: <20260520030357.679687-3-yi.zhang@huaweicloud.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 14:30:05 -0700
X-Gm-Features: AUfX_mze2KSMzcr9sNQr-lNuBFUay6tZXCOW1WB9AHVpL4GFldBmQybXidQ8yFw
Message-ID: <CAJnrk1Yeqij31Geuv55Es+si0zRqzCGe-B=hpw_DjT11AsRcTQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] iomap: support invalidating partial folios
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, brauner@kernel.org, djwong@kernel.org, 
	hch@infradead.org, yi.zhang@huawei.com, yizhang089@gmail.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 8:09=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> From: Zhang Yi <yi.zhang@huawei.com>
>
> Current iomap_invalidate_folio() can only invalidate an entire folio. If
> we truncate a partial folio on a filesystem where the block size is
> smaller than the folio size, it will leave behind dirty bits for the
> truncated or punched blocks. During the write-back process, it will
> attempt to map the invalid hole range. Fortunately, this has not caused
> any real problems so far because the ->writeback_range() function
> corrects the length.
>
> However, the implementation of FALLOC_FL_ZERO_RANGE in ext4 depends on
> the support for invalidating partial folios. When ext4 partially zeroes
> out a dirty and unwritten folio, it does not perform a flush first like
> XFS. Therefore, if the dirty bits of the corresponding area cannot be
> cleared, the zeroed area after writeback remains in the written state
> rather than reverting to the unwritten state. Fix this by supporting
> invalidation of partial folios.
>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/iomap/buffered-io.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 64351a448a8b..876c2f507f58 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -761,6 +761,8 @@ void iomap_invalidate_folio(struct folio *folio, size=
_t offset, size_t len)
>                 WARN_ON_ONCE(folio_test_writeback(folio));
>                 folio_cancel_dirty(folio);
>                 ifs_free(folio);
> +       } else {
> +               iomap_clear_range_dirty(folio, offset, len);
>         }
>  }
>  EXPORT_SYMBOL_GPL(iomap_invalidate_folio);
> --
> 2.52.0
>
>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
