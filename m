Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76805279907
	for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2026 04:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787803241; cv=none; b=gfHr+nTO5QqCkI3PCvAkuq1EX1eIfW897yKdLB0JdPvN+hitNeulqSBvzyNH/CB6w+oiB6lP3wqWxgfGQnaX6UbjcQdz6K9HaaVaHfiduJ5IuUUvtE3MTuxuW1MX4UBz/rlDAcOfRS9l06AUpuDXB7Cs7rR/glYzH/wD8Kt0VTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787803241; c=relaxed/simple;
	bh=aqphUDtK3Mgww0+N7OqoJ0WSMDQ+rjBbJGmfd3cu04E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dn36MibWvpy0FKdJX/41MDrf76LQBm3ED8W31mCaafrd2BVghBq6l4wtZ7vBTG5qVOfL/NdHdZaDHbvISAGIN5QJ+C9gcza0Fe3TQpD7tMzUpHdoOh6hQu+gEpfu0tNfqHvk2p4/u6gNu9EzQDxpZgK7S1NDoRDKoZHJeqZy4m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IKTV/6D4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IKTV/6D4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60C81F000E9;
	Thu, 27 Aug 2026 04:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787803240;
	bh=dZ3rDC6v08GN2eK9OZHID4DQ/dmhFq3PQOG3ONYXu/Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IKTV/6D4TnSixdSxs5YONFEUF3HB9b98BtHvvOUhGBJgaYWOuD8FFH7aTchxHUPj7
	 le/Mu8yGYbFo1Rt29HRct344ZcA3Ss2bns5EZfGBGBB+x57D53CydnCwo57VPVgHXz
	 r6wYXxDd2tOb/vqqc/m1JjPvSdYiomeMqRpGhHilW0hCBZo3SayjetYnQDAZTU6LfC
	 9mGp3vfX//r3VZkZW8WZwUiM3ldMGt1IBwx+8dVESv83O9ga8LjCR6dTYBUi5rz14b
	 TkxdoBWAO1cEbRP4Jmb1pi8VKNL+0Xh7N/G+aKxtyynf+UWEdXOO2nn2Jt85URdaw+
	 F62fTVSs5pIrw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5.10] ext4: don't enable DAX on new encrypted files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260827034018.136340-1-ebiggers@kernel.org>
References: <20260827034018.136340-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 04:00:39 +0000
Message-Id: <20260827040039.D60C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Ineffective assertion / Dead code. The `WARN_ON_ONCE` check for =
`EXT4_STATE_MAY_INLINE_DATA` in `ext4_set_context()` is logically unreachab=
le because the flag is unconditionally cleared by `ext4_convert_inline_data=
()` just prior to the check.
--

commit 5589d62f76f800192f6a44a1efbb08cf6ce9550c
Author: Eric Biggers <ebiggers@kernel.org>
Subject: ext4: don't enable DAX on new encrypted files

This commit simplifies new encrypted inode creation by setting
EXT4_INODE_ENCRYPT earlier, ensuring S_DAX isn't mistakenly enabled and
then disabled, which broke via a prior commit.

Closes: https://lore.kernel.org/r/20260723085648.1500357-1-ojaswin@linux.ib=
m.com
Link: https://patch.msgid.link/20260730175212.36923-1-ebiggers@kernel.org

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index c698dd5816c3a..c1538e61022cb 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c

[ ... ]

> @@ -1513,21 +1519,18 @@ static int ext4_set_context(struct inode *inode, =
const void *ctx, size_t len,
>  	 */
> =20
>  	if (handle) {
> -		res =3D ext4_xattr_set_handle(handle, inode,
> -					    EXT4_XATTR_INDEX_ENCRYPTION,
> -					    EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
> -					    ctx, len, 0);
> -		if (!res) {
> -			ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
> -			ext4_clear_inode_state(inode,
> -					EXT4_STATE_MAY_INLINE_DATA);
> -			/*
> -			 * Update inode->i_flags - S_ENCRYPTED will be enabled,
> -			 * S_DAX may be disabled
> -			 */
> -			ext4_set_inode_flags(inode, false);
> -		}
> -		return res;
> +		/*
> +		 * __ext4_new_inode() should have already set the encrypt flag
> +		 * on the inode and avoided enabling inline data.
> +		 */
> +		if (WARN_ON_ONCE(!IS_ENCRYPTED(inode)))
> +			return -EINVAL;
> +		if (WARN_ON_ONCE(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DA=
TA)))
> +			return -EINVAL;

[Severity: Medium]
Is this assertion logically unreachable?

Looking at ext4_set_context(), it calls ext4_convert_inline_data(inode)
prior to evaluating this assertion:

ext4_set_context(...) {
    ...
    res =3D ext4_convert_inline_data(inode);
    if (res)
        return res;

    if (handle) {
        ...
        if (WARN_ON_ONCE(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE=
_DATA)))
            return -EINVAL;

For newly created inodes, EXT4_INODE_INLINE_DATA is not yet set. This causes
ext4_convert_inline_data() to execute ext4_clear_inode_state(inode,
EXT4_STATE_MAY_INLINE_DATA) and return 0.

Since any new encrypted inode will execute this path, the state flag is
guaranteed to be cleared before the WARN_ON_ONCE evaluation. Will this rend=
er
the assertion completely ineffective?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827034018.1363=
40-1-ebiggers@kernel.org?part=3D1
