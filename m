Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E3A2FD69A
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 03:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787801955; cv=none; b=XsmjNjK7kGWiIFUluH//zTyShu0RauBT2r9j2xVpTDSkqRZcItsEtCy3Yww7JmUkMvpNWEFb6MdLiAkmlZTDQB/3Y2e2+Tl1DiCALnX5acNHTofoEAsJOftevF/PcZNxqN7FHaXpdoNlx1meGv8Ln4QcF6OIw/3V1z8ZJBcNZ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787801955; c=relaxed/simple;
	bh=0L5CPyLT9hMs/oVSntkO1toomx1KB0ad7SkRIm//j1Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C+bMvfInajzdiZPyQDg3p36ELP98WCgadmqNJ+oNxequIp2TTyDZVBJnv8AzjLTKA16ukx40tJenqWMMk8DEbPq4k2XzNJLBTqs7cM8fp6YAF+E4N65vkqlnbvFWqQuX/CYLt2MBDdeqyR/AunmXjQV/Wt+85OL6f6wrn11bEB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRbBt5HL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRbBt5HL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06CB1F000E9;
	Thu, 27 Aug 2026 03:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787801954;
	bh=KFHQkCzHJAjFIIFXDTYJro3R4xIf6lBgMtU+KeRncLQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WRbBt5HLRzGKr0QNq1GeejJDwaoDIrpT5qnme4vlhKBy22JuI/UVRcMBUGCXsRLsZ
	 bz1Bz9vUn2DiOUJ0f77cD3k+FulTBxVLuWE4Hjdp15EAlClGRtXyExvwScK7rgsd6A
	 qJcDUvvzE0P6nsT85j6b0c8yUL0wIHXi7OkJPhyNb49/y7q6SXrIQ8tBOCodbIl+TW
	 +DJdSz+Ac8FzpVacf8v/IeHk+nn166XLpoywkl9YUn18oplLAmP6Ku+pTp0199ouAs
	 VS3UYjbZKWdBdWPlZIcARCeVF5a01PSf3nRmog7Zvil5zGaX+PDqldt60SIS0aQ/kU
	 4fXJOoyGtZJyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.1] ext4: don't enable DAX on new encrypted files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260827032917.82878-1-ebiggers@kernel.org>
References: <20260827032917.82878-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 03:39:13 +0000
Message-Id: <20260827033913.C06CB1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827032917.8287=
8-1-ebiggers@kernel.org?part=3D1

