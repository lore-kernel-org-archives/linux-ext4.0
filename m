Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793528732;
	b=Q/HHICeg/ws8oaYVuO2SV+ytqsyqEB4orus15LtwCvhpfBhP7AIUb8a/wAAVn2+VAMTb
	 QBIfgyIbab9Eq2EOKPAB2lFUWPJnKrPoBe41ft1JovXLoU/WU3YdB3xslClkiu+KU/whD
	 cKNAojm2FaycrmnRb4QjPwBr5PwxJw+6tx+8rza5phXUROMQQR9stsya7LVpJT7xz2tsN
	 81xk+oV6ViTGeEyV13vYRO79Y8Hzkcw0bJu+GDKQtsClakABK4xzhjBH2Q2DskK3vYtfu
	 YbKbZh35b7v4/gPqTZ6odwlUq/fken++JOdIMC2ezbaiM7/f+bM3UsPv0QQUhQxVGMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793528732;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=t/0ncG9nll+q5fYk7Wdi+F9VACKzeLeYjVLKA0lnaSs=;
	b=JxQkvjo+73kTIdZulhxNP3nEZy1WJyhZnC92poaKr/P0L+QJLGoel3lIPIyM1niNRCLl
	 1OSIyTL0alizq/7eJA1tiyP9RwsUPy9IIPh6CvCglCNC5DHh9qMDrOTEQn/aJXAEd1hLM
	 vbJ+O4O6wyuhVayB2ifnYLcFyvwFbxkWSbEBKGEdDhWoFNPEtnyrfLjNWWlFhAjSJdLIC
	 3yhr0Wtspa9nLfYx0f2UiZuf9HvRZN8vqOKGq2y1fjUNxRO/A90BQJQbDlK5INncnWCxM
	 6uUAfiUiRT/RkJx7w1yy7djZQBGhQ5KZ9Wn7828+Laxqknex/unPsMi8QHG0e2Xe/Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UrrkJBqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D969606A325
	for <linux-ext4@vger.kernel.org>; Sun,  1 Nov 2026 10:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UrrkJBqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB48F1F000C1;
	Sun,  1 Nov 2026 10:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793528732;
	bh=t/0ncG9nll+q5fYk7Wdi+F9VACKzeLeYjVLKA0lnaSs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UrrkJBqs1jkbejcYAy3TljDiKVYJ+GbInMu9ntyLX+JRFahCmYoqAt/hPjBS+N0bX
	 YkrEzV2h3JU0GUvUYrmzWD0BgqGfhsXMYIUW9MeqViR3kzQ+3ckeqAuTCZ42sWM/TT
	 vtkm4MXBz42JTAF0fGEtPFLMT0Cs9ejIct/q6lFkWgw5Err7mapAeEQ3fMNXhVdOcj
	 otNi3urGnS2Qp1UH+TEHxw5mEXZVB7X21saLJQyi4Z3S2bS6HfyIy7h3UxECLSEO/y
	 0TzLDKZABgxGmbAm4KEXpgTe2SBQrvy/K0ttgUabdAg+4fB6z2711A8B0lIt5thDw8
	 TP6+hm0NpZT3g==
Message-ID: <sashiko-outbox-192355@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: report unwritten extent conversion failures as
 writeback errors
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261101102145.647496-1-guolingxing@tju.edu.cn>
References: <20261015102943.74632-1-guolingxing@tju.edu.cn>
 <20261101102145.647496-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 10:25:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> When a data writeback bio completes successfully but the subsequent
> unwritten extent conversion fails, ext4_end_io_end() does not record
> the error in the inode's mapping writeback error state.
>=20
> Bio failures are already recorded by ext4_end_bio(), but conversion
> failures are not. When the conversion is processed asynchronously,
> its return value is not propagated to userspace, so fsync() may
> return success despite the failed conversion.
>=20
> Record conversion errors with mapping_set_error() before
> ext4_release_io_end() ends folio writeback and wakes waiters. This
> allows fsync() to observe the failure.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101102145.6474=
96-1-guolingxing@tju.edu.cn?part=3D1

