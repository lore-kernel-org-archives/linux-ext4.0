Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649CE4AA572
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 09:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789551914; cv=none; b=YiR71uXaLCGVNA73vTCGPADN2nnKZPrVvLdydI9s7FMLmVO4W4poAMXwthPw1m+5zxHKuOsnTla2f/eF3pwBy8wuJK5v90nIdUR4zNDp9dDeIOYbPnGhrdQARUMs19hqlV/heDng7R7AxYH0iuoZZZuVqlFT4+4pUoc6hwMDBPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789551914; c=relaxed/simple;
	bh=Tju1aGsFeQ0jaH2rBaXVexRg3ikPZ/rYuNuhv81497I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FsMq0E5iceYXGvAoZE5c9gQk4igOtH/mKI4tNrL7A4S/lL0RD+oaNTpfqbBc6R1TWM1glKlG1B/ZR4WSd3rZsyag9SDISLr+gj7TEXwXb2qOxYAxx4c3vqQMSSN9KTf+Q9HIJAR1scZ5UwalT78N/mmcNTyDadMQ/WU6BOKA2ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3dDiLY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3dDiLY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30061F00893;
	Wed, 16 Sep 2026 09:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789551901;
	bh=w7Crz+7eD3Whw2qVCzWydiQ1XN8KXDQvZpidqGyFeeo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n3dDiLY4Nc33s83qtt69R/kswhAzxjg07eg6610OZjVQ74drICJd3Ymus6O2kEgzx
	 SVTNSaBzhEyaX/fRJaS+7VFrygfoFNSELzjXIsbmFKwZZSeLoJLdhwES3nUFEg6+JS
	 vk5TXsRd8/TBEhDBaBecBvQZ8oKBihRV0spzVHZoXI5oxHDY+GLeXB1ULsqM7AIBg5
	 RpuoEp8JyExNHxAUIXV2ZCE8B1yyxQ+573Ijg0THy7HuKhLBeP/z0idiHTRBWMKzdy
	 41BMxbqfnrRQGcgP/8ZGnGSTUoFeEfjZKzjyJrBP+g/EdZpgThkbN9qhiT5aOLqcU+
	 ejfaJ3gfZ8YGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260916092450.654408-2-yi.zhang@huaweicloud.com>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 09:45:00 +0000
Message-Id: <20260916094500.C30061F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] mm: data loss in hole punch due to ABA in speculative folio lo=
okup
- [High] mm: memory leak in hole punch due to skipped successfully split or=
der-0 folios
--

commit 2e1b0dbca7f3fd72aa6840729db47e2498ff1268
Author: Zhang Yi <yi.zhang@huawei.com>

mm/truncate: fix data loss when splitting straddling large folios fails

This commit modifies truncate_inode_partial_folio to return out-parameters
pstart and pend indicating the fully covered page range safe to discard
after any split. This is intended to fix a data loss issue when splitting
a straddling large folio fails.

Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/

> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be474..bec6d881d0225 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
>=20
> [ ... ]
>=20
> @@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *fol=
io, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> +		pgoff_t end, aligned_end =3D (pos + offset + length) >>
> +					   PAGE_SHIFT;
> =20
> -		if (offset + length =3D=3D size)
> -			goto no_split;
> +		if (pstart)
> +			*pstart =3D round_up(pos + offset, PAGE_SIZE) >>
> +				  PAGE_SHIFT;
> +
> +		if (offset + length =3D=3D size) {
> +			end =3D aligned_end;
> +			goto out;
> +		}
> =20
>  		split_at2 =3D folio_page(folio,
>  				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>  		folio2 =3D page_folio(split_at2);
> =20
> +		/*
> +		 * folio2 may become stale due to a concurrent split or
> +		 * freeing, so validate it before and after taking its lock.
> +		 * If it fails, we can't get an accurate end position and fall
> +		 * back to folio->index, which may leave sub-folios split off
> +		 * at the offset edge in the page cache this round.
> +		 */
> +		end =3D folio->index;
>  		if (!folio_try_get(folio2))
> -			goto no_split;
> -
> -		if (!folio_test_large(folio2))
>  			goto out;
> =20
> +		if (folio2->mapping !=3D folio->mapping ||
> +		    !folio_test_large(folio2))
> +			goto out_put;

[Severity: High]
Could this lead to a memory leak if the first split successfully shatters t=
he
folio to order-0 pages?

If the hole punch starts in the middle of a large folio and the first split
successfully shatters it into order-0 folios (which happens when min_order
is 0), the tail page folio2 becomes an order-0 folio.

The speculative pre-lock check validates folio2 here:

    if (folio2->mapping !=3D folio->mapping ||
        !folio_test_large(folio2))
        goto out_put;

Because folio2 is order-0, !folio_test_large(folio2) evaluates to true.
Execution jumps to out_put without updating end to aligned_end, leaving end
initialized to folio->index.

When pend is returned as folio->index to the caller
(truncate_inode_pages_range), it is used as the upper bound for the
truncation loop. Because end is less than or equal to start, the loop
terminates immediately, skipping the pages within the hole punch range
and leaving them permanently leaked in the page cache.

> +
> +		if (!folio_trylock(folio2))
> -			goto out;
> +			goto out_put;
> +
> +		if (page_folio(split_at2) !=3D folio2) {
> +			folio_unlock(folio2);
> +			goto out_put;
> +		}
> +		if (!folio_test_large(folio2)) {
> +			end =3D aligned_end;
> +			folio_unlock(folio2);
> +			goto out_put;
> +		}
> =20
> -		/* make sure folio2 is large and does not change its mapping */
> -		if (folio_test_large(folio2) &&
> -		    folio2->mapping =3D=3D folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +		/* Split failed: back off to the head of the straddler */
> +		if (folio_split_or_unmap(folio2, split_at2, min_order))
> +			end =3D folio2->index;
> +		else
> +			end =3D aligned_end;

[Severity: Critical]
Does this speculative lookup handle the reallocation race correctly if the
folio is reallocated to a different file offset?

After the first split, the tail pages are added to the page cache and
unlocked. During speculative lookup, the tail page could be concurrently
reclaimed, freed, and reallocated as a new large folio in the same mapping
but at a completely different file offset.

The validation checks earlier and the page_folio check here will all pass
because the physical page split_at2 is part of the new allocation.

However, the file index of the folio is not verified. If this unrelated lar=
ge
folio fails to split, the fallback path assigns its index to end here:

    if (folio_split_or_unmap(folio2, split_at2, min_order))
        end =3D folio2->index;

This unrelated file offset is then returned to the caller via pend, which
can cause the hole punch loop to truncate an unrelated segment of the file.

Should we verify that the file index of folio2 matches the expected index
(e.g. folio2->index + folio_page_idx(folio2, split_at2) =3D=3D expected_ind=
ex)
before using it?

> =20
>  		folio_unlock(folio2);
> -out:
> +out_put:
>  		folio_put(folio2);
> -no_split:
> +out:
> +		if (pend)
> +			*pend =3D end;
>  		return true;
>  	}
>  	if (folio_test_dirty(folio))

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916092450.6544=
08-1-yi.zhang@huaweicloud.com?part=3D1
