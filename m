Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F9C45038
	for <linux-ext4@vger.kernel.org>; Wed, 30 Sep 2026 07:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790752630; cv=none; b=YScoo+Onq49/dO/spQdjhdVHFLrGjvK0jCJX44i0nFjIx3WCGE5LChBMBeZuCIl+ciQUxjwKhKQorD5QEgJcTyVB+ZwrjTTXkYyNNKe0MPFjX4q6vFOW5kXu3UD4S82hiX/NljNPJzhHjQUG9JzXqgxAk99baszPV3RrVdoyF38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790752630; c=relaxed/simple;
	bh=UU5juSbO6K9LSq7sRfQbuoPgSlcQQFp5LXFqqngLAck=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dfgMl02a9PF3UXAE6g4/iHiHxciGJ9vLLF8nR4pSFSMJqG6PI6E3TTR+OsPEhrxH9nrjFyE3/Trw7E5hOhaJ4I9RzVHdrlrJnYuCEbOL3JfTbcwX9iQjI+DMJBWksb8gcs6SLMkYCr2QIe9AQ7VJ6ezYHXdr3Vmj7ugs8CFzRVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGME/BgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGME/BgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DBA1F000FF;
	Wed, 30 Sep 2026 07:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790752628;
	bh=UU5juSbO6K9LSq7sRfQbuoPgSlcQQFp5LXFqqngLAck=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gGME/BgVD2D5+6Da4kxmvTq6XcB78IUHrXEIpo+HodNaF1FVcbMJAuQHsxOZ+Y+iC
	 9Ay4FXJ5BOZuZKsx+ecjkb3insnZMr4GlA2VXoSA7LIe4J5bn+pP3DdwKPaNj55IY0
	 CG8j5J5VMyXDkEuBQvg4+H4Ns6G1TME4ruM/cV1Q7JIxFaHizhqMUvDS6qJeqGugWf
	 Vp2+LI1gqNkL6eF9IUwPvO4egHMoIwax51UDrzah6mj61bV1dOAqCNxKXH53FPucX2
	 TxG28whNI/8J8eBziVsQPRjbPP0EOJxkzygF3n5voyNXah4LZVRZ5Df72WvJyvzfe2
	 ERQbhW0OvXxPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] ext4: remove unused locked_ei parameter from
 __es_shrink()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260930-fix-ext4-es-scan-nr-scanned-v3-2-9aef0be87d21@gmail.com>
References: <20260930-fix-ext4-es-scan-nr-scanned-v3-0-9aef0be87d21@gmail.com>
 <20260930-fix-ext4-es-scan-nr-scanned-v3-2-9aef0be87d21@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 30 Sep 2026 07:17:07 +0000
Message-Id: <20260930071708.48DBA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> __es_shrink()'s locked_ei parameter exists to let a caller pass in an
> inode it already holds i_es_lock on, so the shrinker walk can skip
> that inode instead of deadlocking on write_trylock(), and fall back
> to reclaiming from it directly if nothing else could be freed. Its
> only caller, ext4_es_scan(), always passes NULL.
>=20
> Drop the parameter along with the two code paths that exist solely to
> support it: the ei =3D=3D locked_ei skip check, and the trailing
> es_reclaim_extents(locked_ei, ...) fallback, neither of which can ever
> run while locked_ei is always NULL.
>=20
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930-fix-ext4-e=
s-scan-nr-scanned-v3-0-9aef0be87d21@gmail.com?part=3D2

