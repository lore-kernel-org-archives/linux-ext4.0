Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422411;
	b=ZFTW2H1jzKpYdto1O9XmLTxao+utA5o4XFpC33lyfWsqCCCLWCH8f+gJwmMH8OmbvFqL
	 T9diTQ9wms7/wkn+zCkedjBThiohX2gIlqZokarDR40xq28qnV2f3dgiTlR4kdHdR7Rua
	 Q5UQbEe/EJjP2/B/4g1+2IZ0bYVx9YwE4wsx89d528oSMNl3shBekHNDubiHrhmPP/T4W
	 CdPRJC+Hvur4rFzWW/gS/MxsRqeOj5mZJBJfPOQDHHRXaWW0DtkfPOIEbE8JbUYqYP0c1
	 cNm0iw7+8WFNfgWRD9bNhXieEBoITDp6uOnbYzHKopUfRZOYO+GNdegjrWHN+TKLS4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422411;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=u65AFebECRPTCROHRjQmX0a4sx+6uCK7HKTWTCYrRvM=;
	b=dPuno/e7k/DbjXIL61qp1KxyrVcr+8nKoz+YF9avQseCA8hQlatHRaRBEJkmFa8z7qe4
	 byU9v1nWBdg3HX524cwiRaJCuqe+Q0xzVSrrNJFnzH8CmAXHM9Xa+qhCSw8o4pzr08FZW
	 04WPwWm2NxacEhxQsC2c72jMhCJGInz3h+wogfI5YVyrO6BfnxVd0uy7q/Nya+vOQMnJz
	 AmxkNLUiWqEz+U3RoYj4IeYpWztha7GcaKAJHDnpnHD4RA1+HAplMGetkHNegaa9izKF4
	 Wf2xlKCDxMDRswQ/50NbXc0YPF5IZ/84a58gpw7i6ASHO1X9abIh2r4fTVHjRDy9zGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G1QXA8Gf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6F96079D47
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G1QXA8Gf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6381F000C4;
	Mon, 19 Oct 2026 15:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422409;
	bh=u65AFebECRPTCROHRjQmX0a4sx+6uCK7HKTWTCYrRvM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G1QXA8GfAeUzHpT8omt+bjzNLABhREQ3l2KvN1Po0GVEV/HWpFGHWI0tem6hwkNkl
	 J/JRH8M+ANSP9IFQ/8O76H7ZsbslZUGPZ1Glez0AtdRnBw8xNam85/4d30RvT7m8rn
	 2Gf8csSLtYchv6f0eABRVdLncSm600Vq7MhDrECAPQmbrWcsYFlEmsWDlvgtGruQWW
	 WEUZwWebDOsnPhrCH7I+Bew/BP1hxvhpLXmgme6Kl0Hu3CLso8TCTA6tzf5jMfVCyH
	 wqsju5/bu765Gw4ICFIlQnY/sLRjG5zbd7Lm2MXyTgDC1i9w6/0bXheQhKM5h2nklh
	 7A9ImAuwICkZQ==
Message-ID: <sashiko-outbox-177613@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.12] ext4: reject mount if clusters/inodes
 per group are not 8-aligned
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261019135441.1420968-395-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-395-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 15:06:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Baokun Li <libaokun@linux.alibaba.com>
>=20
> [ Upstream commit d42dc7726a003262b73ffef2b744ff57a5488799 ]
>=20
> The block and inode bitmap checksums are computed over a whole number of
> bytes: ext4_inode_bitmap_csum_*() use EXT4_INODES_PER_GROUP(sb) >> 3 and
> ext4_block_bitmap_csum_*() use EXT4_CLUSTERS_PER_GROUP(sb) / 8 as the
> length passed to ext4_chksum().
>=20
> If s_inodes_per_group or s_clusters_per_group is not a multiple of 8, the
> trailing fractional bits are excluded from the checksum.  Those bits are
> then unprotected, and any incremental csum update path that assumes a
> byte-aligned bitmap can compute a checksum inconsistent with the full
> recalculation, corrupting the on-disk bitmap checksum.
>=20
> Reject such filesystems at mount time by adding the missing " & 7"
> alignment checks alongside the existing range validation.
>=20
> Suggested-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://patch.msgid.link/h3n7jlfhyna64dn5o76qxcspnhxdddcs6crpxftmy7=
gnl7b3sx@jenszfpcsnit
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260508121539.4174601-1-libaokun%=
40linux.alibaba.com?part=3D10
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Link: https://patch.msgid.link/20260608111150.827117-2-libaokun@linux.ali=
baba.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-395-sashal@kernel.org?part=3D1

