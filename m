Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CF52836F
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 12:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786708895; cv=none; b=bGbR/TnLFLzkGIJarUUerewbvOGG+vaOF5vE+fI0BQkwdhZNZJ7z/YxpGbdRpfvYVRtyMb9B+4aD579vOkIBnQIP3sn9PD8/7m+ZdIC/EULJTR/R40D4yDl8RpgR/fFP8grpYqjUKk8qTFNJ0Cy6vzd4hTqejDQjlL793fznK0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786708895; c=relaxed/simple;
	bh=eACHucyY1ioRFNMUcRgotPYcq9BToSGF2jM0j5Jh+lk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u/A4ALFLarjZblRFKhtmn1bUCGhuJ7b2vQMolGphhLwWlhryahsyERpqzHlDFuJZ7X4YXAasWKO6W2qZliQ/TNY8jM4G3TjFFZ+McSuKZ0AXnK3vhWY16rfvGERgkPpIL234PjvvDo+Rjiqr/5cCduo7bQiDI7smfi6qupzCR9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ot8/iv27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ot8/iv27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC00A1F000E9;
	Fri, 14 Aug 2026 12:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786708893;
	bh=eACHucyY1ioRFNMUcRgotPYcq9BToSGF2jM0j5Jh+lk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ot8/iv27EoYTh/QLY4GfTBEqQZ2raYbfUNB2g+LsOTMHGCeF782rViv4Vn+znwZ4I
	 pB2c0YV75Iimyx3l7N4XU4ehz6a22is+kKFhNOmXIVIzWhHdP1FWDWCW0cufyUaOk3
	 B5jSPWQqX6ggIgEaJwOPE5bZPaKXNXBCtle66TXosSnwXnM9TaDlywpJ3PXrBrkqxp
	 9EQk8Bxiezv85zBrrdjHHVz/TmbFCC0PA41diomVIo/IHhQjAN35jq9T33F3za9Sn3
	 yk7bPhAjzgJtsRxSLCMf+YnVyLEwNkro0LneMoCsaNZzQ7EKZ+csPIeRNW4nMWLz/L
	 BAcUJLBjRaVwg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/2] quota: allow DQF_ROOT_SQUASH on all quota
 formats
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kitae Yoo" <kitaeyoo777@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260814114649.51253-2-kitaeyoo777@gmail.com>
References: <20260814114649.51253-1-kitaeyoo777@gmail.com>
 <20260814114649.51253-2-kitaeyoo777@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 12:01:33 +0000
Message-Id: <20260814120133.BC00A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ignore_hardlimit() exempts CAP_SYS_RESOURCE holders from enforcement of
> hard limits and of soft limits whose grace time expired.
> DQF_ROOT_SQUASH disables that exemption, but it has been confined to the
> old v1 quota format since the quota format abstraction was introduced,
> and commit ca6cb0918e87 ("quota: Verify flags passed to Q_SETINFO")
> later made Q_SETINFO reject it explicitly on other formats.
>=20
> That confinement predates generic project quota support. Project limits
> bound the size of a directory tree rather than restrict a user, and are
> commonly used for capacity isolation of container volumes and NFS
> exports. There the exemption defeats the purpose: knfsd raises
> CAP_SYS_RESOURCE for requests mapped to root on no_root_squash exports
> (CAP_NFSD_SET), so any remote root write silently exceeds project hard
> limits. XFS enforces project limits regardless of capabilities.
>=20
> Lift the format restriction so the flag can be set per quota type
> through Q_SETINFO on journaled quota as well. Existing setups keep their
> behaviour: the flag stays clear unless explicitly set, and setting it
> was previously rejected with -EINVAL on anything but QFMT_VFS_OLD -
> accepting it there is the user-visible ABI change this patch makes.
>=20
> Signed-off-by: Kitae Yoo <kitaeyoo777@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814114649.5125=
3-1-kitaeyoo777@gmail.com?part=3D1

