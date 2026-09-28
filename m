Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA334CDA30
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790607402; cv=none; b=flMpdrSkjyJUUEzgoNzcfLhwvHJotE1H9harrXWiYF3a8A5BEHg+rsYge3HtKft++v9CplbzPlHOzN0xgZxGZGkYxDKYoaKAglhx6P+VdZm3duJdLhXaLcW5tAI41FfQqIwhAFjqrkh4Fc2gLBh4nHUyCPPH61LMPRD09q577hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790607402; c=relaxed/simple;
	bh=dDXwe9hArDAv6rYUs4KBTT2aKaGqY6PQPd4aJZxgjm0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=vEe2s+NaHHbnGvbEXD2N3zGb4tC6rslJb7lHXs4hU7W6MmxZ2mpRPz/IICd2Nj45Zu2kM6ZWlh1iTNCvq3jaY2b9sRxp/hrcUrnKvEjG5AnsX8sSFr7ddkGBndw7Rz/PXwAjwtQpcU4jx9D/dOsUfFn1O8qzTZ9MTGYr9tcU1BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRbbh50T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRbbh50T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B221F000FF;
	Mon, 28 Sep 2026 14:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790607400;
	bh=SDvP8AbcpwjYWNIo7Ll1Lyxu/o5Zv2CkFEHlEWQU8Ec=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JRbbh50T+rK2KdD5vvkINObQasMEpSeY5IZ5gVFgChAGYVhZL8rvRV78u3CcmwQg8
	 aLRdhQ+0NXSaPageKk6DDRwAdgR/LMmjpQXqeXgHE2uP8tch9ThofmA3pfLE5PFdXU
	 1UfzJ/23OOByx8+7TMuQdT0eyJFszGfR07rMcHx+ef7WxA9GN5OMDY7+ZDTd55v0KG
	 veQEzM6mQPWLyIc1+3EA0gtJg8iHYwBSihQrvk5/blAD81yQkXSLtcoTRFX4x5RdkP
	 ii9zeQqb9ymG2sSzqCLlgqArlK5DBXEzx2xGVFhif+g9+QipYAQL4GlUf1wZcwOmla
	 TyV6FlAl8lDZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260928-fix-jbd2-shrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com>
References: <20260928-fix-jbd2-shrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 14:56:40 +0000
Message-Id: <20260928145640.72B221F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] jbd2: SHRINK_STOP return bypasses nr_scanned accounting
--

commit 77b2a9acfe221fe68e4d994c53d398a2afba6743
Author: Qiliang Yuan <odys.yuan@gmail.com>

    jbd2: fix shrinker scan budget accounting in jbd2_journal_shrink_scan()

This commit changes the jbd2 shrinker to report the actual number of
scanned objects via sc->nr_scanned. It also introduces a condition to
return SHRINK_STOP when no buffers were successfully freed, to prevent
do_shrink_slab() from looping over busy buffers.

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d4fe..a61b7a59c0a0e 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1263,10 +1263,27 @@ static unsigned long jbd2_journal_shrink_scan(str=
uct shrinker *shrink,
>  	trace_jbd2_shrink_scan_enter(journal, sc->nr_to_scan, count);
> =20
>  	nr_shrunk =3D jbd2_journal_shrink_checkpoint_list(journal, &nr_to_scan);
> +	sc->nr_scanned =3D sc->nr_to_scan - nr_to_scan;
> =20
>  	count =3D percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
>  	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);
> =20
> +	/*
> +	 * Give up on this reclaim pass if this call didn't manage to free
> +	 * anything. This is deliberately based on nr_shrunk, not on
> +	 * sc->nr_scanned: a checkpoint list can be full of buffers that are
> +	 * still busy being written back, in which case a call can
> +	 * legitimately scan (and correctly report through sc->nr_scanned)
> +	 * a full batch of them without freeing a single one. Retrying
> +	 * immediately within the same synchronous reclaim pass is not going
> +	 * to let any of that in-flight writeback complete any sooner, so
> +	 * there is nothing to gain from letting do_shrink_slab() keep
> +	 * calling us against the same stale freeable count until its
> +	 * one-shot scan budget for this priority level is exhausted.
> +	 */
> +	if (nr_shrunk =3D=3D 0)
> +		return SHRINK_STOP;

[Severity: Medium]
Will returning SHRINK_STOP here bypass the intended accounting of
sc->nr_scanned?

Looking at do_shrink_slab() in mm/shrinker.c, when a shrinker returns
SHRINK_STOP, the loop breaks early:

mm/shrinker.c:do_shrink_slab() {
	...
		ret =3D shrinker->scan_objects(shrinker, shrinkctl);
		if (ret =3D=3D SHRINK_STOP)
			break;
		freed +=3D ret;

		count_vm_events(SLABS_SCANNED, shrinkctl->nr_scanned);
		total_scan -=3D shrinkctl->nr_scanned;
		scanned +=3D shrinkctl->nr_scanned;
	...
}

Since the break happens before the accounting updates, won't this entirely
discard the scan progress reported by jbd2 when it hits a batch of busy
buffers? This appears to leave the scanned items unrecorded in vmstat and
leaves them un-subtracted from the deferred scan budget.

> +
>  	return nr_shrunk;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-fix-jbd2-s=
hrink-scan-nr-scanned-v3-1-916caaa53420@gmail.com?part=3D1
