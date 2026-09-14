Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F15480DCD
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 14:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789396286; cv=none; b=nUJfmAaleBaXm4h7NplsgpvpApKgezvUxpDfRapA6KX7qPgKN1JYWWvuffSKn789vw6u3KHpdt5mmbwbaSP5PBjMQhq1Wr4QF36d51o3rQlu48Nx71UJAbVZXYsslDaa9v1i1uRgTdCW+7CndDjFfodFhRlYX2GGdYgTl32kk4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789396286; c=relaxed/simple;
	bh=wxBw97D3n70QL3zmvWubyM0T5mJ0kFxx9ywDlXKJKE8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=exIN9nbsIx89DTbCANkbVNfUWIkexvuVoCsWvxx/3FfF3CodGiEZFLasmXoBmQXK+mcLeE+YpArt5s9H7XQAQV7SpuNGh25dTKz0ixpP/N/e0RkkAeZCST8n3eTcIwHnSUl88iQ6r3GKzJfAk+pXvO4RqXYUmgbzQHdvsAHxaQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w1J0c01B; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w1J0c01B"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a605844571so2567910a12.3
        for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 07:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1789396282; x=1790001082; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wxBw97D3n70QL3zmvWubyM0T5mJ0kFxx9ywDlXKJKE8=;
        b=w1J0c01BB4Wc/hIVnALfDO/nJ7wV9PyhPx1QLkZR6/y5eEgy2MQhaA9CrnuGT0C9ov
         NRnsnL/8INBnbni/otjlfmFpGe7pCN9fuFhGlZ991Qn5+HShoizqVXgWVORane49EiEp
         6+xzBGXwiZUU2FOxoq1fLJnd4vq4G9sFoZgUz2IUnX64uigoHTuBea7++RsLmGqR0UoQ
         XpWzbNuAsWqjOk1gNP35hvpHZwN8+q8V+8BPOMzxD77H3ZopujXSWNDpSdR7XSNI5Ur6
         7OlDVZABQ8AVOXgxNI5u0DM3CBOiTZmp6mHVUYUaMJIVVmpZQTb0qmbTnPqH4b4TM9BG
         cx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789396282; x=1790001082;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wxBw97D3n70QL3zmvWubyM0T5mJ0kFxx9ywDlXKJKE8=;
        b=oGO2SG8xL+fALWAztjT8X7ncShhBrTOLCRe9OMsPmPFJy+3qUEmlrrkuTmhG+9sLrm
         IWgmfSPRFuxMrsvbbuOjOozTd8toCBl1joRGGpoHj3aH2MM6lf72pur5DyesyhdjiL8s
         kCmRucfYmtFnC5jAii2RQVp8uyX8NlRsAWm+op/FlHEdkmSM900UQhUB4xCF1YgP414n
         gwMWDpoD3FQ6SttpNxapJXPGc74Gur5XsPpeXMnRw0cSSI8n4CzqBT564dm3EFKP4C+3
         zkdXptuJ8t3rRgur1y/JBMX5aZ0gWyp4WUvXeaKb6OhC9evKAcv6WfKQWeQO8Fnwy3qi
         TJnA==
X-Forwarded-Encrypted: i=1; AKwUvByTaLke8GGUP7GwmlSzk1CM2DSasQVRmUR/Lvant37nlrnDrGPobPzRHe4XrZJZwq4/2pwYkbYBC6aW@vger.kernel.org
X-Gm-Message-State: AFuF++l6kfh2aEQLau5+LMToSZL8I4X5VpKTDenjKD+9gvfQs5NKz8VO
	fQpvMstAK4mFy4c/22yMOEo6U5Q9h4T994mwhyOHy02XNpz66xW6u4Nag92MpnA3Onk=
X-Gm-Gg: AYBFou1GeEV835ZGXpyw8GF+/Tz98kc3iDU1DyY/oX7r5rXSY6Y7lvJNOuN2iOgFCHB
	pZ9BLvOu2ktZd7pOyrNhZ8HlA4DHMTS9QN0WrsoZ6Ds8ksSlF7gxHREfCDzrBWzhwOrOr47H1tR
	hesNoPWqic23bautwbLwRveoyyse6ee+UkG/RH3bV8hrQKAVuaablphzGNalas+7j4AtBp99YiP
	F893DUJJirEJib59pNlv8knTq3hQQJ6rzXK+GndD8GQ6s6DY6LuQg/UdIK4FxCNxgXWxeC/+Zgh
	tVl7HAJirwgpNueIxyeTOsMxF+0D6rmc+6Ov5M7pbNMnmG7Szerl/1fT3aEAxA1xfqMFILbVzih
	WwjKQ8+y2nISk2E8SrttscRQ01cTfWFWNGrtM1SglS4eX4F22xvU4yo6H96cUBeXNFEJR3wqlf+
	ELCgPkNtSnkRo5iIe9zjgR15CEnaphbwjksvWuqRhjYWcjA4/CRiXDQt4Ls0EBMP9XZVUDo/kst
	oY=
X-Received: by 2002:a05:6402:1ed0:b0:6a7:e514:1d85 with SMTP id 4fb4d7f45d1cf-6a9f624bf08mr1626452a12.13.1789396282078;
        Mon, 14 Sep 2026 07:31:22 -0700 (PDT)
Received: from draszik.lan ([109.255.181.4])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9b58314fasm4317005a12.3.2026.09.14.07.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 07:31:21 -0700 (PDT)
Message-ID: <6b9d4e9f8c16c6db084402c54dcf1b046b56823f.camel@linaro.org>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Christian Brauner
	 <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, Srikanth Aithal
	 <Srikanth.Aithal@amd.com>, Luca Weiss <luca.weiss@fairphone.com>, Jan Kara
	 <jack@suse.cz>
Date: Mon, 14 Sep 2026 15:32:40 +0100
In-Reply-To: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-09-02 at 09:33 +0800, Joseph Qi wrote:
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit().=C2=A0 But jbd2 shadow buffers have a NULL b_folio since co=
mmit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio.=C2=A0 Submitting such a buffer during journal commit oopses=
:
>=20
> =C2=A0 BUG: kernel NULL pointer dereference, address: 0000000000000000
> =C2=A0 RIP: 0010:__bh_submit.constprop.0+0x87/0x120
> =C2=A0 Call Trace:
> =C2=A0=C2=A0 jbd2_journal_commit_transaction+0x932/0x1b10
> =C2=A0=C2=A0 kjournald2+0xb2/0x250
>=20
> Hit by the ocfs2-testsuite fill_verify_holes test running with
> data=3Dwriteback.
>=20
> Dropbehind only applies to buffers backed by a folio, so skip the check
> when b_folio is NULL.
>=20
> Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data di=
rectly")
> Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
> =C2=A0fs/buffer.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)

Tested-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org> # Pixel 6

