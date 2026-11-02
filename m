Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793585924;
	b=2gavJHOQWtntTOSuiv3b9mHQW9omaxyJdh2SnIK1jwBMzq/C7RuguAbUGS9SSfEsLvxh
	 MWq97PAv+BbkhcDpaoSev1OMHVOuqjh1rN1NQkAKgobEXecfcdYqfCnJ4ffftX1i8nej1
	 f4/PGPHUStGw8u+CV/9dMqA5hXdAmD9DhlapoTd7+FdZGwL7nWvjvEHzVflj1YIcEYuUd
	 DqTsQOxsvCSuUJaPe0T4xP0o5oEKRvX4sJ9e6Q1Ddm8l3qRXCvP5PTSXovC7YWOoL13Q1
	 T7MbkmEb7wNwRq/xpXH+l7jmeUAQ95l/aZwGKMS2ZrUCkwmj+nbBa5i2a43QzmKC63g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793585924;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/CZuYMLFl8Zn03VljoAnwsVDD6gx2/SzqIwbqoTS0YI=;
	b=5F63g1MlMFBjhmqJOMRq/FbQDoMXCNJ+o5uDcYyDCJqmKoAGkw1laI0T5DrMfr8Da1et
	 qENrWes8S+nRHR8+BG21XKRF0c/BPYWOei11ebs752jAc8W5HyB1ktPh9mqSpukdPpi7d
	 kcACLqp4002OC3L9Ze23WqxJy0tPbGe9fV+piPKke5quSZdXq2/D0sUrl8AD9mamYWiTr
	 xFEwA1Ym4h7T1PpCyR1BEQGNTmWGostTw/ZuAZwNEEnGtU+TqDPNCLBaEvhGcJZ5BSKut
	 mtyEqBlXiFtHCQwKuqmCs95Lc9JU9F8Ct+SCGh5osZlI6gRULrvqYV2ryPC67nF9s/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGEJ94cN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A0F606A329
	for <linux-ext4@vger.kernel.org>; Mon,  2 Nov 2026 02:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hGEJ94cN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F611F00919;
	Mon,  2 Nov 2026 02:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793585924;
	bh=/CZuYMLFl8Zn03VljoAnwsVDD6gx2/SzqIwbqoTS0YI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hGEJ94cNFT3NPEkf41rQAMZKkzUk5BWRty1QVXlG8Xx4hYDhIwVnIB1gg9Hwip2d8
	 suBk3Xrj9z9Nx7zL10U/ySM9rghtHnpl53VFF4CM/SZyp5u9HpPpsWW1KPJLY+FIfy
	 dgsYdJ9Kzi9sexgy/UKggoDoVc5J1OBh24eSpj56BDG8fT66J4P+aFRjMdmDPpl0sN
	 NPFNijMplSVYqT72UZ4woHqEK1/meHuPGRG+rTkZGXqnnEakA0cgCfD4z8oNI3tnVB
	 4qHih8WCZt4+6O+IVlaari4JlXy3Od3FMx4Og1tsp2awszarUPPved/BQbyEJN3tIj
	 4BxJ4A8+bp95Q==
Message-ID: <sashiko-outbox-192825@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RESEND v5] jbd2: fix shrinker scan budget accounting in
 jbd2_journal_shrink_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261101-fix-jbd2-shrink-scan-nr-scanned-v5-1-ebd1ecc59a96@gmail.com>
References: <20261101-fix-jbd2-shrink-scan-nr-scanned-v5-1-ebd1ecc59a96@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 02:18:43 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] jbd2: repeated busy buffer rescans in jbd2_journal_shrink_scan()
--

commit e6c15f2237536f947ab070ac978601d8d9849323
Author: Qiliang Yuan <odys.yuan@gmail.com>

jbd2: fix shrinker scan budget accounting in jbd2_journal_shrink_scan()

This commit updates sc->nr_scanned in jbd2_journal_shrink_scan() based on t=
he
remaining nr_to_scan count from jbd2_journal_shrink_checkpoint_list() and
returns SHRINK_STOP when sc->nr_scanned is zero.

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
> +		return SHRINK_STOP;

[Severity: Medium]
What happens here when the checkpoint list has already been walked to
last_transaction and only a small number of busy buffers (for example,
1 <=3D sc->nr_scanned < sc->nr_to_scan) remain on the list?

In fs/jbd2/checkpoint.c, jbd2_journal_shrink_checkpoint_list() loops via
goto again while *nr_to_scan is non-zero and journal->j_shrink_transaction =
is
non-NULL:

	if (transaction !=3D last_transaction) {
		journal->j_shrink_transaction =3D next_transaction;
		next_tid =3D next_transaction->t_tid;
	} else {
		journal->j_shrink_transaction =3D NULL;
		next_tid =3D 0;
	}

	spin_unlock(&journal->j_list_lock);
	cond_resched();

	if (*nr_to_scan && journal->j_shrink_transaction)
		goto again;

Because of that loop, jbd2_journal_shrink_checkpoint_list() only returns wi=
th
nr_to_scan > 0 (meaning sc->nr_scanned < sc->nr_to_scan) when the end of the
checkpoint list (last_transaction) has been reached and
journal->j_shrink_transaction has been reset to NULL.

If earlier batches freed the clean buffers and, say, 1 busy buffer remains =
on
the checkpoint list, jbd2_journal_shrink_checkpoint_list() walks that 1 busy
buffer, reaches last_transaction, resets journal->j_shrink_transaction to
NULL, and returns with sc->nr_scanned =3D=3D 1.

Since sc->nr_scanned =3D=3D 1 is non-zero, jbd2_journal_shrink_scan() does =
not
return SHRINK_STOP. Back in mm/shrinker.c:do_shrink_slab():

		ret =3D shrinker->scan_objects(shrinker, shrinkctl);
		if (ret =3D=3D SHRINK_STOP)
			break;
		freed +=3D ret;

		count_vm_events(SLABS_SCANNED, shrinkctl->nr_scanned);
		total_scan -=3D shrinkctl->nr_scanned;
		scanned +=3D shrinkctl->nr_scanned;

total_scan is decremented by only 1 instead of sc->nr_to_scan (128). On the
next iteration of do_shrink_slab(), jbd2_journal_shrink_checkpoint_list()
starts over from the head of journal->j_checkpoint_transactions and rescans
the exact same busy buffer, multiplying the number of scan_objects() calls
and journal->j_list_lock acquisitions on the remaining scan budget by up to
SHRINK_BATCH (128x).

In addition, when the checkpoint list is empty (sc->nr_scanned =3D=3D 0) and
jbd2_journal_shrink_scan() returns SHRINK_STOP before total_scan is drained,
do_shrink_slab() breaks out with scanned < nr + delta and banks the un-scan=
ned
phantom budget from the stale percpu counter into shrinker->nr_deferred:

	next_deferred =3D max_t(long, (nr + delta - scanned), 0);
	next_deferred =3D min(next_deferred, (2 * freeable));
	new_nr =3D add_nr_deferred(next_deferred, shrinker, shrinkctl);

Would it make more sense to check nr_to_scan !=3D 0 (indicating
jbd2_journal_shrink_checkpoint_list() reached the end of the checkpoint list
before exhausting the batch budget) or to leave sc->nr_scanned untouched so
the stale budget is consumed without deferring phantom work or rescanning t=
he
same busy buffers up to 128 times?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101-fix-jbd2-s=
hrink-scan-nr-scanned-v5-1-ebd1ecc59a96@gmail.com?part=3D1
