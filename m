Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE2136493C
	for <linux-ext4@vger.kernel.org>; Tue, 29 Sep 2026 02:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790648935; cv=none; b=anJdLDx7ofCsSctV7qZ011YGL+Ha74HpSMmTWSymMH++X+s/piC/T9pGke/SpjOQAUK5T5A4CZIcz+TLa0ufxH0Pjev5gik2Y+I2NFHjDBb6tcqwQNXSJhbnSNCjTX72uPsA/QuUx7s/6mHWDGBw3FFVhFycu2mffBKE6p60z/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790648935; c=relaxed/simple;
	bh=pVgspAfQNL/zbr0IZPs+rmgAi3HBbUZW4BRjm/QvWHs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BE8L30nIOSRmfoK52i9CgNOjjtr4/PNrp/V6uGg/jDRBTxIeptSkYdXEyN0ihnYMn4pQswPRQjrwdELhNrz7JsgqJW/0t79pRrlkYBDSN6XWsmmnHEBHHkJzbH1XTtUtAoU8wmvyAiocs1iBOd+ucYRy53WGo2n0mFv4otmLow0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYbHT9BD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYbHT9BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC0F1F00893;
	Tue, 29 Sep 2026 02:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790648934;
	bh=pVgspAfQNL/zbr0IZPs+rmgAi3HBbUZW4BRjm/QvWHs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RYbHT9BDfr/t/kmQEVTYGQC45KTL2TRyXUZUNvOL0AkVtdm8l8rovYPnEFOmW3d6t
	 ge2sdZSZb2JrSP4kzSW6WFSWWFOqjoJ6UM87cjRNRwqr+/c3p7Ch03MD+RTGtHZEyH
	 CXx5iq/hd2cHCqerLGq30sDKqLeb03LUzUUUBs4WVp6ahUKJSSDuxgDtNxVAfgRsUY
	 y2BBDJXtJGwHBTrqANfXYVq50okhNqJMreNT6y4TzBM9FU+dxuYX1t8fh3028D3RsV
	 X7A27gCAST21fiAvWXpGuOhuX2LQGU886N4daQdUIwKEgP5sh/rKN1NQ/hL9SNu/g2
	 mg3O3TGKwarPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260929-fix-ext4-es-scan-nr-scanned-v2-1-f4e8f6f6b8b1@gmail.com>
References: <20260929-fix-ext4-es-scan-nr-scanned-v2-1-f4e8f6f6b8b1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 02:28:53 +0000
Message-Id: <20260929022853.EFC0F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> The extents_status shrinker's count_objects() callback,
> ext4_es_count(), reports the number of shrinkable extent_status
> objects via a percpu counter. do_shrink_slab() reads this count
> exactly once per invocation and derives a one-shot scan budget
> (total_scan) from it, then repeatedly calls scan_objects() in
> fixed-size batches until that budget is exhausted.
>=20
> ext4_es_scan() never updates sc->nr_scanned, even though
> include/linux/shrinker.h documents that "the callee should track
> its actual progress" in that field. Because sc->nr_scanned defaults
> to sc->nr_to_scan before every call, do_shrink_slab() always
> believes a full batch was examined, regardless of what __es_shrink()
> actually did. When __es_shrink() makes no progress and returns having
> examined nothing, do_shrink_slab() has no way to tell "there was
> nothing to scan" from "a full batch was scanned and none of it was
> [ ... ]
> nr_skipped stayed at 0 throughout every run, confirming the wasted
> calls came from the stale one-shot budget racing ahead of the real
> list state, not from the existing precached/trylock skip paths.
>=20
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929-fix-ext4-e=
s-scan-nr-scanned-v2-1-f4e8f6f6b8b1@gmail.com?part=3D1

