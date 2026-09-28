Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F0823EA83
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 12:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790598697; cv=none; b=lcruktciLyMJ+kMJcdVNAOX94OkA2dIq9KaAWEHTd8BQXqbIlA0NePJH2kAIAHPQcIOP03K4Nfm9GbXtotMY3PDh08qBGKUnD/auraFY3Ml0+H6Xn3VstbLhPv9tGSerD9D5tNjwqDQvUo0Uau1eXxxLYdkym1ls1xB181VZ6W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790598697; c=relaxed/simple;
	bh=A+dby+zesU5B8A+NrfXEWrE7BNAKVq2mXOnXzHNF+10=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p9iE0pthQlmd7VGkq8MlJzQwiKzO4KllUqwQpjmEnzjJ2rhI+9CjU7nQmoSGVLTfwn2UbxNe8wiXoaLpkt59Wc08XoLEVK+OMyqgofHxobodyXh1py4G5IX4WBSMsGL3XGcNhpWUAhvZQCyVX7f9Zg6IhmqlWe33YauIvdBk8eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIm0HHGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIm0HHGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6891F000FF;
	Mon, 28 Sep 2026 12:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790598696;
	bh=UrvI8zEwV0JyxxNnrXj3RsgLvEZgXyOkWwxamvOT1RM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nIm0HHGoIbhBS/7UUYFHqoGsr4zIWSDDgiDvaEq1HWCbJvG/hVcKF9Mo1fgIWautA
	 0ZU2MheBtvbo1/Z3i6u3Mlve67MV/IEfYqBwsosXIgYUCB3j49PnMAhNyYybOpgNTF
	 TCDD5LLQM/aGCL/B+9pY+P/7g7odLskHQIxLIEGW6gu2A5mRverqP0wCdKqFZPXvsG
	 fznOMHwhpP1HLPHJXzODXr5On8XNgvXSTmDlxJJmppoYhKdw+1WJs7T7njzKyA+o5q
	 fV3CMU5eMlq3P8En9HO9BqqcIK9EZHFX1OlZyGdilVG6I7xIiIOFMKqNM/kvJqjcam
	 ZqUtHdaiiNWSg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260928120833.3440834-2-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
 <20260928120833.3440834-2-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 12:31:35 +0000
Message-Id: <20260928123136.2D6891F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] mm: integer overflow in round_up() during truncation causes co=
mplete file data loss
--

commit 583804d300760dcf60e3ec5aab6503a560ad3e7e
Author: Zhang Yi <yi.zhang@huawei.com>

mm/truncate: align truncation boundaries to mapping minimum folio order

When the mapping has a non-zero minimum folio order, this patch changes
folio_split() in truncate_inode_partial_folio() to stop at min_order instead
of order 0. It also aligns both start and end to the mapping minimum folio
order so they always fall on a folio boundary, preventing valid out-of-range
tails from being dropped.

Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=
=3DOWzVRgD4202y1g@mail.gmail.com/

> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be474..8a28f4a212677 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
[ ... ]
> @@ -395,6 +397,10 @@ void truncate_inode_pages_range(struct address_space=
 *mapping,
>  	else
>  		end =3D (lend + 1) >> PAGE_SHIFT;
> =20
> +	start =3D round_up(start, min_nrpages);

[Severity: Critical]
Could this round_up() result in an integer overflow that changes a very lar=
ge
start index to 0 on 32-bit architectures?

When an unprivileged user issues fallocate(PUNCH_HOLE) or truncate at an of=
fset
near ULONG_MAX << PAGE_SHIFT (e.g., 16TB on 32-bit systems) on a filesystem=
 with
min_nrpages > 1 (like ext4 with large folio/iomap), start approaches
ULONG_MAX (e.g., 0xFFFFFFFF on 32-bit x86).

The macro round_up(start, min_nrpages) performs 32-bit arithmetic. With
start approaching 0xFFFFFFFF, start + min_nrpages - 1 can overflow to a val=
ue
less than min_nrpages, causing round_up to evaluate to 0.

This would corrupt the start index to 0 in truncate_inode_pages_range(), and
the subsequent loop would unintentionally truncate the entire page cache fr=
om
index 0 to end, causing complete data loss of unwritten data.

> +	if (end !=3D (pgoff_t)-1)
> +		end =3D round_down(end, min_nrpages);
> +
>  	folio_batch_init(&fbatch);
>  	index =3D start;
>  	while (index < end && find_lock_entries(mapping, &index, end - 1,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928120833.3440=
834-1-yi.zhang@huaweicloud.com?part=3D1
