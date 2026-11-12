Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794520491;
	b=owFVIQbSeCSEZzwGVwQiMe9oPwi9juu/QKCGzKTuSSdDd9TsQN2C9jQCPBd9f3xONB2H
	 UC+EfTSHU0ckPgnehHvhP2EYw7yyEZLcwsOJtnC+mnRZ9WJMVAbIC6c2exdpWACP7vfu9
	 op2sLrZszcu0CktF2tPttzwFLQT/ix0mvgxGBwbCoY8YeoYjT8EVp4yx7m9/XNM/O4HBv
	 aCikQChsyyaKTkdzKlxzbDnM/m6I79N6zZ15Iv40wP58jA4oyWidXOz+7bgsNGix4u8Hg
	 bjLzoyCSOBlj6Lw3YaBW9zICU9kYfwwe/0GTG7zs7JAOC8TGJfDcrmIKogHyuDFX15w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794520491;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d+LrrXLjRUPSouFoRYWMBftie/wO/fBwpQA7xxtqfjw=;
	b=pLdkMFSpiy1NBffAPwLrPwMM84seOfN8KPPAvpkJ+l1if6zV6/yOnXsrt+Tx7gxNGOGQ
	 SlDVjRQeHBSdRCTyXvQ2dHdlq24RFAYWq/p9GKXtyIaFNUy6RbSUmkJOwwr4PT2WwNnMi
	 fxvE0eL1P8QXmo9orS8VmgIQWqIult9pBVaJXs0oLU6AVWGsZAtE6QUbYPh6m86CIUWy8
	 GwEKG1PLlezSQLarZD8QaTNdc2QeSJm+RUhXdx9yNA2MikcoSE5M/46c+bejpJJCXLnKP
	 gcovOwI64o0TctlVp3y1UZ3syL0iKkQp21cVOuA3t+UvTwRfb965lTUrbBzcmPD3mYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kfYmSh99;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23D9606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kfYmSh99
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE6F1F000C4;
	Thu, 12 Nov 2026 21:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794520490;
	bh=d+LrrXLjRUPSouFoRYWMBftie/wO/fBwpQA7xxtqfjw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kfYmSh991+lM5z+kObO3AGI5gPcqugjXUGaAGHidPurbrm7E6bZAoUU9OuAwNq1xN
	 R3p/i6e0pEG7ImiufgZq3BYquRgvgk0M298u/ugs4QMFvlMqTTze8ty5FgusIz3r2v
	 vgOnD3Q7nwCAdPHgtChgOroxRVx9OMby04AvMSGWqbjPyq0Tc+cQqaU7mwWISQQMzF
	 uyoyE+7ks6bCgf/l0FUmk7X7XamHvfYvBAC3rfsejaYUvFfYPpALO8f/XgraiRoalh
	 GK0ZPP52XBo5eiOf+mXM4MbTVVqApwt/vcQpHkoTX0602BJRHQGp3gnf2cqg2xwuin
	 yHjA5fTgn0Avg==
Message-ID: <sashiko-outbox-211876@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 07/14] xfs: test for reflink after the dio write
 checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-8-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-8-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 21:54:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> A direct write that is not block aligned can expose stale disk contents
> on XFS if it races with the first clone of the file.
>=20
> xfs_file_dio_write_unaligned() falls back to buffered I/O if the file is
> reflinked, and tests for that right after it takes the iolock. But
> xfs_file_write_checks() runs after the test and can drop the iolock, for
> example if S_NOSEC is not set. A clone can run in that gap:
>=20
>     direct write                        clone
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                        =3D=3D=3D=
=3D=3D
>     takes the iolock shared
>     sees that the file is not reflinked
>     drops the iolock
>                                         shares the blocks
>     takes the iolock exclusive
>     writes a part of a new COW block
>     maps the whole block into the file
>       /* the rest was never written */
>=20
> The fix used here is to move the test after xfs_file_write_checks().
>=20
> Fixes: ed1128c2d0c8 ("xfs: reduce exclusive locking on unaligned dio")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D7

