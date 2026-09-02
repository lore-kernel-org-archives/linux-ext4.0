Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CE333A9E1
	for <linux-ext4@vger.kernel.org>; Wed,  2 Sep 2026 07:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335608; cv=none; b=Y0fSF1KVA2qoOciA1xzN2AIp2Or30p9QTQVypxNVbbnC1NAc5m0hM9NcrbIYgbGgZ2AY1HtRvAoeQBtF09BtpwkYB8twY+hHGrofDKzGu9JTFyqyQ2tUjQhy4thHj5CiUXtP9zZd01zsQpFYUJn2KldajXDcIx4otYOUuT5qNrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335608; c=relaxed/simple;
	bh=/1NWQ9K7FEJjxaKMGkLHPLblv9zfA/FhLOxkHekw/RA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rbNRbUlj1UAy5QmEHd7MFWwPDyJpVBJJyeWLB9WsB+ji+/+3BWV5gv5Q2swSOsNys3f7Eb1vCp3z6YWE4EJoBwOgk19Uv/F3j4gcEIBDOqQNQY+rFyPDJrUMp8Q6pFLWDu82NaJVIaOTX4WnHzspEVIOJXn6inFilXL+A12qvD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PieGFl7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PieGFl7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9571F00A3A;
	Wed,  2 Sep 2026 07:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788335606;
	bh=/1NWQ9K7FEJjxaKMGkLHPLblv9zfA/FhLOxkHekw/RA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PieGFl7bHeQfqDVuKiDEShuMCb4XIjUaYVpqTCe0knpSLb/SgJ2Nfibd+4Hg8SdX8
	 qcy1FzjTTLjpMxwHCpC4VWdDz/rSOGwzqxvSg+qRVsdev9naYl9sk42JlYSpjoMfly
	 6SWEwpcIRuWhgu97nihdB3KjiJOhkwJ8U1yXOJVpP+f7khwN8wPTgKfFVMV3y9DRUL
	 vLtxLUPMQtx3nfY0zATQcVLvYYvrcey/I/CSgKg6EUN8MyewiYOFu4YrXN0mBHda//
	 b5IgsnEP9owT139Kwoc80MZmW610xHeI8MO00RviJgyiBSXacSFBY8b5tVdeRF/TgU
	 D3pvsArMJfbTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/8] user_namespace: Use acquire/release for
 nr_extents synchronization
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260902074805.398540-2-ruanjinjie@huawei.com>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-2-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 07:53:26 +0000
Message-Id: <20260902075326.8C9571F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> Replace smp_wmb()/smp_rmb() with smp_store_release()/smp_load_acquire()
> when publishing and consuming `nr_extents`. This expresses the
> publish/subscribe pattern more clearly and allows architectures with
> native acquire/release instructions (e.g. arm64's STLR/LDAR) to avoid
> the cost of full one-way barriers (DMB ISHST/ISHLD).
>=20
> No functional change intended.
>=20
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Seth Forshee <sforshee@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902074805.3985=
40-1-ruanjinjie@huawei.com?part=3D1

