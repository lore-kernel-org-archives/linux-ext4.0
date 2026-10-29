Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793277258;
	b=Dk9gMioSjB8pVi3W3FJkl+92aEcuBLgFaMV0sYMo7qB0O351OUtJii2Iumm+pSqHDlgf
	 qsYUcfH4ktgkMDFlWm1YWNpdbxD1purUClmCgEHPl3lG/xMVZQlaRgrfjDUPfj0AORIsL
	 UCpqMVxvzA+/Nyf/s2Sn9sOSn/RdiJ2fstWUqAUc/xxvyJGAPXEWhHDMhq3jiJX46tXn8
	 CCRcIelEtd2NvuaUuHk5o6Z5P9VTd9vVYZU7U0947ykck2TWcoYHC86tT22S1/f7fToj8
	 MvxjAvhFgF97CivAXzXM3NnUtOOlhAERGF/iF2T5Hbu8kcLcV7aatq7gMGiHVF1wQLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793277258;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=TljEkjepvlA85ByNhr+Jov8cE3i5MPRsLtCF0BSV1X4=;
	b=cPi1we+8KTbBrXD/icWq+upcTfSm/T0xlLjX+twKJAUho/HTvpPSHvk3tA9D697b43XW
	 2yJZJmQe1FSGYyRFfSWSXx3QmSqK0uJBZcrCKF40qI8g13qjYFTevD+4H3U0p1/Mu4nbG
	 slzAgtzhqBnpjCz75X+jzSX3cPWTGX7uFDVVplu8v2p5/l6eHFZqT5setSa1Z+DD6sC72
	 3+fAlPgjKYrOufeyRd+L74lAB/sOsZQ0MrXJJfcBeikSRWKJJyor+IaN6Wff+hPUd8WRk
	 LAgDlj8IJPkArlP/uXrqVTZFWJN4eYb2fxCsV9SDJsWh0tYGDbxF7bB+P4ql54zec7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oy+Uqdf6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0013606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oy+Uqdf6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EA81F01825;
	Thu, 29 Oct 2026 12:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793277257;
	bh=TljEkjepvlA85ByNhr+Jov8cE3i5MPRsLtCF0BSV1X4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oy+Uqdf6zWyfuSxFuHKiktEmkm1V6wiuK6b8IgN8LQnhokdANcMZ448yavCU9wb9v
	 qr7Rc9SGxzT0sOgeG6SeuqUDoG9A6kq9071F0ceHUL8g8fh9T/pe3G4bL/mAUo4fQT
	 ebCl8okwm59BH5BuaWresNygUT5nz/JZBT+c9qRi7GiE06PTFSW4Nz2frNemGK+4XH
	 t1ksvR+WVI4OAnmBjA1B3DqKYiaoTMqFoBlS+5Ye3piPYCGJkK2wj9LCRMywOSNqAW
	 xUApx5Q/jEtsPaVaFz5ap7IKok6yR9hdK+9BRX2vA/qT7278vuNIUunxJF9V+TNP1u
	 15MGqxriDxY+g==
Message-ID: <sashiko-outbox-189286@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 02/11] ext4: replace ext4_dir_entry with
 ext4_dir_entry_2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-3-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-3-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:34:16 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>=20
> Replace remaining uses of struct ext4_dir_entry in namei.c
> with struct ext4_dir_entry_2.
>=20
> The code paths affected by this change already depend on the
> filetype feature, so using struct ext4_dir_entry_2 is
> appropriate and avoids mixing the two directory entry types
> unnecessarily.
>=20
> This change does not affect support for 16-bit rec_len.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D2

