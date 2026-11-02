Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793645044;
	b=CLxGh+WL3rWcmF3y6XqZIi+9vxmXx9pEaPobqgqFapdO+BAacM5VluN76iq+Zlp9hBi6
	 5la4z5WRNuNW3PTtyiTpUN37Z7fAWmXjcuoLLF1aoujtV5gdqyJ+3FQ3l4wjnwnH6c/Ga
	 1sPghCN1ZvG7adT3WAtAL5m9K8rs6C9UF1vuzE5H/w+gup9zr9PzLV5FEGcmOH5pPEpA0
	 0fDRPKcwgdRnO5YOfyyq6j7wsokXtlFlhZS5a0/pZxtz5C6IjInwxly6stBeMgKiMke/P
	 tPIcmIEcdvCqztya+Xl8PmatNymnE3Gm/9Yk8liE5kCnHc5WCQyyvCx0NCq2N6fVoIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793645044;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RYQUKgJCnYkIZEPgSSID5jYdikrxKb3xpNXC/+exDng=;
	b=sYcpMOqjMRGQLo9HRCwwLlUXJWEoH/sVGz/6lRArcrkc7h2DUHMuud4MXCRR1fXUojXq
	 Yq/sPTz6LlAIhIXIhejH+VVwVUAgaZ9KNMoENhuoAdw6PzEZLNaxQzJlnRDGRV9IA17xF
	 ULj9ZEHArIyrRAmgWaYUIQcztPD9NztqFlVzurp75S9ctXG6XFx3E1h2GENUAjvoNCI2p
	 CnKrZH9IJDTSEgnmCYJ7QKTzh3JwY8gDzB55QTLxvzMD1+RBGXiuzRx7X9qSGrUXJ8Ktw
	 BUt7y0fPQl6rzL9wawDZ7zXdjV+RqZH6i2uqJi+i4O3KuTv5IByT408doco0Xz812nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kOCCKuB3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78078606A324
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 18:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kOCCKuB3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECEB1F00A16;
	Mon,  2 Nov 2026 18:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793645044;
	bh=RYQUKgJCnYkIZEPgSSID5jYdikrxKb3xpNXC/+exDng=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kOCCKuB3WUbDbeXrCL7y7TkdqjJ8Ud1aLuflGMc0Twi6Rx3qkKDXQ44YGHOzbKkg3
	 X47Ln68DaAvo14iHK9mpgYGq0rKmCzLH00IYsXlcpxnTqz+QtISf5tGF4NAPQ1LPEK
	 DaAYhfISDeBNRatzWvxOqVmSQvQTOdB+g+1xJ3w0riKXI/VlX2+DmCF0KBFS3YiMQG
	 mfaPPpIg+8VUGHYhaH4QfrahR/P+tMZlgyMA0/Aioc95y0HBaZZOjgtr19y8xkAaAT
	 oJnYafq11Oyae4mmtaOr1yeAWkSeqMPUk96/JImUCqYsquo+y2xoMDfmmaLeSzHpvM
	 wxBJF2t4FOIiA==
Message-ID: <sashiko-outbox-193961@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/8] ext4: fix endio zeroout corruption by tracking
 unwritten to-be-converted IOs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261102-ext4-endio-zero-bug-v1-2-266d2bb9e6dc@linux.ibm.com>
References: <20261102-ext4-endio-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com>
 <20261102-ext4-endio-zero-bug-v1-2-266d2bb9e6dc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 18:44:03 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] ext4: ext4_conv_pending_sub() takes i_conv_pending_sem on decrem=
ent
- [Medium] ext4: unnecessary zeroout write lock in ext4_ext_convert_to_init=
ialized()
- [Medium] ext4: unnecessary conv_pending lock in ext4_split_extent_zeroout=
()
--

commit 93e49ed931682b3fa02d1b8dadca8a78a2dd31b3
Author: Ojaswin Mujoo <ojaswin@linux.ibm.com>

ext4: fix endio zeroout corruption by tracking unwritten to-be-converted IOs

This commit introduces ei->i_conv_pending_ios and ei->i_conv_pending_sem to
track in-flight IOs pending unwritten-to-written extent conversion so that
extent zeroout paths can avoid zeroing out blocks with pending IO data.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index a229983f91dd8..d255884cf0750 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c

[ ... ]

> @@ -3328,6 +3362,9 @@ static int ext4_split_extent_zeroout(handle_t *hand=
le, struct inode *inode,
>  	ee_len =3D ext4_ext_get_actual_len(ex);
>  	is_unwrit =3D ext4_ext_is_unwritten(ex);
> =20
> +	if (!ext4_conv_pending_zeroout_lock(inode, flags))
> +		return -EINVAL;
> +
>  	if (flags & EXT4_GET_BLOCKS_CONVERT) {

[Severity: Medium]
Should ext4_conv_pending_zeroout_lock() only be acquired for the
EXT4_GET_BLOCKS_CONVERT branch in ext4_split_extent_zeroout() rather than
unconditionally at function entry?

When FALLOC_FL_ZERO_RANGE splits an initialized extent via:

  ext4_fallocate()
    -> ext4_zero_range()
      -> ext4_alloc_file_blocks()
        -> ext4_map_blocks()
          -> ext4_ext_map_blocks()
            -> convert_initialized_extent()
              -> ext4_split_convert_extents()
                -> ext4_split_extent()
                  -> ext4_split_extent_zeroout()

it enters the EXT4_GET_BLOCKS_CONVERT_UNWRITTEN branch:

	} else if (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN) {
		if (is_unwrit) {
			/* Shouldn't happen. Just exit */
			err =3D -EINVAL;
			goto out_unlock;
		}

		lblk =3D map->m_lblk;
		len =3D map->m_len;
		pblk =3D ext4_ext_pblock(ex) + (map->m_lblk - ee_block);
		err =3D ext4_issue_zeroout(inode, lblk, pblk, len);

That branch only operates on an already-initialized (!is_unwrit) extent and
only zeroes the requested range [map->m_lblk, map->m_lblk + map->m_len),
where ext4_fallocate() and ext4_zero_range() have already waited for DIO and
truncated the page cache for that range.

Acquiring ext4_conv_pending_zeroout_lock() unconditionally holds
i_conv_pending_sem exclusively across ext4_issue_zeroout() on a written
extent and causes the zeroout fallback to fail with -EINVAL whenever
unrelated unwritten writeback IOs are in flight elsewhere on the inode.

[ ... ]

> @@ -3743,7 +3795,8 @@ ext4_ext_convert_to_initialized(handle_t *handle, s=
truct inode *inode,
>  	split_map.m_lblk =3D map->m_lblk;
>  	split_map.m_len =3D map->m_len;
> =20
> -	if (max_zeroout && (*allocated > split_map.m_len)) {
> +	if (max_zeroout && (*allocated > split_map.m_len) &&
> +	    ext4_conv_pending_zeroout_lock(inode, flags)) {
>  		if (*allocated <=3D max_zeroout) {
>  			/* case 3 or 5 */
>  			zero_ex1.ee_block =3D
> @@ -3756,7 +3809,7 @@ ext4_ext_convert_to_initialized(handle_t *handle, s=
truct inode *inode,
>  				split_map.m_len - ee_block);
>  			err =3D ext4_ext_zeroout(inode, &zero_ex1);
>  			if (err)
> -				goto fallback;
> +				goto zeroout_unlock;
>  			split_map.m_len =3D *allocated;
>  		}
>  		if (split_map.m_lblk - ee_block + split_map.m_len <
> @@ -3770,16 +3823,17 @@ ext4_ext_convert_to_initialized(handle_t *handle,=
 struct inode *inode,
>  						      ext4_ext_pblock(ex));
>  				err =3D ext4_ext_zeroout(inode, &zero_ex2);
>  				if (err)
> -					goto fallback;
> +					goto zeroout_unlock;
>  			}
> =20
>  			split_map.m_len +=3D split_map.m_lblk - ee_block;
>  			split_map.m_lblk =3D ee_block;
>  			*allocated =3D map->m_len;
>  		}
> +zeroout_unlock:
> +		ext4_conv_pending_zeroout_unlock(inode);
>  	}

[Severity: Medium]
In ext4_ext_convert_to_initialized(), does calling
ext4_conv_pending_zeroout_lock() in the outer condition take
down_write(&ei->i_conv_pending_sem) even when neither the tail nor the head
is small enough to qualify for zeroout?

When max_zeroout is non-zero and *allocated > split_map.m_len, a partial
conversion of an unwritten extent larger than max_zeroout where neither
*allocated <=3D max_zeroout nor split_map.m_lblk - ee_block + split_map.m_l=
en <
max_zeroout holds will acquire i_conv_pending_sem for write and immediately
unlock it at zeroout_unlock without issuing any zeroout.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 6ede3644a738b..280ba3d359e3b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -669,6 +669,98 @@ int ext4_map_query_blocks(handle_t *handle, struct i=
node *inode,

[ ... ]

> + * 1. Incrementing the counter must down_read(i_conv_pending_sem).
> + * 2. A zeroout must check the counter and zero data under
> + *    down_write(i_conv_pending_sem)
> + * 3. Decrementing the counter needs no lock. At worst, this makes zeroo=
ut bail
> + *    out due to a stale, elevated counter value, which is acceptable
> + * 4. Changes to i_conv_pending_ios should use atomic helpers.

[ ... ]

> +void ext4_conv_pending_dec(struct inode *inode)
> +{
> +	_ext4_conv_pending_mod(inode, -1);
> +}
> +
> +void ext4_conv_pending_sub(struct inode *inode, int n)
> +{
> +	struct ext4_inode_info *ei =3D EXT4_I(inode);
> +
> +	down_read(&ei->i_conv_pending_sem);
> +	_ext4_conv_pending_mod(inode, -n);
> +	up_read(&ei->i_conv_pending_sem);
> +}

[Severity: Medium]
Why does ext4_conv_pending_sub() acquire down_read(&ei->i_conv_pending_sem)
when subtracting from i_conv_pending_ios?

The locking rules in struct ext4_inode_info and above ext4_conv_pending_inc=
()
state that decrementing the counter needs no lock, and ext4_conv_pending_de=
c()
calls _ext4_conv_pending_mod(inode, -1) directly without taking
i_conv_pending_sem.

Taking down_read(&ei->i_conv_pending_sem) in ext4_conv_pending_sub() causes
callers decrementing the counter to sleep behind any writer holding or wait=
ing
for down_write(&ei->i_conv_pending_sem) during synchronous zeroout IO, and
prevents ext4_conv_pending_sub() from being used in non-sleeping completion
contexts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102-ext4-endio=
-zero-bug-v1-0-266d2bb9e6dc@linux.ibm.com?part=3D2
