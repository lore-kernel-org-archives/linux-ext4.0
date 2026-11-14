Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794657828;
	b=lcCzOVKOIYwdLAaZK6X0WyB9n0H5CDWnyhYbn08SbrME9ZkUCdFxG6AX+B/FXNjyy7i5
	 gtkpxYxJZlqTAjtaKpFILDnKZ7waz7m7oYn0+pZlI2XJ0wEeuarbOQC6py4oyTuZXcMpJ
	 TMOVcgtsdA26bJif4rMlqEQiSzyQDXZm2mUDk4IjfQWU9xKqYUqYv//L6AgUaVEruOYU5
	 /AmI1wm/ta+QHfr5gLpNOmcW/jRuqiVyUesuc4iUq781at+fojm4LulYAqGT+NA3c9QUh
	 sBEFr9r3Wtcv5GERcqO+o7QioM2+0kP6fokTtIzPbrw+CrENHEDssHX+97lOoqd6l2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794657828;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jiuTCshP8KfeGV8qWJXMI3dBeiUyCgbO33UdN4oGqjo=;
	b=ZZaLF+w/Jdy9j0dtE7k1jSifQggIitmJvk4t4tCq2hIQjjLrjNeqigQKxqrQc/NKyfus
	 kEGWc7EQYf1Qz2Ly8MKu2fjTkzvAp7w6B9Y5YKvVzsaEXxUWd3M7Gae3IbOim3RTpmaG/
	 ArJm//02xJNWkyFa78bxRskAFv4aKK/kJ+gFocaTN0HkdaybVi4Q11Ft1FjXNtH0GMJRg
	 Yn5DFtgfFVC0Wdo8+NzKP3Hl6h0ZpJJJRDi/Zcl66jbhMHfgGkcBnintOnxCORXi0Ep7s
	 SHTuVf7EwbVVkFkSLj9fc8KUgeODUmOrpfFggKb/QLCJ+pBSpXIYRZcm16RTar4AZ1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ld4V0FGG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CA4606A33F
	for <linux-ext4@vger.kernel.org>; Sat, 14 Nov 2026 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ld4V0FGG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8039D1F000C4;
	Sat, 14 Nov 2026 12:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794657827;
	bh=jiuTCshP8KfeGV8qWJXMI3dBeiUyCgbO33UdN4oGqjo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ld4V0FGGH9OIMLfH+K8ky5/b2kp84mevp8M/WVuyqCmXJKYt3hSeCslnmwbZB3Ca8
	 edRGyHnFpBpQklLD+eyBjCP7sNnPt6joC0PrU0o3twgUUgGTDPslIawBFaOw7CeqUW
	 qMLOqNsceV0mGWaJYq0cSflPi9EwiFSyDWKwemvl6VK87dQj/ePQWKKpFakAAfDFeu
	 nir8vyukqO2yI9RovGGzvGW7c009c7Y9/EUuP33u3pAx2B3Au51ktx0USsGydkVlfR
	 FsZpa/0cmzmKiOaXRN2XK/w/TSgv04iEe8gozqSuKipXnZ12f9lNP+3Wjr0NHdfCLs
	 /mudYT8Raq0OQ==
Message-ID: <sashiko-outbox-214475@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 24/33] zonefs: use the generic emergency read-only
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, "Mark Fasheh" <mark@fasheh.com>, "Joel
 Becker" <jlbec@evilplan.org>, "Joseph Qi" <joseph.qi@linux.alibaba.com>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-24-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
 <20261113-work-fs-sb_rdonly-v3-24-0be92bb73709@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 12:03:47 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Set SB_STATE_EMERGENCY_RO instead of a private bit and drop the checks
> the VFS does now. /proc/mounts and statfs() report the filesystem as
> read-only again. zonefs_set_emergency_ro() still prints the warning
> once. The check in zonefs_seq_file_write_close() stays so a failed zone
> close doesn't make the filesystem read-only a second time. And so does
> the one in zonefs_file_write_iter() because the loop driver, nfs localio
> and others call ->write_iter() without rw_verify_area().
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-work-fs-sb=
_rdonly-v3-0-0be92bb73709@kernel.org?part=3D24

