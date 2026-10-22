Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792639070;
	b=OFI+fj3iApU0UpINfXUjm2Fi12F2LY4aWcUcRx6lfVh2knpmkjM+eAlxGK3PkwTHEPwb
	 OIzeFJ6eETIRWXJ0gKoVWghHfCbGXHlnQkTP+IQB4KzDayFtW+ko4obhcBPyp1/ZXPkEB
	 k4lWjpR8hhNQAh3lYqS7wq0ebd4mSHLANmpAFFXVSQ1U5LkmABwKsnZd9Q5P9LzXloe/G
	 YzBH6HAzUAkUEgrinjxPR14YlGwuGcEVmyoc+wjiWgU/zvyDZ39/SJIC3babnGJ98VYYo
	 Iy2B/cw+iH9qfsdB6LwgiijfbtPPAfXONCXaJMjlNS2OutVOnso+0k/JsICb6E7J7yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792639070;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=spGJkPypkr2vPNm7e7LUXvNPw2wtNFh/R52riYLespc=;
	b=CwgwheroKm/M3Dv42e/P5VqRxFKSPs84PD5fuOVtlyDEED7MbcAeOkOkop8zjCqiAHHq
	 AJcoP+SMUdLQKod4aEUUke9aUgUOht0zPNkSCOJYOJyGzt+a6mAuaf5LHYGoaig18Qltm
	 eyNbpZbsvDZoT9sBpM6m9iAZO/hdL+EmV+wsWavDi6QBaGoEdhJyHb4aT6LRBSTY+uVsk
	 hBzj6qB9ZSPYFRghG4mE1fz9lhAjH/j6s9qaMCUSvS8yCgLWQxIVQz5rQ1o03ksxX6cCW
	 7GkoJ8d60DeIPPQTupTYym6JJtq1JUl3RVXhhdeS2jk+w0dEqwA0L2QP54mNPe3Vz+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k4RtLEY0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E4E60A5BE7;
	Thu, 22 Oct 2026 03:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k4RtLEY0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990261F000C6;
	Thu, 22 Oct 2026 03:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792639070;
	bh=spGJkPypkr2vPNm7e7LUXvNPw2wtNFh/R52riYLespc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k4RtLEY09u1+buu1L4UjX6VaFTBBiqjQfsQP0PfqyDGYFg8I4T7sg3P7fwmAPprBT
	 MiInYEA3xl/poBdsCkTdWid7FAH6Tw1QFbjY9QxJFmaix27c5kHSV+JdoUwGJXme84
	 98g3HEoPMU50iKZ7u4G5+sQV73O9R8Aw/xMJ61ggKdKqVwvnNTvpssnyzwpQlw4IkT
	 pY1wddNT+mU95HSJOPRhLoCe7ToWUrjDk4z7PmYpMblFdRrtEBQ2v/87TXNAyAs8eG
	 LfaWYCVhrnarr/oxhj9g2xy6UcOeeHnWlJriCb6AobuYyz8WzUExMApn7Xl/XjkN67
	 LN2mCIPjoVg9g==
Message-ID: <sashiko-outbox-180925@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 24/41] shmem, ramfs: allow UUID and GUID owners
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Koester" <jan.koester@tuxist.de>, "Christian Brauner" <brauner@kernel.org>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Jan Kara" <jack@suse.cz>, =?utf-8?b?VGhlb2RvcmUgWS4gVHMnbw==?= <tytso@mit.edu>, "Paul
 Moore" <paul@paul-moore.com>, "Arnd Bergmann" <arnd@arndb.de>, linux-security-module@vger.kernel.org, linux-ext4@vger.kernel.org, audit@vger.kernel.org, keyrings@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>
In-Reply-To: <262bea3af5bc330d6ffa07fa1c6feb76a1a52609.1792552161.git.jan.koester@tuxist.de>
References: <cover.1792552161.git.jan.koester@tuxist.de>
 <262bea3af5bc330d6ffa07fa1c6feb76a1a52609.1792552161.git.jan.koester@tuxist.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 03:17:49 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] mm: shmem_fill_super() omits SB_I_UID_R when CONFIG_TMPFS is dis=
abled
- [Medium] mm: shmem: broken tmpfs quota accounting and transfer with SB_I_=
UID_R
--

commit a299bb3c86efdb02b056108e4776b749d61cb7ed
Author: Jan Koester <jan.koester@tuxist.de>

shmem, ramfs: allow UUID and GUID owners

This commit sets SB_I_UID_R on ramfs and shmem superblocks so that inodes on
these in-memory filesystems can be owned by UUID and GUID values.

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 848316eaa7f4f..b54775e0c3102 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4988,6 +4988,8 @@ static int shmem_fill_super(struct super_block *sb,=
 struct fs_context *fc)
>  	}
>  	sb->s_export_op =3D &shmem_export_ops;
>  	sb->s_flags |=3D SB_NOSEC;
> +	/* owners live in the inode only: UUIDs and GUIDs need no format */
> +	sb->s_iflags |=3D SB_I_UID_R;

[Severity: Medium]
Should SB_I_UID_R be set outside the #ifdef CONFIG_TMPFS block in
mm/shmem.c:shmem_fill_super()?

In shmem_fill_super(), this assignment is placed inside the
#ifdef CONFIG_TMPFS branch:

	sb->s_export_op =3D &shmem_export_ops;
	sb->s_flags |=3D SB_NOSEC;
	/* owners live in the inode only: UUIDs and GUIDs need no format */
	sb->s_iflags |=3D SB_I_UID_R;
...
#else
	sb->s_flags |=3D SB_NOUSER;
#endif /* CONFIG_TMPFS */
	sb->s_d_flags |=3D DCACHE_DONTCACHE;

When CONFIG_SHMEM=3Dy and CONFIG_TMPFS=3Dn, shmem_init() mounts shm_mnt via
kern_mount(&shmem_fs_type) -> shmem_fill_super(), taking the #else branch
without setting SB_I_UID_R. Inodes allocated on shm_mnt via
shmem_get_inode() (such as memfd_create() files) still use
shmem_inode_operations with .setattr =3D shmem_setattr. Calling fchown_r() =
or
fchownat_r() with a UUID or GUID on those file descriptors will then fail
with -EOVERFLOW in fs/attr.c:notify_change():

	if (ia_valid & ATTR_UID &&
	    !sb_can_own_kuid(inode->i_sb, vfsuid_into_kuid(attr->ia_vfsuid)))
		return -EOVERFLOW;
	if (ia_valid & ATTR_GID &&
	    !sb_can_own_kgid(inode->i_sb, vfsgid_into_kgid(attr->ia_vfsgid)))
		return -EOVERFLOW;

[Severity: Medium]
How does setting SB_I_UID_R interact with tmpfs quotas when
CONFIG_TMPFS_QUOTA is enabled?

The commit message notes that quotas of tmpfs do not account such owners,
because dqget() returns -ESRCH for UUID and GUID owners or groups. However,
allowing UUID and GUID ownership on a quota-enabled tmpfs mount appears to
cause three issues in the quota paths:

1. In mm/shmem.c:shmem_get_inode(), dquot_initialize(inode) leaves
SHMEM_I(inode)->i_dquot[cnt] as NULL when dqget() returns -ESRCH, allowing
UUID/GUID users and groups to bypass default tmpfs mount hard limits
(usrquota_block_hardlimit, usrquota_inode_hardlimit,
grpquota_block_hardlimit, and grpquota_inode_hardlimit).

2. When an existing inode owned by a classic UID/GID A is chowned via
chown_r() or fchown_r() to a UUID/GUID U, mm/shmem.c:shmem_setattr() calls
dquot_transfer() before setattr_copy():

	if (i_uid_needs_update(idmap, attr, inode) ||
	    i_gid_needs_update(idmap, attr, inode)) {
		error =3D dquot_transfer(idmap, inode, attr);
		if (error)
			return error;
	}

	setattr_copy(idmap, inode, attr);

In fs/quota/dquot.c:dquot_transfer(), dqget() returns -ESRCH for U and sets
transfer_to[cnt] =3D NULL:

		dquot =3D dqget(sb, make_kqid_uid(kuid));
		if (IS_ERR(dquot)) {
			if (PTR_ERR(dquot) !=3D -ESRCH) {
				ret =3D PTR_ERR(dquot);
				goto out_put;
			}
			dquot =3D NULL;
		}
		transfer_to[USRQUOTA] =3D dquot;

Then fs/quota/dquot.c:__dquot_transfer() treats a NULL transfer_to[cnt] as
no UID/GID change and skips detaching the old dquot:

	for (cnt =3D 0; cnt < MAXQUOTAS; cnt++) {
		/*
		 * Skip changes for same uid or gid or for turned off quota-type.
		 */
		if (!transfer_to[cnt])
			continue;

As a result, inode->i_uid or inode->i_gid is updated to U, but
SHMEM_I(inode)->i_dquot[cnt] remains attached to classic owner A's dquot, so
subsequent block allocations via shmem_inode_acct_blocks() ->
dquot_alloc_block_nodirty() continue charging A's quota.

3. If that inode is later chowned back from UUID/GUID U to the original
classic UID/GID A, i_uid_needs_update() or i_gid_needs_update() is true, so
dquot_transfer() sets transfer_to[cnt] =3D dquot(A) while transfer_from[cnt=
] is
still dquot(A). Because __dquot_transfer() does not check for
transfer_to[cnt] =3D=3D transfer_from[cnt], it calls dquot_add_inodes() and
dquot_add_space() on dquot(A) before subtracting from transfer_from[cnt],
temporarily double-charging dquot(A) for the file's usage and failing with
-EDQUOT if A's hard limit cannot fit twice the file's usage.

> =20
>  #if IS_ENABLED(CONFIG_UNICODE)
>  	if (!ctx->encoding && ctx->strict_encoding) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792552161.gi=
t.jan.koester@tuxist.de?part=3D24
