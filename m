Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797980;
	b=JkMkFPdGCwPPNGd1HucIl/svZu1bO8UewZlG9Md0qDm2LO3QpXWfoqSg7t6vl7rwKG4N
	 wAehYMTrJPYca8rYAG8b+4pE8F3qWC3I6yyDz53Ti/oZhv+Sw6ih7Dqv+ZWQf6NNlYD23
	 76oMCviWEN0m8X8ozMNpH3VvXVp6gE2QkJHC/HgAv+NPTypXsR+AVWCt8882SLWBh4DGV
	 fy/hzitO1DpqZA86cuHLlr2kB+AAq4AkED6tocvcaNqTmIy5m+tC0b0wOrDWrewLHqNsO
	 w85SDYhZyyDwh7ZwJsDF+UoE684HVm0J8vVafqHV8as6iPA8iNVonqYOYQUtTfMOvPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797980;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=t/mEZEjTb/PNSKZddt6r+1apdeIoySlP41uIezglfHM=;
	b=4Cn12fiSBPdaNeUZAG5UcZPtQeulWoTrlcPJBHy2MOhD3CRxlKZbNN7ybcsfWXCui/Wt
	 Te9529zYec0FJtTXNBIQNsZDS/pj5htbkD9Z/VyBWm5+O/rKGMyaameRU2hXWaJNTaUzA
	 tUFo2VKFgqr38CbzcReOHy2k5lk78aIb7opG8CM1lnOiPZamW7S6PH7QX7VhpncH4IJdH
	 M+m3ZGom6oWWVX6HBwbJNvq08qxTaNl4+mm/+4I09V1O4Hle+uhma4fHJICf1sxtDDtjm
	 CSE92IZ+5kd0KefHFAJJi0mQPuZPBMHOD46BkxBFUe7BHHFKtWevdW+XtMqTgWku0kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=odfx4za+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8587606A31E
	for <linux-ext4@vger.kernel.org>; Fri, 27 Nov 2026 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=odfx4za+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B561F00898;
	Fri, 27 Nov 2026 16:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795797979;
	bh=t/mEZEjTb/PNSKZddt6r+1apdeIoySlP41uIezglfHM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=odfx4za+ykDIaJhOOE/dVz37hgOB+04V7Yf+8uUZ9niT+FplUuXUiSwKps6vP1FFC
	 XOs8+1l3BslshAPB9aTzLmzg3hQpB+ZrSj3XZdvEjJDdo2satM/HrogWMwMJH6RgmY
	 Euo3zZph0HO2D/L8AoaukWWzrxJSI3P9ovE1LSTgoLxeNWPJ3Te9mTk6NzObTKVNZe
	 catLTv5qk/DOpE9bGqzoHW32+Z5m6X2kF0hm9AXFk+PcRWpnM1C1bo2NMWirD17exW
	 hU/qU7jnSdpLu0Lp85mz4IYuWmjSZMGkZAKpOPkDU4IFDr9dQj4CJa0lUaUUG1qLVZ
	 EOxt4qWRx9Uew==
Message-ID: <sashiko-outbox-237922@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/13] ext4: add es helper to convert unwrit to
 convert pending without changing i_es_seq
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261127-ext4-endio-zero-bug-v2-4-4106968e4d15@linux.ibm.com>
References: <20261127-ext4-endio-zero-bug-v2-0-4106968e4d15@linux.ibm.com>
 <20261127-ext4-endio-zero-bug-v2-4-4106968e4d15@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 16:46:19 +0000
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
- [Medium] ext4: unused static ext4_map_mark_convert_pending() breaks
  build at this commit
--

commit 80a3192297d6fe076d14d5912fca2f3312352549
Author: Ojaswin Mujoo <ojaswin@linux.ibm.com>

ext4: add es helper to convert unwrit to convert pending without changing i=
_es_seq

This commit adds helpers to mark an unwritten extent as
EXTENT_STATUS_CONVERT_PENDING in the extent status tree without
incrementing i_es_seq.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9368a68db2894..f7fc5fb7e8197 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -757,6 +757,29 @@ int ext4_map_create_blocks(handle_t *handle, struct =
inode *inode,
>  	return retval;
>  }
> =20
> +/*
> + * Mark the unwritten range in @map as convert pending in the extent sta=
tus
> + * tree. This is used by the zeroout code to ensure we don't write zeroe=
s on
> + * such unwritten ranges and hence must be serialized against endio conv=
ersion /
> + * extent zeroout, which hold i_data_sem excl.
> + *
> + * Returns false if the extent status tree changed since @map was looked=
 up, in
> + * which case the caller must redo the lookup.
> + */
> +static bool ext4_map_mark_convert_pending(struct inode *inode,
> +					  struct ext4_map_blocks *map)
> +{
> +	bool ok;
> +
> +	down_read(&EXT4_I(inode)->i_data_sem);
> +	ok =3D map->m_seq =3D=3D READ_ONCE(EXT4_I(inode)->i_es_seq);
> +	if (ok)
> +		ext4_es_mark_convert_pending(inode, map->m_lblk, map->m_len,
> +					     map->m_pblk);
> +	up_read(&EXT4_I(inode)->i_data_sem);
> +	return ok;
> +}

[Severity: Medium]
Does defining ext4_map_mark_convert_pending() here without callers or
__maybe_unused break the build at this commit?  Its callers in
ext4_map_blocks() are not added until commit "ext4: add support to track
convert pending ranges in ext4_map_blocks()", so compiling at this point
in the series triggers a -Wunused-function warning (and a build failure
with CONFIG_WERROR=3Dy), breaking bisection.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-ext4-endio=
-zero-bug-v2-0-4106968e4d15@linux.ibm.com?part=3D4
