Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDC13DDDB0
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 07:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789370845; cv=none; b=Y4qcupqCjMGLP0oGBGhPH5e3fpwAyIaINz2AqWRSTU7pzpWQchvV7lRVg33Pht6GQehTo2jlL1iROUAGvuFDRFPamwb6uZk+TdVWeTxiJGbx+LUZK+GPnq9Cke3M6NQQpTIqVSeBbE9nDN4TLTCgaz2VFIcljrTUe3VxW6p/G84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789370845; c=relaxed/simple;
	bh=CVSZ6pCIUTdohRrqT0kLpzT31+uiyldwGYsSEKHOLq4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J+Zhv66gxnDn1CnocIHh91rISMNlhzX6GkAavelaPTfKL8L+jp7xydvAswX/Ldhfb7FStmDLFs9Kjz73E+depQcCkJZXtb+60faq3qHk5wXWOWyddVr69q/U/BUaI/DqW27+5K81rmLBjQFnmkZN3XzfUNx+UUK2W3SSHHKK15M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gN9zyb1a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gN9zyb1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7101F000FF;
	Mon, 14 Sep 2026 07:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789370838;
	bh=umUeGQJaQdrJBT2qhTCYZaoTxolf9bQZRZVjJL/pPo8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gN9zyb1aTslcjenNpzoy34usAQ+PSPsSrnNoXPUs9i7DxtCdjO8ToS5I4c8WDwfTw
	 EG7Kf2XvVG8T4Tg4lAaRHCAZSpQnvVDbUrW1h4CVqaEJkMSRY1PQ9WYu/+RIWTQtG4
	 QUc9ohTnTBwaplfSZfyPxwrPmIPY9LECgWJByZe4CAu22TnildSHLcEQZY3SrLSpOZ
	 aHD+rJGYeHpuk0kjYaCHcwJsy9YJFJC2MEl2kjEn35LryUHE6Io4p2NxNGU+BGlXoC
	 4FuaDcYUaJVbxKU/xId2tt3ZXKlG+0ESw4ZIAkstt3NVJ+ZR/E2hlYO4RcDxwiYIdW
	 fkbS77pq1bN5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: propagate errors from fast commit i_blocks replay
Reply-To: sashiko-reviews@lists.linux.dev
To: lty <781735889@qq.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <tencent_46F42EDFC0F504046B160E939DB76255EE08@qq.com>
References: <tencent_46F42EDFC0F504046B160E939DB76255EE08@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 07:27:18 +0000
Message-Id: <20260914072718.AA7101F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch fails to fix error handling in the second loop of ext4_e=
xt_replay_set_iblocks(), leading to partial block counts being applied to t=
he inode and masked errors.
--

commit 561c6a78544da466ba6d1525d42b474f54d2d473
Author: lty <781735889@qq.com>

ext4: propagate errors from fast commit i_blocks replay

This patch stops ext4_ext_replay_set_iblocks() from calculating partial
block counts when ext4_map_blocks() fails. It leaves i_blocks unchanged
and aborts inode replay on errors.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 76038b6c36552..d67e30cf44adb 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
[ ... ]
> @@ -6329,11 +6329,11 @@ int ext4_ext_replay_set_iblocks(struct inode *ino=
de)
>  out:
>  	inode->i_blocks =3D numblks << (inode->i_sb->s_blocksize_bits - 9);
>  	ext4_mark_inode_dirty(NULL, inode);

[Severity: High]
This isn't a bug introduced by this patch, but does the second loop in
ext4_ext_replay_set_iblocks() still suffer from the same issue?

While this patch correctly captures errors from ext4_map_blocks() in the
first loop, failures during the extent tree block counting phase still jump
to the out label:

	while (cur < end) {
		path =3D ext4_find_extent(inode, cur, path, 0);
		if (IS_ERR(path))
			break;
		ex =3D path[path->p_depth].p_ext;
		...
		ret =3D skip_hole(inode, &cur);
		if (ret < 0)
			break;

If any of these break conditions occur, we hit the out label shown in the
diff context above and blindly overwrite inode->i_blocks with an incomplete
numblks tally.

Additionally, if ext4_find_extent() fails, we don't propagate the error code
because ret might still be 0 from a previous skip_hole() success. This allo=
ws
fast commit replay to silently corrupt metadata while returning success.

Should the error paths in the second loop also jump to cleanup instead of
out, and ensure ret is updated to PTR_ERR(path) on lookup failures?

>  cleanup:
>  	ext4_free_ext_path(path);
>  	ext4_free_ext_path(path2);
> -	return 0;
> +	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_46F42EDFC0F=
504046B160E939DB76255EE08@qq.com?part=3D1
