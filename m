Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DAB422E34;
	Wed, 26 Aug 2026 09:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738064; cv=none; b=izOZ58tI+DM1X7HKERp+6mM7XanFSaMx+Phm2WSUrIk5PWyzIhUOCMkKxRfyOC5P7tvxlbri3jAmZWzEInkl+92fdyNNhzP0BhNA8iZPhUrzxhbV/XO85Y1aYegHie241PGGYIaW3ycpHW/9dn1+AqE++AlVFg1GqLu/yz1AIZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738064; c=relaxed/simple;
	bh=vp71zuxjW8f+g25fPAMUIotLHTkwTxC8kcRt/h0sCWA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V9rkQ/TYzpLd8k6VL3jUyT2gMe0aJu9B6C6jf7mz99UqLO/XfqojXXpG+M2Xduw/qH1QDXd9+Zo1g9zrE8KMjV6dQnpyyER1/xmikarwiZ0gIBpEVNYAyMjXJryohQLyzFahW5dukYykl+akFlG2qmyNqBPNjrNT5vfPq9qr5Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lway8kqF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lway8kqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F20E1F000E9;
	Wed, 26 Aug 2026 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738062;
	bh=gHgukxtvOD+mfDQTx4MlfZvPSXwor899hHIHhQqm2qs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lway8kqFyVYq9xZzbYLAXsVJgQHlXy8QabjMubbCCHRKo8YAMqDWcTjdGDwd0aPk0
	 3ZHUDm3BhbhMZbnTY+LQf8x0EEKmCd8fg7CXLZmzQoZrK3FGsNOPLirst12jk/M3K7
	 9tiS5kKXZgx7yhMLFl5K0Bw+aRpYcLht5Qn/cSgJs9LOZHqhkQ4hAjoqVvrAB4+Ma1
	 hKnkEM8ItoxYBqZWOVM/ZyZTce6WxFeq85qBl4uFPkLinrJSBsH/IgoHLMXglJLjKm
	 fw66FhnUSQtmM1QMlIitpmi62TBp1JSVD4qcZUKcvd8bnYn7sfTnhtT15+RQJqCteJ
	 Rwm5rIFms5lvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 07/11] ext4: Convert group-count barrier protocol to
 acquire/release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Vincent Mailhol" <mailhol@kernel.org>, tytso@mit.edu, "Marc
 Kleine-Budde" <mkl@pengutronix.de>, linux-can@vger.kernel.org, "Oliver
 Hartkopp" <socketcan@hartkopp.net>, "Oleksij Rempel" <o.rempel@pengutronix.de>, linux-ext4@vger.kernel.org
In-Reply-To: <20260825095422.3166067-8-ruanjinjie@huawei.com>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-8-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 09:54:22 +0000
Message-Id: <20260826095422.6F20E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] ext4_get_group_info() reads s_groups_count without an acquire barr=
ier, leading to potential out-of-bounds array access during online resize.
--

--- Patch [7]: [PATCH 07/11] ext4: Convert group-count barrier protocol to =
acquire/release ---
commit f34a19e39cbb154b52efeb9c4d1fc4d48a993810
Author: Jinjie Ruan <ruanjinjie@huawei.com>

ext4: Convert group-count barrier protocol to acquire/release

During an online resize, reading s_groups_count and s_blockfile_groups
requires strict ordering against initialized block group metadata. This
commit replaces the smp_wmb()/smp_rmb() pairs with smp_store_release()
and smp_load_acquire().

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 2fdff50526e93..e7f15c9e9187a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3527,16 +3527,12 @@ static inline void ext4_isize_set(struct ext4_ino=
de *raw_inode, loff_t i_size)
>  }
> =20
>  /*
> - * Reading s_groups_count requires using smp_rmb() afterwards.  See
> - * the locking protocol documented in the comments of ext4_group_add()
> - * in resize.c
> + * Reading s_groups_count uses acquire semantics.
>   */
>  static inline ext4_group_t ext4_get_groups_count(struct super_block *sb)
>  {
> -	ext4_group_t	ngroups =3D EXT4_SB(sb)->s_groups_count;
> -
> -	smp_rmb();
> -	return ngroups;
> +	/* Pairs with smp_store_release() in ext4_update_super() */
> +	return smp_load_acquire(&EXT4_SB(sb)->s_groups_count);
>  }

[Severity: High]
This is a pre-existing issue, but since we are formalizing the barrier
protocol around s_groups_count, should we also fix the plain read of
s_groups_count in ext4_get_group_info()?

If a concurrent reader calls ext4_get_group_info() during an online resize:

fs/ext4/balloc.c:ext4_get_group_info() {
	...
	if (unlikely(group >=3D EXT4_SB(sb)->s_groups_count))
		return NULL;
	indexv =3D group >> (EXT4_DESC_PER_BLOCK_BITS(sb));
	indexh =3D group & ((EXT4_DESC_PER_BLOCK(sb)) - 1);
	grp_info =3D sbi_array_rcu_deref(EXT4_SB(sb), s_group_info, indexv);
	...
}

Because there is no acquire barrier (it does not use ext4_get_groups_count(=
)),
can the CPU speculatively execute the rcu_dereference of s_group_info before
the load of s_groups_count?

If the resize writer just published a newly allocated s_group_info array
and incremented s_groups_count via smp_store_release() in ext4_update_super=
(),
could this reader see the new s_groups_count but load the old s_group_info
array pointer?

If so, would the boundary check pass, causing an out-of-bounds read into the
old, smaller array using the new group index?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260825095422.3166=
067-1-ruanjinjie@huawei.com?part=3D7
