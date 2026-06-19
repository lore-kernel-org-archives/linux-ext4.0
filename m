Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E25313E2B
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 07:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781854126; cv=pass; b=uKVfB7S22znelhqgLwNEg/YmSTCB49heCV6m6ggVS7n0FjZdm7U2P1xpILvI/QKMZEeTrpvVuMSTfuqysYT7vjGa2H+XWgkYhMHxPtbzQGr7AM8CPgOPgaXI+yYaLHUAO29ffs/p3DidW2M5X9Bo5YV9aPJ2wPzssr1ieQEEma0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781854126; c=relaxed/simple;
	bh=PLjuf5U1Ldp+lKMspivltGTyqfvutQwDbWwFfF6CvPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FBeLyryBmqRviRnju4nkmhg9HpOdKw02F4Ra+gdXlyXxaHYJcZfeuIzwX19e4htO2wEh/+lIuFf/XMxOtDtHE2eEBOIhH4Jd5pxtahqz6Rgh/A2tb2qUpR+PYwLk6jA3LibGolC0f2M1hiTHZlGGjQnZUwf6stnupN3F4i4l0FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKTQcXfm; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKTQcXfm"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-693c69b97e7so2886955a12.2
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 00:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781854123; cv=none;
        d=google.com; s=arc-20240605;
        b=Fj5MJ6Z3Jeb8XJT50D6hXXwHX1x6/m9GoqkwknMMRayKz0riL9KfkmIpRgIHhPy08n
         RusYmmm9bTKtzrJXaTlhw18NVWBpbkDCkUjC3Mfo7BIzeygJwx7SZ5Sd51WLcUNeUPXg
         +5YxFUDdkv0rSYUKfSGE9wf2+vUr0SZ/LKX2ZFxgdwzHL0i2qRcwIDgDwD7vwl7BxA6K
         Kn5lF83DBcXnW5iqVBlviTCIElFgdEWWJfEW7Yfrshdvrwm+z2qUDQvBSnJuSTi1Qywa
         4WnnCqV5O6R6pqq+f6zJ18vKirliqp1ZvMrFwo6zorO18D91ig8exjFLu2RB3/M0AdJY
         0b/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        fh=c1xpJ78A4KJJp8ygCpywanrgF855BE9NQ5eMWHPZ96U=;
        b=JpPzBO8izSzENAmj4Zo3e+FdB+o9auzFBCdZpY/uwvQHTMcfo73iR/naETJU0zEZ5+
         nESRC3Q8GQZzIE6sTrLsyU8AZ13PyoAPl+GBM6hP38lW4nnQE47zx3fHkkL5e8q0Tvdd
         XXE+ljXDm1yZNvP1vT0JVYCrHPgQxp8yHfJJDVeDbYxGXq+c/SBnt1sE0bJ4xbrO7xpZ
         15XS3BpSYv9t7AUI1sVsGsDL2/cHQdVq4XrCIvbmMTZ9g58j/h4JR/W+PV/2OlVUZojH
         JSbe1hK9yF16MXMD2bw5et38XsEouh4Vl2bkc5etJIah0rlQyFFWX/MlcmgEzaW590OU
         Us5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781854123; x=1782458923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        b=EKTQcXfmTpSi/O7oXABloqzK4/JL++I7lANtSI92FSwbPSaHSyI+Ly8uLgGGwc1czJ
         YtYQI1UH6Uizdt0GwLZqdw2hO65NG7CfVB0eP71OayhIh1bgU1DaOg15/9a9kMa2zgBW
         zdQNfNRTcXpnOjFC0pWD2Qy8AAunFSt5GVlRmax9ecbpzBv06uE4YFJ4+8celdU/Mj1B
         MGNL1NDGi6M4Os0QZhfGMRwpocG1MmdFdOgNugrBvNpnHeADOFto20dQ5EA6cQgJtC5/
         S6OL7JKPrJ0cmvFh1esu4XnUeP+wn0wTEaOxYUfcyAwVCO0NjXfBZnXTUOLQKFc0fC2I
         AXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781854123; x=1782458923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cXsAttpCRAfo1jUwXpOflkS7AbE4OJcRHMhxuP67MIc=;
        b=Mm5QEcTtBOrZHJ5Z7/uMv/ZQmfVzBcBHihdakuBKOp19rLU7clyu+npYfI9mc2sUVy
         1vnqThKGbX5xeOyflgg/aoDn6comLjnyxXef9t590eHNol0tmQQlSrFW2MbKOZEDmx9S
         D1cfp6Scl4smxMreyOUwXE3hWB4OVkaN7OeL1dNjgRLocKLClyB0TsxpodXmJosVrm+S
         L0ZpGWV7ZnEuXOxJzU8uZ0/koUmWI0XHSxJN8snG2+pQWOMKgkpV8yexSaxeX7rForSY
         f2RH+OM0lMV+mszGbmnWYxuB0g7FBC2J6SwU/BA9zMwo95RZiRTfCaVYl2ILFu0KWF19
         N+VA==
X-Forwarded-Encrypted: i=1; AFNElJ+qfla0NHjaHtUuakvhLkCyniM6jexl3/2NeIT2WtBr0PvJIeICRU6AaaWWInwLCGa/IceX1ebUj3Yb@vger.kernel.org
X-Gm-Message-State: AOJu0YxEA3K+/mou1jyGBIXowsxXSgiEeJi/WdjOsE57Yzhf5KTkXZEP
	xW/1CIZZ29ObzE2zNdTPwcK8TxtNhYHf2ujilCap/+RvW+LKZkG9pktDOCOOCgTHoAl7sH+5iDL
	/TOxHfwXJ+/YZatR7e72iu1FRKbK+nnQ=
X-Gm-Gg: AfdE7cmZWsQcA2CKykwCqUq6FtmthtePR4hTIxvg3EKp9KsWoS0hJbcZnYwPXxlSLgZ
	16p6iTRR71PyOHvS72nEli3F+FCYgMI9is1z+kEr1dpRuQGB96v5xlzGaVU+RUtM8qOI2RYQvtF
	Z52xIqAwnxCamBVJRtEcXiroF3Xl8Cjdjz1vIUNbejTwlyCa7e/+2OELqugPoRX7BIUV1Hi0YUf
	ic55c+b3qE+i3YE9SISqDbr9cgRF4HiyKCpnKpdclVPurT37/PgSEpkqhjMklJrBudnnQq576/d
	9y2ZD9lwOz6JN7iybLKke6yGbF0hNde2oQLoBRLx4Q==
X-Received: by 2002:a05:6402:5107:b0:695:572a:7ab5 with SMTP id
 4fb4d7f45d1cf-69711e00675mr1216968a12.19.1781854123208; Fri, 19 Jun 2026
 00:28:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260520123722.405752-1-aalbersh@kernel.org> <20260520123722.405752-4-aalbersh@kernel.org>
 <20260520190719.GB3424023@google.com>
In-Reply-To: <20260520190719.GB3424023@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 19 Jun 2026 09:28:31 +0200
X-Gm-Features: AVVi8CcyPPKNjODd0CeG8qbXXsZeOsRanxA9PmKFMYeTLACw7w0uBX2gqOCDc0w
Message-ID: <CAOQ4uxh_hfiSwMw8ABhhrz7GguZWjHEiBmvb3eq16Wfqw0+ZrQ@mail.gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, djwong@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 9:07=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Wed, May 20, 2026 at 02:37:01PM +0200, Andrey Albershteyn wrote:
> > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > instead of opening file to ensure that fsverity info is loaded and
> > attached to inode.
> >
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Acked-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/util.c | 14 +++-----------
> >  1 file changed, 3 insertions(+), 11 deletions(-)
>
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
>
> I'm still confused by the new implementation of fsverity_active() that
> got introduced by "fsverity: use a hashtable to find the fsverity_info",
> though.  I should have caught this during review of that commit.  For
> one its comment is outdated, but also the memory barrier seems to be
> specific to the fsverity_get_info() caller and probably should be moved
> to there.  Anyway, that's not directly related to this patch.

Eric, Andrey,

Did you see the Sashiko review for this patch and others in this series?

https://sashiko.dev/#/patchset/20260520123722.405752-1-aalbersh%40kernel.or=
g

It annotated some review comments as high and critical.
For this patch it is about interaction with fscrypt.

Please take a look and say if this is concerning or false positive.

Thanks,
Amir.
