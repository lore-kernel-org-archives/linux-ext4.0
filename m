Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6607429BD8C
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2026 04:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786510316; cv=none; b=Q85DBViRfDlYzTV5bmLkciOIUrEBygMx65Sr52CFSlL5Uq9IMnUCHuMCvt11miMM/Q0zV5dseA9ovdjbnM8gh4VQFZYDV1tHzx1BVMnxg7WUxYLfMo0i62Wl5gXBVXwBo2GSfBQGrYomUXfgrVaJOJYGc2zKZhCnaIJmH0dVVMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786510316; c=relaxed/simple;
	bh=U3UD00AYbD1AieBUq+nsH2oGD3LHciYpNpSOqmiOFuw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Stsp9WauzsDI4WheKr+AmPvyO3lAg3hDOkmOudUXaqxCqhi8a8faIKwpN1G1qCRDwDBFXmg6fio32Eq1KTIIjaOm6KTFXJoFjYYjaD4LT/NkeRzZHUS3hqoV8jOrTSGjPqEg08thvBZanXOSg1prcnZDRy9t5aQMnpdfgvUpjYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vl/XtZzf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vl/XtZzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA48B1F000E9;
	Wed, 12 Aug 2026 04:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786510314;
	bh=k/YIdjmVu46AJ0BqYFlIXbE+uTNDcULmW4YGLo1vYvI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Vl/XtZzfj54NhlRROfKhdMf4pWS1XoVgXjBjgQKnSwtUxsxObfyVRo6In3hnKmGU9
	 yU5keTt6p48kmPh+IpEQxJ47kQT508H5iv3JpmwAXxHwbmHfPNHZsdExJpbV4cWRSw
	 jzvai7CkgM/oRhkkJCbO1qdUDlk8fH0Fq74G4dqdvyjBvbxZr2UrFRHmUfso0K8jbK
	 bSOrmNqnFB1wgMCS4nT5FQgpLitTP+1Hz+prHkDesRRFGSBIzkvggcSvT8w2+tYS5g
	 SZdkvDP3dX/j2qAQv7WDdVa9ZNgQYmVGtQfnEb1VSUG2MKgxKKU1IP8vyg41UEqYu8
	 gOUcQJAcKXLuQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix fast commit replay failing on a read-only
 mount
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hsiu-Hsien Lee" <swinds24@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260812044353.1018268-1-swinds24@gmail.com>
References: <20260812044353.1018268-1-swinds24@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 04:51:54 +0000
Message-Id: <20260812045154.BA48B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> A filesystem with fast_commit that needs recovery cannot be mounted
> read-only:
>=20
>   EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
>   EXT4-fs (dm-0): write access will be enabled during recovery
>   WARNING: CPU: 22 PID: 5544 at fs/ext4/ext4_jbd2.c:73
>    ext4_journal_check_start
>    __ext4_journal_start_sb
>    __ext4_unlink
>    ext4_fc_replay
>    do_one_pass
>    jbd2_journal_recover
>    jbd2_journal_load
>    __ext4_fill_super
>   JBD2: journal recovery failed
> [ ... ]
> victim is gone, i.e. the UNLINK record was really replayed.
>=20
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hsiu-Hsien Lee <swinds24@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812044353.1018=
268-1-swinds24@gmail.com?part=3D1

