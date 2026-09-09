Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDA739CD09
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 06:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788936210; cv=none; b=Im2iVHTv6BrRvFjd2uSBiKNJbpQ03j8c6ys4nJMaIweuQeYFTyPwT1Aew7HPka0yES82hsb02PM9KgHwOX/uRkF2dlvJxPzBMWjKIXEbaI/3tNFGOQmJ/n2UJEcDWjYE54TWZlAhmpRzFWkzsmBvpYl9bRP/cuqC1zQRKL43Z1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788936210; c=relaxed/simple;
	bh=K8cCA/ztBVf1waxu5zKk24fr0RR6OF0jdYwGmmDR3mw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NRsePqk4H/HkcYKQbeXPtra/KLUsuMla3qe41vYBB1zbl2YR9BADRks7OMehyWsoe0XJytsOTkrjbKYIiTC5GEIA+llbNWjXa3fLBRvm7k2LSdKx2EroFG4/Iftuqr267F/oAWqHH5TULuXQNPiln1nKZozpyKxsNmdtE9fJB+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UZsU5U2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UZsU5U2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B50C1F00A3A;
	Wed,  9 Sep 2026 06:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936207;
	bh=CIoiv2DGPdEbvdLdZEGXCvc/8Ccm3p1jdpzq2PwfNwc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UZsU5U2k+TZY7B1HnLH2XTUSqFI3eI6oadrRDzpx0XLFRdExoRDyeRs8MFxsGIxAG
	 HgCmFv0Mu8P8KAB5/YlBgG/LNJTP4ud3S5kqv7AplQ/L1NvRvt0Fryr27Ts92O5XPi
	 /aP8XgCa33tw77fFRkKOYUDwtgwZSr9lINonYoHJ7sGAXNJH8B09w+6o7hSH5B6evL
	 IziDzp3+oZWw0iD1hVBy/dkPzeA/3Uk2dSS/Mhib+hqPIWRXoIeAbJ8DYtAGaGGawT
	 7aFjZnwj2pcrOSkSvq8Fzbbw21WN1EWRMyLMQE1omqQn1qeAJQwiBvX5ROKaRU/ZuL
	 XTsbR1RHvOaUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating
 straddling large folios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 06:43:26 +0000
Message-Id: <20260909064327.2B50C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Speculative folio access without proper re-validation causes c=
orrupted truncation bounds and massive data loss.
--

commit fca88c7c0a18efec3a5bc4b07763e9cc7f4d03f7
Author: Zhang Yi <yi.zhang@huawei.com>

mm/truncate: fix data loss when truncating straddling large folios
   =20
This commit fixes a data loss issue where a straddling large folio
might be incorrectly truncated if the second split fails. It modifies
truncate_inode_partial_folio() to clarify return semantics and return
the safe-to-discard page range to the caller via out-parameters.

Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/

> diff --git a/mm/truncate.c b/mm/truncate.c
> --- a/mm/truncate.c
> +++ b/mm/truncate.c

[ ... ]

> @@ -259,38 +266,67 @@ bool truncate_inode_partial_folio(struct folio *fol=
io, loff_t start, loff_t end)

[ ... ]

>  		if (!folio_try_get(folio2))
> -			goto no_split;
> +			goto split;
> =20
>  		if (!folio_test_large(folio2))
>  			goto out;
> =20
> -		if (!folio_trylock(folio2))
> +		if (!folio_trylock(folio2)) {
> +			tail_isolated =3D false;
>  			goto out;
> +		}

[Severity: Critical]
Can jumping to the out label here bypass the validation of the
speculatively looked-up folio?

If folio2 was evicted and the physical page was reallocated to an unrelated
mapping (like an anonymous THP) right before folio_try_get(folio2),
folio_trylock(folio2) could fail because the new owner holds the lock.

> +
> +		/*
> +		 * split_at2 may no longer belong to folio2 due to concurrent
> +		 * split. Retry to find the correct folio in case it's still
> +		 * large.
> +		 */
> +		if (page_folio(split_at2) !=3D folio2) {
> +			folio_unlock(folio2);
> +			folio_put(folio2);
> +			goto retry;
> +		}
> =20
>  		/* make sure folio2 is large and does not change its mapping */
>  		if (folio_test_large(folio2) &&
> -		    folio2->mapping =3D=3D folio->mapping)
> -			folio_split_or_unmap(folio2, split_at2, min_order);
> +		    folio2->mapping =3D=3D folio->mapping &&
> +		    folio_split_or_unmap(folio2, split_at2, min_order))
> +			tail_isolated =3D false;
> =20
>  		folio_unlock(folio2);
>  out:
> +		if (!tail_isolated && pend)
> +			*pend =3D folio2->index;

[Severity: Critical]
Does this assignment risk reading folio2->index from an unrelated folio?

If the folio_trylock(folio2) failure above jumps here without re-validating
that page_folio(split_at2) equals folio2, we could read the index of a
completely different folio.

If that happens, could truncate_inode_pages_range() receive a garbage,
arbitrarily large index for its truncation end boundary and unintentionally
drop all pages up to that index?

>  		folio_put(folio2);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909062339.4738=
16-1-yi.zhang@huaweicloud.com?part=3D1
