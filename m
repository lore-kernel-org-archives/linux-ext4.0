Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB0835C6BB
	for <linux-ext4@vger.kernel.org>; Fri, 16 Oct 2026 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792161343; cv=none; b=TrO3aiLqCIMFm0vPW8y2kMLmZH3epQLLHXL7gkyaC+EzBJDluxichSWtp2OXsSiggkdiyX8hTHb8KcHlSvlHjoDVPOAGZQ/lVjCSSOZbxbKecPgCwSEl3mBhfMIZ7Gi/sEnEwoWrJn60+Qrki7Iwfvnj1ijJ7z7blos5TSCizNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792161343; c=relaxed/simple;
	bh=gKFQEFB3EfBJ4vuOp5cU46ALctp0h/zGWty16Q4ulec=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jUDiWXomqghnjUt2Xya2LWE8QcVKk5S/YloPCOzAtCFkrGgw5Dmf11Ty795Mm+7xGGiMI2lHWCYxFDl01FKCHUG6eVXJKsVHODBcf0fSzRDHmCkSSXmPAYJbjina/e89CnzKYFPJoCPsDCGxK63jx/zdX1cFmjHeXnr+ywrcwc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZfSLa+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZfSLa+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F116D1F000C4;
	Fri, 16 Oct 2026 14:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792161342;
	bh=gKFQEFB3EfBJ4vuOp5cU46ALctp0h/zGWty16Q4ulec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YZfSLa+PvPuIWVkK1qDrfkUub6Sw1NY3+AqmKtFPtHQ2Z9S4jjmk1Np3dNAPpEkth
	 KnZg59xi5v2NEjqMKEOensxwd/E2iJqAYsq+0Htkq6gg4WzMuAhddmo6pfn86DFVyU
	 dyEGjVNgxrR0B8PPH2buwJHZ+LAFGKfLUQoLgvrlgVl3mx1/lX+x/7o7WNUtv379xp
	 awla/qQvKawM4BVsLEVMIVi8Uvcwi2vY2y581E2dwVBlNkeTzN/ZuSBpTTqPSr54FL
	 bINOipQ+MWGFeHMayo0dgEM6xFdLvi3iZBiEX5QZIpExft4eQCb1fORRuyCvjboKeF
	 whGKQuX832yJg==
Message-ID: <sashiko-outbox-174461@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix folio reference leak in
 mpage_submit_partial_folio()
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261016142524.655789-1-guolingxing@tju.edu.cn>
References: <20261016142524.655789-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 14:35:41 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> mpage_submit_partial_folio() obtains a folio reference with
> filemap_get_folio(). If the subsequent position check fails, it
> returns -EINVAL without dropping that reference.
>=20
> Call folio_put() before returning from this error path. Leave the
> folio locked so that the caller can invalidate and unlock it through
> mpage_release_unused_pages().
>=20
> Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents =
mapping loop")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261016142524.6557=
89-1-guolingxing@tju.edu.cn?part=3D1

