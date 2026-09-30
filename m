Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180BB45517D
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 07:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753241; cv=none; b=gLKG21so4qirlXMdseS1Up+2FuIuXuDG+eKsFyEED6Dk6fIfmNy7/FFvcawWAdDy4m5NaaCEGRcOaIr5VZgazEd8b41eH5dryzouwD6gqVkWayd7zZPssXDuj0b+gsT0jkw/WShowFVXw0IReRUyy5mocXdGBgw8HYXQ0u6uF+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753241; c=relaxed/simple;
	bh=FDdesBlFn3tNS9KQ39c43aQvAxJ38RZx6D62IPUNbOM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kfbcV9RK7+/ua6xl6Wx5XWbcJgKreZPVl5KdP7mDfYMYARdKTReorx4lzDtb+Eg8Jg6fWNg/r7TfA6tvG2DIhdcYLUpIJb/a/96yNRfeNHJdYvRsf3tlPgvE14cYG70efFny6RdV75m5rVoVuyM810g7NuaVTw3KhofHDNQ7Oyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeS4YOJO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeS4YOJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD131F000FF;
	Wed, 30 Sep 2026 07:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790753239;
	bh=uorLBjbO8OL/ZbmNtaN9NJfqsi85QJIxjvI685bT5vM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PeS4YOJOX3MD60rUBBmy4ZSoT8xdcEeVuJTtEGvzUxav4FM5crIKsf3kdzKCF88gc
	 rYHRQCrhb+D13jMNJHswKSOJjJ+OkISvuk5cjIF9RC9DPDp3gqpcfFuyed3SAgo6ck
	 pbLYKjRfDrk7kNYpF84tVGjCuwhPEk2moAtVBxOmrXp3hOo82PxNs4wN3qv+7K4UmR
	 vQsUqmGVfVBDqbnsAQ9IjHslrawwVL9RseMO3btN2jU5fvVnT2Q/x4khr4MJImq+8a
	 uuQZwqpOP76xcD+v0uduPRbyikkHIc39iY41c6S98aejXex8jWipv4yZZUk3s2YtQF
	 APVztA0PkjGhQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260930-fix-jbd2-shrink-scan-nr-scanned-v4-1-eb9a3ccc2524@gmail.com>
References: <20260930-fix-jbd2-shrink-scan-nr-scanned-v4-1-eb9a3ccc2524@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 07:27:19 +0000
Message-Id: <20260930072719.7BD131F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] fs/jbd2: premature reclaim abort in jbd2_journal_shrink_scan()
--

commit ac994d3eed163d41361f281d91578f4538a2003f
Author: Qiliang Yuan <odys.yuan@gmail.com>

jbd2: fix shrinker scan budget accounting in jbd2_journal_shrink_scan()

This commit modifies jbd2_journal_shrink_scan() to return SHRINK_STOP
when jbd2_journal_shrink_checkpoint_list() frees zero items. The goal
is to prevent the shrinker from continually scanning a stale freeable count
when the checkpoint list only contains busy buffers.

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d4fe..c921afce7d061 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1267,6 +1267,16 @@ static unsigned long jbd2_journal_shrink_scan(stru=
ct shrinker *shrink,
>  	count =3D percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
>  	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);
> =20
> +	/*
> +	 * A checkpoint list full of busy buffers can keep reporting a
> +	 * stale, positive freeable count after nothing more can be
> +	 * reclaimed. Stop this reclaim pass once a call frees nothing,
> +	 * instead of burning through do_shrink_slab()'s scan budget
> +	 * retrying against buffers whose writeback won't finish any sooner.
> +	 */
> +	if (nr_shrunk =3D=3D 0)
> +		return SHRINK_STOP;

[Severity: High]
Could this unintentionally abort the entire reclaim pass when the code hits
a chunk of busy buffers or gets interrupted by the scheduler?

If do_shrink_slab() provides a scan budget and the first batch of buffers
happen to be busy writeback buffers, jbd2_journal_shrink_checkpoint_list()
will return 0. This change then translates that 0 into SHRINK_STOP, which
aborts the rest of the scanning budget for this reclaim pass.

Additionally, jbd2_journal_shrink_checkpoint_list() can return 0 early due
to scheduling or lock contention:

fs/jbd2/checkpoint.c:jbd2_journal_shrink_checkpoint_list()
    ...
		if (need_resched() || spin_needbreak(&journal->j_list_lock))
			break;
    ...

Will returning SHRINK_STOP in these scenarios prematurely skip remaining
transactions that might contain clean, freeable buffers?

> +
>  	return nr_shrunk;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930-fix-jbd2-s=
hrink-scan-nr-scanned-v4-1-eb9a3ccc2524@gmail.com?part=3D1
