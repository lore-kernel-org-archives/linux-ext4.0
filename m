Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793376600;
	b=ZYrbP7jMs+W31wIpFwtzagbwLVSwDnsxccnaQ9lF4R7CiUZ5nq6b/z93+O0DPusMwTEr
	 edYaH8+30i2VJ0r+BJWU0dyfxQvcN2V12fuujUYTrh8m2QfoBrp8+4PoDwojyC62bPwK9
	 K22MYsTIOEHfuvi4aMQZh5lS5fUElQEF3we/ONqXP/k2MkR6IvDfvTUZvB/8g9eF8cNxW
	 kP+5WC5g4igQ0rrEdWDrJRgYejamob+i62DsLwQSp1C9I0oWXZ6twetHzsNSSrSR1cFak
	 E7FwIRd8KPH6s9wKCsIeZ/z8Uf9vd/bLxUg7j5T76wsgJTZOIiB5rNQIhIgXcMFmPmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793376600;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=IW4743zhbPHUndFWVvBObs9O7CPbf59I+WyzsqPOL2g=;
	b=Iil9PQuAd1Ob7o7YrDiOGjRqM2YCZd/LrlgjgwV+5piMJrzu11zVdBvtva+OBgKFOzqC
	 CaIUTQwtYoJNEU/DfndUpwwhBm/STiFUH+T0x459EsKS2QxO1UdGz49rNbgLy/Xlh07y8
	 1XxNUgmwdvSEp/Q9eYIHVjAplqsdO/WSpH9JgJoGC8Do2KguvMRWCpAW9qSHuqXM1ki+l
	 5Yhm2K1NwevOnwd1pYjdppOgwSrfPTKDgUATb6H1vKSsS5lt4VIaH69XPRJN9gPFC678U
	 Kf8RKwA2gdDHgiu5orZ1r+/CJDgpUDWfTpV6CVALf/hU17WGeIXrmaW9BJYHSWaCKsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blumUYUK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F46C60A2608
	for <linux-ext4@vger.kernel.org>; Fri, 30 Oct 2026 16:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blumUYUK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7D61F00A1D;
	Fri, 30 Oct 2026 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376600;
	bh=IW4743zhbPHUndFWVvBObs9O7CPbf59I+WyzsqPOL2g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=blumUYUK5Wc1pX2VX65JFyPqAxM4IUtnKDC8SEAdaFLDipuDe0h6bSQrQhfT3xKOb
	 1pa+4IbczG8cxaxPr5EybmKIBxW+9kQNxbX8dBSUPDjc/rnESut5PQjIN8KoKeDYT1
	 doR2SgF3rADiujv7TcbZG8/tcx5i8l+UyCbaTnXu0wcZI6IEj6+85VfIXgyunibKll
	 JoqzO9FZ5XVF9iMjb+b4gPo3FjuqNKMtLe7FhADx70hje4TOI/KRGMCYlT8biq83UW
	 RXwwQnNshUsxkiSKU0rmo0YES/J7AOzPy6ViSOd/eBgRNvikip82NOBQXEtNZ/SsNT
	 vjLV5u2YIhepQ==
Message-ID: <sashiko-outbox-191232@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/34] hfsplus: don't set SB_RDONLY when creating the
 attributes tree
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-13-2f44f64f0b66@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 16:09:59 +0000
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
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-sb=
_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D13

