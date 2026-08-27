Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00FD38238D
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 03:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802005; cv=none; b=WzpzQk7ehzkNUhXVDQIAHJr2JDzo20Y0vEVgoaAy3uRGPg1vLo51oBNv2uWw+GDDu3+/Gvgxu2V8mUjYZA4I4ukpL3MWwhbbBZeHdRTrVmEK2evtBS1atfQDojGOnmVvEKVZIgkwOodhJw+c717ZVPKzS6VSLkY1RdC9q+RMCTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802005; c=relaxed/simple;
	bh=1iu8xZ+a5kl9Tv1R9WFnq2Fj2oGcXM8VtH2MeU2ndUc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R7heLL9l32S4k56dH8jnBFZR1/Gb26bbeEAb+FxRqRK9nfKF3Xr/gn8jKGd32TpViIDActFE11oBxSODld3ZTPOHuFZTTN0U027VY0aNT0i4UsJhxenGgPoQSAK2CDlJjzV1lirFO9wKgIMzegBg2W1DF/lWAMvmRizJ9U5cy1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UOZgspKV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOZgspKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BB61F000E9;
	Thu, 27 Aug 2026 03:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787802004;
	bh=HiRer6ppJctyPtvf0uGgAlPbJeTDJHhQFjolsz0Fwrk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UOZgspKVTCNcrs4VDDODwS8FIWHqDKRdnZwe9x1nF7uteUVbD6tUMLt0m4BC3+eDr
	 6q1DRhF1szzEd2DVHyC/yh+c2VI7+gpdNAkfi9/CxvegGvMThUpTTUneCXJwWVrMiS
	 GQbrZBw7khM2uitSYHsYkZWaMj1+e2Md/FpgWiQquIkNgzWFPVdQpOqG4l7buIBS06
	 fQfr+hR5WsyrrdGABfNK6m3nCjCeHw3qBXuPQlUelNGbHEuxl45vryknzm2PYB0GPZ
	 gFIJy74DpP6W6l71v+LoBtsawM8LW65421HGYS2xemhxnKzFysVn0GE0sI3WNEZGHN
	 8SY6b2LXWS4Ow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.6] ext4: don't enable DAX on new encrypted files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260827032857.82762-1-ebiggers@kernel.org>
References: <20260827032857.82762-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 03:40:04 +0000
Message-Id: <20260827034004.82BB61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> commit da32af420d6d466e247c43ac0b829edeac7ae0ad upstream.
>=20
> Currently, when a new encrypted regular file is created, the call to
> ext4_set_inode_flags(inode, init=3Dtrue) in __ext4_new_inode() is made
> before EXT4_INODE_ENCRYPT is set.  As a result, it can set S_DAX if the
> filesystem is mounted with "-o dax=3Dalways".
>=20
> EXT4_INODE_ENCRYPT then actually gets set a bit later in
> __ext4_new_inode(), when it calls fscrypt_set_context() which calls
> ext4_set_context().  ext4_set_context() sets EXT4_INODE_ENCRYPT and
> calls ext4_set_inode_flags(inode, init=3Dfalse) to set S_ENCRYPTED too.
>=20
> This was intended to clear S_DAX as well.  However, this was broken by
> commit 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load").  This
> causes data written to the file to bypass encryption, also causing
> [ ... ]
> Tested-by: Disha Goel <disgoel@linux.ibm.com>
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Link: https://patch.msgid.link/20260730175212.36923-1-ebiggers@kernel.org
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827032857.8276=
2-1-ebiggers@kernel.org?part=3D1

