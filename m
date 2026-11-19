Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104714;
	b=AsxsoahrkHblX4UjVsamhvpx5xX8YeuVgXJMFWPWra8aG4dFlSswRQUFwtPl/SQ9pWcz
	 cdC5gi6ACVq5Doa8Py1mV5jV2pJR4NbiZthfBNzsbka4+OYoKVitnN8ISrIp7wKcT/ZIQ
	 pT+P3Y/upE/zwLSOr47DyGprxIheRsAjKoCdnc+3lLnldINIDeK8mB+1mkDc52I1fA8xl
	 iNL+Z5f1gs3KGhuC0Qyinnv+rjIpPsTElOeINser/1FQgyHPVxrcffE2jOz1wAyj6mCZt
	 kC8s+LBoL2n6BiYV8d8kYj9ji9PAKvTMU9a5pWjK0HUzec3glt5lA2gbfIamR0sBwtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104714;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qIXhrSWcZEb4ZcQaXPpozCTVtB4t08oLwEmPRR2TwuA=;
	b=KSPxcyp/pNai2/Uw8lkR1HnNED/NrWEWjUy1xmJVyeg+2UF7kYbZxgS33XJv/UVZBQ06
	 Nde01pi1VFb0xIdHGEcgaxYB/qXuyGIQacuTQHxy9Fo1a823kBFXJuo0WDFoFcRCVNt4p
	 ZJBZwlHFjt4GTQrKdY/QPujlasxwkfrCgZM/UwbidzWHm8DT8PMwmUEWy0Ifgvc5R7km1
	 1C0g9Ev4hw6PN/dbaAHOfUaunD3H6i6Ka8zOn2kpteKP1U4k1vu66chBMri5jkxa+2CVr
	 AdFAfjgF1Wi/hP16GU0wFDHfIkWC1J6yXP1uluE9UjdBAVDVVzDuSPZsOMLlkmKfdtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EcuT+wmI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27B8606A325
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EcuT+wmI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6152B1F000C5;
	Thu, 19 Nov 2026 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104714;
	bh=qIXhrSWcZEb4ZcQaXPpozCTVtB4t08oLwEmPRR2TwuA=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=EcuT+wmIWPV3qpgEs6/fwmnqvRF/yN2KJXZdE8FHWuvNkRK8cqJ8GkzQN2IDRE9Z9
	 KVzgHIsYQQnoas/bOC+pJtuL1BHgGNY9aOaocx4JBov86HG5XeZZK5KPS9jgHFGG2L
	 jHj32vzPxYmw87RtqqKCbaV3NsIAnIheW1Gq+pbqr6Ja4qrGvVfWRsDVQZt4YtZfxa
	 FdLFRlOf/RsjproXHOCGLr1qMnhpV0gwC7CaUvNWH1TkwnhEoGHjuhLJ2jAdjL61Nx
	 36UnoxS7q5HjLQob0cXZtkcjvQBW+EvydRlGAqd/k4wBE8XE4yOH98HpYJDXfgEjVg
	 KxSgNZ7ZBbQtA==
Message-ID: <sashiko-outbox-223484@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 19/26] ext4: add KUnit tests for fs/ext4/migrate.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-20-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-20-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:11:54 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add the ext4_migrate_test KUnit suite in fs/ext4/migrate-test.c to test
> online inode format migration between indirect block maps and extent
> trees in fs/ext4/migrate.c:
>=20
> - ext4_ext_migrate() precondition guards, fast symlink no-op handling,
>   and temporary inode allocation error propagation
> - direct and single-indirect physically contiguous block coalescing,
>   sparse logical hole preservation, and indirect metadata freeing
> - double-indirect and triple-indirect tree traversal and multi-level
>   extent tree construction with proper i_csum_seed propagation
> - error rollback freeing allocated temporary extent tree blocks while
>   preserving the original indirect inode layout
> - ext4_ext_swap_inode_data() concurrent block allocation detection via
>   EXT4_STATE_EXT_MIGRATE (-EAGAIN)
> - ext4_ind_migrate() conversion of empty and single-extent inodes back
>   to direct block maps and rejection of unsupported layouts
>=20
> Export ext4_ext_migrate(), ext4_ind_migrate(), and a KUnit wrapper for
> ext4_ext_swap_inode_data() via EXPORT_SYMBOL_FOR_EXT4_TEST.
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D19

