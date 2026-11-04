Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793782939;
	b=2ESpNo82B6l2mDVF4LQEByovuTWJuSpVbxMLV55NsOqpgukTAhuZWhAbYgzpeiJ8LJoh
	 5ytBm8wII+4pdknrGwtWsqttuTlkEwK3Ekb77LuEB3x42TWLGcyOA4jhmsuhHr2QzN9Xv
	 6cDL8PN+D7y4pKDD3H0307NglzD+4shlgjb9qeN8c4q6XXgeE1oIsrhPpQDQJZSNi80rO
	 DiU6ps+sGWaJbungnHLaP8KnZyvod8xbv0jBPT4jCYemcXn+sP7r6xxS4j8/jP/MLGHOM
	 egL15SoLM8Nkb55Ae/piJ0H1XPhy8uRRp1WA9YoJNLT+Dra6PelMeHVSF4SLc5qctXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793782939;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=uYa95PvTTN1Dq5Idu3PjwIilX0EkL8MCdsIUf+/lNlA=;
	b=sXm1kTSITYv2+tlTLRLKAn+kEHVtmtJcHsRMDKXHR+bpd+cgdK9KaOUHXtTxomrPK6gJ
	 VlU2fwg2kgWmds6qOwnnYCgkzAC9fgW+uulQKghn8FZO7O5PzVZHTtD3YbN/tSkIujFcJ
	 wtwPrGagQsZl0HpvCf4UGlfstwlOPept8YtKHeE0ZAARqQCm3FpeVyYUXOMdL5zLi2OMc
	 Vutikjp2JJcTttlLiwaLA4N8jibw93u5yblZJ65wymgGix5gUC7DIOiAZNsxdAuZbz1ep
	 ub1SPwohDPJaWGhxF9xSrA/6Wj1uGicXbmzBCREH9zNvlYxIHTICMszmXpZz0nHe4dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nu3Pg+Es;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06EB606A326
	for <linux-ext4@vger.kernel.org>; Wed,  4 Nov 2026 09:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nu3Pg+Es
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C701F00919;
	Wed,  4 Nov 2026 09:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793782939;
	bh=uYa95PvTTN1Dq5Idu3PjwIilX0EkL8MCdsIUf+/lNlA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nu3Pg+Es8VmTqdE4Ua58MZXSLQA3iwUX/55tJ9ZWR2PzXEbQrBlhANTg2GIxrNjtG
	 7r6spU0kbzrb+foNIEsL+BT0U9tPGAO7N4GaorETUmJsQa/4nhdRMVmGa5dnG6soam
	 cN/v5TPKVqRlhIVBYxvgsLJx5r59wsCNgxxNdfXwEYwBdPEYrR005i5gaCxtsybEJl
	 lJf1yaHoWKvixQy3ru16XvbdrkkX/z1UvMDAy8csYzo3vzFOuJL2balt/5t32lt8AQ
	 RGu7WzTc9snmymSZRamZgGX4OZRm6UqLW5oQXGTJHnn7wd/B/kxjr0c3adzZaGeGQY
	 mvjOd8yCSckmg==
Message-ID: <sashiko-outbox-196913@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: fix slab-use-after-free in do_split()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <tencent_7AA5D3581EE4D99A947097C4F02730DCCF09@qq.com>
References: <sashiko-outbox-196874@kernel.org>
 <tencent_7AA5D3581EE4D99A947097C4F02730DCCF09@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 09:02:18 +0000
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
- [Critical] ext4: missing frame->bh aliasing check in do_split() causes OO=
B write
--

commit 030c053bcea32f45b1d61f119ec600fe4bd02c71
Author: Shuai Liu <847807867@qq.com>

ext4: fix slab-use-after-free in do_split()

This commit adds a check in do_split() to verify that the newly allocated
directory block buffer bh2 returned by ext4_append() does not alias the leaf
block *bh being split, returning -EFSCORRUPTED if they match.

> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 231a274b814ec..c0454a2594523 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1928,6 +1928,14 @@ static struct ext4_dir_entry_2 *do_split(handle_t =
*handle, struct inode *dir,
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

[Severity: Critical]
What happens if bh2 or *bh aliases frame->bh under the same inconsistent
block bitmap or block reuse condition?

In do_split(), frame->bh holds the htree index block and frame->entries
points into frame->bh->b_data. If ext4_append() returns bh2 =3D=3D frame->bh
while bh2 !=3D *bh, this check passes and data2 is set to bh2->b_data:

fs/ext4/namei.c:do_split() {
    ...
    data2 =3D bh2->b_data;
    ...
    de2 =3D dx_move_dirents(dir, data1, data2, map + split, count - split,
                          blocksize);
    ...
    dx_insert_block(frame, hash2 + continued, newblock);
}

dx_move_dirents() then copies directory entries into frame->bh->b_data,
overwriting the htree index header and frame->entries (or dx_pack_dirents()
overwrites it in data1 if *bh =3D=3D frame->bh).

When dx_insert_block() subsequently reads the corrupted count and limit from
frame->entries:

fs/ext4/namei.c:dx_insert_block() {
    ...
    int count =3D dx_get_count(entries);

    ASSERT(count < dx_get_limit(entries));
    ASSERT(old < entries + count);
    memmove(new + 1, new, (char *)(entries + count) - (char *)(new));
    ...
}

it can trigger BUG() via ASSERT() or perform an out-of-bounds memmove() past
bh2->b_data.

Furthermore, if frame is &frames[0], overwriting frames[0].bh->b_data
corrupts ((struct dx_root *)frames[0].bh->b_data)->info.indirect_levels with
directory entry bytes, causing dx_release() to read out of bounds past
frames[EXT4_HTREE_LEVEL] on the stack and call brelse() on arbitrary stack
values:

fs/ext4/namei.c:dx_release() {
    ...
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

Should do_split() also check whether bh2 =3D=3D frame->bh or *bh =3D=3D fra=
me->bh?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_7AA5D3581EE=
4D99A947097C4F02730DCCF09@qq.com?part=3D1
