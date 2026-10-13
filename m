Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EBA2749C1
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 06:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791873400; cv=none; b=lZ6VpRi/s44P/+gTF9mOVTwAwUSqbqhq8FNOtmJufAuM5gJbyGRm7nbx0BCTLdEo+HhbwzFb58JewO8Ft7vc5fdCUeiJSbw8Ovmv40LclEy8wuKmPfMX0umtMRlh4x//yjlNXgV2UEo8KJzfjFbJbdXz1t5ITr6ytdlw4iQ7GJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791873400; c=relaxed/simple;
	bh=U9qBEBIMLwdpGUrvPde286Ja4wmVtiU3bHuEkG/rRa4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cWpDR/8/Bchvok4ndnyUajpb3QcAA39DcT7ba6/i+Uafnb8uQ6GoDMFoQ0aW/o7v/4AX++bqmOhJAqPe7RgJxFMEdq//XG2xUwyXWZs6BgTsclLPrGW2cc2u59UBMM/oyeC9j74pnkj+D6X12kIlFjNOIpwZP2bV9a0JsJgAHH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gE+WUYku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gE+WUYku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F04A1F000FF;
	Tue, 13 Oct 2026 06:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791873398;
	bh=L3/Erne+rnhFHu09Mvh6eUr+B+BcpoLtRwvHxw8hG1w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gE+WUYkubHGtfUmj4NaLYupJWEK59/UvRbA4i5y4QZWQm1qZbU/4Lb9Q1EcxkKc0k
	 gIQ19XG0oNRmZPwdd3fZ1jkDWtMMfXXcnS3rL6SH1Za9OCw1N4dYtiiqyToMMAcU93
	 yZ4FIY/zIs8l551EWUg9NIuJNnufp1E7XD701e3yc97UjL0Z0bGe3IxA1WW7qYpe1x
	 YqE3eBzMtGg/HsZ76+Vszpr2zXw5ZkWxTfmkZ+OvZ5yQFglf02zNv/hmSzZbFg+dqW
	 sXM/EOnUdWqmjVUsCxMefSWUEEKScFbETFDI/nTyGALhs54c1T3v9SHRaU/FLdcnkh
	 P9bWezBuwDV5Q==
Message-ID: <sashiko-outbox-169109@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] ext4: check return value of blkdev_issue_flush()
 when replaying fast commits
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261013062618.1741670-3-guolingxing@tju.edu.cn>
References: <20261013062618.1741670-1-guolingxing@tju.edu.cn>
 <20261013062618.1741670-3-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 06:36:37 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ext4: regression causing mount failures on devices lacking flush s=
upport
- [Medium] ext4: severe mount delay due to O(N) per-inode fast commit cache=
 flush
--

commit 1d9ac3ed6ced15861bdc5e6964915fbce6a1b1e6
Author: guolingxing <guolingxing@tju.edu.cn>

ext4: check return value of blkdev_issue_flush() when replaying fast commits

This patch updates ext4_fc_replay_inode() to check and return the error
code from blkdev_issue_flush(). It intends to abort the fast commit replay
and fail the mount if the cache flush fails.

Cc: stable@vger.kernel.org

> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index ead8b16f9be07..f554405ebabfe 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2019,7 +2019,7 @@ static int ext4_fc_replay_inode(struct super_block =
*sb,
>  out:
>  	iput(inode);
>  	if (!ret)
> -		blkdev_issue_flush(sb->s_bdev);
> +		ret =3D blkdev_issue_flush(sb->s_bdev);

[Severity: High]
Does this code introduce a regression for devices that do not support cache
flushes?

If the underlying block device (such as certain loop devices, ramdisks,
or older flash media) does not support flushes, blkdev_issue_flush() will
return -EOPNOTSUPP. Ext4 usually ignores -EOPNOTSUPP for flushes, but this
change unconditionally captures and returns the error code to the fast
commit replay mechanism.

As a result, fast commit replay will abort and the entire filesystem mount
will fail on these devices.

[Severity: Medium]
Can this flush cause severe mount delays during fast commit recovery?

Because ext4_fc_replay_inode() is called for every inode in the fast commit
journal, this will trigger an O(N) number of full device cache flushes.
This can cause significant performance degradation when processing a journal
with many EXT4_FC_TAG_INODE tags.

Additionally, is this flush structurally redundant? JBD2 already guarantees
a final blkdev_issue_flush() on the filesystem device (journal->j_fs_dev)
in jbd2_journal_recover() after all recovery passes (including fast commit
replay) are complete:

fs/jbd2/recovery.c:jbd2_journal_recover() {
    ...
    /* Make sure all replayed data is on permanent storage */
    if (journal->j_flags & JBD2_BARRIER) {
        err2 =3D blkdev_issue_flush(journal->j_fs_dev);
        if (!err)
            err =3D err2;
    }
    ...
}

> =20
>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013062618.1741=
670-1-guolingxing@tju.edu.cn?part=3D3
