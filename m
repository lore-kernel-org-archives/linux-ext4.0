Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793637504;
	b=equKJ8WLe9KYxaEY19O4S2pPIpAU+KOqbZysJXDLQw3toC/IniPCCJKZ2J/EzIPADiYx
	 SMpaw39+/wu6AQtGIFwOR0gyXStdatN7HTLRN08q+CYSDjT1r2No38a6Zr53crZxJvvZi
	 wP/fEUltCUy7c4eDmRySFvtOKGxQvlZ3XjSq4ZzAJCGLTySdOVw8gH9hcNkeVFQf00IeA
	 AT92aqANELBNukZFL/GOpoPfiHuZ9DRjtBpBs8yU+eOKOBPlp4s5DBwrQ+FDGOIhUeAK6
	 NVbuM8KtgU/TQro5yvdgiTWfV/k6SVtDwzTXrlHnz7sxlwe6AzG/T//hrAECuOF4EYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793637504;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fO4/gczcL38rvcZYXO1Ds8U3Wk8BBJxUxN37yOrbdg0=;
	b=5ZiwtlmrP7tdB+0LObdWTvST7B8wC+cOaOqbTfZ3qqT0IcM9pC5xBpLgu7rCOShQz16z
	 bjBzIdawWDHuO26+/w9w1OF0X++cc1sLudP6lqKOq/y+ElQFOZACf77+2SORAWPaD+d9J
	 4BnUkZckM2deGkbY30u++4sJsfbAaD0PYJYgWejfloX9HZKObLw2nNH7gQoiUDSjduA4w
	 opVCaB5rYLC076wxPixGMeIL20fipVmKiJN4xWeJRP1hiVGCq8fwHOLyACMqnhCjiJqs/
	 Sw0VXONyinLKJoiEBUs4YtJqeC+K/znLmlbpxVuELaQEibWSaAqiaM7+az1HHG6bb5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="K6hCd/l8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE1B606B0F9
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 16:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K6hCd/l8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412671F00A1E;
	Mon,  2 Nov 2026 16:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793637503;
	bh=fO4/gczcL38rvcZYXO1Ds8U3Wk8BBJxUxN37yOrbdg0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K6hCd/l8deZ1byZ41/jft9jgpiJmcyxm339XkDbHmmxQbDKclvd/FPsI24QS80JU0
	 V7SLuwH6nHr9VfU+nWXFAyEqvCrFJ/mgJLsWJc2xAhvTl1MyG8pOcRGqZ3drsCkGMX
	 uw/dzIpY9TjBEF7gwLPHaxNNi+K9/ZzwDfbbdcjhpypGz7fKPkSOb0crgZ+ehyWI8w
	 R/vGlTLmrA3m6TueMKn/hYfoo4w6d/yPzFmwsR7ZUdLoo76Qg9HxlEgx6YdczbSpnV
	 fOYxwZ/MJS8I0yUlW1f90NJqYC6HqP9Wq4A5E8bl9RF7p0L8YtrjQma6g4927yxCy+
	 x9SM/yXwBGH7w==
Message-ID: <sashiko-outbox-193760@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1] ext4: honor NULL returns from __filemap_get_folio()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Naman Jain" <namjain@linux.microsoft.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102163341.2170232-1-namjain@linux.microsoft.com>
References: <20261102163341.2170232-1-namjain@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:38:22 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> The bitmap and buddy folio conversions assume that
> __filemap_get_folio() returns error pointers. In Linux 6.1, however,
> it returns NULL both when a non-creating lookup misses and when folio
> creation fails.
>=20
> A cache miss therefore passes the IS_ERR() check and reaches
> folio_test_uptodate(NULL) in ext4_mb_load_buddy_gfp(). Creating-lookup
> failures can also dereference NULL in its slow paths and in
> ext4_mb_get_buddy_page_lock().
>=20
> Restore NULL checks at all six lookup sites and return -ENOMEM when a
> creating lookup fails. Preserve the folio locking and migration checks
> without changing the global filemap API.
>=20
> Fixes: d34e4fd4e73f ("ext4: convert bd_bitmap_page to bd_bitmap_folio")
> Fixes: 862483175d3d ("ext4: convert bd_buddy_page to bd_buddy_folio")
> Cc: stable@vger.kernel.org # 6.1.x
> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102163341.2170=
232-1-namjain@linux.microsoft.com?part=3D1

