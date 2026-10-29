Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793280697;
	b=3kJPg5fqQwKYBT1qP27bA45glXKodo6cj2/JH+5/lUZSuRMVMq1QfuYJowtb9ZF1CnmG
	 k7MgsQdEKp/uhPx0ArnakEuXtHEaN1h4wlP9mB4vt6jxWazKl/WW6dQp6PSy6bYgbaDWw
	 WxaxP99gkvKKutYsuCK4N5uhvZovL2u1wu25TF1vrYJ+pw4HqkDn+1aU0jPbomPmKgvzS
	 0stuGUtOVYUn2C/lGjUa+rQOSAF2EjUA2r275lRgN9sx+sRUSgTebSSJOMRsbgHMATtbR
	 tfq47EapjBo3EebwMy1kWQuA9bg323erCArGEIVr8qn4mOqg9cxBe0VIwMzodLEsn+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793280697;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8kDeXNQdyrzxoC2laqvxpLb7cCvC1cPORHYkDpHP9sw=;
	b=4Rl5MCGFxcg3DCKxcm0DSinUoHQJc8QUFOnlvFtfomxClLtZ+C4opxRIHCmHU3cYZXE2
	 CBFYOBEtXuW9MEA4NyZWLCYhCWt0cg8feLfLoDqsmzMZvYjfS5ND5seJPj0gAbttL9wCv
	 OXYOQ5rLoDj4biBIr/Ek/yahGME/luCx4cFXkUu920czoBhd14cM9oHp8Zsucp/gSib6A
	 86WixZC4auqFUGvck9UulzSKuoSI4KHoFDu1DkN166YnvG6Cco0xwu9KKoRat/mpnqDMQ
	 xiHDNJFuLSYnkk6d2VCGzB+XXWwyLn5XLxyJYFRvj0OyM8WngH3aG8zePM1T4aFlJpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IPUoNrjc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474A2606A31A
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 13:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IPUoNrjc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B191F01828;
	Thu, 29 Oct 2026 13:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793280696;
	bh=8kDeXNQdyrzxoC2laqvxpLb7cCvC1cPORHYkDpHP9sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IPUoNrjcVR1qQAnbHtmdMvlGrLsgJq2msIU9F9UQlB12L38WJSHwlfxsflxneHblx
	 8pby+no2qoTXuQarAJb+cgOgFqd7eyZm1cQPiCeTQBzxJQVZbw//Bl5isfTp2t0gE6
	 mFvIUWX3xMZ6eoj7vX15bsLmwYjQZkGlo/gvYpf+QqNg+SwQP1A8GiRd0Ufm6CI8EW
	 V+W0La+UDNEKYIderGGredkGPK2y/BggrcmlUT5wnMLRe7ihbB2T4d5QaEvZDs29oh
	 i/TH9y07h61dm0yZiXlCXIfTB4VadsLRIdSPfGodINkhk11vjdMY/QJB6SOGUIBuj+
	 RlgCA7nHFBKeA==
Message-ID: <sashiko-outbox-189381@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 1/9] ext2: add ext2_inode_block() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-1-7d6c678a585d@kernel.org>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-1-7d6c678a585d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 13:31:36 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Move the lookup of the inode table block that holds an inode out of
> ext2_get_inode() into a helper. ext2_sync_inode_metadata() is going to
> use it to find the block without reading it from disk.
>=20
> No functional changes.
>=20
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-inode=
-metadata_writeback-v1-0-7d6c678a585d@kernel.org?part=3D1

