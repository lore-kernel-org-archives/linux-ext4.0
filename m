Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795456411;
	b=df+Xd8mk+0VOIfHZg2e4b4xiCnzjds7Z9sO+kL+m+9guaLjne9TS2AjwtHwxKO6pBUUO
	 LY9DXC24KsKSXT1Gn4B14pcYCQZsiuMuKOlvaiU+WaiINGVe6Ecwpjz02ePtTxgMtPH0j
	 JCWuEckNWBfFKBnegOEiCoMfEaOy55SKgekKcsqKuXOcno5rCFqMEvMJ2WKPCcuBSvwir
	 HkwMQLIt4U5zVc83ogI38woot8kRNhkhBDNrQNRikxBd8I1J2AAwa4/4TowU0SOcYwcBq
	 eu7zGV8FPn+SR+XhWfOp5otxmMG4OX1QykXSCjv3uIrh/tawhDKrRHlpDwyCfw51rPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795456411;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GDFbMoFano89WASRUqVyUa0DJKFOPyM4pQrz3QLwMG8=;
	b=whuNdhtJC4JijbyC4lY5GSKOmsca8OW9yfSs7LZuuxnuyRjU1wSS/kORnge03AA1AJbp
	 29tp0QNPwWifh5fOCdh0h6r5uEqmM60LiBwgV6V1tz+BkCofqw2OL3K3p8eQWTBMXM3iM
	 VVgLixPGZUbLB5fx1bu/Hg2t+rccO8wHjN+lEG7iZvAYIV7kTBRP00yPW5u5UGzuZM1LK
	 bCecL/iqcXPf4EnCDW1bQwO+gDr7AwrGvUA6dYCs58hQ8VLn8zEUx2IRHvz0Bwu3Rmcxh
	 j7d66AT0sH7HbKKBQzT8GEX1g62+ocUrcBsmVa0liUGhZzqJx8Nd3GqFnsCYs0AEGkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISqYKmHq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66D6606A31A
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2026 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISqYKmHq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019171F000CF;
	Mon, 23 Nov 2026 17:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795456411;
	bh=GDFbMoFano89WASRUqVyUa0DJKFOPyM4pQrz3QLwMG8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ISqYKmHqRTcHnHwZ5o6VZbwWHHCNPgnANpTfks7x1UzNltDPOFhWdaRtcns+4cgvg
	 eNWnrfj2bHgq9h8w2BRqNRyfCMcXOezYTCNGZerd5d23R2cRJofS9NbU0T073L0A2p
	 V84TJgSm3kgQ1FT/S/Fm1l4+wUaMou1PBws4Z2rQrYSmzNS8gGchD0jKTI2eBmQXc7
	 SZl+HZ9IjQs7Yx5E6uUfxxehJ3R8133tR0t5hBp+FI95KOI6SsmVanPMKtVlD7uwtJ
	 WTInG8qLe7040lIh6MWEAYH83UhtLpFzNEoqMfkkPZA0xhlhU//b8NU6NYCihc0OuB
	 o5/3Ux9ajMypw==
Message-ID: <sashiko-outbox-229785@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: fix inline data conversion races when
 !EXT4_STATE_MAY_INLINE_DATA
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arbab Haider" <arbabhaider649@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261123172856.100887-2-arbabhaider649@gmail.com>
References: <20261123172856.100887-2-arbabhaider649@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 17:53:30 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] ext4: race with flag clearing and rollback in
  ext4_convert_inline_data()
--

commit d8d6562907c89295338f0cf9b804847e8da0f4c9
Author: Arbab Haider <arbabhaider649@gmail.com>

ext4: fix inline data conversion races when !EXT4_STATE_MAY_INLINE_DATA

This commit updates ext4_convert_inline_data() and
ext4_inline_data_truncate() to handle inodes whose inline data has already
entered delayed-allocation conversion (!EXT4_STATE_MAY_INLINE_DATA).

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482b..a740549611252 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c

[ ... ]

> @@ -1977,6 +2001,7 @@ int ext4_convert_inline_data(struct inode *inode)
>  	handle_t *handle;
>  	struct ext4_iloc iloc;
> =20
> +retry:
>  	if (!ext4_has_inline_data(inode)) {
>  		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
>  		return 0;
> @@ -1984,14 +2009,18 @@ int ext4_convert_inline_data(struct inode *inode)
>  		/*
>  		 * Inode has inline data but EXT4_STATE_MAY_INLINE_DATA is
>  		 * cleared. This means we are in the middle of moving of
> -		 * inline data to delay allocated block. Just force writeout
> -		 * here to finish conversion.
> +		 * inline data to delay allocated block. Force synchronous
> +		 * writeout here to finish conversion.
>  		 */
> -		error =3D filemap_flush(inode->i_mapping);
> +		error =3D filemap_write_and_wait(inode->i_mapping);
>  		if (error)
>  			return error;
>  		if (!ext4_has_inline_data(inode))
>  			return 0;
> +		error =3D ext4_emergency_state(inode->i_sb);
> +		if (error)
> +			return error;
> +		return -EIO;
>  	}

[Severity: High]
Can a concurrent ext4_convert_inline_data_nolock() rollback via
ext4_restore_inline_data() still trigger the BUG_ON() in
ext4_do_writepages() or cause ext4_convert_inline_data() to return a
spurious -EIO or premature 0?

When ext4_convert_inline_data_nolock() runs (for example from
ext4_page_mkwrite(), which does not hold i_rwsem),
ext4_destroy_inline_data_nolock() clears EXT4_INODE_INLINE_DATA and
EXT4_STATE_MAY_INLINE_DATA and drops i_data_sem before calling
ext4_map_blocks().  If ext4_map_blocks() fails (e.g. -ENOSPC),
ext4_restore_inline_data() restores EXT4_INODE_INLINE_DATA and
EXT4_STATE_MAY_INLINE_DATA:

CPU0                              CPU1
ext4_page_mkwrite()
  ext4_convert_inline_data()
    down_write(&xattr_sem)
    ext4_convert_inline_data_nolock()
      ext4_destroy_inline_data_nolock()
        clear EXT4_INODE_INLINE_DATA
        clear EXT4_STATE_MAY_INLINE_DATA
        up_write(&i_data_sem)
      ext4_map_blocks() -> fails
                                  ext4_da_write_begin()
                                    test EXT4_STATE_MAY_INLINE_DATA -> 0
                                    ext4_da_get_block_prep()
                                    dirty folio 0
      ext4_restore_inline_data()
        ext4_create_inline_data()
          set EXT4_INODE_INLINE_DATA
        set EXT4_STATE_MAY_INLINE_DATA
                                  ext4_do_writepages()
                                    BUG_ON(ext4_test_inode_state(inode,
                                        EXT4_STATE_MAY_INLINE_DATA))

In addition, because ext4_convert_inline_data() checks
ext4_has_inline_data(inode) and EXT4_STATE_MAY_INLINE_DATA before taking
xattr_sem, a second caller arriving while EXT4_INODE_INLINE_DATA is cleared
returns 0 before data_bh is initialized or inline data is restored.  If it
arrives in the window inside ext4_restore_inline_data() after
ext4_create_inline_data() sets EXT4_INODE_INLINE_DATA but before
EXT4_STATE_MAY_INLINE_DATA is re-set, filemap_write_and_wait() finds no
dirty pages and ext4_convert_inline_data() returns a spurious -EIO.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261123172856.1008=
87-2-arbabhaider649@gmail.com?part=3D1
