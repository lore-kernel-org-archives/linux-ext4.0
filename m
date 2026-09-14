Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8774156DF
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 08:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375282; cv=none; b=GTIcurYmOkYGCG/WlWaz7ivgLuIsuc6FxHEOo3YWx42RChos+mV97Zz8NkSokvwjJxZaKt+2HFTb0684Sh7ECQVhIH/DbpmoZ3i8czPctK377yilEhaKV/QraoueQ37XvmZf1pgehxktMv+fKyuDtSzUHG+qtnBC6FIhotmrYGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375282; c=relaxed/simple;
	bh=wVdRPz8u8m5tap7v8+70jMAkwxyePnPftrIY8aKPiYo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sRl3XEI7BHkdXlMq52pjMFZ23cyN7D2Ez4Bmv/wl1e9SSDlp+GbuSAt2kjURgcJnhQIDl4NTaNJmreasS7u8pOKvGJcWJhmd2brCzW3G1bJB4UCu01mPBR86tS2RCtwZ3ZerWX6cTz0pNvLfZSfCAfNejTxGGnTn0OPwFpQRfP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WufQ+0Uc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WufQ+0Uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0831F000FF;
	Mon, 14 Sep 2026 08:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789375272;
	bh=4XJkIzY72T8mI7hhb6ODoftwjxnhPvpf/dUgFD4/vE4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WufQ+0UcFDgZr0e/qfOEowo60+ausiGrmecZB4BNrRSzV3jvJp59qVCeyVKMPi9NP
	 oCi7iGfUnlYnD/uRzAXfEtF0Jy+nSZkYAUto3/wRd6LgH2T4Ox4qnlW6zjdwC7Mndt
	 hoZLVakhzgFDKW0NZ8E+GG5/4gJvPAlqcnNqSVRLO/MPiViOr/GaHBrPLKwdKc5mL9
	 0nlaPPWqhAGoxZqmoy8XySyMOPuCAak6AOov58pxy1WFqaL7hoaN0fTNqr/ewdAmDG
	 O+Eo574/KUeTWFL+BZLhQXLfq1DAPYLBPV6vCGufc5QZ/AeMkndEX/DJtyfiDnkG9A
	 fQgpaNnTeWgYA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: fix the logical block counter overflow in
 indirect migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yichong Chen" <chenyichong@uniontech.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260914082516.3442815-1-chenyichong@uniontech.com>
References: <20260914082516.3442815-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 08:41:11 +0000
Message-Id: <20260914084112.4F0831F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing bounds check on extent length during contiguous block =
aggregation leads to extent corruption and silent data loss.
- [Critical] Erroneous freeing of active extent metadata blocks if `free_in=
d_block()` fails after the inode data is permanently swapped.
- [High] `ext4_ext_migrate()` silently overwrites error codes, including th=
e newly added `-EOPNOTSUPP`, falsely reporting success to userspace.
--

commit 551790cf82563190f29580d447430a3723ff4943
Author: Yichong Chen <chenyichong@uniontech.com>
Subject: ext4: fix the logical block counter overflow in indirect migration

This commit prevents a logical block counter overflow in the ext4 indirect
migration path by keeping the counter in 64-bit and refusing migration if a
block reaches EXT_MAX_BLOCKS.

> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index c5e3fc998211a..f492935d5e3de 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c

[ ... ]

> @@ -66,6 +66,10 @@ static int update_extent_range(handle_t *handle, struc=
t inode *inode,
>  			       ext4_fsblk_t pblock, struct migrate_struct *lb)
>  {
>  	int retval;
> +
> +	if (lb->curr_block >=3D EXT_MAX_BLOCKS)
> +		return -EOPNOTSUPP;
> +
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
This is a pre-existing issue, but it appears this contiguous block check
blindly accumulates blocks without verifying that the maximum extent length
(EXT_INIT_MAX_LEN) is respected.

If a file has more than 32768 physically contiguous blocks, the resulting
length is later cast to 16 bits in finish_range():

	newext.ee_len   =3D cpu_to_le16(lb->last_block - lb->first_block + 1);

Could a length greater than 32768 set the 0x8000 (UNWRITTEN) bit or overflow
entirely, causing valid data to read as zeroes and corrupting the file?


[Severity: High]
This isn't a bug introduced by this patch, but the error handling in
ext4_ext_migrate() seems to unconditionally overwrite error codes like the
newly added -EOPNOTSUPP.

Looking at the error path in ext4_ext_migrate():

err_out:
	if (retval)
		/*
		 * Failure case delete the extent information with the
		 * tmp_inode
		 */
		free_ext_block(handle, tmp_inode);
	else {
		retval =3D ext4_ext_swap_inode_data(handle, inode, tmp_inode);
		if (retval)
			/*
			 * if we fail to swap inode data free the extent
			 * details of the tmp inode
			 */
			free_ext_block(handle, tmp_inode);
	}

	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
	retval =3D ext4_journal_ensure_credits(handle, 1, 0);
	if (retval < 0)
		goto out_stop;

If any function within the migration loop (like the new EXT_MAX_BLOCKS chec=
k)
fails, it jumps to err_out with a negative error code in retval. However,
retval is then overwritten by ext4_journal_ensure_credits().

Since this function typically returns 0 or 1 on success, might this falsely
report success to userspace and leave the file unmodified or incomplete?


[Severity: Critical]
This is a pre-existing issue, but I am wondering if the rollback logic in
ext4_ext_migrate() erroneously frees active extent metadata when
ext4_ext_swap_inode_data() encounters an error.

In ext4_ext_swap_inode_data(), the original inode is permanently modified to
use extents:

	ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
	memcpy(ei->i_data, tmp_ei->i_data, sizeof(ei->i_data));

	/* ... snip ... */

	retval =3D free_ind_block(handle, inode, i_data);
	retval2 =3D ext4_mark_inode_dirty(handle, inode);
	if (unlikely(retval2 && !retval))
		retval =3D retval2;

err_out:
	return retval;

If free_ind_block() fails (for example, due to a lack of journal credits), =
it
returns an error. This error is caught in ext4_ext_migrate(), which then
attempts to clean up:

	else {
		retval =3D ext4_ext_swap_inode_data(handle, inode, tmp_inode);
		if (retval)
			/*
			 * if we fail to swap inode data free the extent
			 * details of the tmp inode
			 */
			free_ext_block(handle, tmp_inode);
	}

Since the extent tree root was already copied to the active inode, is it
possible that calling free_ext_block(handle, tmp_inode) blindly frees the
exact metadata blocks that the active inode now relies upon, leading to sev=
ere
on-disk data corruption?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914082516.3442=
815-1-chenyichong@uniontech.com?part=3D1
