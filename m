Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847892BEC34
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 12:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790599249; cv=none; b=XZZbE7Xuar3MotsHUlurSQEaAs5dFVziLz3W+KaBfFpWY/Ge2F/eougmLsMNeTC9ROY3nSmp1oN6Kqn+CYsFLR8M/CTkcLJLNXgdAmAcDGwameqYx0Y2PqTDuVa2nDrD5xeFf2QRgN0paPk4u2uMvrQhkAEwZpc4yapay1bxBGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790599249; c=relaxed/simple;
	bh=DakE5qpICacjijCLCawxYMXwuXg86kReinll7Fe+QjI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ECCfsS6pmoOQniCNViSFYjI/8mOdJ7ZCNrPDRi2sAe2sLLzCAFvQHsDlSPgrBfCqo3Zg2XKacrEnOOMORrZHRJesEbcx4C+3usTezu+Da5LrbbwtqzEPtHE3jQxUaGa6RGbnyNT0EkA2cTJ26sgd3cCrwvExNJokdwK6hJ3bTbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NxTKHbG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NxTKHbG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0357D1F000FF;
	Mon, 28 Sep 2026 12:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790599248;
	bh=l54ckVoZJxzbnY2XNk/OrhP3NYMuqEUlLSzIC8uRxPs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NxTKHbG8NBbZmgj0rO7bufKPHPOF0jzKYVFQFCUY/usTRMw6VcknPUvTJTzmkZdrZ
	 ER+zQa/AqS3m9gq65pBo8NsQ37A+wDQkhuSYXXwyRbDcZvb3/iuP7SMzctBjbaQbss
	 WRYajdnKu787Ddux4lML1GFBW+ZwELUciyYEXNU4ZEBlhzyucRXrI+jIz9R4VeUCXj
	 nxjJZSLW2bRrNDrHi5pMJMNHwlmhS5SKTQ/qqcFHBHuGphTUVmN7GdAI8STZJNVQ55
	 FTAgow2Ns+eVrgm0HYLHbsHBxSL7nSwlB/F4yglELI7CWVP/Guvo8kkCHdxpxYtdiL
	 m86X4jign+jDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com>
References: <20260928-fix-jbd2-shrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 12:40:47 +0000
Message-Id: <20260928124048.0357D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] jbd2: CPU spike due to incorrect shrinker nr_scanned accounting
--

commit 47731fd468777a6abc87ac06fd933280e1966163
Author: Qiliang Yuan <odys.yuan@gmail.com>

jbd2: fix shrinker scan budget accounting in jbd2_journal_shrink_scan()

This commit updates the jbd2 checkpoint shrinker's scan budget accounting
by calculating the number of scanned items, and returning SHRINK_STOP if
no items were scanned.

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 09efa337649e2..2602e5946cc14 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
[ ... ]
> @@ -1262,10 +1262,26 @@ static unsigned long jbd2_journal_shrink_scan(str=
uct shrinker *shrink,
>  	trace_jbd2_shrink_scan_enter(journal, sc->nr_to_scan, count);
> =20
>  	nr_shrunk =3D jbd2_journal_shrink_checkpoint_list(journal, &nr_to_scan);
> +	sc->nr_scanned =3D sc->nr_to_scan - nr_to_scan;

[Severity: High]
Will this correctly account for the items that were scanned but not freed?

Looking at jbd2_journal_shrink_checkpoint_list() in fs/jbd2/checkpoint.c,
nr_to_scan is only decremented by the number of freed items:

    freed =3D journal_shrink_one_cp_list(transaction->t_checkpoint_list,
                                       JBD2_SHRINK_BUSY_SKIP, &released);
    nr_freed +=3D freed;
    (*nr_to_scan) -=3D min(*nr_to_scan, freed);

Furthermore, journal_shrink_one_cp_list() explicitly skips busy buffers
without them counting towards the freed total:

    if (type =3D=3D JBD2_SHRINK_BUSY_SKIP && jh->b_transaction)
        continue;

This effectively sets sc->nr_scanned to the number of freed items, not the
actual number of scanned items.

The shrinker API expects sc->nr_scanned to reflect the actual amount of work
done (items scanned). If the shrinker scans many busy buffers but frees very
few of them, it reports a tiny number of scanned items.=20

Can this cause do_shrink_slab() to repeatedly re-invoke the shrinker without
meaningfully reducing its total_scan budget, leading to high CPU usage or
potential soft lockups under memory pressure?

> =20
>  	count =3D percpu_counter_read_positive(&journal->j_checkpoint_jh_count);
>  	trace_jbd2_shrink_scan_exit(journal, nr_to_scan, nr_shrunk, count);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-fix-jbd2-s=
hrink-scan-nr-scanned-v1-1-e6f4016ec699@gmail.com?part=3D1
