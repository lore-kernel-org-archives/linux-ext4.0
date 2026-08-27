Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E533F35F5F8
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 03:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802728; cv=none; b=JUx/0cmcVAY11/IkdZ/mr1s3QLN1+JjlcePeVa1K4y9pVJvm02eMEcjkxDiAWa2ctnqU0uaS8IuDYqcosx2702rUKLCYUBnOOW+0Gp1HLRmft68eG0rklhMWY9dAJ4gbul7Z042iO/OQ+GsfvURBavG+up9pffTLARzUK7KSWiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802728; c=relaxed/simple;
	bh=+H4gQP1qufHySz9ngkmbbZf0uBmNZI3Zvj4LCfnFkqY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DGDAdMGesJaQsxMXSbJhErNu/dp4P0/jrUi8srLplPS/eWR4Bbv35FgDS5fmVdpQp5+vOrEIVr6tSrYAlZm3+S5lle1432cyiw7JJ6aWjj3tCM5xFo2V5Ex9IkpbvEtSWhPOwys+Ow38RPWDqIV6jnip8+gwVSFc8DfE/YIo6+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFuNiOyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFuNiOyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833121F000E9;
	Thu, 27 Aug 2026 03:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787802726;
	bh=nfsWv+dKLUbY1ex6t+ML0ftTUgMCX1Up/19XJHRixxE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nFuNiOyPlFlVFXC79gYE+qXtrvRNyog5k6EH2STsMJE20UM+/ye3Tk2K73B4pp1i1
	 VGXbo28zVcM8gYf18DR00I5XUmNZwsHcGjum01sZjhy0MVLtFETF0jy+pecXtNJq80
	 NOxJZroANSl78opRnnrMFK+Wudea6t2JuKTVhYZPwCuqQAk7O4u62ejlIqp+P/bfJt
	 XWlG5ZbAx1XAxKVwPlpE+4DGUbm7bpzM87bYGRuXFsm2OJLQWN5KbmXux1qAsBhBSJ
	 uAzWzergRb4o+S2yBHCLcGs1ddkLnn/9yITRfzD/MgkOrsx5G/55dQUCKLgQvgPfy0
	 IinKL0d8uPyKw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.15] ext4: don't enable DAX on new encrypted files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260827033833.135937-1-ebiggers@kernel.org>
References: <20260827033833.135937-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 03:52:06 +0000
Message-Id: <20260827035206.833121F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827033833.1359=
37-1-ebiggers@kernel.org?part=3D1

