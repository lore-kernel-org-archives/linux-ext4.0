Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160122BE053
	for <linux-ext4@vger.kernel.org>; Thu,  1 Oct 2026 07:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790841199; cv=none; b=Pfku9U01o0ZQlpmYD8qu7eT+AYz9rUeEdwE6oeu9rkZeqmLrV9lgZRrujvjKbO/TRpyexn2vNpvb1oQS5y//mAgIVcKjOx6e+ySlkq0YzqqR+zWS34YZtWQEq0NPrnLs1YljRmmb6Ge0tDARpO5vUkAxO3iWC4EBzLqYDKS1mS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790841199; c=relaxed/simple;
	bh=Y+3MzEscEAU0StAFgAB1iGbPUPKnXH65kDkuZ2WXnBI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D6aiHBcKgAnFz+CQu/TxN1Hb2VrxiNePdBSGYSHrqj4H93MBHuojASGW1uH38h/fdbz90vuTmFoYhNKa27c0TVtfDKV8Nsuev8+uGVBNXMAilNr4FQmGoZgySszty7Prydel8IkEv/VEStrhcf7xOXjTK40oiyqoUGW9sUkwTUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJfCwdic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJfCwdic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5B01F000FF;
	Thu,  1 Oct 2026 07:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790841197;
	bh=fH/GTWsE2LG5qhfxglzbTGVHVPqHqj4+Z/b3KefPDjU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dJfCwdic5lUmrScb89kv2xVEFdpXmHT9RjZ7tSp5KyXoe86nS2aK0Md0BEPnxYmnM
	 fsl5r66uZ1w6jTp01V+WASC5kK9nMWFMNbx7JggowDFBNRIoL93uvTTVUN3joZaOMD
	 3z1E+bGIfR10wdK0P+tKjusGSFF6zZ56WuJIg+BtUB0RjJG7bEcTiPt1H4lLrU+XNv
	 +AKbF6wXwUZNcI0EDH4iYxpAPCoAYXkLm0ZQQh8njzxqyNmxiegkE7OyU0nkrJQKjI
	 lxeiR7pmueR0baC0TZBygC0m9xnewPNH9YJf5Nq6+pPCEgAGV7rUJR0/wooS3d2CfX
	 oOS7HNXSpBlpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261001-fix-jbd2-shrink-scan-nr-scanned-v5-1-5348b51efce2@gmail.com>
References: <20261001-fix-jbd2-shrink-scan-nr-scanned-v5-1-5348b51efce2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 07:53:17 +0000
Message-Id: <20261001075317.9E5B01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] jbd2: shrinker busy-loops rescanning the same busy checkpoint items
--

commit 22efbdb58b6c52d305510bf987737313bb851b41
Author: Qiliang Yuan <odys.yuan@gmail.com>

jbd2: fix shrinker scan budget accounting in jbd2_journal_shrink_scan()

This patch updates jbd2_journal_shrink_scan() to report the actual number of
scanned buffers back to the shrinker subsystem. It sets sc->nr_scanned based
on how many buffers jbd2_journal_shrink_checkpoint_list() examined, and uses
this value to determine whether to return SHRINK_STOP.

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 00f5a98f3d4fe..eac5f84a1afc5 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -1263,10 +1263,22 @@ static unsigned long jbd2_journal_shrink_scan(str=
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
> +	 * Key SHRINK_STOP off sc->nr_scanned (buffers actually examined),
> +	 * not nr_shrunk (buffers actually freed): a batch can find every
> +	 * buffer in its transactions busy and free none, while later
> +	 * transactions may still hold buffers whose writeback has
> +	 * completed. sc->nr_scanned only comes back 0 when the checkpoint
> +	 * list had nothing left to walk.
> +	 */
> +	if (sc->nr_scanned =3D=3D 0)

[Severity: High]
Does this condition cause do_shrink_slab() to busy-loop when the checkpoint
list is fully exhausted but contains a few busy items?

If the shrinker budget is large (for example, due to a stale percpu counter)
but the checkpoint list has only a small number of busy items (e.g., 5),
jbd2_journal_shrink_checkpoint_list() will scan them and set sc->nr_scanned
to 5. Upon reaching the end of the list, it resets
journal->j_shrink_transaction to NULL.

Because sc->nr_scanned is 5, this fails to return SHRINK_STOP.

Will do_shrink_slab() then subtract 5 from its budget and loop immediately,
restarting from the beginning of the list and rescanning those exact same 5
busy items? If this repeats until the large budget is completely drained in
increments of 5, could it cause CPU busy-looping and j_list_lock contention
in the memory reclaim path?

> +		return SHRINK_STOP;
> +
>  	return nr_shrunk;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001-fix-jbd2-s=
hrink-scan-nr-scanned-v5-1-5348b51efce2@gmail.com?part=3D1
