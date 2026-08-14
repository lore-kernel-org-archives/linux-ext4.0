Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C892D39CD10
	for <linux-ext4@vger.kernel.org>; Fri, 14 Aug 2026 10:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786703495; cv=none; b=kQFxyYXpmyRrlTUZfHCSSI8AKXc+zgj6F4rJw6GCn/CP63PnL/9Wq9ZOg9x5FEhP/iW4gF8736d9KMJ85vaXVgH1VFBGp6boXjFY6swCdkcp4s0CfMeTeKK3ATOAP8xw6lgcOzfKy281i2miEB8Lf0J7F7PdkD8C1OdBbjYFYoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786703495; c=relaxed/simple;
	bh=pUzZTPHqEq+Fi6PZ88Y2Rl1zrK1dcX0HB/4DxlemU6g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ps2HiFevrpxrmYGcgpFee0y68KCvze9bjXPvfe/IuLJb0xRi+QNHfqPkXLye9RIAtA61Hb4abaTT3pthBcM5xWcDcottmFq8HG+j2HlFyCjX4awrKwJYqx1UeCZ7qrmnrvsVebwt34HSaeatGTzMXzS2oDxuyXVOa5pff4o1Rhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCyV8ZpX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCyV8ZpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A601F000E9;
	Fri, 14 Aug 2026 10:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786703484;
	bh=OBgIOjnvxJXpmvJNT5l4cpNm/Gn22F0S15LEaCl+Bi0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LCyV8ZpXAm6IKqEczUDljLGxvTpmi+WGpNAzx6zPqL6ab+Ubeh5/WeW8LaTiNl0fE
	 UxqnkflmWbIFp9X7a1ODUQHO75mCH29B//4Sigs7S0Mgz4NyWGwTlw10xLopVeUmKy
	 WNr1FHa02kAYQipw9QL2u6qDlwMUMg6enfCN+WKojlME3tKC6ILhfSIy1sQmxgjq+X
	 2qDPaiuhfAKI+cshb5VZ66GRAyKFvQsL98by9cGDqGRxdCyA5ZidhcK7SXVExqaqVM
	 DYNzo8jNZCI8FCOmuXa6U7psaFnNSpuUwcyUeY6W+HPjwp1JnmfRehbL+NVb+p9ino
	 QAnFmV1D96Acw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -next v5 25/32] ext4: defer i_disksize update while
 DISKSIZE_GROW_PENDING is set
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260814093331.1703882-26-yi.zhang@huaweicloud.com>
References: <20260814093331.1703882-1-yi.zhang@huaweicloud.com>
 <20260814093331.1703882-26-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 10:31:23 +0000
Message-Id: <20260814103123.E1A601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing State Initialization / Dead Code: EXT4_STATE_DISKSIZE_GROW=
_PENDING is never set.
- [High] State Leak / Data Loss: Discarding the zeroed EOF folio without wr=
iteback permanently leaks the pending bit.
- [High] Durability Loss: O_SYNC extensions via fallocate/zero_range silent=
ly persist a stale i_disksize.
--

--- Patch [25]: [PATCH -next v5 25/32] ext4: defer i_disksize update while =
DISKSIZE_GROW_PENDING is set ---
commit 5fa612fe6ec599be935a3aa55b36845e34d3180e
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: defer i_disksize update while DISKSIZE_GROW_PENDING is set

Operations like append allocate, zero range, and truncate update
i_disksize directly. If the new i_disksize exceeds the original value
while the zeroed EOF block is still awaiting writeback, metadata may be
persisted before the zeroed data, exposing stale data on crash.

> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3605,30 +3605,67 @@ do {								\

[ ... ]

> +static inline void __ext4_set_i_disksize(struct inode *inode, loff_t new=
size)
> +{
> +	WARN_ON_ONCE(!rwsem_is_locked(&EXT4_I(inode)->i_data_sem));
> +
> +	if (newsize < EXT4_I(inode)->i_disksize ||
> +	    !ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING))

[Severity: High]
Could O_SYNC extensions via ext4_do_fallocate() or ext4_zero_range() silent=
ly
persist a stale i_disksize here?

If the size is extended with an unaligned old EOF, the i_disksize update is
deferred. Since O_SYNC immediately commits the journal without waiting for
the pending zeroing writeback to complete, it seems it will commit the old,
deferred i_disksize to disk.

Would this cause the file size to revert on crash despite a successful fsyn=
c,
discarding the size extension?

> +		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
> +}

[ ... ]

>  static inline int ext4_update_inode_size(struct inode *inode, loff_t new=
size)
>  {
>  	int changed =3D 0;
> =20
> +	if (newsize <=3D inode->i_size && newsize <=3D EXT4_I(inode)->i_disksiz=
e)
> +		return 0;
> +
> +	down_write(&EXT4_I(inode)->i_data_sem);
>  	if (newsize > inode->i_size) {
>  		i_size_write(inode, newsize);
>  		changed =3D 1;
>  	}
> -	if (newsize > EXT4_I(inode)->i_disksize) {
> -		ext4_update_i_disksize(inode, newsize);
> +	if (newsize > EXT4_I(inode)->i_disksize &&
> +	    !ext4_test_inode_state(inode, EXT4_STATE_DISKSIZE_GROW_PENDING)) {

[Severity: High]
Are we setting EXT4_STATE_DISKSIZE_GROW_PENDING anywhere in the codebase?

Looking at this patch series, it appears the bit is checked here but never
actually initialized or set. Does this mean the deferral condition is always
bypassed and i_disksize is always updated immediately?

[Severity: High]
If the EXT4_STATE_DISKSIZE_GROW_PENDING bit is properly set, could it leak
if the dirty folio is discarded before writeback?

For example, if a file is truncated down before writeback completes, it
seems the bit might never be cleared since the writeback completion function
wouldn't be called for that folio.

Would this leak cause all subsequent appends to skip updating i_disksize,
leading to silent data loss on crash for future writes to the file?

> +		WRITE_ONCE(EXT4_I(inode)->i_disksize, newsize);
>  		changed |=3D 2;
>  	}
> +	up_write(&EXT4_I(inode)->i_data_sem);
>  	return changed;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814093331.1703=
882-1-yi.zhang@huaweicloud.com?part=3D25
