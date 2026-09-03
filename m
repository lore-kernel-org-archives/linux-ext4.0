Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5C64A0EEE
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 12:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788437343; cv=none; b=TnYqpftLs4p2Z/K6khM3OKRgiSxrEb800FXwV/5YxnqLavbAWZWgSAZ0TsBy5XhtSaQXD3IEpuQKhhKgOgLeG+OFp2ZaFFCAQf+4u4YuYpa0m1FOQqIi0LFWbadVsRU4Atc2WTCOB7vFt/KXiyYqSRpt2CwCI7SD8WbbghlCQFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788437343; c=relaxed/simple;
	bh=KgwL73l0vUC2/3WvQT/lKV+5/BLJD5plNPjXPtEsNRI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eYS7aN9GzcfNY8LhEEa3CWn9vjuPgUHx2+8MS62ShQpquG0U4COpDwJaNcuTjhR/tVNNuiJnh3MaNWRC5Rf4emYt+0MwsUPCr3xk9d7TfbgVIEokyqRr1ynn1VtsFvTR/xHaeamPy0Fr/qZ3z4icUPX7d5Qk5oMfUJJ+5I8cLvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GW5tDjUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GW5tDjUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386491F000E9;
	Thu,  3 Sep 2026 12:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788437341;
	bh=r4GS666UUJ2niaV0rXjNa+P9QDlBWvQCKD20AQPmKn4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GW5tDjUhNdpSnwv26wGuKonPUCHXTafn+WPFq+w2tXSKHYHTlfRP6HTqwT7VXJjIL
	 FKc+AiKWqssMCc+fE7bTZmg1onsSFY9fn5iPcmjUSV6Mk6GVGATfyA96ROwe1z1jrE
	 MYblFCfFGhQDugshB+ZM+zmgukzkx7jzfzi5lueZH8IWMgEx8Bx7xdU3hl7rKNx7vg
	 fVDu3IetoDvBzkL4TN4OAHIzJeHktmtq3B/EowfQ22arlUSe/kTXs9zrDURRwDJvwD
	 7nCQF329+Ph+cFQ5zGaBphrYa/ERCN6U/7sllJTFnT9Mbge2e0jENl+Ty/tG8ULlGT
	 TFjktameDRruQ==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 12:08:59 +0000
Message-Id: <20260903120901.386491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing re-validation of `page_folio()` result after `folio_try_ge=
t()` enables TOCTOU race, leading to out-of-bounds page splits and kernel p=
anics.
--

commit 34ec9be8b97f90a8067df5949df00d3bb219ade3
Author: Zhang Yi <yi.zhang@huawei.com>

mm/truncate: fix data loss when splitting fails in truncate_inode_partial_f=
olio()

truncate_inode_partial_folio() splits a large folio so that the caller's
truncate loop can drop the in-range sub-folios while keeping the
out-of-range tail.

Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/

> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be474..2ebb00f6c3793 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -273,24 +283,28 @@ bool truncate_inode_partial_folio(struct folio *fol=
io, loff_t start, loff_t end)
>  		if (!folio_test_large(folio2))
>  			goto out;
> =20
> -		if (!folio_trylock(folio2))
> +		if (!folio_trylock(folio2)) {
> +			tail_isolated =3D false;
>  			goto out;
> +		}
> =20
>  		/* make sure folio2 is large and does not change its mapping */
>  		if (folio_test_large(folio2) &&
> -		    folio2->mapping =3D=3D folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +		    folio2->mapping =3D=3D folio->mapping &&
> +		    folio_split_or_unmap(folio2, split_at2, min_order))
> +			tail_isolated =3D false;

[Severity: High]
Does this code have a TOCTOU race that could lead to an out-of-bounds page
split?

In truncate_inode_partial_folio() in mm/truncate.c, a speculative folio
lookup occurs just prior to this block:

	split_at2 =3D folio_page(folio,
			PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
	folio2 =3D page_folio(split_at2);

	if (!folio_try_get(folio2))
		goto no_split;

Without a re-validation check after folio_try_get(), couldn't a concurrent
operation (like memory reclaim or shmem readahead reallocation) change the
compound structure of folio2?

If the compound structure changes, a thread could successfully take a
reference on the new, smaller folio2. However, split_at2 would now be
outside the bounds of this new folio2.

When folio2 is later passed into folio_split_or_unmap() in the modified
code above, would this out-of-bounds split_at2 cause a kernel panic via
VM_BUG_ON_FOLIO() inside folio_split(), or corrupt adjacent page structures
if debug is disabled?

Should there be a check like if (unlikely(page_folio(split_at2) !=3D folio2=
))
added after folio_try_get() to stabilize the reference?

> =20
>  		folio_unlock(folio2);
>  out:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903115018.2034=
541-1-yi.zhang@huaweicloud.com?part=3D1
