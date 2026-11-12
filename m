Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794520544;
	b=UNAJuAQiG42bAlvKnVaaUza7JVouFkPrC2Yx7MH30Z2HpIXiBiG2iHeNe+ceZskMzSE3
	 pnnfmoDgxRD8FtmNd6E5riNJaA8IgEz8UIB+eHh+VQWTntQf/kr5MyPv7+VxSyisnjwTP
	 TqJ4ewZstXSRNCg+Pf+6ggGZOdJKHENTQdTz569z1+q4591yT7JDadwc4O3rSoozXGkhh
	 GNnhvqUN+Offi4BrS1Vr4pT9v/AjMTAoLeDhWk1LLr4YTToF3IDA9NV5/ReCKnyrccagC
	 fmfzWp7V4USL+QiLGnJinIVKeU+pXWL25dmIDPLfLS/UI8N6AXWvWQi/yXLPykT0LJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794520544;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=s952ZTvcXCKccNY3F8CLIpczzA2lT+cDID5HR56Fa0g=;
	b=ZILF8/RDDQxY8V0KGoTI4lJPBHSg/DSnK1Iad4D5G9fPTvA98bTqtf6EXf3xdoGoEat2
	 xVhqnNS4Atfk/47E+lbIneNW/1PTmE9rV5vFu6C/wEHBaCKwPC917Kk/fXm410ic5IodK
	 gJpHd56zz9KTtXzRpKW3cgybVUQ5Hfs7BW55Tt82cZpZcsM9SEFZ4Crm3t056tQEHGx22
	 a9i/7OfDD9h1BKqmBf5YTbgipRNF33C4XsrdISMBCHqaRwo8ikppHfqjIQDXLAUuFV30d
	 vV4EPjHQsgi+r3luAl9WfTFNfnSc7SXgXySaTz3eEcFWUdnudh4faJt8W93clh8clag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=afN8J4RS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1AB606A31C
	for <linux-ext4@vger.kernel.org>; Thu, 12 Nov 2026 21:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=afN8J4RS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC5E1F000C4;
	Thu, 12 Nov 2026 21:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794520543;
	bh=s952ZTvcXCKccNY3F8CLIpczzA2lT+cDID5HR56Fa0g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=afN8J4RSnWgcbl1Hl1RY8pnYq1aVW3I4fINW5ocHLprbBpf1HCcbwK4DuJMkkV4gQ
	 OSHUfqeFN01EIsAFxGoM6zwSqquZHhnRSFfnHCoUbIIXowQFMb8IDyU8rSyj2d0zeD
	 pS0dVwyWk7qcqRWfKcrNr9UwmZFuF0tUhNUnmoDaPTVSMV0s07XcGxBzXzGuvw9/hm
	 5uBDFQB40WYgqLQLrSAU29QJ22FQoNucFD0ixvIDZd15lkFTMG6BUpAsz26YpvXzgL
	 /wdc2VxHgh8znvWy+GyKHu3I0G9bmFcO92o5cVu9xni/SLCHkto8c09QKSQYNNtnm3
	 pTiyrIljx4UGg==
Message-ID: <sashiko-outbox-211879@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 01/14] xfs: don't skip the flush before shifting
 extents
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Mason" <mason@kernel.org>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261112214604.67875-2-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
 <20261112214604.67875-2-mason@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 21:55:43 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112214604.6787=
5-1-mason@kernel.org?part=3D1

