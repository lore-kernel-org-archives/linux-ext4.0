Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008B338424F
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991260; cv=none; b=sjrxIHOBSh3CZ99rdBYMj1RpAQoP4tgQe+q7bfeOt/bEXhNwgVIPedz/Co79dQ4iJnlSkG2sNAS0hpuDkMLY+gsk5wolW+iatiSFyWdOsWzCiV566035Dva67pdX6lIxwT/Rxk4IMEpFzgvLqiHbfQW3GLRioLjt752RJOE29Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991260; c=relaxed/simple;
	bh=womXNNGPoERd66w/yFZEdtPC4CPgxZE+8XZCjesQcd8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aJjuJyHCa//c0YHEbus5YTdwUDSkvoRRrBRhxHorIfabI4cXRdV8JrSlXZrkOPYEiGQ6gc2CyXUYVT6xS8baRjrvSzWmRoTBjH68zeHI3KytpmDOSjs6g975Iy3aJuKmVLh2uJvyWQS4sWqOo1E8M+l+OvPTaGQes+v4WQTa/F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bBjuyg5v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bBjuyg5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886B01F000FF;
	Sat,  3 Oct 2026 01:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991258;
	bh=womXNNGPoERd66w/yFZEdtPC4CPgxZE+8XZCjesQcd8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bBjuyg5voDFUec8ppk4XEe6c//u5LWRBH21T1A2CdQ9K3QJwi/mL5Z3zyayowZvPa
	 gmu9mQYqf1e+JmZyZzpYwTZtZwLCFysCGAsuK+zDiudldOfPWG0FlB8Drvc1l4+iSZ
	 qIE7zECIt+toFRp04nj7xZMBAIEtV1q5smCtJo6Hii5owJsTOg1LcAQ4z7R+kFC9OP
	 MfiKiSOcy3mG/DPHdi5OL9tVi96L68dqs/0cPBQu+zIKMGxURdt4VH8rq7Y3iuHgwv
	 SlTxNEFy13kCWZE0dY26qol/8ih4GFFIUwHZvKEsf520Gssl8ipUsD91Hlwlt05pTa
	 AOsb44HmRNBdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 07/21] xfs: introduce fsverity on-disk changes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-8-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-8-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:18 +0000
Message-Id: <20261003013418.886B01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Introduce XFS_DIFLAG2_VERITY for inodes with fsverity. This flag
> indicates that inode has fs-verity enabled (i.e. descriptor exist,
> tree is built and file is read-only).
>=20
> Introduce XFS_SB_FEAT_RO_COMPAT_VERITY for filesystems having
> fsverity inodes. As on-disk changes applies to fsverity inodes only, let
> older kernels read-only access. This will be enabled in the further
> patch after full fsverity support.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D7

