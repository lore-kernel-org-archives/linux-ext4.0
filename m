Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793786599;
	b=NkmFeYY1CdlSkt3D2MHBiA/Q5sTOlxQybiViFDd1PjtLn+Z37J8YQC85nkQuC28M1/nt
	 aFSumV7/Us3AGbs5BIbsZeASlxwueJHaDfjk/DgAHMkCSFDQmazrECRQLwJf8g0BxfpDw
	 L9mm4fRQrmmnt4e8+4CnQVpU/cSCukEYipO2KOvBtK0oVwqRj2mkH5hwWUkl8FJtZPsVE
	 c0zSS/x1qfFVFoH4lrvMeWcvcLqmUTWit72Pq4AfXj4Gh0Zs8ppzyjhdpNuzAnx4VeIpY
	 IZWD1ysdbYnlhfm+wWQzeUhwfG1y+M18z3kLeNi6gA4garxDV8V2qY0vAcIjp7RZYvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786599;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OTbgdTCSyrzSjV4Sb7Cs7n24G031U7SPKuyXoaJQ4fE=;
	b=JfwgX4HvOEZT+DszklECpxAvUZMwjchOA33Vy+XbztuKa1U+R5CJFhKCT+LSjQn9Jcpg
	 XwpEN/Orrw3VvcQ+znE4jI/Ew3CpNS/LSzY3zcbtc1RVWDxg8TdeikRKvy4vHod8EWMCM
	 NnLyWlvxetEuo4rJRslA6Z39nL2zd2Z4BVK6+BGFZ0XjLCWW30Vf6ia0zzvr3o/R8dUiQ
	 yrdBpaf7De/jrKY+1SJ3HvCDL52h3+iufkanWOx9S3Np+epzOgtb8Tw0a8UyqeuXi/8Rw
	 dvaFf4r8Pvaa88/+/+rXB9d8wieNY8d/o8/1Lxy40us4cvVGuzbNFcjxBboUh5qrwdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RbG8RjOf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1C3606A333
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 10:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RbG8RjOf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18DC1F00A15;
	Wed,  4 Nov 2026 10:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786599;
	bh=OTbgdTCSyrzSjV4Sb7Cs7n24G031U7SPKuyXoaJQ4fE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RbG8RjOfxXWghwN5t+n8lJ8AeLQENffxp0itP/bPkWTrcLc0bJWSwzFJu7BE7T/Mo
	 pehnmG02Ik2OXjkhsXkilDMB8DU01gs87NFixD0iLiv1PwjsEDOPuLeuQ9O+kJmsri
	 2q5waxsuW8GU3RXm7dVoHwgTlVEpTKoJ7ibq/pKdJ+/NA6Y9+B+UJMLwNnfjb4Qxp8
	 0K/oX9D/fpLswXCL050cM21LNuudfmNu9841nLWqKAlbN/g4p3E/qBl2yicPPVQT51
	 3wrfd1N0cXA7kh6KHBxz2aQTtZiPpWMezE340M16R+ezR4GrgfBcI19F1/xsPY7EkT
	 FCvra/iQV3LDg==
Message-ID: <sashiko-outbox-197027@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] ext4: fix slab-use-after-free in do_split()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <tencent_540C64A2D2BD5D3A8FC54C9EB80917F75305@qq.com>
References: <sashiko-outbox-196970@kernel.org>
 <tencent_540C64A2D2BD5D3A8FC54C9EB80917F75305@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 10:03:18 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ext4: do_split() misses aliasing checks against ancestor htree ind=
ex frames
--

commit 8ed2c45a835d613a6749d7f4f50dcf613d01b442
Author: Shuai Liu <847807867@qq.com>

ext4: fix slab-use-after-free in do_split()

This commit adds aliasing checks in do_split() to prevent splitting a
directory leaf block onto itself or onto an htree index block when the block
bitmap is inconsistent with the directory tree.

>     ext4: fix slab-use-after-free in do_split()
>    =20
>     do_split() allocates a new directory block with ext4_append() to hold
>     the second half of the entries of the leaf block being split, then
>     dx_move_dirents() copies entries from the old block (*bh) into the new
>     one (bh2).  Nothing verifies that the newly allocated block differs
>     from the block being split.
>    =20
>     On a filesystem whose block bitmap is inconsistent with the directory
>     tree, a block already referenced as a directory leaf or as an htree
>     index block can still be marked free, so ext4_append() can return that
>     same block.  With concurrent operations on such a filesystem (as
>     exercised by the syzbot reproducer), the block can even be freed
>     between allocations, resulting in bh2 aliasing *bh.  dx_move_dirents()
>     then copies the block onto itself, corrupting directory entries
>     mid-copy: a rec_len field can be overwritten with name bytes, so the
>     subsequent wipe of the stale entry memset()s a bogus length, causing
>     the slab-use-after-free reported by syzbot.
>    =20
>     The same aliasing applies to the htree index blocks: if the leaf block
>     or the new block aliases any index frame (the parent index block
>     frame->bh or one of its ancestors in the frames[] array),
>     dx_move_dirents() and dx_pack_dirents() overwrite the index header,
>     dx_insert_block() then memmove()s with a corrupted count and writes
>     out of bounds, and dx_release() can loop past the frames[] array (or
>     leak frames) with a corrupted indirect_levels.
>    =20
>     Fix this by checking for all of these aliases in do_split() and
>     bailing out with -EFSCORRUPTED before any directory block contents are
>     modified, reporting the corruption via ext4_error_inode_block().
>    =20
>     Reported-by: syzbot+09bec78ee77613a3efdd@syzkaller.appspotmail.com
>     Closes: https://syzkaller.appspot.com/bug?extid=3D09bec78ee77613a3efdd
>     Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Shuai Liu <847807867@qq.com>
>     Changes in v4:
>       - Extend the aliasing checks to all htree index frames: do_split()
>         now takes the frames[] array and compares *bh and bh2 against
>         frames[0..level], not just the parent frame.  An alias with an
>         ancestor index block would overwrite its header, letting
>         dx_insert_block() memmove() out of bounds and dx_release() loop
>         past the frames[] array or leak frames (Sashiko)
>       - Mention the index block aliasing checks in the commit message
>         (Sashiko)
>=20
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 231a274b814ec..0789c9dc31b80 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1922,12 +1922,36 @@ static struct ext4_dir_entry_2 *do_split(handle_t=
 *handle, struct inode *dir,
>  	if (ext4_has_feature_metadata_csum(dir->i_sb))
>  		csum_size =3D sizeof(struct ext4_dir_entry_tail);
> =20
> +	if (*bh =3D=3D frame->bh) {
> +		ext4_error_inode_block(dir, (*bh)->b_blocknr, EFSCORRUPTED,
> +				       "leaf block aliased with index block");
> +		brelse(*bh);
> +		*bh =3D NULL;
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}
> +
>  	bh2 =3D ext4_append(handle, dir, &newblock);
>  	if (IS_ERR(bh2)) {
>  		brelse(*bh);
>  		*bh =3D NULL;
>  		return ERR_CAST(bh2);
>  	}
> +	if (bh2 =3D=3D *bh) {
> +		ext4_error_inode_block(dir, (*bh)->b_blocknr, EFSCORRUPTED,
> +				       "cannot split aliased directory block");
> +		brelse(bh2);
> +		brelse(*bh);
> +		*bh =3D NULL;
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}
> +	if (bh2 =3D=3D frame->bh) {
> +		ext4_error_inode_block(dir, bh2->b_blocknr, EFSCORRUPTED,
> +				       "leaf block aliased with index block");
> +		brelse(bh2);
> +		brelse(*bh);
> +		*bh =3D NULL;
> +		return ERR_PTR(-EFSCORRUPTED);
> +	}

[Severity: High]
As reported by Sashiko on v3 [1], what happens in a multi-level htree
directory (when root->info.indirect_levels >=3D 1) if *bh or bh2 aliases an
ancestor index block in frames[0..indirect-1].bh rather than the deepest
index block in frame->bh?

Although the commit message and the embedded "Changes in v4" changelog state
that do_split() now takes the frames[] array and compares *bh and bh2 again=
st
frames[0..level], the code in fs/ext4/namei.c was not updated to match:

fs/ext4/namei.c:ext4_dx_add_entry() {
    ...
    frame =3D dx_probe(fname, dir, NULL, frames);
    ...
    de =3D do_split(handle, dir, &bh, frame, &fname->hinfo);
    ...
    dx_release(frames);
}

Because ext4_dx_add_entry() still passes only frame (&frames[indirect]) and
do_split() only compares *bh =3D=3D frame->bh and bh2 =3D=3D frame->bh, any=
 alias
between *bh or bh2 and frames[0].bh (or frames[1].bh when indirect =3D=3D 2=
) goes
undetected.

When frames[0].bh is overwritten with directory entries by dx_move_dirents()
and dx_pack_dirents(), ((struct dx_root *)frames[0].bh->b_data)->info is
corrupted before ext4_dx_add_entry() calls dx_release(frames):

fs/ext4/namei.c:dx_release() {
	if (frames[0].bh =3D=3D NULL)
		return;

	info =3D &((struct dx_root *)frames[0].bh->b_data)->info;
	/* save local copy, "info" may be freed after brelse() */
	indirect_levels =3D info->indirect_levels;
	for (i =3D 0; i <=3D indirect_levels; i++) {
		if (frames[i].bh =3D=3D NULL)
			break;
		brelse(frames[i].bh);
		frames[i].bh =3D NULL;
	}
}

Can this corrupt info->indirect_levels so that dx_release() either stops
early and leaks the buffer_head references in frames[1..indirect].bh, or (w=
hen
all three entries in frames[EXT4_HTREE_LEVEL] are populated) reads past the
end of the stack-allocated frames[] array and passes stack garbage to
brelse()?

Also, should the "Changes in v4:" block be moved below the "---" separator =
so
it is not included in the commit message body?

[1] https://lore.kernel.org/r/tencent_8E52FEA6C91DD754CC6282C41D4DFA95E505@=
qq.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_540C64A2D2B=
D5D3A8FC54C9EB80917F75305@qq.com?part=3D1
