Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1EC3E51C5
	for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2026 12:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791807382; cv=none; b=A188M/7DvMO5C0YaCmRZT/VI/3gvpf7Cv+zeKgTyld6mCO29a1xPoRS1GWu3Kpr79wZqunyRlibGSBbibaml6TjMDQlE58opddQwIYZ4NTwmxPE5EGIZ0QjK6SMDK7baU4lSRAkIM3RR3d3QSPGvB+9vQii951eKtg6CRuNUGgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791807382; c=relaxed/simple;
	bh=2u3laYR5bnCN/KBYTs41cWX2K58Ua506V4MGFre+6+s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YW26i4XM/SSbpciwKH2J/Y1Id7kb9h1EDEF30so0QsmHAyv8T+wtZntO9gkYkpcm2wccEjJTJG+vt4ZGxupGJBFmwnknQd/NrawczKG8kFjb8iC2JORz2fuXHKD2h7HqzhGjq0k1jspQr2UVRpnDN+jeNb8h7TLgZiahcUBHDt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JMgKQPki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JMgKQPki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384D51F0089B;
	Mon, 12 Oct 2026 12:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791807381;
	bh=Dk/XqOAUE/KLZvFAf0UxwkBqwPXjAbVMy+bycyDSpSQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JMgKQPkina9upOQmtlp2uA23mzHclPTjYuoUMuxVtaikxFLHeou9cjeg/ADCcLY0e
	 9rs7WjughppMaT7xEUNgpOkcvSuJWaWkWOqcp5Sg0ByEorVOxcTC6Bybxtf9SSEqJ2
	 mbW6GwDNKq11fTyGiof0Uwi/7tpYHUpSoo19iB7n8JhNo9zL0qXbDGMZrSqYLA8kBx
	 U8Sod5LesCCrQp4ZtYE6pFHOJ7M8jW7uQOhUtb8/uY+kEkmy3i5WiDcoQL6WKjP+Ko
	 WcA/hRB0cETmg9NnDgfesrWPQZhCsH+NECBCxUyYriBGdfi82KYPi8hyqxE61P/qZr
	 So0NgcEnbckYA==
Message-ID: <sashiko-outbox-168078@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] jbd2: check return value of blkdev_issue_flush()
 for async commits
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261012114713.4049391-3-guolingxing@tju.edu.cn>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261012114713.4049391-3-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 12:16:20 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When asynchronous commits are enabled, jbd2_commit_transaction()
> calls blkdev_issue_flush() on the journal device to make the commit
> record permanent.  However the return value is ignored so if the
> flush fails, the transaction is considered committed although the
> commit record may have never reached the disk.  Abort the journal
> when the flush fails, as we already do when waiting for the commit
> record fails.
>=20
> Fixes: f73bee49855f ("jbd2: Modify ASYNC_COMMIT code to not rely on queue=
 draining on barrier")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114713.4049=
391-1-guolingxing@tju.edu.cn?part=3D3

