Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286B5463B98
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2026 12:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388542; cv=none; b=LcH+pRq4feAKRVdO5G/VuwBi7GssGv2gswK8vhxLi5tVOK67t6lTuIC0P78QPGJdmEZ3yfxeNu/Ox6t9YLiWCjodzXCpnVE/mPxNdpw0qfVlNyoO8XtSqprYwPaA8sjzI/sBKcoA3KyVCpOEQsyccKS4O7mfDi172eWHCiTpY5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388542; c=relaxed/simple;
	bh=d+rey0nCSeg7dkfjQe4aSsqqXQ6oeE6NZ3Fc3x8rYNA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SoJnuOSF1wp+PP7RA3m8a/lkFcQvvs6791DhYhPlhWs0yF+5mzdvd8ZyRb8aiSeufNSKuH0Ah88sH6DfeoB87GFuKbfIEKZ8DMq2SPwrTMRWgYaWpKA/NFr9qa3BhWD5pPFIQV8LJSYnC7BEl7GOaKpvGFryfr+IX5YFDHfROXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxYKDm/O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxYKDm/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D05C1F000FF;
	Mon, 14 Sep 2026 12:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789388540;
	bh=7CvXg8+iiXaDuitpxAapZXd8U43ZC6fAT4LIVx+oN5U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RxYKDm/OgJgaohEI7Dg5fm5+2vw5YA57ghYMwSYInl8oHmY/KALpy6Ze6EJ7dHuAw
	 he8uIZlQQSGfpE6I7osxcHgzuS8vuQ1C2/r9t3gIVfQJsnpz+gOw4tkkLvt9G8pYnu
	 HJ4qG2JQEzb7WTrdGbC3U5IDbSB9sAtSqILDNNwIOtd+L/9dhvK6gDZ45qukRo71Z+
	 v79thTlwnzhAa6xjOMnP2VAGJkCnCvISKHhs60xvxRaiBVgzhdUGShMwPhz21ECQ+o
	 7ThpR/46pJjgo74GkKHFLNRt49gfN5eNwuv6I/jNwGfhPYu4FLvSyBJ6wz+RfIfpZs
	 V1Yg4N86gLqxg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: propagate errors from fast commit i_blocks
 replay
Reply-To: sashiko-reviews@lists.linux.dev
To: lty <781735889@qq.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <tencent_BCDA824359279D18963B838B15B01BC1CD06@qq.com>
References: <tencent_BCDA824359279D18963B838B15B01BC1CD06@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 12:22:20 +0000
Message-Id: <20260914122220.9D05C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Incomplete error propagation in `ext4_ext_replay_set_iblocks` when=
 encountering an empty extent leaf.
--

commit d0296b8bc160aac911c99a12a53e4f06189bb5cd
Author: lty <781735889@qq.com>

ext4: propagate errors from fast commit i_blocks replay

This commit modifies ext4_ext_replay_set_iblocks() to stop calculating
blocks and propagate errors when mapping fails. It ensures failures from
extent lookups abort the fast commit inode replay.

> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c

[ ... ]

> @@ -6291,15 +6291,19 @@ int ext4_ext_replay_set_iblocks(struct inode *ino=
de)
>  	numblks +=3D path->p_depth;
>  	while (cur < end) {
>  		path =3D ext4_find_extent(inode, cur, path, 0);
> -		if (IS_ERR(path))
> -			break;
> +		if (IS_ERR(path)) {
> +			ret =3D PTR_ERR(path);
> +			goto cleanup;
> +		}
>  		ex =3D path[path->p_depth].p_ext;
>  		if (!ex)
>  			goto cleanup;

[Severity: High]
Since ret is 0 on a successful extent lookup, does this branch silently ret=
urn
success when it encounters an empty extent leaf?

If an empty leaf (!ex) represents a corrupted extent tree, should this set =
an
error code like -EFSCORRUPTED before jumping to cleanup, so the fast commit
replay can properly abort?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_BCDA8243592=
79D18963B838B15B01BC1CD06@qq.com?part=3D1
