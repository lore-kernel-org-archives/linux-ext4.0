Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312B14ABBC1
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730929; cv=none; b=YHi3wQsBX/i1eCA5RIu9GoD2VGZY19CC/QJp37BL5sRs0lIEfpMjR197emotGypxls+ypWcT+QxXQzdn3Xq1CNd/A0Nv5DQTHsdLiDTJ/7r1JZEJ2XcwmBJtTAjVj21P6k5GnOqghlT81BS9Kq2ZAqlguari5L/ySC5gLyAmfi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730929; c=relaxed/simple;
	bh=sFQrLV+J9FkEah/H0PPv12mTJ5Ax4ShMBVkO272sPwE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l1RLwrC1rJudiHkFx8nsLzO4eB4BPvItBJCbwt4IOq/3KRDUVvmaj2xoJv0KH/FvXFsyNHrUJCKhkxE5mJydwJm191RQ3AWcvEMCPC766J1WbhbqG/67eMj//jLSlBB5w3ROL2PE9y68HgJWW3PKFuqjjySA7UKBziGFWboQr30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUOz1LLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUOz1LLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA22F1F00893;
	Fri, 18 Sep 2026 11:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730927;
	bh=g7PnYsSrsomf0ex3xZNUOa7TXjnaGJZkObM9td8Wna4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PUOz1LLcngmlQhc6oaJSX0Q4hU6gXwloEpsIS048BIkOuVWinuVMd3w4gp3DHlMpr
	 01E1hcDmGj4dE8EoXSvHTR8hKK4q2z/tsXUjDck5aHtGh9qzXKtyHcIWFnav7FfODs
	 lWaQgZDKH4GRJSA8+ELMlchW5OpLHX6gJJgP9OqrkP67qYc0HxFyePN5Cs7ZtWRD+j
	 IqGhnBmmCg4JZdBpi1abu4+8kr1oxLAMBod0/I7wUQ2Vh7rTN023xg25g9NchUURpp
	 oI4KncQ4oEUBv9nx69XhY6809b8MF9u2aPkO3Toj2MU1WYVv8My9N5CotbpFlLaA+Z
	 i7p6pTdgNktnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: don't read past the UAPI struct in GROUP_ADD
Reply-To: sashiko-reviews@lists.linux.dev
To: MarkLee131 <kaixuanli0131@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260918111742.827428-1-kaixuan.li@ntu.edu.sg>
References: <20260917151441.413135-1-kaixuan.li@ntu.edu.sg>
 <20260918111742.827428-1-kaixuan.li@ntu.edu.sg>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:28:47 +0000
Message-Id: <20260918112847.AA22F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Kaixuan Li <kaixuanli0131@gmail.com>
>=20
> EXT4_IOC_GROUP_ADD casts the user pointer to struct ext4_new_group_input,
> its UAPI type, but sizes the copy by struct ext4_new_group_data, the
> internal type:
>=20
> 	struct ext4_new_group_data input;
>=20
> 	if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
> 			sizeof(input)))
>=20
> The UAPI struct is 40 bytes, the internal one 48.  A caller that follows
> the UAPI and allocates 40 bytes gets 8 bytes read past its object, and the
> ioctl returns EFAULT when those bytes are unmapped.  The two structs have
> differed in size for as long as I can see back -- v6.12.9, v7.2.4 and
> current master all have 40 against 48 -- so the copy has been over-reading
> the UAPI object throughout.
>=20
> The first 40 bytes of the two structs have identical layout, so copying
> that much fills every field the UAPI defines.  Zero the rest:
> free_clusters_count is overwritten by verify_group_input() anyway, and
> mdata_blocks is read only by ext4_resize_fs(), which builds its own
> group_data array.
>=20
> Reproducible on v6.12.9 and v7.2.4 by placing a 40-byte struct at the end
> of a mapped page whose successor is unmapped: the ioctl returns EFAULT.
>=20
> Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111742.8274=
28-1-kaixuan.li@ntu.edu.sg?part=3D1

