Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6070C43B6E2
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731134; cv=none; b=Ma/4JQtcAaMr6jrr45/tgy7QKEC9FBPXjrq0Q9WmYxoPksXLPDzSeWsjsZGnwgDzLUafv/869IUD+6ofWgxhwcHMppH34m+NC2u79mG+8E1Jj9uXGa8YgPPORE7MQHKL1iMqzs/V52r+nXWT+sbY4w0jGlB+VdYQkB9ofY0icjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731134; c=relaxed/simple;
	bh=+HBgcNuZcrDqtE9BNQ/qoXXLb40oomS0PK/CH2u/hLw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ujYTdMcol3+F0MwuURBEyDLG2OIRdBpBwR4d1lX06oACJ2d/oduZFqddEWqLZqHvVfsxau1jhGE/AomGMl3VKneOrGoKx/YOjndEl7ZN/b0C3MnsMl0QnUzX24Kvi68Dk8NzESRxP7pzMsEqNhy4oWA6srz8pza5V3BM9MZpGzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0TJIeEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0TJIeEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80601F00899;
	Fri, 18 Sep 2026 11:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731133;
	bh=RKahkIAuooknIS5qKnjbxYwAmqveQDEU1+WleM/XXes=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C0TJIeEQGXsYaqmkrceHfrEFbIBDKgL+mo7cyrnHxzW7eeI71w0P7Eub+G/j7Nd1L
	 gHEWOlJNH/IzOYLt14f/HrjC1ZArKm7hOBsIj2nl8RwDOtgpW+QIyR9ezT6Q6GrkeA
	 BkHN+m551J/huYwQn8RabnIMg7Avhv8ojAwQVvlP9qAYZCPYCNcqb1JW+uim1SP4bG
	 Z1SScYMuefBSZZLKJiYKOILawWjGuekeXSqM7eNZtH36JDg3xnSNJAsrMu7qXPSjsS
	 /RrP2MhFb3iuy2VbAXg+nLXMeeMeNrnZytP4bz6f/YtTqAZeMRM6CL1I2y+HGhqT5q
	 BWlcOuTQVWbGA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 13/21] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dsterba@suse.cz
In-Reply-To: <20260918111539.1003439-14-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-14-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:32:12 +0000
Message-Id: <20260918113212.B80601F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] xfs: XFS_BMAPI_UNWRITTEN corrupts data on realtime files
--

commit 03f3992d52956762d29c7c4c4908adeac76b8662
Author: Andrey Albershteyn <aalbersh@kernel.org>
xfs: add XFS_BMAPI_UNWRITTEN to unmap unwritten extents in __xfs_bunmapi()

The __xfs_bunmapi() function is used to remove all extents past EOF. This
patch adds XFS_BMAPI_UNWRITTEN to remove only unwritten extents, leaving
written ones in place. This will be used to clean up unwritten extents on
fsverity inodes.

> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ba6a9611f6f9d..69364abbfd011 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5279,6 +5279,10 @@ __xfs_bunmapi(
>  		if (del.br_startoff + del.br_blockcount > end + 1)
>  			del.br_blockcount =3D end + 1 - del.br_startoff;
> =20
> +		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> +				del.br_state !=3D XFS_EXT_UNWRITTEN)
> +			goto skip;
> +
>  		if (!isrt || (flags & XFS_BMAPI_REMAP))
>  			goto delete;
> =20

[Severity: Critical]
Does introducing the XFS_BMAPI_UNWRITTEN flag cause data corruption on
realtime files due to how __xfs_bunmapi() handles unwritten extents?

If a user creates a realtime file, writes data so that EOF is not aligned
to the realtime extent size, and preallocates space after EOF (creating an
unwritten extent), subsequent calls to clean up with XFS_BMAPI_UNWRITTEN
(such as enabling fs-verity) will process the front-misaligned unwritten
extent.

Because __xfs_bunmapi() falls through to the legacy realtime misalignment
logic for unwritten extents:

			} else if (del.br_state =3D=3D XFS_EXT_UNWRITTEN) {
				struct xfs_bmbt_irec	prev;
				...
				/*
				 * This one is already unwritten.
				 * It must have a written left neighbor.
				 * Unwrite the killed part of that one and
				 * try again.
				 */
				...
				prev.br_state =3D XFS_EXT_UNWRITTEN;
				error =3D xfs_bmap_add_extent_unwritten_real(tp,
						ip, whichfork, &icur, &cur,
						&prev, &logflags);

Could this legacy truncation logic forcefully unwrite the written left
neighbor (the valid user data before EOF) to form a full realtime extent,
effectively destroying the mapping to valid user data?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D13
