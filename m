Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793780786;
	b=k8tl/O7aQNU7zoU3qIPaxPXIMmKrpD46pjxyr280DuZUqMBXH61QCpjqHiRMqB9e5sic
	 fcDbGThJnBaa7ZC6Abg5BzIESMMUVLSQ7skCdBn+5wcmU+4VtiroeRR1QRFEOZICnEshI
	 NtqNDBDI9wrt+FW+cJfwB0C11Xl4fPt28e1qIA2SV/hDciwquo1+Le39UVap4XJNcBN+L
	 7UJI157s/hJdc4To5elNx6fm7UQcyza5R+/w55Dv8pLBhQdp8YoJ1EVMO+ZlAMi0LCTzG
	 g+1ndV8KLzihc+VuqcXpNx8AbsJpQPwLRp6qPS81vsscWYHtQGmQ2N+Qog1G9/KdbVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793780786;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RUh3LAf5cPpiQ5/3sOe7kSUo0VodGP3PWwMfmN37IX0=;
	b=h9QaffQGaVO+5bYtnqAspcc19fQrRStBRaWAjzN2D0jo0QZzwMU7IG44IqKwb68n70ao
	 82lzgNDfkm72MKwKcPLTAFNlDWfBki7u/Nw84X9ScYqg9x5PTth4t0hqw3kl7SUFXl2nJ
	 RS5Pn/W1X814IuOnzEz/wLswrb/JJnREcKFHt2I6xzCpk5smVhe2D7+HwjT/vSBuCFqcb
	 GgH41/ysNB5DCtiC0oiYhBJ13v0vKqSwxdbSIo7DPHnYbqJbuHLMjRlgweRoIlVhxTNvq
	 Y2AfjSeXtTVSLwccblCdE2NwHS4CxyOMhly0p1HRus4z0Ae5Fbg1UIJALVJ8oUw33Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSvqdmAi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6199C606A31B
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 08:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSvqdmAi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F541F00A1D;
	Wed,  4 Nov 2026 08:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793780785;
	bh=RUh3LAf5cPpiQ5/3sOe7kSUo0VodGP3PWwMfmN37IX0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fSvqdmAij3Jr933Dr4Rjc3V9a2o13SqnT9KHXMA5YbqgKHmyz2Ra4+OluTpRd7x0e
	 XGHoET2QfBkV11fKu39MoJ6V7QoJAM0UnXE19sIMliKy++JSPVPzonwZgdzZmuLaF0
	 jTlaZ/owlLijfC168xmiZd1UlkaSgUJCaYQGh6FUmDpiSXYzw82hbeGrTg6VdpNHLg
	 78u0IN29e0VFlBwO1j9gpOC62YIJ/qrm0T4aK+okIJQ9F1wh7+VYD4LujM07g0Saqu
	 rqh94nQUNpuNkyvAm02oCq+JpwAw2Lp+w0cAmANh0kJu1y3EpNVWB7hbcWrrGMIYy3
	 PK5Co/b/rFbtw==
Message-ID: <sashiko-outbox-196874@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix slab-use-after-free in do_split()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <tencent_76448BFB81B402CBBF3C529331EEA998FA06@qq.com>
References: <tencent_76448BFB81B402CBBF3C529331EEA998FA06@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 08:26:25 +0000
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
- [Medium] ext4: buffer_head reference leak in do_split() when bh2 aliases =
*bh
- [Medium] ext4: negative errno and logical block passed to ext4_error_inod=
e_block()
--

commit 03492d237958226b95dd674bad3a9c3663bcb8b7
Author: Shuai Liu <847807867@qq.com>

ext4: fix slab-use-after-free in do_split()

This commit adds a check in do_split() to verify that the newly allocated
directory block buffer_head (bh2) does not alias the block being split (*bh=
),
returning -EFSCORRUPTED if they match.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 231a274b814ec..bffd4c460842a 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1928,6 +1928,13 @@ static struct ext4_dir_entry_2 *do_split(handle_t =
*handle, struct inode *dir,
>  		*bh =3D NULL;
>  		return ERR_CAST(bh2);
>  	}
> +	if (bh2 =3D=3D *bh) {
> +		ext4_error_inode_block(dir, newblock, -EFSCORRUPTED,
> +				       "cannot split aliased directory block");

[Severity: Medium]
Should ext4_error_inode_block() take (*bh)->b_blocknr and a positive errno
(or 0, which save_error_info() normalizes to EFSCORRUPTED) instead of
newblock and -EFSCORRUPTED?

ext4_error_inode_block() passes error and block to __ext4_error_inode() ->
ext4_handle_error():

fs/ext4/super.c:ext4_handle_error() {
	...
	if (!continue_fs && !ext4_emergency_ro(sb) && journal)
		jbd2_journal_abort(journal, -error);

	if (!bdev_read_only(sb->s_bdev)) {
		save_error_info(sb, error, ino, block, func, line);
	...
}

When error is negative (-EFSCORRUPTED), jbd2_journal_abort(journal, -error)
receives a positive value instead of a negative errno, and
save_error_info() -> __save_error_info() -> ext4_errno_to_code() fails to
match -EFSCORRUPTED against the positive errno entries in err_translation[],
recording EXT4_ERR_UNKNOWN in the superblock.

In addition, the block parameter of ext4_error_inode_block() expects a
physical block number (ext4_fsblk_t) such as (*bh)->b_blocknr rather than t=
he
logical directory block offset newblock, matching the existing call later in
do_split():

	if (WARN_ON_ONCE(split =3D=3D 0)) {
		/* Should never happen, but avoid out-of-bounds access below */
		ext4_error_inode_block(dir, (*bh)->b_blocknr, 0,
			"bad indexed directory? hash=3D%08x:%08x count=3D%d move=3D%u",
			hinfo->hash, hinfo->minor_hash, count, move);
		err =3D -EFSCORRUPTED;
		goto out;
	}

> +		brelse(bh2);
> +		*bh =3D NULL;
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}

[Severity: Medium]
Does this path leak a buffer_head reference on *bh?

When do_split() is entered from ext4_dx_add_entry() or make_indexed_dir(),
the caller holds a reference on *bh. Inside do_split(), ext4_append() ->
ext4_bread() -> ext4_getblk() -> getblk_unmovable() looks up the buffer_head
for the newly allocated block and increments b_count. When bh2 =3D=3D *bh, =
the
same buffer_head now has two references held on it: one from *bh and one fr=
om
bh2.

Calling brelse(bh2) only drops one reference, and setting *bh =3D NULL prev=
ents
the caller's error cleanup (such as brelse(bh) at cleanup: in
ext4_dx_add_entry()) from dropping the original reference.

Could this jump to out: (or call brelse(*bh) as well) so that both referenc=
es
are released before *bh is cleared:

out:
	brelse(*bh);
	brelse(bh2);
	*bh =3D NULL;
	return ERR_PTR(err);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_76448BFB81B=
402CBBF3C529331EEA998FA06@qq.com?part=3D1
