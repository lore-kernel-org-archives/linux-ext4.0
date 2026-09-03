Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179A94AF9D0
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788443178; cv=none; b=L87jywBYmCE45tSo6RXdjBv32X0uJbdk/ekGKsc/ZVd3/UzcSiOVVOA9u2qVSODPVShoNclyS4R5eDulCiE6abGXnZu9H5QotADaKYvJxzXsY+Dt+0ujq5nuGJecXt8mxMh2cQYsfjvfbxWwfD9kDKZG/6/luNcDtLEvysN4hw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788443178; c=relaxed/simple;
	bh=eg1cKsMfVQNQi0Aw3Kux21dFcruUpGAXcHsq4XQ0Vjc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=urN8lmljbGUj1wZ4WeshnCiiHz7D1HrOz3UCFsbV22HJoxfNJV5kadGUiEGbkNoqc6RHTxW5cQwPmkBQsVWpscOhabk08DJHZBNZZThw/2KF6fl4CEt13HlihCvWEgfOv1rKDl2xrdyIfa3LL66XHOlqxEUfJT418jzdxioGL7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7NoQKyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7NoQKyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756061F00ACA;
	Thu,  3 Sep 2026 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788443170;
	bh=eg1cKsMfVQNQi0Aw3Kux21dFcruUpGAXcHsq4XQ0Vjc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d7NoQKyW5jHf1rhwL0SYadyr81xoPBr3BbkQaFPxrEhQE7CJSNdmKtNotLasRYJnR
	 qfwzK3/Sdf9w8Qknqgh0BGWp3gb03ztMDScy396yKjo/YHFqTf/Hy55lsD5Tv4xbDT
	 /XLuYTo3PFT/x/O2qqZ6xLf72q+4QAwm/c8jS9z5qauxtiK030H2ehDPpH9TlGLdRf
	 3QTVLudCFfn/YLZ2Hvu6Wv6ZHK2fnTdQ7yCOj4wgyhEvVzopEOJOXwYphtISI7HZ9P
	 3ip7NLdbAlLTMGiM0krx0UWhr3EY6Tg44rhdqJYed8gCFs9SMDrjVmI24yWRmh7Hoh
	 O8zCLsg7HIYEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 31/31] ext4: introduce a mount option for iomap
 buffered I/O path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903124017.2325538-3-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903124017.2325538-3-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:46:09 +0000
Message-Id: <20260903134610.756061F00ACA@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D31

