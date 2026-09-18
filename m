Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299AD3ACA7A
	for <linux-ext4@vger.kernel.org>; Fri, 18 Sep 2026 11:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789731031; cv=none; b=WcBG7bnqVd3NOw0WpPgcX/PjbofgPSL1jdYb3bvXzZdB05Sk/20c23VsHp/fiDou8NrG6Mg7kru9cg6ZMGpqLPnRziyz5rrXDSIzU2N+OcV3gClyQTGfJhxW9ziWWJzRpMwUjJxKaCCN7tU+ibIqhndWnvhB5LO7xm7Ug/26v4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789731031; c=relaxed/simple;
	bh=VsaCzXZV37iWiNeeWW4gV6gKbLPGywIKEujLf+s755k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bXBoR26hSdeCYg1yWjvFbFXgEzmqU2La63hZTC86wSMHJLK7F4uLnNE4glkmHFHW2A5lsy6IRNnEdo5J1gKiLfzTQ2uNBkWkf/4aADeUG/bIoKXwdnduTPAkUprR8RCUM9KoWUp27INAMky+QSPPkfVC2pl4Y4u3aD7YuvHJb5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwlv8rkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwlv8rkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585B61F000FF;
	Fri, 18 Sep 2026 11:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789731029;
	bh=VsaCzXZV37iWiNeeWW4gV6gKbLPGywIKEujLf+s755k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dwlv8rkNBjMemqORiHkaX0MT7mnBM/1ffxCcxGQVS25HStHY/ynw48eJtaiIcmoks
	 xR0Zy5qNW6deUqo2zYGyr1YOE1rHPl7AONmla3oXmkkqtm4/sjRSkM9XtbXSeE6H1k
	 NNFd3EqLzTsqtKJlPUmONeommLmoj8F5P4Hp6ZhXbsffc7CY4GRsiBSIJ7ypC25yv/
	 o2ZytDS5bRqMRVySOnhCwd7TdkawMgYOtkhEH4fO2fiRg23ojOXPpTex1trTJgbCyS
	 9aJ54qZx9P6W5gpn7bVJG1RnE4M4+o53GEhLWpqzcrZB6dCidceAzLQuT496rzXZMx
	 sNilz5qNkouVQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 18/21] xfs: advertise fs-verity being available on
 filesystem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn" <aalbersh@kernel.org>
Cc: dsterba@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260918111539.1003439-19-aalbersh@kernel.org>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-19-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 11:30:28 +0000
Message-Id: <20260918113029.585B61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: "Darrick J. Wong" <djwong@kernel.org>
>=20
> Advertise that this filesystem supports fsverity.
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918111539.1003=
439-1-aalbersh@kernel.org?part=3D18

