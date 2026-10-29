Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793277424;
	b=bza7TJaYCloCl/cxQnyJWbb5G47I16nPU+XlOPt976Pf5tWA0L2COazSPhER6bYDHu5Y
	 TFPUE7gs92DHtfYFd93dTtn3ZubMTVpnQX6xUc8RgF0BK0y84JTi0HkAj5Akn8mNA0S1i
	 OGO+QiC3naG70yZfwrUtMUldNmhnCM1W/A6cvtXqm+s6C13bNn8/CPfWpG3NDT4os15Ne
	 uN1FmBzR2zzj2yvZUo77R2bFkQNTfHai4xWfeN2v/9xGwO+nfNqGD32Lkf4T0dzbRgulI
	 eefhixxwGTNOouesV3PkOm0BlgazjX1aK/wd549tX7b3s0UbPwdDbCuGp+ERGQOSC+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793277424;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eBknAFo7hfVnfTqpl6JC3m43M8Hm1HQGjkcajZtBL1o=;
	b=L8f5GLEaFwu9b5Z81/pzlQeVYuMP+n3RiXIIb8kskAAXOGC1eiPixDeHsdKZV9W816cZ
	 wVviqPzbFK4MVkp8EJSnu1mEU4tf+dE9Ak3M9498KwbfMPdutrvFyXCdj9LluF9Gwtp1T
	 0g6hHPR7ERoIyl83p4DKJ7C5O6zeIzx7tSdNTZYoLecjxdSCo8cZJf4aAPtwm1tsibOMD
	 kDmv+XgA1dro/sEzeBjZR7uuILa0HPclApD+lx3cTdmGyiXt+ed0bNghPI60you4wh/9N
	 XDD1J6ZO3X+Djr4ccFLa7EpJNkSVwnKtiU61j5wQTnW3XQ+FOTB6dXQpRiSMbhU/81w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LtfiJUtB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596D460A6F6E
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LtfiJUtB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C9D1F011E7;
	Thu, 29 Oct 2026 12:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793277423;
	bh=eBknAFo7hfVnfTqpl6JC3m43M8Hm1HQGjkcajZtBL1o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LtfiJUtBVGSsOGxFTBLzG2m/Y2QeJhKo9o2iTEXk8I49VGBZ5TKeGZbIXu9ItrJ0D
	 4LM6rAN185Ah5o28u25tyxBgQR0gWTj6SnzcJo447w18OqfFsUo7k7qKAltYhk3F5c
	 YE4bDvx29eYAjgkKSWq+MEfLWAQL+vTgdRQRQ+kbeHXodyGLpNIx0Bfvs0MwFpB/7p
	 XJidXjdTnE5vyfMLHy+tuYWd/T76k7PjKkAAezLaHgj8a2jlLQMy63pmmJk1qDJto8
	 vpt+7zWRe0Z4Zglj/S37Otw4wCD7mudKJMTEP/yNOH6I+KEnJKwsUcWVq3qaHHHk/n
	 w7S37mtZHdnHw==
Message-ID: <sashiko-outbox-189288@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 01/11] ext4: validate count against limit in
 ext4_dx_csum_verify/_set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-2-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-2-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:37:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> dx_countlimit's count field was read from disk and used directly to
> compute the checksummed range (count_offset + count * sizeof(dx_entry))
> without ever being checked against limit -- only limit itself was
> bounds-checked against the block size. A corrupted or maliciously
> crafted filesystem image that sets count to a large value (e.g. 65535)
> makes ext4_chksum() read far past the end of the directory block
> buffer, hitting adjacent slab objects.
>=20
> Reported-by: xiaowu.417@qq.com
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D1

