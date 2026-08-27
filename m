Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467D740D578
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 08:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787821084; cv=none; b=uY06KH7IFEe6pE50dI6bIyNThyVkAXGBKNT7Ikau6PmHTjdYbP2VncTwlT1rjiN6Z705u6kwRqG/+sK0w+exKhNjkKSj1iUUOAcgr0+RIe9CDd0VZMMiGHTwO0vnIfCOmcIkNxOEmMNGcQ6wuxGvCGZXE+iwP/ov8XpcFuENDSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787821084; c=relaxed/simple;
	bh=oByp/uro1IwAyV7zotL6Z+9gqNalTOBG2GfBwsb18tY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J4csJbif73cxa8f/BdGtTz1vzuVKEVSYKkUBbtmovIUCibMGIriD0H7yVI875/+CINlgSJTgLvLhvOwESE+HfxvmsauKitNA5J4KzLj6KoGxV/GmoP0TOYtTnOo/NImJqHgfQX2sqDSqQE2D69fqkliaZvz9lMQP08ZaNyKofis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DwhEdOF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DwhEdOF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957941F000E9;
	Thu, 27 Aug 2026 08:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787821082;
	bh=sNOcaFLbBhmqjD7SjkQXGTwZTQd8L/XzSca1dK48Y4Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DwhEdOF87F4IdRTWfEF5TDP+RvkxtzoP8X9sBfxErWyrZvZXJ+BXqSHcMdnnlFRhz
	 suoDgSYAV0Oa9lhht6mZuJfS+ZDP/rcxtkazvdknFQjVOOvOOJwFKXRPt/HU2yunth
	 No0hnmtSrV6LsZmLpUEpKU61mvjgtkoHtENIQxsjhNPINA10BrASM4Ov+h9AwA+xUJ
	 8RwanKAAZxPNC9TSkji4hIrt04soXZ2WoYPTxxfPsHkTabvcLXajVItqei4TvC96j8
	 5xeB/X6m5TzFFzsMH4IM0ekGEFbgQ+NOZ5GkpDfj+Q6IGKVpRaYQ8ZQKGSIHWSDjos
	 sk7AK2yfyxDDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: don't report delalloc data as a hole on
 indirect-mapped inodes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6>
References: <CGME20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6>
 <20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 08:58:02 +0000
Message-Id: <20260827085802.957941F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When a plain lookup finds no block, ext4_ind_map_blocks() sizes the hole
> it reports by counting the empty subtrees under 'partial' in the on-disk
> indirect tree.  That count knows nothing about delayed allocation, so a
> range holding delalloc data that has not been written back yet is
> reported as a plain hole.  The extent-mapped path does not have this
> problem: it trims the hole it found at the first delayed extent before
> returning it.
>=20
> ext4_map_blocks() consults the extent status tree before it calls into
> the mapping layer, so a query that starts exactly on the delayed block
> still finds it.  A query that starts earlier does not, because the hole
> reported for the earlier block already spans the delayed one.  On a
> 4k-block filesystem, lseek(SEEK_DATA) from offset 0 on a file whose only
> data block is at logical block N and is still dirty returns:
>=20
> [ ... ]
> Reported-by: Alexander Monakov <amonakov@ispras.ru>
> Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27=
ce3aa3@ispras.ru/
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827084829epcms=
2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6?part=3D1

