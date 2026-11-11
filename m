Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794402395;
	b=XIiXipqr30TJZXdWvsBUJLxJryxvnB29YQWGiHjUcOX5+bYHBr7K1uaqsnpfPP3UqWcS
	 cRFikLw87BNhOWXRb6R5YJUEWQFJ2cGg7A1S1kBEaYVIO1OXBWfGjerJ1ylR6keuAFUE5
	 3tPvH/1IH65l9o7MkGFg73FqYyo2Z2KxOehDsqO+HBgixBAsVY2RB5isu6E8oUcfPqbAp
	 +zE+up/jcfbTi5R+aRa30wBgUZxdpHp3fz4Bd/v5AIWLsjkTO6sUSoN+jDbZoiv4rMfHy
	 35hQpf3LGdrLEXMyKX8OosUmUtBPskb0RLVWIWCPiiQ1Vb8hVC7+fLsM+9n4BIjIG+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402395;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d8pqirlEZeqndp8We0tCy2pb92VFCdcft6iDRex0wmA=;
	b=r5vOmJ3cjnfZIoKw23bGaPrbeTC3V6NjilHv71ob4xL3CYr6hYQt2vNADiN9T5ApYrfM
	 Frf1G2x1BDdKQUzP5B3gNL4nj5IB5x3wMLENKIyAlxogYgcBV69RAArgMTvL6k8w+i4lu
	 2UeafDr2L0FtYWpBTOXPA7/U0xgxmk5TCNrZQAmBLmFQUlpssqKKX5w4+WcgSciMD2dzx
	 3yynIWfFeHcm0TT4x0sPX9YkO5ciSZSg+5gkO1v/UTFSY7a4p8/T3ulhQJMZEURVzI0kq
	 dUeBhHnQeoR13Nbs6KhDT6UI9MbeLUTs/RoWIDByejbeAjKOyo0DHkZBV7zZNO0r9SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ENuE+HHn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F177606A321
	for <linux-ext4@vger.kernel.org>; Wed, 11 Nov 2026 13:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ENuE+HHn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF52F1F00A05;
	Wed, 11 Nov 2026 13:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794402395;
	bh=d8pqirlEZeqndp8We0tCy2pb92VFCdcft6iDRex0wmA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ENuE+HHnuM/z9MnyA2krTbQ9EWKkFoZZkJix4wSbfuDORb59oq77+VHDWNUKLq9Dk
	 KrFRnbK2VpreCOkXSVgUdx4h2KUbVVQeot7rFsYNgGStTQXqRntpfWWMmxc6lZa7YV
	 f6Dp9AGnM8H2CkJSF3IRax2IyBovoSxpE12K+CtQfGKF7GWE14IRe3oVbkqda8xr4M
	 jb/OASF20sQYAjbnr+Hl2Nfmc/srdJfeF/isrdoDxIaRhciOW6EM5YrWL0XbAVoDwA
	 jKlC6VDcRobjUZPdYx+jDsoPmZ/4uVRNgQ5ITOwo0TJ6VywePxK24JtZoTwZoPZjmZ
	 BqZ4kWRn6L4lw==
Message-ID: <sashiko-outbox-209039@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: report sub-block project quotas in statfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hungyu Lin" <dennylin0707@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261111125304.96354-1-dennylin0707@gmail.com>
References: <20261111125304.96354-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 13:06:34 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> ext4_statfs_project() converts the selected space limit from bytes to
> filesystem blocks before checking whether it is nonzero. A nonzero quota
> smaller than one block therefore skips the project space adjustments.
>=20
> For example, a valid 1 KiB hard limit on a 4 KiB-block filesystem leaves
> statvfs() and df reporting the underlying filesystem's space, even when
> unprivileged data allocation fails with EDQUOT.
>=20
> Test the byte limit before converting it to filesystem blocks. The
> resulting zero block limit then clamps the project space statistics to
> zero. Keep the existing rounding and the rule that a zero byte limit
> means no quota.
>=20
> Fixes: 689c958cbe6b ("ext4: add project quota support")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111125304.9635=
4-1-dennylin0707@gmail.com?part=3D1

