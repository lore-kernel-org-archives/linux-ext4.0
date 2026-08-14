Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2E242C4E4
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703119; cv=none; b=PKS3dGCUwAlnKt2D8uEFMtNlrXUiz0ox/zSvcTh+Dk3sWqbtUgxUQ+T83Qr3mTLWPT0cp67Cmjz0fWjRQ6FBkpszcmkdEBPgSAA5R+cewu9D9LxGBHa4AzQD6iU4K56UqatBtAI2odgrk0mMx47sHtMPN4OmDa6zYctjHPaBkSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703119; c=relaxed/simple;
	bh=pMUIHBgichyYpgd1lGlcO2xhd2zCqnNf+ZjVx4L6AHA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dzMLxstGbP38L463vBPjmMqyA9sOoYzRXKThb+O0AweHVE2zb7jBJ7jqr1H0XWHcs/Whr3yFMmLXnJIiHtKd2lvFtlKj9klw8d6SvQO2BszOSXrpvH/8GzjWdcMrLLs60aqR4+fVv+RLRwj6Hy1FAPSYmWnDszCztGszaWxqXTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kp/4xBMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kp/4xBMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3B31F000E9;
	Fri, 14 Aug 2026 10:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703109;
	bh=pMUIHBgichyYpgd1lGlcO2xhd2zCqnNf+ZjVx4L6AHA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kp/4xBMNWPuL5sOd+hzcbvmQwUgSb4hcCE1lPuregKmBbxV4Hs7TpkpzgmpoUk3UM
	 e4BRv8gJoWMtxhj97NjnUju6rcxAsQkaNzdFnupik/d2lLaRLDmI3a5FMP7GCjHcyk
	 PFeEtEDFtWc5liqOZfaqVdDw+/nZhGucLY2DCsKl/XAMXxbnfSo2PYEG35o5BQlh03
	 5e0OJbJAt3Igq6rXMWh0L+NqyS1yYQwRUI5TGl1LFVQHkyqh+H9WOTBcKCk4Fv3qXt
	 VF8UMwGR8pEPeLhEqBUMh0zgWIbsGmD7R4K8vaxCx1iht8JuWfcae0Pgj8jf5rp54x
	 W31q4ToAsiLwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 32/32] ext4: introduce a mount option for iomap
 buffered I/O path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814094616.1710143-2-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814094616.1710143-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:25:09 +0000
Message-Id: <20260814102509.9D3B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Since the iomap buffered I/O path does not yet support all existing ext4
> features, it cannot be enabled by default. Introduce the
> 'buffered_iomap' and 'nobuffered_iomap' mount options to explicitly
> enable or disable the iomap buffered I/O path for regular files.
>=20
> Toggling this option via remount is allowed. The change of I/O path will
> not take effect immediately. It will be deferred. The new setting will
> only take effect after the inode is re-initialized (i.e., after the last
> reference is dropped and the inode is re-read from disk).
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D32

