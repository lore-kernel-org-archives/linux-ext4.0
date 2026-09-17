Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551B04C9DE2
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 15:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659019; cv=none; b=X8auYSzj+OKJZMbm7X1nF+hrZkEoyqJavexvybttAFcFj7a0Gso2V+EGSHy4dT7SwFJqlZ6+OaKHJU9uBSJ5Jx0TW9OBFZltwpOVWPBqUwpHr0pyxI0a+gZU2C7ajkrqb2yNGhP876ptJ/MEow5+l1Hn+8IC8ZDuuI2Gma2MfyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659019; c=relaxed/simple;
	bh=8asRmT0ZAfLKPWnpsfjSYb82NTot77snHd6ujv+0RYs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fi0AdfAC5P9vBYtDf7Y3U2M2J5RbCFILRFyOVbSbwQBIWE5JiWLacEieiDHuNyWhBolk/vsgxMverjlvMx+DYmNz3axGbSXGHnODO5IzVfAjnDIDkjCHVLXb2naGalRwYvpuSDI3tNjADzgIas6ouRAMN9KNNR2F5PTunZiprdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5cPaZjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5cPaZjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFFF1F00898;
	Thu, 17 Sep 2026 15:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789659002;
	bh=c/P0uq0HBGZ8G2asSSqki7i7F9sudMb8OqsghtdrEv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m5cPaZjWY1O/u20dADJgqUmqFA6GSSsMGdNPE17dZuyzR4niA7t3iz9XTwpfv+CbS
	 fr9laGALXZQeo2NQSZJ2ZRtQgnnAsC9j6cpP2IWyie4ZLBzih4z2KYhZ4MynbmZAu3
	 wWiBxOsZswMmEjyWbc4el3BXmvi2tJg0cJMpD24G6mKDvrCbd1gqCHSheeV/VyZiaL
	 /MyRXe3khFOXH+vfYV5QBQWdjsCNwugL0N10sBW+If1ULnx3okjk7GrnrtXTa6ElDk
	 tLPYMsKTNZei/i+BNm14EiD687DJQLCfrilVOd3oSHuM4grCk0rWegz5hMTBJTke8i
	 aP2bIeOi9Bgyw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: don't read past the UAPI struct in
 EXT4_IOC_GROUP_ADD
Reply-To: sashiko-reviews@lists.linux.dev
To: MarkLee131 <kaixuanli0131@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260917151949.415967-1-kaixuan.li@ntu.edu.sg>
References: <20260917151949.415967-1-kaixuan.li@ntu.edu.sg>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 15:30:00 +0000
Message-Id: <20260917153002.AAFFF1F00898@smtp.kernel.org>
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
> ioctl returns EFAULT when those bytes are unmapped.  The internal struct
> has carried the extra fields since ext4 was split from ext3, so the copy
> has always over-read the UAPI object.
>=20
> The two extra fields are not used from this path: free_clusters_count is
> overwritten by verify_group_input(), and mdata_blocks is used only by
> ext4_resize_fs(), which builds its own group_data array.  The compat path
> already copies the six UAPI fields individually; the native path does not.
>=20
> Copy the UAPI struct, then set the internal fields from it.
>=20
> Reproducible on v6.12.9 and v7.2.4 by placing a 40-byte struct at the end
> of a mapped page whose successor is unmapped: the ioctl returns EFAULT.
>=20
> Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917151949.4159=
67-1-kaixuan.li@ntu.edu.sg?part=3D1

