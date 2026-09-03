Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8334A8A0B
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788442454; cv=none; b=ucGD97054tegoKiZ1eJ+ctQ7XxTJb65rO2xgX6TX5OEHlrIqEnx9rG8AItfPnEaq/Gp74cMnT8Oja3EUcxG5vg9MXNBFGG/L+bMcfbyl0u58MOEbNWhsFhjiFbVVwkfEy+2D3yo+IZMtb2/EnVvvtgo3TPFDIH4G/EO/sKmH6aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788442454; c=relaxed/simple;
	bh=Y/LskW2QtvHIZLYbaHpx5N5vPN2lGKgr1E/S7CesvPs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K13kPHRVkyiyie/VH/StRj618Pi6WYIEjGas//0RXo0FjhQxQTr/rYSv3uBS3QmgKOtlLHk6Z11Qd2Q+wY9Ekov6JvBbolTgg6laGY/6lsdaxGTaEBgZ51McxjYyRIpwYuWGruowv1unY+occUa6CRq4GuA7IYgK/a/NIig7vzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=go2qlT7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="go2qlT7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F391F000E9;
	Thu,  3 Sep 2026 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788442443;
	bh=Y/LskW2QtvHIZLYbaHpx5N5vPN2lGKgr1E/S7CesvPs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=go2qlT7pmb+1RlvzVofYnmA4fUovRLSGFdy03DstCsbRuhsVMnC0CJoOgmOaiMunO
	 dYzwI8rS9ettdEkn9RZY2ABjZSKv78g1hsBAqWheWWU6f/uubAhorwiYvK+27FdkN6
	 Q2r7XjX6IQqWJjNK4Xkh578a/hUqmcXbo7ZW8L3fCdHjn7HbrH73H5o9BbgbkGoS3E
	 uADDMVDknMx9pbcls1wOuEKYmFHbjPqwYarhUDCe/H2tNUn1mgNSVuyu2dGQV8R+Me
	 2ZN8LZbsBkAlN4vx2RcGfQ+0WusMC9n8EXU2P5C6XpstuS9fT/rmQ5BmCZyrgZjBW4
	 3rB1Uj0YTFW7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 28/31] ext4: add tracepoints for
 DISKSIZE_GROW_PENDING set, clear, and wait
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-29-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-29-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:34:02 +0000
Message-Id: <20260903133403.10F391F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Add trace events ext4_iomap_mark_disksize_pending(),
> ext4_iomap_clear_disksize_pending(), and
> ext4_iomap_wait_disksize_pending() to track disksize-grow-pending
> state changes and waiting.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D28

