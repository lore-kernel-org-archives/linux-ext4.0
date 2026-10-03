Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B0D37F72F
	for <linux-ext4@vger.kernel.org>; Sat,  3 Oct 2026 01:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991250; cv=none; b=RcdnrqRADIbvqMFX2iaU0lRlKjL5gTqFedIP8e0xyGB7bAfSuG1t/qSCCwYKJnF2Pw5sF3diW50nXlwwG9PKvvQGUmPnku6qYDQ6JjPE2sLR4SeASqe1FgY3v5t0xXi4uRv6uCCOhzalTMZ/cBbxN6ilfDQGgsGz05XTdefO9wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991250; c=relaxed/simple;
	bh=+O9LM30e3T4xFjIK9E8xD59gAWHAklJ9oPVFOmADKlA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uH75YkZ+9tc1zUF+Uso/0zAqcFM1u1wj2M6gc9y2kT4T/8jnyTnvkXpaqeTeDcQpJJmigO4jrZrabF8iluP3tHxqqczMjgE4iyEc3rAsWY/J3lvoeo4+FW419MIEu4wZEZjLNJ7gce+yeYusQz5zySr8qsTgNPWDqwTDFF09ZZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2ALVcLt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2ALVcLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6A41F0089A;
	Sat,  3 Oct 2026 01:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991249;
	bh=+O9LM30e3T4xFjIK9E8xD59gAWHAklJ9oPVFOmADKlA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j2ALVcLtT7h6I8+G5E9gU5/Bw34HAAMJG/ltL7zVkljaQVf20u+VhiXHlTe2VvvOo
	 kgm/vzjlCdvyhLNcoimBAPnrh0FeCIHy6lg0FRlLIlhJ+KV4aXz60MfGgUByWBTrlg
	 90bcBJ+/HCamIzaK5F2/8tsu240/dVx/2O2Y9aKqi776HulQf83wCD+2IwGPX6ad5O
	 SekLAnQj3coP0OfneRz9XYGZFxv1zTHFdaYg1Jl8yJbphoF1PP0zMYFP4JhrBYrKgg
	 E8hPHsJPCQ7CPi2LoGPUXSBUfpF3a9UcUHOpgGK8I6awDuradIXhYS4vmC8Zexrt1I
	 orAN25QM7BuQA==
From: sashiko-bot@kernel.org
Subject: Re: [f2fs-dev] [PATCH v17 16/21] xfs: initialize fs-verity on file
 open
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrey Albershteyn via Linux-f2fs-devel" <linux-f2fs-devel@lists.sourceforge.net>
Cc: dsterba@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20261002223705.2175542-17-aalbersh@kernel.org>
References: <20261002223705.2175542-1-aalbersh@kernel.org>
 <20261002223705.2175542-17-aalbersh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:34:08 +0000
Message-Id: <20261003013409.6F6A41F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> fs-verity will read and attach metadata (not the tree itself) from
> a disk for those inodes which already have fs-verity enabled.
>=20
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002223705.2175=
542-1-aalbersh@kernel.org?part=3D16

