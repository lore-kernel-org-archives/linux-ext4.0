Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592235;
	b=fxX0lnPsmzB2LKkyTMgCJWjb68xE7p1LP/P9adIBnzuq7zBfB1MjJxSmfdNi6BDdrWs8
	 90D+Nni8lJWoZU9mOYfBgvl5aFFE0bL+NhS/ewL7R3bjgeonKekeOOr0XJn/xEU0D+575
	 i4R/U4gHBjyrmqTLjwVh7dEW71veEay4ArJBx5/m8Vmz3IUUG0cn7zoM+TFs1I07wWJsM
	 /vgEQcDH3QsxM8vOehQ9H7/Qp1INEh75QjwwKngmXd17aySppbZOLns9O8iCWgfc+QvaE
	 eqc7MV4hL6+3iur0xRfxDpmo8i/nX2Q9iuynYIAIYiThxpQ+1mQ8b2KMUfhc6JWNbGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592235;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+H+KrvpY7uR2GeDyeLgI/xAh9gM3sDh05mVsVvZq0WY=;
	b=rt9BbT6imTvNXBC3ko1r8HOwtT6BYQtPPNphOHIiPTE/jVC7Ac+0Z4OuYsM/lo6TkbNn
	 o9P2nSBTnW0NItmeErQY9dXqIgTrNodIsRZEf5B2/wH8A5Z6lx1vMUHd9Hva3B+fOnkUz
	 o2MtJDEfvtT18tQ6T5D+5j/Z2uElXgrT6DgF+GpHVhBLWm86Q4q7XceIX288DpqGeUe04
	 IG4aFxyoUWywcVC65mE0hUmb4VzMLdqRjXnsL2r9EC67mVKbgwLXst249Ul8fWHt6G/sq
	 h8XU+X0srhOvJGf4LjMzXrOjrkcFujS1pWQc2ZA0/liGZqXPrMz7rWgirPCxjC6woUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zq3rcvUt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B500C606A682
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 07:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zq3rcvUt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB11D1F000CF;
	Wed, 25 Nov 2026 07:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795592235;
	bh=+H+KrvpY7uR2GeDyeLgI/xAh9gM3sDh05mVsVvZq0WY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Zq3rcvUtuiaR8UWLxgtod1yLRbGVCKwLo76wO/BNjFiahK+9g8wMLetKr0jfGrIkF
	 27v5zUorTeDRHI8iriQ2opuHsbRE7ea0Ja6YlAD1ypevwMsfNpLpNGU2cvjvvtcK+/
	 2TPfQ6vKVuNKpUxwFRKiMLagg1PERp9YbvyIskvXgLrueBJu5C9rltMd06+PeDr95C
	 LVAC5HSAz6/4mTKyASJKveepYiEU+Kcareyh125J453grx0cdytr3TdNLKgEkGDfdW
	 MqmF3Oomkcdp6PNIUyfQWizWidP3QJC1SvYnG3CxBCtcjbADdLIlOQRfW+xD3Kez7k
	 5bgXObHNBWDgA==
Message-ID: <sashiko-outbox-232820@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9] ext4: bound xattr journal credits to transaction
 limit
Reply-To: sashiko-reviews@lists.linux.dev
To: arzuagapozosergio@gmail.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261125072006.32251-1-arzuagapozosergio@gmail.com>
References: <20261125070002.27868-1-arzuagapozosergio@gmail.com>
 <20261125072006.32251-1-arzuagapozosergio@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 07:37:14 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] selftests: ext4: missing KHDR_INCLUDES in Makefile
- [Low] ext4: changelog notes placed in commit message and missing Fixes
  tags
--

commit 3240428a7d5aa26a79642ee4a851967a647d2656
Author: Ryuji Hiroshi <arzuagapozosergio@gmail.com>

> ext4: bound xattr journal credits to transaction limit
>=20
> When setting an xattr without XATTR_CREATE, ext4 reserves credits for
> releasing an old ea_inode even when the attribute does not exist. On a
> 1 KiB-block filesystem with a minimum journal, this can request more
> credits than JBD2 permits, triggering a warning before the operation
> fails.
>=20
> Drop the obsolete credits for releasing an old ea_inode. Since
> ext4_put_ea_inode() defers the final iput to a worker, freeing the old
> value's blocks does not happen in the current transaction. Continue to
> count ea_inode references in the external xattr block for the case where
> it must be cloned, and check the estimate against the transaction limit
> after reserving the default JBD2 revoke credits. Repeat the estimate under
> the xattr write lock before modifying the attribute.
>=20
> When an identical xattr block is reused from the cache, drop the
> provisional ea_inode reference unless the block was modified in place.
> Handle both a different cached block and the original block being found
> after cloning. Bound the aggregate credits for inherited xattrs during
> inode creation against the JBD2 transaction limit before starting a
> handle. Add EXT4 selftests for these paths.
>=20
> Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
> Reported-by: syzbot+25d45c0bd716f2b794a7@syzkaller.appspotmail.com
> Link: https://syzbot.org/bug?extid=3D25d45c0bd716f2b794a7
> Assisted-by: Codex:GPT-6
> Signed-off-by: Ryuji Hiroshi <arzuagapozosergio@gmail.com>
>=20
> Changes in v9:
> - Skip the large default ACL test when the filesystem reports
>   EOPNOTSUPP, as happens when POSIX ACL support is disabled.
>=20
> Tests:
> - make -C tools/testing/selftests/filesystems/ext4 clean all
> - sh -n tools/testing/selftests/filesystems/ext4/ext4_xattr_journal_credi=
ts.sh
> - Booted the v8 kernel in QEMU/KVM with a 1 KiB-block, 128-byte-inode
>   ea_inode filesystem and 1 MiB journal; all 4 harness tests passed.
> - e2fsck -fn passed after the guest unmounted the filesystem.

[Severity: Low]
The "Changes in v9:" and "Tests:" sections sit above the "---" separator,
so git am will record them in the permanent commit history.

Also, in addition to dec214d00e0d ("ext4: xattr inode deduplication"),
this patch fixes the unbounded new-inode xattr credit calculation in
__ext4_new_inode() and the provisional ea_inode reference leak on cached
xattr block reuse in ext4_xattr_block_set().  Should it also include:

  Fixes: af65207c76ce ("ext4: fix __ext4_new_inode() journal credits calcul=
ation")
  Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")

[ ... ]

> diff --git a/tools/testing/selftests/filesystems/ext4/Makefile b/tools/te=
sting/selftests/filesystems/ext4/Makefile
> new file mode 100644
> index 0000000000000..90569a1ccef38
> --- /dev/null
> +++ b/tools/testing/selftests/filesystems/ext4/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +TEST_GEN_PROGS_EXTENDED :=3D ext4_xattr_journal_credits
> +TEST_PROGS :=3D ext4_xattr_journal_credits.sh
> +
> +include ../../lib.mk

[Severity: Low]
Should this Makefile add "CFLAGS +=3D $(KHDR_INCLUDES)"?
ext4_xattr_journal_credits.c includes <linux/posix_acl.h> and
<linux/posix_acl_xattr.h>, and lib.mk defines KHDR_INCLUDES without
adding it to CFLAGS automatically, so the build otherwise falls back to
the host's /usr/include.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125072006.3225=
1-1-arzuagapozosergio@gmail.com?part=3D1
