Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143EA3793C3
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 03:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802263; cv=none; b=TopVJK7Gfr3wJHAY4DCzGKDPBNEyTbFbNS6Aov60e5LXNimT6TUoQ7Pqn9HwfTdz36SNWUjPgydkunHsH5GJsFCVM9Y5lYehKaKOLYF9PZirRi1Rl3gi183Bt7yCtX3zhtJSiBW7OWg/YS/MoxV/CYTw9qy+VXksXW20gEtfmiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802263; c=relaxed/simple;
	bh=HoGvUtve859kSPlqrwaxGlEy9RTwXk/S2dePoV1Nc7w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=T57q61Krwz64QvSGSX8XsDDJxzlpEUb3ni5HOewSi3vudwiljRBhBzjXrcQVOTwZExF9AKOTek7Sv1uX0Riv9fdOeRGBKlcJt0N1+ut5kd6ExY1kH/lzVeazIMl50KrJmJnbnL0kB8IZuU+o8V51iuTHW9VsyGfKRH8j1++4wvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BB1cE0vS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BB1cE0vS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DDD1F000E9;
	Thu, 27 Aug 2026 03:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787802261;
	bh=q8+r7oc2TfnZ5M5N0qdP0j/2oAH0uzcM8fSrPIvlg0I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BB1cE0vSpCMfcDRsRHFQVhRCsUO0pTiHfCrTp8vU3VCtXhspZQ0CX3bRf6SaWy7CO
	 QY2oS1yfmEV0zuTuVlfq3Ss1RnYc3NGSgDHliOdy5GZpHKNrvs9GJlhdfveAIls9Sv
	 irfAME7ZUgPH015148SwrsAhm4PUUdd/YtkEdvCIs6UOAgCKns4egSbjoVTGkQIK3B
	 mi/WUvTxDSEgwH9KFRcg866UqRvsl4s3V7QTkDBVTIMeHHVPDddHmi2AhcyFm/4W6L
	 WHJ3hxEUFel9RCrkilyM2S/bCk3eon3/SIkSAVL6Feu1HWPVGXBizLPyJlhdhIyz9l
	 GV8SqehXSYczg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.12] ext4: don't enable DAX on new encrypted files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260827032815.82363-1-ebiggers@kernel.org>
References: <20260827032815.82363-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 03:44:21 +0000
Message-Id: <20260827034421.B9DDD1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827032815.8236=
3-1-ebiggers@kernel.org?part=3D1

