Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104751;
	b=pLB5TxN7c6jJFClxNfqiFrOcdw4IYiWAgNX0IV96kwUL/Q0fnOHde53Cxc9GFAUR8nz0
	 bVo8SWuPvChfgTT+7Py7AViuBmVBsftH0dh8RbWWirA2HJmyPhQ4KNAhfu3K/56cVk7za
	 VcEtOPe4SbvAJUd6rLfeFhJ1wDGaENodJQESPuJQ9zqu2Y5gMG2e1QWEqR3LRa8SQ/eSK
	 bfrE1TjFDgSdxsQZ2rE2nVC5H0Qc3HSM9CEO0GEE4UjFObXrYmaEldVyjij6FTKfBJAY0
	 pw/IKlwfgseYg85H+aM/5Gu2pULh0fn9Hkf7KZ10pRf9GSMrrPX4UIudQ5g1aZhpmMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104751;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hybJduZiNXAqDZeBqOg3mlncW2a7rsBMSN6I8Y+f8Ko=;
	b=FepZ3TfmEZkhwtVcTLgvyXq7NaGFHCa+lMKNdhVn8UWKJs+k2R4mH9i/FzIaLMetm042
	 PilRIYwN86m8tQpMrd4DBJ1dSeKcspUPds/pgJcrvmE6Rt+hm5E++s0lxC+gY9NcRXRnD
	 VDPpg39lkw4JgMhwYxSE+uVW8wyogMMznGaaTRSF4fwJsI23bF570TAEws76Do+ivs1my
	 bj+m53YGgXQyDrpjFpzvJk0Jddgoe42/VlxKrbhy4CbAaT2xOMSRFG8urgHDj6rK33JgZ
	 I20gn/4qipnW9ttZGIofiAwmyAmbZi7w5pKpIlC61dFpTZW8+txVOfgsSnnrubk4wYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QlfV9y0V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBF9606A324
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QlfV9y0V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0BC1F000C6;
	Thu, 19 Nov 2026 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104751;
	bh=hybJduZiNXAqDZeBqOg3mlncW2a7rsBMSN6I8Y+f8Ko=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=QlfV9y0Vf814SUSpMTeOF8vXu8BwU+iVyTFDl8KS/VXL/OZhFJmQIpEobPI2Sf0r5
	 aIr0XAvcgjjs/l9GQllDp+1FFHN9eqnu7sINN9CaNpEGLM4dy07KqEoRPlS9vVHMu7
	 LclaaAMvMe8EiBe8wa4qh/HrQqYLoREVXe3URwHAyOitrKSfyYyiduNxykCe4Sw9PY
	 jqNBTTCtdwJIhrFVG4B8XuGmIQsOLWP6Hjncg9MKaSGHqT/Gwemp2v6GrevP5xWJp1
	 +nWmwuzM82LY/QMGLq2wRIWiGGgLABYkETpC8C78sHEtolCTt23CfKEl0dB6ibgILG
	 dqZId8ExPSGjQ==
Message-ID: <sashiko-outbox-223488@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 21/26] ext4: expand KUnit tests in
 fs/ext4/extents-test.c for file range operations
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-22-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-22-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:12:31 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Expand ext4_extents_test to cover high-level file-range operations and
> reporting entry points in fs/ext4/extents.c:
>=20
> - ext4_fallocate() mode validation (unsupported flags, encrypted
>   collapse/insert rejection, FALLOC_FL_WRITE_ZEROES device limit check,
>   non-extent inode rejection), preallocation with and without
>   FALLOC_FL_KEEP_SIZE, and hole punching via FALLOC_FL_PUNCH_HOLE
> - ext4_zero_range() via FALLOC_FL_ZERO_RANGE (written-to-unwritten split
>   and EOF extension) and FALLOC_FL_WRITE_ZEROES (block zeroouts,
>   unwritten-to-written conversion, and orphan tracking across EOF)
> - ext4_collapse_range() alignment/EOF validation, block freeing,
>   left-shift of trailing extents, and adjacent extent coalescing
> - ext4_insert_range() alignment/EOF/maxbytes validation, mid-extent
>   splitting, right-shift of trailing extents, and i_size growth
> - ext4_convert_unwritten_extents(),
>   ext4_convert_unwritten_extents_atomic(), and
>   ext4_convert_unwritten_io_end_vec() IO completion conversions
> - ext4_fiemap() and ext4_get_es_cache() range checks, FIEMAP_FLAG_CACHE
>   precaching, external xattr reporting, and status extent reporting
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D21

