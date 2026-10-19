Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D063E8C77
	for <linux-ext4@vger.kernel.org>; Mon, 19 Oct 2026 13:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416047; cv=none; b=krWCoHZ4aCatMje0gsAT3/7YZwAwM2nssEGqCqei5QcIrNt7HEHIgeVFcZERypDR3ngPyj+IWA0CPvuCi4eUuXcIdGeuvM8goQMbq3q4MCjgiSX7VNThMvZusNrHdyXG98LJYKDeG1/GrdmARrYamJk9W/D9Rkq62b5tO5mssAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416047; c=relaxed/simple;
	bh=4LY9Py6EH558TKDW8Ves2EbGB0pmLDfAD7j2Ac8p6P4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XFMBDMWRLvtu6TCJ+mQoGUsVM7HKHNwdmpSvjS3+dcypiSQ0aR8ooDNkSLDxuXiqBrAWWeZdwFwNl0I9lRQ9gxQdpNgfOLShbrCAS2Lok996aiAUL0YnJ6DA69ixrxHxEqR9cutJHdsOg/GLVxgQllPkbw/vJxXirKaiHl80cCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8S9hjfG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8S9hjfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CC21F000C5;
	Mon, 19 Oct 2026 13:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792416046;
	bh=jG9gVjlJWUfvGZBd3VYOqLNAihB7cL+7qGWAH3Y1dk8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M8S9hjfGY+yGgnUdRxLFNCH7KpDNzzyD0/TTYEa6zLtRsx1VsGxxGY4F8XmLSpBdg
	 0cIqtgs0z6nt73D9GwVRPmW04zeEq7z/nuTQmMM42/KNrpavmCmKiCO0+8iXfrffHH
	 FHJlrJvnIO+fxpsynsAbjbZca2tiSQJ0xif5SLd7rgjRx+4Qgc48uY5AkJsWoi/nmG
	 PrlKIXAb0DG9cegGjzoCN6UBxjcoKI8V8R5zh2cVSzApb4MZH8TiRdHptzR+uB+oBH
	 wu78G0GxnQ0FyAdtaEREHG/lsRu8h5DB2ikLtk7vFmZDvb4LA+M4RtkQyyhCtj1s01
	 HNMnkaBRj3IIA==
Message-ID: <sashiko-outbox-177129@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: don't read past the UAPI struct in GROUP_ADD
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kaixuan Li" <kaixuanli0131@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261019131655.2583227-1-kaixuanli0131@gmail.com>
References: <20260918111742.827428-1-kaixuan.li@ntu.edu.sg>
 <20261019131655.2583227-1-kaixuanli0131@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 13:20:45 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

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
> The first 40 bytes of the two structs have the same layout, with the UAPI
> 'unused' in the slot of mdata_blocks, so copying that much fills every
> field the UAPI defines.  free_clusters_count, the one field past it, is
> overwritten by verify_group_input(), and mdata_blocks is read only on the
> ext4_resize_fs() path, which builds its own group_data array.  Copy the
> UAPI size into a zero-initialised struct.
>=20
> Reproducible on v6.12.9 and v7.2.4 by placing a 40-byte struct at the end
> of a mapped page whose successor is unmapped: the ioctl returns EFAULT.
>=20
> Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019131655.2583=
227-1-kaixuanli0131@gmail.com?part=3D1

