Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A709535FC9
	for <linux-ext4@vger.kernel.org>; Tue, 22 Sep 2026 11:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790076432; cv=none; b=RCBLG3zvghCZ2NctRU6BpYnpXbxwu/bjgOqDZ7FtxWT//DcSZmp9nEAcaTAwtSQgosCg59PPJ0D4C0CU1Xa1t78VuVwaq5HAsBncqbcL0vAcbITdwaGcYK18I7sjm4prLWt5XDrAnURIN3SXzTBpDDUISQUw+d1AW1+nhJPGcgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790076432; c=relaxed/simple;
	bh=eXQq7C3k9W58eHq8WZhHfhBqOhY8h7u7ACB4BppEqgU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tYbvvD4owbCnB59s6hxW8GTtTeRgeLpwWxROC24Ikg8WQThZLbSqjXU+xJU7AvRpUihyDxLH2Wx3scag5fBRgxW6dHh4zcjewzXORY3b8pCiJQbV7TH9yXpFthZh6KqKeEBWjXVHHhj04MI2X2AHRD+V6rQxGVie0DphHwMwKJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFgl3huf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFgl3huf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1319E1F00898;
	Tue, 22 Sep 2026 11:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790076429;
	bh=SxVFJXIbtxFQc7WvetC46qvyGFEIw9HmfsJmTBnulzs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZFgl3hufr8SjqoFcW9idX9LpuE8dvr8U7LHgnItoHYMgz3LOAbmw3IrkWV6Cmuj9W
	 3EDzemSY97Xfzo3R98T8fkyEOVXPXAHSKUORB2E0xQFQao1l1fqYjiAj59CtYe/k9J
	 r7lV34ZjeWVAlSnXHYOpGLqK8FBcqemH7Qd+Wr/tGYC/DCD3/yiLrQ5Kb6+QYBmvWz
	 0KgCBFop6+wdry17T8PFvGZLwNsiR/nTqunhKLxYovZfsfBEyau6resBVr6rMTnSlC
	 Eck0kjmIKbOX19bnlq/7QEqV/9r44ngKte6blPyO/fFHWIhRuDcnWRAXvq1Hr/B74V
	 CyW5mc3bUalPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260922110703.468389-2-yi.zhang@huaweicloud.com>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 11:27:08 +0000
Message-Id: <20260922112709.1319E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] mm: integer overflow in truncate_inode_pages_range causing dat=
a loss
--

commit e346e0885d48b84feb918a7c5125a3b206d6bba7
Author: Zhang Yi <yi.zhang@huawei.com>

mm/truncate: align truncation boundaries to mapping minimum folio order

This commit aligns the start and end truncation boundaries to the minimum
folio order of the mapping. This prevents valid out-of-range tail sub-folios
from being incorrectly discarded when a mapping has a non-zero min_order.

Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=
=3DOWzVRgD4202y1g@mail.gmail.com/

> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be474..f9625bb4916f9 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
[ ... ]
> @@ -374,14 +376,14 @@ void truncate_inode_pages_range(struct address_spac=
e *mapping,
[ ... ]
>  	start =3D (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
[ ... ]
>  	else
>  		end =3D (lend + 1) >> PAGE_SHIFT;
> =20
> +	start =3D round_up(start, min_nrpages);

[Severity: Critical]
Can this integer overflow on 32-bit architectures?

In truncate_inode_pages_range(), pgoff_t is a 32-bit integer on 32-bit
systems. If a hole punch or truncate operation occurs at an offset near
MAX_LFS_FILESIZE, the start page index will be close to 0xFFFFFFFF.

When min_nrpages > 1 (e.g., on filesystems supporting min_order > 0 like
Ext4 with bigalloc), rounding up this index wraps it to 0.=20

Would this wrap-around cause the entire page cache for the file to be
truncated instead of just the intended tail, leading to data loss?

> +	if (end !=3D (pgoff_t)-1)
> +		end =3D round_down(end, min_nrpages);
> +
>  	folio_batch_init(&fbatch);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922110703.4683=
89-1-yi.zhang@huaweicloud.com?part=3D1
