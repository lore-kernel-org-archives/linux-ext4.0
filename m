Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD233876B3
	for <linux-ext4@vger.kernel.org>; Tue, 13 Oct 2026 07:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876959; cv=none; b=IgTkiNgjEX8BnRPdIjcbGWiOoCPt5GlWHBnBi7HiTC++zSFH75sQzdh6FK2GO8zd3YQ5uMxjqP2iiYkwwEBq8gA+4pxNEN41HLWGzV+AFhLxnYbMyiI+MK7kCzdGRtnSvPyXDswSOsOvLh78a+kVrla78qi/Cge4msXjVojp/48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876959; c=relaxed/simple;
	bh=eS1a6dOS5eAx6r1KQIKOBf0ZyXpNFyeWZPLl+a8JZ8s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=rctadlGx+NkFyZgvYO5koHeu2hlbNJVbbkSMaKAIukinY/CedY6y/5EpZjkmKwIcVvcggdvYt6v3pHUm9kbFW4A0cMUnlTyjJ3OKE/Vgo7ebi/bElq8A2JougiEjuRrF29YlRXTizfvcfa3m3TXKpSWTXmfxovW8M06F8/EPbRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fmi/vp2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fmi/vp2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869391F000FF;
	Tue, 13 Oct 2026 07:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791876957;
	bh=eS1a6dOS5eAx6r1KQIKOBf0ZyXpNFyeWZPLl+a8JZ8s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fmi/vp2D7c9rKwvOykQrxoX7H0w/rHg5PN2UX5+6Y0poi+7H9W3FnkOMWzPfnKd4s
	 f/HVPyUKEjseHUNFx21sh8R9hhJyzxEBrVu3CXyRnxej4OzUU0JoxcdJo9vto+zHNm
	 56oeG0pxe85m0qsBN+8MRapAskVLROI1vkU7D5LIhTWlIsBeb3LufcbM0PhKaFghjt
	 a+zOY2XClwuhvLZHU6eWBtYaA+Z/FqwzD0KkQtH19t9RVPtSZJh2n4flZyIyO+BRqj
	 W3cDcnKOHLnvm6c+Wtjn1rKvU4CeZ+nkOki1zl0PPlatI7jzAx/FHdkLAPl3Ar4SW+
	 8cD1lCekrYoOQ==
Message-ID: <sashiko-outbox-169190@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: spread files of sibling directories over a flex
 group
Reply-To: sashiko-reviews@lists.linux.dev
To: "Daejun Park" <daejun7.park@samsung.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261013-ialloc-flex-spread-v1-1-9ea1d86961aa@samsung.com>
References: <20261013-ialloc-flex-spread-v1-1-9ea1d86961aa@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 07:35:57 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Daejun Park <daejun7.park@samsung.com>
>=20
> On a flex_bg file system, find_group_other() puts a new file in the
> first group of the parent's flex group that has a free inode. Orlov
> usually keeps a directory below the top level in its parent's flex group
> and packs directory inodes at its start, so the files of sibling
> directories come from the same group and get consecutive inode numbers.
> The flex_bg path was added by commit a4912123b688 ("ext4: New
> inode/block allocation algorithms for flex_bg filesystems"). The
> non-flex_bg path instead adds the parent's inode number to the starting
> group once the parent's own group has no free inode or block, so that
> the files of different directories which share a group land in
> different groups.
>=20
> When several tasks create files in sibling directories at the same time,
> [ ... ]
> retry only with a group below the number of groups.
>=20
> Update the description in Documentation/filesystems/ext4/allocators.rst.
>=20
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013-ialloc-fle=
x-spread-v1-1-9ea1d86961aa@samsung.com?part=3D1

