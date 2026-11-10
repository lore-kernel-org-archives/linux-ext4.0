Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794338217;
	b=B1GhoqcC9mnAOOUl/bx2EjBocsVJaus8YtSg657lpvIyevsXfSswK5xNaiqZ3z6+jB5i
	 VYmuGp26uK9OTqrrInTHQZaTIoBDrLRYD8jaWwK5Ta6vvvo3o90TYoGV9okKMdaBjFx7T
	 T7dLrF93iOa7Ukr9sBzAJ8zKnImGmPWyMFWo0g5OgKbXIfTGq/VFm92ilkne9Xm9+g6AL
	 i+1qyQMkwDPg4Ns5yME0QgnPLcSFqSEKWjpgNnrQ8NNJEx0Km61GeKCdsfrC46csx8F1p
	 zCoBy9P3RBJdTMwi5/s5fp4NQlXEWLmWwR/O/M7eQ4EHRYS2S5ECX250nVbrCys4a8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794338217;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1GuDY11ezbdsiQEbMHVv9DF1zxCXyj3Q0LagAdy0pMI=;
	b=lze3gO9q5Kao5OKwxquNjfcnJFFlt1qcaNsgjfDxzrdZ0KrrYRui6CFGgmj6v7dSlteI
	 5DofzX6Gj7ozB/uij8/XX4j0aNAPvZfxQJUXXybud06Zxqdjv13SlSSNs3J6nDqaRBgME
	 exYnzOaGXMj+A+BMxIduqnuoLsTpgs0v0QOqlsuaypFLXesDJihtnrXMsac3eDjlxcMnI
	 bRZV8tzGFk0rCWMMtfaRVanY/JBikIctTpa8iE132lzfOmt4bLX8TAt1z6jbaUu0Na0LE
	 4wcJrSbCPd3jUBYVHVNIpRO9/LTNfoZ/5tRxOT4nqYBQEj8/52H+KY9lhUK5L4lVtfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvSzXF5P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E6D606A326
	for <linux-ext4@vger.kernel.org>; Tue, 10 Nov 2026 19:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kvSzXF5P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9CD1F0089F;
	Tue, 10 Nov 2026 19:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794338216;
	bh=1GuDY11ezbdsiQEbMHVv9DF1zxCXyj3Q0LagAdy0pMI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kvSzXF5PExasXDWWpo/THS8OPZfVmf/E5gc7A7f45Wpt7FNWD9gpZpeWxiZ0+A0gT
	 O9XREG3oj1F2rsuhMXaM2fhKuBeC1Z2y1hly++aTDabj3ysafSkS6v00WT7DndpGJH
	 kUNXtUkWaitt/vMiFghIg2Q9FSjvBguVw7Kx9WLyTadQNMRibIDxY82hlUxGJQBpZb
	 2aVrdadAUKRJ5CQvN9HtiCoJwfMQgVgrHCBLMZcHpwpypUQvV9zRO7qVHtmGwvHtJ0
	 fTc5flwGYAV6ep4q2V1lNv1aeRKI3I34d6/UP7pJDQHS90XjjlS+gHeTZCUZpnZzP9
	 N1VYt8mIpy5qg==
Message-ID: <sashiko-outbox-207647@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 01/11] xfs: don't skip the flush before shifting
 extents
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261110190417.32650-3-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
 <20261110190417.32650-3-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 19:16:55 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> On an XFS file larger than 4 EiB, collapse range and insert range can
> drop dirty data without writing it back, and then fail with
> EFSCORRUPTED.
>=20
> xfs_prepare_shift() flushes the page cache from its offset to EOF, but
> passes i_size as the length. Above 4 EiB the end of that range can
> overflow and turn negative. filemap_write_and_wait_range() then writes
> nothing, but truncate_pagecache_range() takes the end as unsigned and
> drops every folio from the start of the range onward.
>=20
> A delalloc extent under a dropped folio stays in the data fork, and the
> shift returns -EFSCORRUPTED for it.
>=20
> The fix used here is to pass i_size - offset as the length.
>=20
> Fixes: 7f9f71be84bc ("xfs: extent shifting doesn't fully invalidate page =
cache")
> Fixes: feeb9b269523 ("filemap: skip write and wait if end offset precedes=
 start")
> Signed-off-by: Chris Mason <mason@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110190417.3265=
0-1-mason@kernel.org?part=3D1

