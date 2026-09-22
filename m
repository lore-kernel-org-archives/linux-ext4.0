Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A0953B325
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 11:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790076582; cv=none; b=OnlfqrWe8xm6g4ZJ+gO74Dg8z3MjaxauPJaXN9T0F1xf0RAvsSQtPzUqCFjGXx6vNKy/HvTQEcdVYnxFeN066CAs8secIwremyDHlI1eZ46ny1C9zfozao1TTFSJRFdMe/HJ8/4fIEUsqNwD47F95+jOccwPFnC1eGcXmwJHsMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790076582; c=relaxed/simple;
	bh=CNGySPDVlBnXBGbLT9fJvQYGRvLcQDA+hhpDACQpv7k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bYhOgO/AQCvl2zLVNXJ3venBY00qXwS3RCBmdMtxgDj6ExF2NDdFZAeFq1nwJ7nwsYTcpWgmfzhDkzVphVRv/u/FBy3u74GLG2u2Vr8/jtATE6dQRvNVHshjYCkw4+WabIvvweaJlo9lRDzd3bAEBbaMt+vqhW0mPE0P7v/n5ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbxrG2dg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbxrG2dg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF871F000FF;
	Tue, 22 Sep 2026 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790076581;
	bh=tOi1br+Pz9UFaXfBW4YwUW5/hTHqFJYJ1DlTMnz/xKQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VbxrG2dgLWuN47bzvgtNJ/xhIV/YwYjx28SBgsk7fEi5OEKh/2ufoGZGkZQHGEWEM
	 N6XGNB9AGEVAxBOJ81ozp77CDUfnl3Qr0sGFh0AQBt+fjrZTrBjPtOkweieNGSBPtH
	 k40FDb11Jr94UZpoC0GTCSC6MndcQs5DQpzAIUxWuDbpaCyWA3c5xiehdLXyGZ95BJ
	 StGYDVvAGEu1IvwfWVMvONpBxLsKcoFozDJdWx7FlEay4oVmzYdks5QkVrdUt01sR2
	 zDuJvfaYw6l9+P6ktLunZ2+7BN7evKQIOwDsnTBL6KtypNYh7BOlf3oNHJwjFPlWQ4
	 d2LDpsGxvBSzQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/4] mm/truncate: clarify return value of
 truncate_inode_partial_folio()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260922110703.468389-5-yi.zhang@huaweicloud.com>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-5-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 11:29:40 +0000
Message-Id: <20260922112940.BEF871F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: newly split large folios are skipped during shmem truncation
--

commit 15553d4635c639eef475fb728e2da88b1d36fe93
Author: Zhang Yi <yi.zhang@huawei.com>

mm/truncate: clarify return value of truncate_inode_partial_folio()

This commit clarifies the return value of truncate_inode_partial_folio()
to strictly indicate whether at least one split succeeded. The callers now
use this return value as a flag to determine whether the truncation loop
should be reset to pick up newly split sub-folios on the shmem path.

> diff --git a/mm/truncate.c b/mm/truncate.c
> index 81fb4de6226bc..317cb4ae36259 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -216,8 +216,7 @@ static int folio_split_or_unmap(struct folio *folio, =
struct page *split_at,
>   * aligned inwards to min_order, i.e. the range of folios wholly within
>   * [lstart, lend] and so safe to discard.
>   *
> - * Returns false if splitting failed so the caller can avoid
> - * discarding the entire folio which is stubbornly unsplit.
> + * Return %true if at least one split succeeded, %false otherwise.
>   */
>  bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>  				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)

[Severity: High]
Does shmem_undo_range() still rely on an outdated check instead of just this
return value?

mm/shmem.c:shmem_undo_range() {
    ...
				} else if (truncate_inode_partial_folio(folio,
						lstart, lend, NULL, NULL)) {
					if (!folio_test_large(folio)) {
						folio_unlock(folio);
						index =3D start;
						break;
					}
				}
    ...
}

Because folio_split() can perform non-uniform splits, the resulting sub-fol=
io
could still be a large folio (order > 0). If it is, folio_test_large(folio)
evaluates to true, so this check prevents the loop from resetting even when
truncate_inode_partial_folio() successfully split it.

Since find_get_entries() has already advanced the search index, the loop
continues from the advanced index and bypasses the newly split sub-folios
within the truncation range.

Can this cause newly split sub-folios to be skipped, leaving them in the pa=
ge
cache beyond EOF?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922110703.4683=
89-1-yi.zhang@huaweicloud.com?part=3D4
