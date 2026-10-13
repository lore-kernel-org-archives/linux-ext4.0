Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B9C3B47E9
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 08:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791880792; cv=none; b=iinMKL+ZC1zh4w01ZeS0w78BOHbRtncYyXILFvPGt7VsdlWdI+HzCub1kTB3fTbkwNSORLSGISm7G97EVkX6M1OPOG5hCL8+fIEJXsq9VFeor0YtmyFVQVsDXEpStmguGv57Ss+Vx8yGXKvM1A+x2AzjhQ2bwNbLAGBRS7Iw03g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791880792; c=relaxed/simple;
	bh=IDAgdh9LWNQEk4tyfdyRNJbO9V/ivwbGusPISSawoQY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=YwUfgVhAtqwJDx2DM1KZlpAAQySA0AGtO2DkZR/5MCLjms3qHGtEiDzFVos6GLj1E6kJYaRI5wwg/6LweGSX43Ss8vXbJU3clyHJHatcZT/OwIufTcXdoCDxdGc06ULPmJsZ75DMdEc3nQDihRs9ULfH0tP/YZZ+9QHshsFD10Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOv10PkH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOv10PkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EEF1F000FF;
	Tue, 13 Oct 2026 08:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791880787;
	bh=KdsxShSbX+tF8kEiAN46LqSiIvQlm8/M5s/3ya7eAIY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dOv10PkH1SAbk2y9JZcD4ku8/h2VaDy21z8QxwmQRczucv96dkgXBhrEko5pTUCH5
	 PA/k2TKLYzvrdLCO4a+GUnJzsK08++Wq97HIEFe0VYOuBNwzVMmzm68aO7m8REsvIO
	 WwuFQTHf0+jRRwUpoaqBFz1waVodGDHGD3MFHaazb9MQu/qsVrs53ehDB+ZiTMC8eZ
	 Nvb3pRo1V6ujMAG6LpqEGzDjWwTCT03lH3yFjGqIzbmY/w6C0/hA6oGTYJNbEvqdA0
	 8iMOu4UjQpCZDgQbupbLKVLIe5c+LzmY4hfWnrQ6vU1F72EZCv3eCR1eSac7XO3+JU
	 0sAcu2HG2slxA==
Message-ID: <sashiko-outbox-169265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/2] ext4: check return value of blkdev_issue_flush()
 when initializing inode tables
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013082331.2089623-2-guolingxing@tju.edu.cn>
References: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
 <20261013082331.2089623-1-guolingxing@tju.edu.cn>
 <20261013082331.2089623-2-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 08:39:46 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ext4: information leak via uninitialized inode tables when lazy in=
it aborts
- [High] ext4: missing cache flush in no-journal mode exposes stale data du=
ring lazy init
--

commit 38a8b479f27a31839f98ff44865f5323825a1303
Author: guolingxing <guolingxing@tju.edu.cn>

ext4: check return value of blkdev_issue_flush() when initializing inode ta=
bles

This commit introduces error checking for the cache flush in
ext4_init_inode_table(). If the flush fails, the initialization is aborted,
and it updates ext4_run_li_request() to check the BARRIER mount option.

Cc: stable@vger.kernel.org

> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index f97a2f4904ebb..843a78fc6e51a 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
[ ... ]
> @@ -1611,8 +1611,11 @@ int ext4_init_inode_table(struct super_block *sb, =
ext4_group_t group,
>  	ret =3D sb_issue_zeroout(sb, blk, num, GFP_NOFS);
>  	if (ret < 0)
>  		goto err_out;
> -	if (barrier)
> -		blkdev_issue_flush(sb->s_bdev);
> +	if (barrier) {
> +		ret =3D blkdev_issue_flush(sb->s_bdev);
> +		if (ret)
> +			goto err_out;
> +	}

[Severity: High]
If blkdev_issue_flush() fails with an error like -EOPNOTSUPP, this will now
unconditionally abort the initialization via goto err_out.

When ext4_init_inode_table() returns this error back up to
ext4_lazyinit_thread(), the thread permanently removes the lazy init reques=
t:

fs/ext4/super.c:ext4_lazyinit_thread() {
    ...
    if (err) {
        ext4_remove_li_request(elr);
        continue;
    }
    ...
}

This leaves all remaining groups uninitialized. Could an unprivileged user
then force an uninitialized inode table block into the page cache (e.g., by
attempting to read a free inode via a stale file handle)?=20

If so, __ext4_get_inode_loc() would see the block is already in the cache a=
nd
bypass the on-demand zeroing fast path:

fs/ext4/inode.c:__ext4_get_inode_loc() {
    ...
    bh =3D sb_getblk(sb, block);
    if (unlikely(!bh))
        return -ENOMEM;
    if (ext4_buffer_uptodate(bh))
        goto has_buffer;
    ...
}

Would this allow an attacker to allocate a new file in that block and read
the uninitialized fields (like extended attribute space), exposing stale
disk contents?

> =20
>  skip_zeroout:
>  	ext4_lock_group(sb, group);
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7d8aedfbbb87f..7d882981bfabe 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
[ ... ]
> @@ -3827,7 +3827,8 @@ static int ext4_run_li_request(struct ext4_li_reque=
st *elr)
>  	if (!ret) {
>  		start_time =3D ktime_get_ns();
>  		ret =3D ext4_init_inode_table(sb, group,
> -					    elr->lr_timeout ? 0 : 1);
> +					    !elr->lr_timeout &&
> +					    test_opt(sb, BARRIER));

[Severity: High]
For all block groups after the first, elr->lr_timeout becomes non-zero,
meaning !elr->lr_timeout evaluates to false and barrier is passed as 0 to
ext4_init_inode_table().

Without the barrier, ext4_init_inode_table() skips blkdev_issue_flush(),
while sb_issue_zeroout() writes zeroes to the disk cache and the
EXT4_BG_INODE_ZEROED flag is set on the group descriptor.

In no-journal mode, without an explicit flush, could the disk reorder the
group descriptor write before the zeroes? If a crash occurs at the right
time, might this expose stale data to new users since the allocator assumes
the blocks with EXT4_BG_INODE_ZEROED set are already zeroed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013082331.2089=
623-1-guolingxing@tju.edu.cn?part=3D1
