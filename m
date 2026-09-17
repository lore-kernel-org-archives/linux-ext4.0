Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0BF4E0202
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2026 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658729; cv=none; b=fDCz+9V754xicy29h6CrZj4jZZk+443VSttUfdOcXfld8wRiJGrFlAQA6bBJ0H1FAZghwenvwjc49i5R6UstBxFpQHqAvNFymZZ6uiJ0/y9DOsnqnuq57Ug0Xg43mv3v1OOKeQKPAZsrRzdf4U0C8wwcAJhelzWYgGxfQbwo35g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658729; c=relaxed/simple;
	bh=a5lyTHUyRMSZt8EGDHxQ19uaoJHBz9GCXiRbrwNdI2E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jDNgL7w7LGGQjkMby7JAbNS9wrD4lTir3fN2GEi+cmp2Vh4EVZEgwi2RT9SSP9ZWQUADQzHEJXz3ecBnwg6iBu77wPFGeAObBjE9a0jdIZllsZXEvMEYCo/UtdbzDLJXeyXg73Qp7onm1rUOkv0lQuD4tJWj/fnBAGCywxV4mAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qzfbs3Vv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qzfbs3Vv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FCE1F000FF;
	Thu, 17 Sep 2026 15:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789658723;
	bh=rjd5I3WCSI81fxe6lD1H02pdS+b3HJF/6hHn0aUtwLI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qzfbs3VvY4OQrM5lB95pHEcTfwdDsAvLuoNXuzE88dOA0YBU0QLE2CHcB92yEKfZ0
	 Sc42XRq0N7m0BthtBjHagzTnqVFM+LFgHhViYBvIWxcAlW1xKYoEMul+PfLcMpuRKy
	 +pDKIvSA8pL+BQOYgU8ASZPvCtlFLkDr/8rjLv0A+zfrVK3sSocn0JFxhXxSNaiAC1
	 g/Bc+LDilZphdSx5KDl4ta8hVzSrSBWx4Lhw5Yh44Bk545tEgtYHD3bppJanAzuJAQ
	 uqBTaRLE++aNUdSv4/TTgOxlcFeCjuQYSHObMvC8iST6QRTzrAN486WG/JjSB7EAf5
	 xVIJqFVtiDHmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: don't read past the UAPI struct in
 EXT4_IOC_GROUP_ADD
Reply-To: sashiko-reviews@lists.linux.dev
To: MarkLee131 <kaixuanli0131@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260917151441.413135-1-kaixuan.li@ntu.edu.sg>
References: <20260917151441.413135-1-kaixuan.li@ntu.edu.sg>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 15:25:23 +0000
Message-Id: <20260917152523.C9FCE1F000FF@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917151441.4131=
35-1-kaixuan.li@ntu.edu.sg?part=3D1

