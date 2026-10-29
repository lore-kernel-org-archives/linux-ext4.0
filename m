Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793277085;
	b=jysmykjmkOqgiCXXzWjKxj2CWCka4L7iok4KJY1kBwJpPG3gnG5fRMW467/RafesIP16
	 fa+XFMNBAOkaC+5dYNTIUCAHcCVgbo31Dd0tndykwiFsfn5SoTmMeQx1NLAEWPFz8r7lq
	 vf8VQiO+hxqgIB01s4AKk4oLgyfudDFYLkBmKVZD1srfmttXQth9dj7g07uBIG7a9+ZEG
	 K7zF9qa4P08UZ6ogJ/NiT+f9E0TLjfruGexa2h+XKrigDb69vRlqyWIV7Ivbaumnrq3gt
	 9aCXF+PEaX7zUiao6vf8rX9lbU0F7rMi/6yS4v6Cjq3l4MSegjrwZwQ/1FAzIomnuTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793277085;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=31bmaLGaUgvaHMqObay22Yq5K9FmGJ3kdm3DtmPPw1M=;
	b=EEQ3L1owV/m9/V9Rlqk8iVO69wiDtPpLxoVOegGV+zaKu9fXcdJAmG20Dw1IEeoTiWJD
	 yGLmlbjQt/hjWg6LAABRdKPFnK5rqMXnTgUMcBHnWKsjomVpbieWY3kxkDeqK0/+SjQG/
	 +cRmktStyUyOxKM3A223hTVW4Yie1BbolHAlB1/3e4+FMRlSCSPkoXgw2VJv7YxmgCkWX
	 G/8jiPRvHURIWFyFD26x5HBnjKXEt/jGwcaQNqWEwZ51g3V/PgueYdHvnWX3PplKsp+Es
	 JlCAdlhFeJ0ex+kAQG+9i9xj9JWAsU1M7nEmXVkwX1RLRA5Dcq/sNkVY2HE5zYig5UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Os1lsC50;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D619606A321
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Os1lsC50
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7317D1F01829;
	Thu, 29 Oct 2026 12:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793277084;
	bh=31bmaLGaUgvaHMqObay22Yq5K9FmGJ3kdm3DtmPPw1M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Os1lsC50QeCyxSIbdkSBPnSbgREi/dLVqbzTG/mvKHlk4FgsWeR8mBjjA4B9dZBSp
	 nCZErFvPj2g3TeBfL/ZBWSFHrPyt8PHrEjvWceJ5Gej4ltYXziQOdNy4rG+sWvxOtE
	 TPpPpLclxZoZlDGUuuvvBJuQWhFwJihNmA7k8Kzkq0S74J/PORLe/Kt0OTwpMOF3gE
	 cpbg2KMIn/XZasDkljYBq0Ow0dwvqAY9B/qgczD8tef1PEPiGRPY89K/6VeHQlJMiJ
	 2RNzoH/PonImfuz5W3bJwbQ2BiE9ixga/Hz2KkRWw9A0PfnHSA40xBgXR8HKC1Duhs
	 6b+p/glATg7TQ==
Message-ID: <sashiko-outbox-189283@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 03/11] ext4: add ext4_dir_entry_is_tail()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261029122413.230409-4-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
 <20261029122413.230409-4-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 12:31:24 +0000
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
> Replace open-coded checks for directory tail entries with a call
> to ext4_dir_entry_is_tail(). This helper will also be used by
> upcoming changes.
>=20
> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029122413.2304=
09-1-ablagodarenko@thelustrecollective.com?part=3D3

