Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA8544C4E2
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786702371; cv=none; b=jrKEI/Mi+DKBo4LBDl4rudoaXzGtJa/THawG0FJJATkGAlBkQdlfxeSKOWHINuqi78oL+kmXn0et+79oU+mBfF8iJEKibGmXXN7eF1UDs/szhiheJszo6AoK532LczTRBTAN1n0hID/dHQ9wS+SwU02acasW0MQXrzqi3ysuURA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786702371; c=relaxed/simple;
	bh=YSAsSntQLRZuNkqKoqf8Uidp6JLYp0LmTcy3gRAT05Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MWByprvbKD9bjiHEGgmmcghYTLZG9EMkJoqt/hQUlUFvJqQHTu7G7us5jg78k5Pz+CQ5iyEI0i8hMmQhADqGZORVw6E1qaNwakYfFHfdNTc63jNBQX0j9ACoq+FEGqgiSQxNa0Y3qSBNUwHbM2iVp1rQ0GdnGUG8SkQcKyToL3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoWXFQAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoWXFQAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168181F00A3D;
	Fri, 14 Aug 2026 10:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786702356;
	bh=DJBahq80iToO8ECFsMFPTcAIVihdpXXJ+4e4ZCto8KU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YoWXFQACqohVT2Db+xOjRgRsgv8WtACyDkxpF1ZLIBVhMYpOWpQRVD/JhiZ7YIAuM
	 CVQh+EATbTzfHuCZY0bC42C0jcUs80A8HknUKqKgwWHfpo2JTrD07J1fmn76tMsy4E
	 e9Acr+6hza/gyDWxuUXlvwxS5SJ9tAJ1LztBbPC+J8yQUYpn1ebRagFLiOu4gPqut8
	 HMpEGx5idF+aUWIbJuhr8G5LOt7V/ROtuEYNUrsTTphv7n9u+I5mJyX5x/Fqle3S9w
	 DnPQRLLKcsCZkln/C32Yr4r+QxLvdoarFzuiWtsMjkOWZ1Ii/OMrBCCb4s8nbLGH7A
	 p83A0plnJT3cA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 14/32] ext4: do not use data=ordered mode for
 inodes using buffered iomap path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-15-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-15-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:12:35 +0000
Message-Id: <20260814101236.168181F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> The data=3Dordered mode introduces two fundamental conflicts with the
> iomap buffered write path, leading to potential deadlocks.
>=20
> 1) Lock ordering conflict
>    In the iomap writeback path, each folio is processed sequentially:
>    the folio lock is acquired first, followed by starting a transaction
>    to create block mappings.
>=20
>    In data=3Dordered mode, writeback triggered by the journal commit
>    process may attempt to acquire a folio lock that is already held by
>    iomap background writeback process. Meanwhile, iomap, under that same
>    folio lock, may start a new transaction to map other blocks on this
>    folio and wait for the currently committing transaction to finish,
> [ ... ]
>=20
> Online defragmentation does not yet support iomap; this can be resolved
> separately in the future.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D14

