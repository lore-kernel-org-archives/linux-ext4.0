Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD6023C4F3
	for <linux-ext4@vger.kernel.org>; Wed,  9 Sep 2026 03:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925751; cv=none; b=kGDuMhB8zKZSBSkukvww3b71NLEZbACJYEcaeFuDIQBAJA+uUS/llC0OBMht8XtCzi90+5pSmcQq5qI3QWGsOH+97QrixQwwmr1Jjaf7AdN6AvYGzZdvYYyok68/3IMMw+VvKD8JzPcvNcB4xry67qCNvPWRftYoif0NzV5lwCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925751; c=relaxed/simple;
	bh=ybGXfFNJRU56K7Lgx4Zhy3ZdvUEUypUYV/sRjJQ9Dd8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IlXedZPPEZ5KHqdpBtQb7wMY9RTtWtvCbD3fluBWG8dbY8z5P+5nwNO7xcSEtGPOKtKbWbx38GH85SRXhP3h+q7wTN+3kUJgsoopWtMbPIR5J3xeauayADQAZLW+lE4EqJE4++HldcVpo9G44+6OD/3wn23pAUD0JpwR/yRDjIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IIxxjxfw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IIxxjxfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AFF1F00A3D;
	Wed,  9 Sep 2026 03:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788925750;
	bh=I+RoKGDpHPZwVochM/LNWGpEPJ0DyDorLQgsvQzBuPs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IIxxjxfwRSALlWhHGFAgCd1NWFCl+su9CGhFwDpluGqbNtr9Z2PdmBs1S04oS25yE
	 jh705fE2KprrPwV3EJd/VHxxWbRr7m+NznVEc7hVjx0Wuvn4dpQHzRAmhXFG6bqYdM
	 0bQmS5svWHbfnOBuSwGkxxs3/7zoqJm4rUNihQP8yiypDGS+N3akXFrbMSHKRwc2Q8
	 H1RaHoYbnXG3QWnlE38UCAK1aP4OedFkVJg4E5LtPg0SJVKJvHCzjs1uKPIKe5PJb2
	 w16oDBaXFaUtoVrRlHdTV2H2z25Z1mWxGg/I8Q2LLuJCn+1bMwVJQdFemNA/ZX2AEx
	 BVKp5CUBDp1jA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: clear journal restart indication after inserting
 extent
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yichong Chen" <chenyichong@uniontech.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260909033542.3087876-1-chenyichong@uniontech.com>
References: <20260909033542.3087876-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:49:09 +0000
Message-Id: <20260909034909.E9AFF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Preexisting bug: `update_extent_range` does not cap contiguous=
 block accumulation at `EXT_INIT_MAX_LEN`, leading to silent data corruptio=
n during migration.
--

commit 7520d7fb83f021805cdf612c9f4b9753118b3505
Author: Yichong Chen <chenyichong@uniontech.com>

ext4: clear journal restart indication after inserting extent
   =20
ext4_datasem_ensure_credits() returns 1 when it successfully restarts
the transaction. finish_range() leaves that value in retval when the
subsequent ext4_ext_insert_extent() succeeds.

> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 5d60ef10fe110..d467b5a13c62e 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -53,8 +53,7 @@ static int finish_range(handle_t *handle, struct inode =
*inode,
>  	if (retval < 0)
>  		goto err_out;
>  	path =3D ext4_ext_insert_extent(handle, inode, path, &newext, 0);

[Severity: Critical]
This is a pre-existing issue, but does update_extent_range() fail to cap
contiguous block accumulation at EXT_INIT_MAX_LEN?

If a local user executes chattr +e on a file they own that contains a
contiguous block allocation exceeding 128MB, update_extent_range() appears =
to
aggressively merge blocks that are physically and logically contiguous with=
out
bounds checking:

fs/ext4/migrate.c:update_extent_range() {
	if (lb->first_pblock &&
		(lb->last_pblock+1 =3D=3D pblock) &&
		(lb->last_block+1 =3D=3D lb->curr_block)) {
		lb->last_pblock =3D pblock;
		lb->last_block =3D lb->curr_block;
		lb->curr_block++;
		return 0;
	}
    ...
}

Could this create an extent larger than 32768 blocks? When finish_range()
creates the extent:

fs/ext4/migrate.c:finish_range() {
    ...
	newext.ee_len   =3D cpu_to_le16(lb->last_block - lb->first_block + 1);
    ...
}

Will this unbounded length assignment to a 16-bit field cause truncation or
set the unwritten flag for values > 32768, potentially leading to silent da=
ta
loss during migration?

> -	if (IS_ERR(path))
> -		retval =3D PTR_ERR(path);
> +	retval =3D PTR_ERR_OR_ZERO(path);
>  err_out:
>  	up_write((&EXT4_I(inode)->i_data_sem));
>  	ext4_free_ext_path(path);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909033542.3087=
876-1-chenyichong@uniontech.com?part=3D1
