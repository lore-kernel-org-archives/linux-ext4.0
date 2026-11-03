Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714891;
	b=Kjf4ByK+CnZH+UkjEYMQ3k0ycpzgfFyVjdvFr51+BKj2tOc+BXpYAh2hBPZQ3DWnHa9U
	 wxKHiI0Y4Rm8q9wnvBRY1Jc4WCKBAf+zqt6Rp2eMarMM2PqHo77d1rac+W/y5oR/huVzl
	 8MKo+pvyK+5ibaWCT0vf3wbidhDGxBlixiZfwCEEMV5F7YisSIwjvNonTCKswh2qnhaPj
	 JpS4fkGLq8mtcN88NBPJsJyaM8DucwVqmZs7pn0AcZGzcCHmOlU0ARLLholWMP6H1UPzW
	 nfzWgRPY9DdusBaentL3Xp1pMaRcwp4TdPj+bAFclQ1em+Rf5/BtfxrDVrieQsV2xvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714891;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=OjEpqhX1gRZrv2InFRUbNhhFEExlUvThEw4U1mem+Ew=;
	b=Ff2pv7BEQ8Rd2F7huGekOtxjzdIfhJvDJw8ghkp3/TeuzhRQmzQSSXGStv6RXteBOecv
	 qKXGHZ4f7FLRjxk/c0taSN+5oia5a+XYhBZlBWhVreSfvc9Flhpz5ljxYCIGcsfE66m7o
	 HOECgIICA7fYx0dLXKYrUKBlQayJAsRBRDOZWzdFCOg+l2S0JUXrdo1lLvKBDylw3DQHm
	 sGpmBXLHVs6hTq+oxpxk2NCAfhd9IUWm6FvNFE+ijDIFuEdoycj2WcQeMBtivDGxny0Is
	 A78Fi0wxyzW9m/MKTSW18x2B0wHhiJF0AacCG2O+Svqsjm7mX5+73i2FvfMKEDt1M+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KoPfHlzK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F22A606A329
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 14:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KoPfHlzK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEC21F000C1;
	Tue,  3 Nov 2026 14:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714891;
	bh=OjEpqhX1gRZrv2InFRUbNhhFEExlUvThEw4U1mem+Ew=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KoPfHlzKpNMymbq1E28HUwQ9x/sg0IaZQNC6wi9m+LAiGWMgAcV26wfueIAClLMf5
	 8XNiftzbsJ7XNrp76cUwSANl1GjhJqkWYTxaP3xprm8KowJA38N+tW6YcQguQhgX+P
	 Axzo9OC1iwBDzp7xddZGKyuXpToXd/ycOXBwDdRhIWTLiUB9Igcrqh6kfDLJrN2zNd
	 fMmDHxvkUBmrl2JWoyodHEzGwPJDCNHibtB+njMFx2N8vt1wOaN8bmYPih9utEd5vV
	 JripV1Yu4HRbfRy4eSkS/L5amWUxtYv8fZz5wiLnEzE8otJA00U/ef09q1eZ/KfdzH
	 YDBUTdDPUjtmg==
Message-ID: <sashiko-outbox-195421@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 07/12] ext4: add ext4_dir_entry_len()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Artem Blagodarenko" <artem.blagodarenko@gmail.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261103134921.610047-8-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
 <20261103134921.610047-8-ablagodarenko@thelustrecollective.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 14:08:10 +0000
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
- [Medium] ext4: inconsistent dx_get_dx_info() offset in make_indexed_dir()
- [Low] ext4: commit message mismatch with dx_root_limit() and get_dtype()
--

commit e8626c9249ed17bdd04a7586fe5be141bfa96520
Author: Artem Blagodarenko <artem.blagodarenko@gmail.com>

ext4: add ext4_dir_entry_len()

This commit updates dx_root_limit() to calculate the root htree entry limit
using dx_get_dx_info() and masks filetype with EXT4_FT_MASK in get_dtype().

>     ext4: add ext4_dir_entry_len()
>    =20
>     ext4_dir_entry_len() (added in the previous patch, where
>     dx_get_dx_info() first needs it) computes the required rec_len for
>     a directory entry, taking into account dirdata and casefold+fscrypt
>     hash space.
>    =20
>     Update dx_root_limit() to use ext4_dir_entry_len() instead of
>     open-coded ext4_dir_rec_len() for '.' and '..' entries.
>    =20
>     Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
>     Assisted-by: Claude:claude-opus-5-5

[Severity: Low]
This isn't a bug, but does the commit title and message match the changes in
this patch?

As the commit message notes, ext4_dir_entry_len() was already added in the
previous commit (73068d5241d8, "ext4: refactor dx_root to support variable
dirent sizes").

In addition, dx_root_limit() is updated here to call dx_get_dx_info() rather
than ext4_dir_entry_len() directly, and the change to get_dtype() in
fs/ext4/ext4.h (masking filetype with EXT4_FT_MASK before comparing against
EXT4_FT_MAX) is not mentioned in the commit message.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index c221bcd562cc9..9953583ad6c3f 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -611,14 +611,21 @@ static inline void dx_set_limit(struct dx_entry *en=
tries, unsigned value)
>  	((struct dx_countlimit *) entries)->limit =3D cpu_to_le16(value);
>  }
> =20
> -static inline unsigned dx_root_limit(struct inode *dir, unsigned infosiz=
e)
> +static inline unsigned dx_root_limit(struct inode *dir,
> +	struct ext4_dir_entry_2 *dot_de)
>  {
> -	unsigned int entry_space =3D dir->i_sb->s_blocksize -
> -			ext4_dir_rec_len(1, NULL) -
> -			ext4_dir_rec_len(2, NULL) - infosize;
> +	struct dx_root_info *info;
> +	unsigned int entry_space, used;
> =20
> +	info =3D dx_get_dx_info(dir, dot_de);
> +	if (IS_ERR(info))
> +		return 0;
> +	used =3D (char *)info - (char *)dot_de + info->info_length;
>  	if (ext4_has_feature_metadata_csum(dir->i_sb))
> -		entry_space -=3D sizeof(struct dx_tail);
> +		used +=3D sizeof(struct dx_tail);
> +	if (used > dir->i_sb->s_blocksize)
> +		return 0;
> +	entry_space =3D dir->i_sb->s_blocksize - used;
>  	return entry_space / sizeof(struct dx_entry);
>  }

[ ... ]

> @@ -2372,10 +2382,10 @@ static int make_indexed_dir(handle_t *handle, str=
uct ext4_filename *fname,
>  		dx_info->hash_version =3D
>  				EXT4_SB(dir->i_sb)->s_def_hash_version;
> =20
> -	entries =3D (void *)dx_info + sizeof(*dx_info);
> +	entries =3D (void *)dx_info + dx_info->info_length;
>  	dx_set_block(entries, 1);
>  	dx_set_count(entries, 1);
> -	dx_set_limit(entries, dx_root_limit(dir, sizeof(*dx_info)));
> +	dx_set_limit(entries, dx_root_limit(dir, dot_de));

[Severity: Medium]
Can calling dx_root_limit(dir, dot_de) after dotdot_de->rec_len has been
expanded cause dx_get_dx_info() to resolve a different dx_root_info offset
than the initial call in make_indexed_dir()?

Earlier in make_indexed_dir(), dx_info is computed before modifying the
directory block, while dotdot_de->rec_len still holds its original unindexed
entry length (for example, 12 bytes):

	dx_info =3D dx_get_dx_info(dir, dot_de);

Inside dx_get_dx_info() -> ext4_dir_entry_len() -> ext4_dirent_get_data_len=
(),
if dotdot_de->file_type has upper dirdata flag bits set (such as on a craft=
ed
or corrupted image) and the dirdata length byte at offset 11 exceeds the
remaining space in the 12-byte entry, ext4_dirent_get_data_len() sees:

	if (ddh_len =3D=3D 0 || ddh_len > rec_len - offset)
		return 0;

and returns 0, placing dx_info right after the 12-byte '..' entry.

Then make_indexed_dir() wipes the block starting at de (leaving the bytes of
dotdot_de intact) and expands dotdot_de->rec_len to cover the rest of the
block:

	dotdot_de->rec_len =3D
		ext4_rec_len_to_disk(blocksize - le16_to_cpu(dot_de->rec_len),
				     blocksize);

When dx_root_limit(dir, dot_de) calls dx_get_dx_info(dir, dot_de) a second
time, rec_len is now blocksize - 12 (e.g. 4084). In ext4_dirent_get_data_le=
n(),
ddh_len > rec_len - offset is no longer true, so it returns a non-zero
dirdata length. That shifts the info pointer inside dx_root_limit() past the
dx_info structure that was just initialized (or causes dx_get_dx_info() to
return ERR_PTR(-EFSCORRUPTED)), writing a wrong or zero limit into entries.

Since both dx_probe() and make_indexed_dir() already have the validated
struct dx_root_info pointer, could dx_root_limit() take info (or its offset)
directly instead of calling dx_get_dx_info() again?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103134921.6100=
47-1-ablagodarenko@thelustrecollective.com?part=3D7
