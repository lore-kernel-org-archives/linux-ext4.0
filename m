Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794263568;
	b=ltsy4vzXj/4/AK8yT2JEStRefgXwHEAVhwAbmRKzKtGRO+9+pS3imYqcz0ach0/2KmGK
	 4Z3c/E/jSFHmgmYmfl2SEA56ZjiUxZS8rdwbd7XGeJx7IewbRxgeVBoIVADJFtJfj1gY6
	 LABveRcM+Q40wmcAD+ww1srWD84PQZDEkaBWh9UFjmplgVpa6CD7/WbfBtCoSZxep7YpM
	 mJ+7ah4m0UJeRqclNUxyEKUiO/c/GBUpZ/Fwao3A8pnHqlV4/1IdTgsXMaejvu4Y0GMQq
	 cQfTSfGvKEe+AcFg0Jw+LjixqTOMFeZAMQM5yNAzEjiv/kmcE1KYebWUPCBCEZEAqiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794263568;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=WyRXDEWLW23uWT0RNcF4QXKCqVnLRA4M1ADO1SXTNUM=;
	b=vK4By+jK1yK0m/r8QvyUNlqAXJO8HTCamJrBXj8Pj2UUzHf4yrwSMCfr1bIhgvyv6dcp
	 XnXx1idSTNYu6JGJJEsCgRWX5oHvyYUdCNBpUj6F6mitneNoysIwRNlp90pLxNHBlS3UW
	 Z4qLzqNR3rllA33rrfHwTO4W6CT8l1GadPGahQBsE1CHVmvo54uLu2c4YiQEevKHmIV9x
	 9jx18t/nJxyO0Psrz+uHM8YmiQ9+EXsI5gy/BQKBqnowDRv3Gp/bV2Eo8FInT0wwDCMBA
	 Y3JGVJAbCRURr5Cv4chyLp+nxIS1bgxvEZHZ3RHMYjNqpnexLNBvm4Xgy8qAq4+qiWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bR9Ioq2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D96F606A31C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Nov 2026 22:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bR9Ioq2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFF91F0089F;
	Mon,  9 Nov 2026 22:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794263568;
	bh=WyRXDEWLW23uWT0RNcF4QXKCqVnLRA4M1ADO1SXTNUM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bR9Ioq2O3a5ZdUJzixh8zUctNwSisxMARtoLUd9l8fhmmfN25OR/COCyZhxZtH3Rf
	 ogb+uS4S+oGkiw8Jgzu9CJesLiv4rlZYTsuquyOETppKd8k0XXZ9P0BEEED97Aj2He
	 /ZsdoXFxp61Nqrg1Oc69X7QbTMVas1BLJRhFsH3+91PKAT4YGYIwcqutbN3qxT7Wa9
	 JhhUdpwc7Uzo3QSD9Lo9JyIN/hLrb5bURnQzuBMkuHbAUf//fKuJZd8PSVi+u/EGM4
	 AWXJ8OPH7/fNkY5fvpMH49v8088oC4QLJ3q6sTpZ/c42CKg0kCAfV29SUELGzLfSzt
	 5GWqWL0hKtmTQ==
Message-ID: <sashiko-outbox-205751@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] ext4: validate extent root during fast commit replay
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261109221211.1793790-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20261109221211.1793790-2-Jeremy.Jean@oss.cyber.gouv.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 22:32:47 +0000
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
- [Medium] ext4: ignored extent check errors in ext4_fc_replay_inode()
- [Medium] ext4: missing EXT4_INODE_EXTENTS check in fast commit range
  replay
--

commit c7e3408ccbd89c7e858695dd9961091a529765cf
Author: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>

ext4: validate extent root during fast commit replay

This commit validates the root extent header in ext4_find_extent() during
fast commit replay, skips extent replay helpers when EXT4_INODE_EXTENTS is
not set, and clears EXT4_FC_REPLAY before loading the root inode.

> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf3702..b883ce015c303 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2002,7 +2002,7 @@ static int ext4_fc_replay_inode(struct super_block =
*sb,
>  	 * crashing. This should be fixed but until then, we calculate
>  	 * the number of blocks the inode.
>  	 */
> -	if (!ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>  		ext4_ext_replay_set_iblocks(inode);
> =20
>  	inode->i_generation =3D le32_to_cpu(ext4_raw_inode(&iloc)->i_generation=
);

[Severity: Medium]
Should ext4_fc_replay_inode() check the return values of
ext4_ext_clear_bb() and ext4_ext_replay_set_iblocks()?

When the new ext4_ext_check() in ext4_find_extent() rejects a corrupt root
extent header with valid eh_magic (such as eh_entries =3D 4 and eh_max =3D =
5),
both helpers return -EFSCORRUPTED, but ext4_fc_replay_inode() ignores the
error, computes a valid checksum over the corrupt i_block via
ext4_inode_csum_set(), and writes the inode to disk.

> @@ -2334,7 +2334,7 @@ static void ext4_fc_set_bitmaps_and_counters(struct=
 super_block *sb)
>  		}
>  		cur =3D 0;
>  		end =3D EXT_MAX_BLOCKS;
> -		if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA)) {
> +		if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
>  			iput(inode);
>  			continue;
>  		}

[Severity: Medium]
Do ext4_fc_replay_add_range() and ext4_fc_replay_del_range() also need to
verify EXT4_INODE_EXTENTS before replaying range tags?

If an EXT4_FC_TAG_ADD_RANGE or EXT4_FC_TAG_DEL_RANGE tag targets an inode
without EXT4_INODE_EXTENTS set, ext4_map_blocks() dispatches to
ext4_ind_map_blocks() while the subsequent calls (ext4_find_extent(),
ext4_ext_insert_extent(), ext4_ext_replay_update_ex(),
ext4_ext_remove_space(), and ext4_ext_replay_shrink_inode()) treat i_data
as an extent tree.

In ext4_fc_replay_del_range(), any blocks reported mapped by
ext4_ind_map_blocks() are cleared in the block bitmap via
ext4_mb_mark_bb() and are no longer restored by
ext4_fc_set_bitmaps_and_counters() now that it skips non-extent inodes.
In ext4_fc_replay_add_range(), if ext4_ind_map_blocks() reports a hole for
a logical block that is already present in an extent header in i_data,
ext4_ext_insert_extent() hits BUG_ON(newext->ee_block =3D=3D nearex->ee_blo=
ck).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109221211.1793=
790-2-Jeremy.Jean@oss.cyber.gouv.fr?part=3D1
