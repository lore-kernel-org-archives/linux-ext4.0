Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4C04B1CF5
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 11:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790596094; cv=none; b=jkpV68tQrgcE2m2GMYDkqKPO6eTd4Dd/HL0OrPeORk5CS3isQujeTsuuGd9acGjcdoF2RCU697WPTRKi35ePoItxr8gkrG6+y04O6X3mCcg5dYJZ6jC3M+YJ/3TQi4hOB6KTxIMJuHFINv6qs4/R+Dr/inN+d0xlqtB6FMy3W/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790596094; c=relaxed/simple;
	bh=7CnjkbfGx7vM7fR9QZKvn3Cl1f4TqF3vpJtx/TS9UDM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=poh2zpakLvu5rHHeARJXlOdYrlgkwoTnBv7tEAU8s6i16hf6zIlHS83eIhrwg2EWKNqmietOv4FayPTSZgM3pdVALoa9POSHZpNmjpcthP0on0iIxeEp+9mhmSH2d0YC4+l+ntQU9kqNDbgNcbtKwaKi0D00//ThTGvo5onLhdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWatxoiZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWatxoiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061691F00893;
	Mon, 28 Sep 2026 11:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790596093;
	bh=7CnjkbfGx7vM7fR9QZKvn3Cl1f4TqF3vpJtx/TS9UDM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SWatxoiZb0f60Lk2Yyj5v1duEnXvwv6yB2570aclZUiFcMVIsM28W0Wk2DcHzj4UN
	 SZz9Urpn1vNMmLj46KcxDKwb3RgKHCohwJMpNxiOwlMRfdindXsdVyzIm1szOoBZZV
	 /TWVlqtHpb+gH9Ms/CgyaB2LkGmCxYDy52c6bfcmQ0JUUBfvMB9HShizxZsj/P6G1W
	 fyV1KAbXxJB8jR23H7e6x53+v/giCb8bYMyX3x+ITRlQj7P6n/tBArr7F6O4fDf70+
	 9N8f8f+OpI1ySx5lMOlZm/kSrSEs+ZrzuZNxUpmCx950TjRQlcCbtAaIExrcbNrXNe
	 GcNVXCKT/flJg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix shrinker scan budget accounting in
 ext4_es_scan()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qiliang Yuan" <odys.yuan@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260928-fix-ext4-es-scan-nr-scanned-v1-1-91d88228b0c8@gmail.com>
References: <20260928-fix-ext4-es-scan-nr-scanned-v1-1-91d88228b0c8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 11:48:12 +0000
Message-Id: <20260928114813.061691F00893@smtp.kernel.org>
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
> actually did. When __es_shrink() hits an empty sbi->s_es_list and
> returns immediately having examined nothing, do_shrink_slab() has
> no way to tell "there was nothing to scan" from "a full batch was
> [ ... ]
> nr_skipped stayed at 0 throughout every run, confirming the wasted
> calls came from the stale one-shot budget racing ahead of the real
> list state, not from the existing precached/trylock skip paths.
>=20
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-fix-ext4-e=
s-scan-nr-scanned-v1-1-91d88228b0c8@gmail.com?part=3D1

