Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66858384224
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991265; cv=none; b=AkvaFm6F+sfmadQjzoh4VeSnbRgvfPDf6DluNn0zo8eRDglahogQfaVIMAZt4YPqyCAoKQqeD8Br3cHwNCekR+B/gAoVNdyCcLWlO571wIkSeF2R80ZcWzO7gMBkPZynTfQ7opSLrbH0Z0cN08ym70m6tEbxWf1HdPBPlqg1vYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991265; c=relaxed/simple;
	bh=71aF5Re8001dOR8w/NauwNq/Z4pyZEpGU497PZMGRWE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UQf70vlZoZDcToVIwzU2Bj/b8Tugb+iG5zxxPlLDoWanIcJl9q96Fkx1BDjzhDtpAgaHTCe7scRfYDIbXGZVzcMjwHd8XhYN0rCS0AxGvICk4/uOKKK4MiPFW3rLZTltf2IhHnTWTAhOtlkCpHsr+o2HEtD5lkNVWSA2P1DRnDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jPyo05Pw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jPyo05Pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BC41F000FF;
	Sat,  3 Oct 2026 01:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991264;
	bh=DbIzpBVN3WRd7NTzQMjDbnLE/zFKPQ+K6jvKXl2+ERU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jPyo05PwPwv2tk+Mbzf8HcytvfQvPKrmMF9mN1+yH0DUBcBje8Swqf55aH8iZInnm
	 HLIy2WH5eckZt4iz8A2oAMT6SIaLaqxrUyFn6zMebKngruj1JXWdZRjsXjmjBjbXOY
	 j40HaU+B6tqhLPOY4jjmPi1kysJ+Gsu0vMnRMtMkEnBqbySry7dzkBkZstlF8Lbg7b
	 /GiqwMA5ow/qh/hLk862lIHttlNORUAs2TjgNWHQ6kUIgTeC7Sck3O6lqkPtfk03s4
	 VBldvUTyB4+x/LTkleQHZjTTrH7ZI+IVKzi/4BaHx1Z+Ag3fW4//gd+3lPeMj7xIZN
	 7f9voUaEFjw5Q==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 19/21] xfs: check and repair the verity
 inode flag state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, dsterba@suse.cz
In-Reply-To: <20261002223705.2175542-20-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-20-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:23 +0000
Message-Id: <20261003013424.08BC41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] xfs: scrub aborts on fsverity validation errors -EINVAL and -EFB=
IG
--

commit 856d4488769e21ab11188de2cd348b2c2b9cb631
Author: Darrick J. Wong <djwong@kernel.org>

xfs: check and repair the verity inode flag state

If an inode has the incore verity iflag set, make sure that we can
actually activate fsverity on that inode.  If activation fails due to
a fsverity metadata validation error, clear the flag.

> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index e5233e31abb75..ebbef3afb7d6e 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
[ ... ]
> @@ -1754,3 +1756,54 @@ xchk_inode_count_blocks(
>  	return xfs_bmap_count_blocks(sc->tp, sc->ip, whichfork, nextents,
>  			count);
>  }
> +
> +/*
> + * If this inode has S_VERITY set on it, read the verity info. If the re=
ading
> + * fails with anything other than ENOMEM, the file is corrupt, which we =
can
> + * detect later with fsverity_active.
> + *
> + * Callers must hold the IOLOCK and must not hold the ILOCK of sc->ip be=
cause
> + * activation reads inode data.
> + */
> +int
> +xchk_inode_setup_verity(
> +	struct xfs_scrub	*sc)
> +{
> +	int			error;
> +
> +	if (!fsverity_active(VFS_I(sc->ip)))
> +		return 0;
> +
> +	error =3D fsverity_ensure_verity_info(VFS_I(sc->ip));
> +	switch (error) {
> +	case 0:
> +		/* fsverity is active */
> +		break;
> +	case -ENODATA:
> +	case -EMSGSIZE:
> +	case -EFSCORRUPTED:
> +	case -ERANGE:
> +	case -EBADMSG:
> +		/*
> +		 * The nonzero errno codes above are the error codes that can
> +		 * be returned from fsverity on metadata validation errors.
> +		 */
> +		return 0;
> +	default:
> +		/* runtime errors */
> +		return error;
> +	}

[Severity: Medium]
Should -EINVAL and -EFBIG be included in the allowed validation error codes?

A corrupted fsverity descriptor on disk can trigger
validate_fsverity_descriptor() to return -EINVAL or
fsverity_init_merkle_tree_params() to return -EFBIG.

Because they are omitted from this switch statement, they fall through to t=
he
default case and return the error, aborting the scrub setup instead of
gracefully marking the inode as broken and continuing the repair pipeline.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D19
