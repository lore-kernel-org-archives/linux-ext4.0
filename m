Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FCB4D37BF
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730795; cv=none; b=KHVTCMN8BlAjeVJ3X4aJAMnwVRKEwwrzlkE/15aRsPin/LMyTQuT13AusQi3EHSNSwy8nZw0kfhX84xVFwl/U7ctvIsHybDxfC1gbXyql92uk2fKU27lqyRBayCq7/uHNp95VmaBFvhWweC99Fz2cBFoxArZqYGONeT0Yar8tr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730795; c=relaxed/simple;
	bh=LVAchk1aP+MlpYItrsu8uKxTLFJ3XP0/F6IWwLMrYlU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A96B0qe3+abYsAE5EU6dhoUdQWj2H5oPOe+8M+nAkjLTAcqzd6A3S7JgS4/397ONSUhPXmOjODgVg15dIKhnIZORPwT978QmxUEh9foam1LnrzJs9BA4QV2RqSpm3jvM6oSyfP+H+eCAXOhztqQaEd24pQg4YLuCPN5DZ7fV3Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iahT8+2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iahT8+2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD331F00893;
	Fri, 18 Sep 2026 11:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789730788;
	bh=LVAchk1aP+MlpYItrsu8uKxTLFJ3XP0/F6IWwLMrYlU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iahT8+2hKi10ADOrgCxXQspZEEbpP72K6kaoyUBUke/4L6VFNnwBTOf77KF3N19b8
	 DRFkqh8b8gSjrKka+Z6Ug6pY73vzYmASAuR5zcHhk6MfS8RlDd/in42oIpPt+5u3Xu
	 nvOooF4vPYqs0vB9PNSzyMgAkBB1HjSNu4au/dvXMoxOPNgRN0qHYX9HjkmswpM1C8
	 qOg6pcNDjwOXNd73uiwzQWumIMdqpz6N2Np9dWC8GjC2IgI3vS83dWiaEbvcg+cAHG
	 ESY6tX6Yvja5P0UfYyL7VjElx3um35msFH2Rs0XlBtrrbMjlBD4mBNl8FClUAheVls
	 2hIhIKo4dehTQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 04/21] fsverity: hoist pagecache_read from f2fs/ext4
 to fsverity
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, dsterba@suse.cz
In-Reply-To: <20260918111539.1003439-5-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-5-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:26:27 +0000
Message-Id: <20260918112627.CFD331F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> This is the same function to read from pageache. XFS will also need
> this, so move this to core fsverity.
>=20
> Note that f2fs and ext4 functions diverged a bit, as ext4 operated over
> folios and f2fs operated over pages. The common one will operate over
> folios.
>=20
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D4

