Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80134A5C27
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 13:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440546; cv=none; b=TxHjgzywJ8RJmldYN5em6N1ieVo5n0/vD+i4PFFwcL2SrnRjxlmB3slBK6pB9aijo2zfvkjeKbNtJnWWT7pwZyS65GwgSYTD17RZiGMkrnHv9dtJi6z9N2eeDE/jHAWhEYjVR9kp2G/eqCBVmJ4vx5QL9SyxiDNJiF16ioIAo9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440546; c=relaxed/simple;
	bh=BjW74CL/GRp94pbf5bF010+sofDvHgtwKgG7IdQzb6w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Y1xDO8MoSuGOhVZqdqH2Qc1dYrQq35Brmolzh7vVkzQIlzS2vqqGy0FnQ1LMaEqGAzuq1CHoQvUv1XLTbr3V6AQbljqQShp689xQy6oO7QIC2An4Xmrg6X6UuXeZtzLlzWOl2Tvq/hqRn+fgVkgkOfSCq4HLfo1cqclvUWDrzHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CM8r8mi/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CM8r8mi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3BC1F000E9;
	Thu,  3 Sep 2026 13:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788440539;
	bh=i1XHrNsX3bOtEp40XbGi9tHDqNgym700AtDIyoXwhq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CM8r8mi/NTozAsWqLOb2lzyXJr4lbJLrMZPu6iFMVf2bSjc2hvNq/GmlSuSclAsQt
	 l+ReB0Gi/6XNB3oTJTiM/4LDDI88oTG0AwkKN2GDeATfD/haEjnVNBLmNDJv9oIbMI
	 VGAH77ReLgJYQ0R2fMBXXM/Un3VbMz1YZk65xXDrZ2rXJmWb22xSz4JzgHneBgAWYI
	 gJsdSLOs7/CShHAnZVpI69q2Bp/VPZ7c7Mey/pEMFHzL4OFLDKC28OaspKr5+3d3Ln
	 esWmf22ugag0PAtmMRAgMXYB/rmu4xGC3i2/f8+5OJCF3TkGZ/h3MYSx3DCIoKwfOQ
	 RH77LHjtco6tQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 05/31] ext4: recheck extent status tree before block
 allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260903123543.2302999-6-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-6-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 13:02:18 +0000
Message-Id: <20260903130218.DA3BC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unbounded retry loop in `ext4_map_blocks` can lead to livelock.
--

commit 084efaf4a2100728f08798dc518e2664e9b89954
Author: Zhang Yi <yi.zhang@huawei.com>

ext4: recheck extent status tree before block allocation

This commit adds a sequence number recheck of the extent status tree
before block allocation in ext4_map_blocks(). The goal is to ensure a
racing truncate does not trim the extent between lookup and write lock
acquisition, which could lead to quota leaks. If the sequence number
has changed, the lookup is retried.

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d703e95a6f62d..fb4834608fd89 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -734,6 +734,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *i=
node,
>  	else
>  		ext4_check_map_extents_env(inode);
> =20
> +create_retry:
>  	/* Lookup extent status tree firstly */
>  	if (ext4_es_lookup_extent(inode, map->m_lblk, NULL, &es, &map->m_seq)) {
>  		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {

[ ... ]

> @@ -820,6 +823,19 @@ int ext4_map_blocks(handle_t *handle, struct inode *=
inode,
>  	 * with create =3D=3D 1 flag.
>  	 */
>  	down_write(&EXT4_I(inode)->i_data_sem);
> +
> +	/*
> +	 * Check the validity of the mapping found via the extent status
> +	 * tree or the disk query. A racing truncate may have changed the
> +	 * extent, since writeback does not hold i_rwsem or the folio locks
> +	 * covering the full extent.
> +	 */
> +	if (map->m_seq !=3D READ_ONCE(EXT4_I(inode)->i_es_seq)) {
> +		up_write(&EXT4_I(inode)->i_data_sem);
> +		map->m_flags =3D 0;
> +		map->m_len =3D orig_mlen;
> +		goto create_retry;

[Severity: High]
Could this goto statement in ext4_map_blocks() lead to an unbounded retry
loop causing a livelock?

If an unprivileged user triggers a file writeback concurrently with a
tight loop of operations modifying the extent tree (such as truncate
or fallocate), the i_es_seq sequence number will continuously update.

Since there is no retry counter or a pessimistic locking fallback
(like performing the lookup entirely under the write lock after some
attempts), it appears the writeback thread could be starved indefinitely
here in fs/ext4/inode.c, spinning at 100% CPU.

Does this need an upper bound on retries or a fallback mechanism to
prevent system stalls?

> +	}
>  	retval =3D ext4_map_create_blocks(handle, inode, map, flags);
>  	up_write((&EXT4_I(inode)->i_data_sem));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D5
