Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCF636196C
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 05:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789019003; cv=none; b=LVIXr8ESbugS5gSmsDtM2RzOWeESRHSDIfYQAWTIQIEmlGhEczu88tLvEcq6UwuRK2WyXnnwVSQMZdD9KuigAapG4ug03GcF6MAs34RcI5xAEzjpL4U2hhMRMP+PFW8hGZllQrGhtoBCeTm3xUlOxeF4rdHn3m81qagkMZbcrAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789019003; c=relaxed/simple;
	bh=wacXTWbKnXKczUsRVIdFw4NlJrFAQmCh+J0x1GJOXZU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MwGBVlhc3iZffzTSVfel/6yBKtjELvRAnea4ZWwlEKSCb1RWAkwQw9na/fhO09ygmiAxhbTNlVRcEOWgH5cCw8H/t+2n5pjSDlgokMxlDECrZZ71vTC+YFsXmNXo3noIq1I7+Nk9PFOHFGIJSsKvtKRwLtJ0xlyjc/r2iM5wwag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lc3Vzdmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lc3Vzdmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF851F000FF;
	Thu, 10 Sep 2026 05:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789019002;
	bh=GRGDYtwUt/83wwmY3PP5kWh3YAjbVRuqI8iLSlrURYM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Lc3VzdmkPW6lJ+pGicZJB8iHzON5IhJD013GOCdxgMi7cUAdHWp4rNJVTfPYLgCIj
	 gU32mChfzlxBipl9sSvO82KynnAztQg+165HiyvZIfmzKUrgZP1KNARjewUK7CJrNG
	 DIBwYRrPYZKUuMRh3aE4fBHRHnxXvGXjK1rJEXBLROBWTZPC8WQLtcut4YXvAOfzjI
	 fVLvmrTwdKnaaCuUkMcXn6ht+Mt6hut6VJqKl2YWyS92UVjaHHv1+2WIwpX9Q7Wdlx
	 TDGkEyftwkwtK+BXrthP28TMQqWBsqGsY5EEkpcDZoS86V4/lv591AKnGpmlcN/b1A
	 ID+Q4lPTvufeA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: don't clobber the migration error in
 ext4_ext_migrate()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yichong Chen" <chenyichong@uniontech.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260910052927.3161092-1-chenyichong@uniontech.com>
References: <20260910052927.3161092-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 05:43:20 +0000
Message-Id: <20260910054321.ACF851F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] This problem wasn't introduced by this patch, but skipping tmp=
_inode cleanup on journal credit failure leads to severe data loss via ext4=
_evict_inode().
- [High] This problem wasn't introduced by this patch, but finish_range() a=
nd ext4_ext_migrate() misinterpret the positive return value (1) from trans=
action restarts as an error, causing valid migrations to incorrectly abort.
- [High] This problem wasn't introduced by this patch, but restarting the j=
ournal transaction after ext4_ext_swap_inode_data() splits the migration, r=
isking catastrophic filesystem corruption on crash.
--

commit 1e2365dd0dc0240e7c7b7887168a101dc865de11
Author: Yichong Chen <chenyichong@uniontech.com>

ext4: don't clobber the migration error in ext4_ext_migrate()

This commit ensures that ext4_ext_migrate() does not overwrite the
migration error code when ext4_journal_ensure_credits() returns a
positive value indicating a transaction restart. It introduces a
separate err variable to hold the credit check result.

> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 5d60ef10fe110..02bb7c20a008a 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -410,7 +410,7 @@ static int free_ext_block(handle_t *handle, struct in=
ode *inode)
>  int ext4_ext_migrate(struct inode *inode)
>  {
>  	handle_t *handle;
> -	int retval =3D 0, i;
> +	int retval =3D 0, err, i;

[Severity: High]
This isn't a bug introduced by this patch, but finish_range() and
ext4_ext_migrate() misinterpret the positive return value (1) from
transaction restarts as an error, causing valid migrations to
incorrectly abort.

During migration, if ext4_datasem_ensure_credits() successfully
restarts the journal, it returns 1. This 1 is propagated through
finish_range() and update_extent_range() back here to
ext4_ext_migrate().=20

When ext4_ext_migrate() subsequently checks the return value:

	retval =3D update_extent_range(handle, tmp_inode,
			le32_to_cpu(i_data[i]), &lb);
	if (retval)
		goto err_out;

Could this incorrectly treat the 1 as a fatal error, aborting the
migration? This would cause the migration of any file large enough
to require a transaction restart to fail and return 1 to userspace,
breaking the migration feature for large files.

[ ... ]

> @@ -567,9 +567,12 @@ int ext4_ext_migrate(struct inode *inode)
>  	}
> =20
>  	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
> -	retval =3D ext4_journal_ensure_credits(handle, 1, 0);
> -	if (retval < 0)
> +	err =3D ext4_journal_ensure_credits(handle, 1, 0);

[Severity: High]
This is a pre-existing issue, but restarting the journal transaction
after ext4_ext_swap_inode_data() splits the migration, risking
catastrophic filesystem corruption on crash.

ext4_ext_swap_inode_data() commits the extent tree to the actual
inode and dirties it. If this subsequent call to
ext4_journal_ensure_credits() requires restarting the transaction
(returning 1), the current state is committed to disk.=20

If a crash occurs before the next transaction completes the cleanup
of tmp_inode, wouldn't the disk contain both the migrated inode and
the unlinked tmp_inode pointing to the same data blocks?

Because tmp_inode is unlinked via clear_nlink(tmp_inode) but was never
added to the on-disk orphan list via ext4_orphan_add(), kernel orphan
recovery ignores it, potentially leaving e2fsck to encounter
multiply-claimed blocks.

> +	if (err < 0) {
> +		if (!retval)
> +			retval =3D err;
>  		goto out_stop;
> +	}

[Severity: Critical]
This problem wasn't introduced by this patch, but skipping tmp_inode
cleanup on journal credit failure leads to severe data loss via
ext4_evict_inode().

If this final credit check fails (e.g., due to ENOMEM or journal
abort), the code jumps to out_stop, bypassing the essential
tmp_inode cleanup:

	if (err < 0) {
		goto out_stop;
	}
	...
	tmp_inode->i_blocks =3D 0;
	EXT4_I(tmp_inode)->i_csum_seed =3D tmp_csum_seed;
	ext4_ext_tree_init(handle, tmp_inode);
out_stop:

When tmp_inode is then dropped via iput(), its i_nlink is 0, so
ext4_evict_inode() truncates it. Does bypassing the i_blocks =3D 0
and ext4_ext_tree_init() reset result in freeing all the extent data
blocks that now belong to the user's migrated file?

>  	/*
>  	 * Mark the tmp_inode as of size zero
>  	 */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910052927.3161=
092-1-chenyichong@uniontech.com?part=3D1
