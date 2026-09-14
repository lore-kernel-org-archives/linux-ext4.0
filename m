Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997B130F924
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 07:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370335; cv=none; b=eUHK17pTaQux2KSHngFPuvjiTD9ygyUl28pwZta/Nz6EV3oq3fv/dW3Pf4vfzgCkLGmCsw5RZCxbl5JTaKdgAkuohBfir/crlNTeinO7jLHi2CcUDreUXBQUD6V7tELFp6IM2wTa2GMEhuiLfDNk92AU1dwEBSxsBsFoc/CgJrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370335; c=relaxed/simple;
	bh=zyI9Aa6D55H0flQBNq5E2Jihny6cLA5bqLF5hPy5Bmg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FqNOsoStLwW48nETAG2nJvI5FkyJACU8gZ71b8fwuWbXymdfwebCH8eMh/qpbQExbhlq3/O1HXRUl1Vwy7Y6bF2vPigbTjCD5XpUWbS0nbuXpWHyiBbM99Oo2esDG6SdIIwVjAB8sDrBROlKD76dCymNoHjnIEGXfTgm80UC/uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aXO2I/8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aXO2I/8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED58F1F000FF;
	Mon, 14 Sep 2026 07:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789370334;
	bh=rzwGqGHZCzMXYMbOW56sZt6/PunPAShhx+T3cbulyVE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aXO2I/8V+sup2kZl+lnCBMwL4oUXoV2rkDlbH/XhhIGm5/H8hDAaee14YCKxMxDZe
	 /d1cey4xwm4bx47jt8YNcIdCRWlm2czIQKDuNWehBoPkVAzOh8UwUpLqmE+IuzQ4Iz
	 kyvUIWPP7DFG81JLxnaTK2queqPzHuLLlEHkDylklHiVAaUxn4vgjNONeFn15L+Aid
	 FI+ofCXPuTbZrulLWd3PF5BFBFCUJeMlEePHj9FkOZyZNlAB6klGSsOwEHzsJEVOtw
	 Gof26PG1jEF61yYfvMZJ2WJqFW2LH339Pdh7pGnT41cI0jv3VF/pz+28kjzC+WVGXa
	 mDMIqrXp2I4zA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix the logical block counter overflow in
 indirect migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yichong Chen" <chenyichong@uniontech.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260914065544.3438431-1-chenyichong@uniontech.com>
References: <20260914065544.3438431-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 07:18:53 +0000
Message-Id: <20260914071853.ED58F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The bounds check for `curr_block` incorrectly allows migrating a l=
ogical block at `EXT_MAX_BLOCKS` (`0xffffffff`), which is a reserved sentin=
el in extent trees.

Pre-existing issues:
- [Critical] Unbounded extent length accumulation in `update_extent_range()=
` leads to `ee_len` overflow and data corruption.
- [Critical] If journal credit extension fails after successfully swapping =
inode data, `tmp_inode` is evicted with its extent tree intact, erroneously=
 freeing the migrated blocks.
--

commit 09fb778181d3ee108e977c6ec47d3771e863f54a
Author: Yichong Chen <chenyichong@uniontech.com>

ext4: fix the logical block counter overflow in indirect migration

update_tind_extent_range() advances lb->curr_block by max_entries *
max_entries for every empty triple-indirect slot. This fixes the block
counter overflow by keeping the counter in 64-bit and refusing migration
with -EOPNOTSUPP when a data block is found after the last logical block.

> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index c5e3fc998211a..dbf13d47aae4c 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c

[ ... ]

> @@ -66,6 +66,10 @@ static int update_extent_range(handle_t *handle, struc=
t inode *inode,
>  			       ext4_fsblk_t pblock, struct migrate_struct *lb)
>  {
>  	int retval;
> +
> +	if (lb->curr_block > (ext4_lblk_t)-1)
> +		return -EOPNOTSUPP;
> +

[Severity: High]
Does this bounds check correctly handle the EXT_MAX_BLOCKS sentinel?

Since EXT_MAX_BLOCKS is 0xffffffff, when lb->curr_block is exactly
0xffffffff, the condition 0xffffffff > 0xffffffff evaluates to false.
This successfully allows the logical block to be migrated and inserted into
the extent tree with ee_block =3D 0xffffffff, which subsequent block mapping
operations will reject with -EFSCORRUPTED.

Should this use >=3D to properly reject the EXT_MAX_BLOCKS sentinel?

>  	/*
>  	 * See if we can add on to the existing range (if it exists)
>  	 */
>  	if (lb->first_pblock &&
>  		(lb->last_pblock+1 =3D=3D pblock) &&
>  		(lb->last_block+1 =3D=3D lb->curr_block)) {
>  		lb->last_pblock =3D pblock;
>  		lb->last_block =3D lb->curr_block;
>  		lb->curr_block++;
>  		return 0;
>  	}

[Severity: Critical]
This is a pre-existing issue, but does this loop lack bounds checking again=
st
the maximum extent length (EXT_INIT_MAX_LEN)?

Because contiguous blocks are accumulated here indefinitely, if the run of
blocks becomes > 32768, could this overflow the 16-bit ee_len field when
written in finish_range()?

fs/ext4/migrate.c:finish_range() {
    ...
	newext.ee_len   =3D cpu_to_le16(lb->last_block - lb->first_block + 1);
    ...
}

An overflow could set the MSB (0x8000), marking the extent as unwritten, or
wrap past 65535, truncating the length. This silently corrupts the migrated
file by replacing valid user data with zeros or unmapping it entirely.

[ ... ]

[Severity: Critical]
This is also a pre-existing issue, but what happens if journal credit
extension fails after successfully swapping inode data in ext4_ext_migrate(=
)?

fs/ext4/migrate.c:ext4_ext_migrate() {
    ...
	else {
		retval =3D ext4_ext_swap_inode_data(handle, inode, tmp_inode);
		if (retval)
			free_ext_block(handle, tmp_inode);
	}

	retval =3D ext4_journal_ensure_credits(handle, 1, 0);
	if (retval < 0)
		goto out_stop;
    ...
}

If ext4_journal_ensure_credits() fails, the error path jumps to out_stop
without clearing tmp_inode's i_data array. Does this leave tmp_inode to
be evicted with its extent tree intact?

Since the extent tree now points to the original file's data blocks,
will this erroneously free the migrated blocks during tmp_inode eviction,
leading to a use-after-free and cross-file data corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914065544.3438=
431-1-chenyichong@uniontech.com?part=3D1
