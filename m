Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EDE4D0A12
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790603328; cv=none; b=sYIqh23rN2ETRgiadM9wMgNMjKfjs+ID75Z6KsWu+uA/KmWcfqZkK7bV1jrWXzxh/C2yIA3nCJW2v4QxYYfofVb6IAl+aD0VOuhAH+IH1ZPMd6bNRR0vQqmcOujaV6dFpiYdpHbx4gzS0ZsVQoQReDOLzSudoAGMVe/mVm+5Bn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790603328; c=relaxed/simple;
	bh=lqc83lUCidJIl+/Djb4vobfWMwJDewCaREV5PyEnE/Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ep1wBOYzhT1fF6YVEY386KU8FG3OHyV0Tn2+lavGO/VOGoZvKP2Dq/+WPQPlqNdwtHcsDoabTHJpqkIjXg4W1AKp1ZEEXJPQmwT2Uxjuth3jmLv82viygKJycrJ7mSJS8xPXgRcVBboJVFeD0NA1k+OIVDgR4gsTXqPRktoAB+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A+fs2Ice; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A+fs2Ice"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D9C1F00893;
	Mon, 28 Sep 2026 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790603326;
	bh=i3Ehm4pIFryphgq7qApXEXVpue6rswpTn0dxLQ6N/UY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=A+fs2IceszPC12WGqwag4rBC8W3s2v9eauBKca9GcW1D+EeRd8Vq/ITSoISETOUl+
	 +bxXwY7UGbMxn/DWifWeI2UUM0cJmPxfVvBu49tahMOrbxlXoBB7ZGPsaFzGLqTbvA
	 jgQG1jgLJINqiGuOoHVcZ7byoTqn8VxWQ+6DMvsFhsLte3hhPsr2RlH2xn8EHAGOZT
	 pARuPp4lel4qsbOfzXjJszbJeqC0EX2Akxqg5hMFi6yMqcARI9XWNd+NuaAyQNKEFi
	 8wJNRqZTuDSmHDH/Vh6QnglFZdjtnrPHXVcqWYYglnXqOTorjbRGpDbXUoSLhfkUZ+
	 MOUzGkL8uso4g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260928-fix-jbd2-shrink-scan-nr-scanned-v2-1-7e1efec3afdf@gmail.com>
References: <20260928-fix-jbd2-shrink-scan-nr-scanned-v2-1-7e1efec3afdf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 13:48:46 +0000
Message-Id: <20260928134846.97D9C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] jbd2: shrinker scan count under-reporting and improper SHRINK_STOP
--

commit 210f96938647f489c8074cf3aa01e6d2cbdb8fe9
Author: Qiliang Yuan <odys.yuan@gmail.com>
jbd2: fix shrinker scan budget accounting in jbd2_journal_shrink_scan()

This commit modifies the jbd2 shrinker to count examined buffers rather than
just freed ones when decrementing the scan budget. It also triggers
SHRINK_STOP when no buffers are freed to avoid immediate retries.

> diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
> index 1508e2f544621..3569e32500b7c 100644
> --- a/fs/jbd2/checkpoint.c
> +++ b/fs/jbd2/checkpoint.c

[ ... ]

> @@ -458,9 +467,10 @@ unsigned long jbd2_journal_shrink_checkpoint_list(jo=
urnal_t *journal,
>  		tid =3D transaction->t_tid;
> =20
>  		freed =3D journal_shrink_one_cp_list(transaction->t_checkpoint_list,
> -						   JBD2_SHRINK_BUSY_SKIP, &released);
> +						   JBD2_SHRINK_BUSY_SKIP, &scanned,
> +						   &released);
>  		nr_freed +=3D freed;
> -		(*nr_to_scan) -=3D min(*nr_to_scan, freed);
> +		(*nr_to_scan) -=3D min(*nr_to_scan, scanned);

[Severity: High]
By capping the decrement with min(), does this artificially deflate the
reported scanned items? If a transaction is large, it seems this would hide
the true number of examined buffers from the caller.

>  		if (*nr_to_scan =3D=3D 0)
>  			break;
>  		if (need_resched() || spin_needbreak(&journal->j_list_lock))

[ ... ]

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 09efa337649e2..e35d488cbfd23 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c

[ ... ]

> @@ -1262,10 +1262,27 @@ static unsigned long jbd2_journal_shrink_scan(str=
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

[Severity: High]
Does returning SHRINK_STOP when nr_shrunk =3D=3D 0 cause do_shrink_slab() to
break early and skip accounting for sc->nr_scanned?

It appears the scanned items are not subtracted from total_scan nor added to
scanned, so they are dumped into nr_deferred. Could this inflate the
deferred work budget, tricking the core shrinker into applying more pressure
in subsequent passes?

Additionally, does aborting early here prevent the shrinker from making
progress on subsequent transactions that might actually contain freeable
items?

> +
>  	return nr_shrunk;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-fix-jbd2-s=
hrink-scan-nr-scanned-v2-1-7e1efec3afdf@gmail.com?part=3D1
