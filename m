Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6B14582E7
	for <linux-ext4@vger.kernel.org>; Wed, 16 Sep 2026 09:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789551921; cv=none; b=ZeF/94X5a9RUA7ktL14gp5tHXb5W4WHObT0SR9iqhf5ZUnCe5KB3fOAM3Tm7MSc0dJGul8jgCvE5wkegmqoZQld701HrrM5rKfA9V87osbJF+BjL1SCKQb0hFSR4iGMDK6PB+BwFm2bSD9U2gUqARYAbdbrrqAkycYqB/QJ8r/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789551921; c=relaxed/simple;
	bh=/Wrun5apwLsF40Squ1I7iY2YiqxxGM+j7SluxFhCkQc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RUsNxgCZbfj8t5NHWzGtjnLYDKGITQzGo1V727RpbLdNNraWeV+oG4t57bCIPcO6zLI7P8GcN98zrOLafeOJKj6htALqgiTXNyEJoha4o9stTSYJI7yHmGicErux80oOmcTKCpFEvJF1Z1HPzcxfVz5Q8iaftSxr8+SJ7TJXWe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+wo+77D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+wo+77D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B42F1F000FF;
	Wed, 16 Sep 2026 09:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789551911;
	bh=/qV7ZzGbaHsx8Pb+A2n27STkJPgUvdwL3zpHcGfH2bY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i+wo+77DkhfS9gGqwPt/vrNJH0RXS3fglo7rvLiEgRC3Fey0FC4VuZUT/8lA77ntm
	 s/BREwleeImZrK1hFds4pptNGM8aTV89/6S4PNT33YyPGFVuMI8Rxk1reTxCXkOcgQ
	 HYTNdiXhewABfCd4YyG6GjCaq0c0JwRZOVguy0vIUxfWnCmd25itnQcPCwI15e0wH1
	 Wbfp/qgLZt8kLDYcouvaXseN72C60YdvAiaZnrKQipD/OIgG3QGWA4WUUxa8AnKVvu
	 yunVzhFOi4xlGuF3z62dloOOA2j8ZNm5EjaPpFB0DJGop1bcNOJdJnDkc4O4aOBIag
	 ySo/4sfYNHfjw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] mm/truncate: clarify return value of
 truncate_inode_partial_folio()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260916092450.654408-4-yi.zhang@huaweicloud.com>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-4-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 09:45:11 +0000
Message-Id: <20260916094511.9B42F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: sub-folio page cache leak due to incorrect end boundary on spl=
it failure
--

commit 4bfa9d8fcd26bcd7a9625b0b4e4d07b1e0a6b145
Author: Zhang Yi <yi.zhang@huawei.com>

mm/truncate: clarify return value of truncate_inode_partial_folio()

This commit updates truncate_inode_partial_folio() to clarify its return
value semantics. Callers now use the return value strictly as a flag for
loop resetting, and rely instead on the pstart and pend out-parameters
to decide whether to adjust the truncation range.

> diff --git a/mm/truncate.c b/mm/truncate.c
> index 5ab7a40b1e256..23c90f00b5300 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
[ ... ]
> @@ -331,10 +330,9 @@ bool truncate_inode_partial_folio(struct folio *foli=
o, loff_t lstart,
>  			*pend =3D end;
>  		return true;
>  	}

[Severity: High]
With the new caller dependency on pstart and pend instead of the return
value, can this error path cause a sub-folio page cache leak?

If truncate_inode_partial_folio() is called for a range within a single
large folio, and the first split succeeds, *pstart is advanced. If the
second split attempt fails early during folio2 validation, the code behaves
as follows:

mm/truncate.c:truncate_inode_partial_folio() {
    ...
    end =3D folio->index;
    if (!folio_try_get(folio2))
        goto out;
    ...
out:
    if (pend)
        *pend =3D end;
    return true;
}

Does this set *pend backward to the start of the original large folio?

If this results in a situation where *pstart is greater than *pend, will
the caller bypass its discard loop entirely? This seems like it could
permanently leak all successfully split sub-folios in the range within the
page cache. For hole punches, could this result in reading stale data
instead of zeros?

> -	if (folio_test_dirty(folio))
> -		return false;
> -	truncate_inode_folio(folio->mapping, folio);
> -	return true;
> +	if (!folio_test_dirty(folio))
> +		truncate_inode_folio(folio->mapping, folio);
> +	return false;
>  }
> =20
>  /*

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916092450.6544=
08-1-yi.zhang@huaweicloud.com?part=3D3
