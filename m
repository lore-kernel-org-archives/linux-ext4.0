Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6776025DB0D
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 03:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012404; cv=none; b=UPgLMgGZ80vLfv8eg4+Xf0ub5ECMyllrmvEBr27O5QBAxnQ5YXzvvIqBp7ziRWBuAw9cce6cDE0nsslWS0OovXPYHagIkRC+tMBSAhZsOttineTMtE+i/4w1St3nE1TeMBXpxx47E4XYdXg9jLOv8gdtt083vzKQT5O6e5XHLrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012404; c=relaxed/simple;
	bh=fMKaK6NJ2jfoXRa23BXe7lL+BbwhBgGl7Aj9kZ05tXc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PXVtv+JDtVz6TNdHBfJ/gvrQj2SQufMLxCbq01hJRgchDwtiR0Yr0YxYsySTTEf5ni5rz6J3YmZqrKfqv7vOXP8gJTmpBImYVXAENVvbgetoLMMaByu1UVN364c6GUjtOYaW0Ef35CJiKzewESEp8qzVn7HJo9TCbyDKb85bXdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLUyYZhp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLUyYZhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127901F000FF;
	Thu, 10 Sep 2026 03:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789012403;
	bh=yNDFVoFy6t77LQF8KfqZXmTBGooRzkGDLsfgGS3wlmk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KLUyYZhphLEyzlMaH4sYD5TEBxhtd2J6tJkSLIq2PsX2n6EWrnQC8T1GzFLSsRd69
	 y6jggqoFtFvXXPgZS8iDf5bklAoLv5wOVaR7x3ISI3Tr0jCATWvV+EKdFNwi/ZUsEM
	 d4DK9btSvGkWZdmG6WymSdLXIlhV7iSvKfSY/wcZPWyY9Bd0u10c7fyO3Uw4CO7thO
	 2B4AlYObg2RwVVuH/ug4GPu2AXvVNfN0n5HWZ+hqqW+fBtOsAUyNwD8ztAuD0NXl2F
	 PfbPyEX/6UowYRSDnQ8JSCbQFwGKgbmrM1vQDqztMo3z0/lmwP7iLRFzm2OzhozCrR
	 5cCA7yXcFgdhg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: cap migration extent length at EXT_INIT_MAX_LEN
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yichong Chen" <chenyichong@uniontech.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260910034000.3155420-1-chenyichong@uniontech.com>
References: <20260910034000.3155420-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 03:53:22 +0000
Message-Id: <20260910035323.127901F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Error handling around ext4_journal_ensure_credits clobbers err=
or codes and causes silent data loss on failure.
- [Critical] Integer overflow of logical block counter causes a kernel pani=
c on >=3D 8KB block size filesystems.
- [High] Permanent disk block leak when freeing metadata blocks fails on th=
e error path.
--

commit e8f71f9a6f0e209c95682ad7839bfdf0af78c8da
Author: Yichong Chen <chenyichong@uniontech.com>

ext4: cap migration extent length at EXT_INIT_MAX_LEN

update_extent_range() keeps merging contiguous blocks without limiting the
accumulated range, which can exceed EXT_INIT_MAX_LEN. This causes
finish_range() to store lengths that overlap with the unwritten extent bit,
leading to silent data loss. This patch stops merging once the range
reaches EXT_INIT_MAX_LEN to create valid extents.

> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index c5e3fc998211a..5316287ab823a 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -71,7 +71,8 @@ static int update_extent_range(handle_t *handle, struct=
 inode *inode,
>  	 */
>  	if (lb->first_pblock &&
>  		(lb->last_pblock+1 =3D=3D pblock) &&
> -		(lb->last_block+1 =3D=3D lb->curr_block)) {
> +		(lb->last_block+1 =3D=3D lb->curr_block) &&
> +		(lb->last_block - lb->first_block + 1 < EXT_INIT_MAX_LEN)) {
>  		lb->last_pblock =3D pblock;
>  		lb->last_block =3D lb->curr_block;
>  		lb->curr_block++;

While reviewing this, I noticed a few pre-existing regressions in the same
file.

fs/ext4/migrate.c:ext4_ext_migrate() {
...
	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
	retval =3D ext4_journal_ensure_credits(handle, 1, 0);
	if (retval < 0)
		goto out_stop;
	/*
	 * Mark the tmp_inode as of size zero
	 */
	i_size_write(tmp_inode, 0);
...
	tmp_inode->i_blocks =3D 0;
...
out_stop:
	ext4_journal_stop(handle);
...
}

[Severity: Critical]
This isn't a bug introduced by this patch, but does the error handling arou=
nd
ext4_journal_ensure_credits() clobber error codes and cause silent data loss
on failure?

If ext4_journal_ensure_credits() fails after a successful
ext4_ext_swap_inode_data(), the function jumps to out_stop, skipping the
zeroing of tmp_inode->i_blocks and its extent tree. When tmp_inode is
subsequently evicted, ext4_evict_inode() frees all of its blocks. Since the=
se
are the exact physical data blocks now used by the migrated file, the user's
data is entirely deleted.

Alternatively, if migration failed earlier, does this same call overwrite t=
he
negative retval with 0, falsely reporting success while the file is
unmigrated?


fs/ext4/migrate.c:update_tind_extent_range() {
...
	for (i =3D 0; i < max_entries; i++) {
		if (i_data[i]) {
			retval =3D update_dind_extent_range(handle, inode,
						le32_to_cpu(i_data[i]), lb);
			if (retval)
				break;
		} else {
			/* Only update the file block number */
			lb->curr_block +=3D max_entries * max_entries;
		}
	}
...
}

[Severity: Critical]
This isn't a bug introduced by this patch, but does the integer overflow of
the logical block counter cause a kernel panic on filesystems with block
sizes of 8KB or larger?

In update_tind_extent_range(), lb->curr_block (a 32-bit ext4_lblk_t) is
incremented by max_entries * max_entries for each empty tind entry. On
filesystems with a block size of 8KB or greater, max_entries is at least
2048. Iterating through all entries adds over 8.5 billion, which overflows
the 32-bit counter.

When ext4_ext_insert_extent() attempts to insert the overlapping extent, can
it hit the BUG_ON(newext->ee_block =3D=3D nearex->ee_block) check, causing a
kernel panic?


fs/ext4/migrate.c:free_ext_block() {
...
	ix =3D EXT_FIRST_INDEX(eh);
	for (i =3D 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
		retval =3D free_ext_idx(handle, inode, ix);
		if (retval)
			return retval;
	}
	return retval;
}

[Severity: High]
This isn't a bug introduced by this patch, but is there a permanent disk bl=
ock
leak when freeing metadata blocks fails on the error path?

When ext4_ext_migrate() fails, it calls free_ext_block() to release the
allocated extent metadata blocks from tmp_inode. If free_ext_idx()
encounters an error (like failing to ensure journal credits), it aborts the
loop immediately.

ext4_ext_migrate() ignores the return value of free_ext_block() and proceeds
to reset tmp_inode->i_blocks to 0 and clear its extent tree. When tmp_inode=
 is
evicted, the filesystem cannot track or free the remaining metadata blocks,
permanently leaking them on disk.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910034000.3155=
420-1-chenyichong@uniontech.com?part=3D1
