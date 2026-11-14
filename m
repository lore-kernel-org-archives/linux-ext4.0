Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657815;
	b=J/Bcbcsf4SIfgXBiGlTb/SXNuA20sAGn16jqk2YrQqahS+DLvq4m0hsD9FtqJQMDjsvn
	 ZGPo72C/FtjEZ2PQS/Wzg77KqnvBbaly+BiIgczN2fbqOaf6iMjGqPh6Seu7BrTP2rmee
	 ePnUFXqJcrrUM0KIZEIUXBUvqnnjOdyCALNy0VhbFl8h3+AiRAtSuS/xbr/b7TellmezZ
	 wEi8l4TmI2ZC3YD3xP7MTPtXooQz8K+Pnf88o4R+m1CaHbJ7mkb0OqfosnfGjEjReS9Na
	 6ZQdMDDllWO5w45ji8TIbfdGq6UJTeBVrDoS1+y5DAWn7txKAmR3Lhsq09MfcCL/Lwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657815;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sHrC0OOzwO9cTErJhqSuau16cuQJeq2/BgddghVoY3U=;
	b=oY6Wur3VxV9Jfgh9B6uuUBXPBGSy/GSdINFMq6M6ltROahC2dkjAMMkXlNIURO5Q4BZu
	 1xQQzYEiAWM7v0js2XPgYSthcfb0gOYu64IyNwPxLKaLdC6El81jFxkHQ0W3mFiVkld/V
	 7Qys1RrUa89xVEEAr/Y55p96Zw0UUjQ0B1I33OxoVemWLyKC9g/YarM0hdJeFsGV5JQyt
	 EoR3btM/R74ZUAWdHL0jK+p7eDKd2tOTvwNfhyLNoGGm28osmjvpjlV4AITO4ZISU59Ok
	 6rVM+qnpfhtH/I9fu0JhqB2voMZYLgP393xUSEdma6HvSQNk67cmn4VIVZa4fkPtn6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="d/AZR7vn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B787606A336
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d/AZR7vn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BF71F000C4;
	Sat, 14 Nov 2026 12:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657814;
	bh=sHrC0OOzwO9cTErJhqSuau16cuQJeq2/BgddghVoY3U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d/AZR7vn1H6Ue/6H4KCb6b5UhJsEngX+AxId5Qr+b2IbA90+ubVRbYX3uYa1zErh8
	 6UxuIOHAdqPuirMHmbOqr1bD3wqP+PTCalePxsb8hGkY1OUXex/1iahWqeifm39bB7
	 mMhomCd+BTMsb5MIldMY1oQX9GS1T7YUZDkfVqBEVHnEz2sPVqUt5LF/DXIoH3zsjQ
	 eOwLh4Vnwe+VzprYOZeEYm9QsJBSUG8HXeqW3I/l8AbSMOvgxkEuo0yCYQ8ADCHxZo
	 cZjnkCdxNyqgPtQdQt8SZSMe+noQKNFHHuvtVO7MnaA3FIHB/3+C18gZX2BMU+iRmW
	 f4sfE+7nkjFOQ==
Message-ID: <sashiko-outbox-214466@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 15/33] hfsplus: don't set SB_RDONLY when creating the
 attributes tree
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-15-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-15-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> hfs_btree_open() sets SB_RDONLY when the map record of a b-tree doesn't
> mark the header node as used. That's fine while mounting. But
> hfsplus_create_attributes_file() calls it too when the first extended
> attribute is set on a filesystem that has no attributes file yet. That
> runs on the live filesystem without s_umount and a filesystem must not
> change SB_RDONLY behind the VFS' back.
>=20
> hfsplus_create_attributes_file() opens a tree it has just created itself
> with the header node marked as used, so there's nothing to check there.
> Move the check into hfsplus_fill_super() and do it for every tree it
> opens. No functional changes.
>=20
> Suggested-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D15

