Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76CD4D5A1
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2026 06:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789455181; cv=none; b=MGCEf47B8/lB5i/QfeLvsYZGeiw9ChiLv41Tbm1Y/U0pn5vwDe1iWt8MO1Ff3zIlVGLD8V2qYWV4RzuZLwsZTTP+ezvNzbdHwnoTrB3tCXEXku+zsS9Ylk54TFFNmU46C4LPnr4eTqfDEEi+euutvZFnXtECBUSUqMESE0Qw3NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789455181; c=relaxed/simple;
	bh=jgPxZOYa7cPYFf5PeIj77UjYDdJN3mE8d+o1TVA0mzE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MuwJuj/e609HidjTxAE/wFSJbzNtIG0RGjuuDnDlCY5wnNCshR+MiYK8OrF0ZpT9dEZAgD0lZnEju2/I3lMoajc9fa/4b7RvDvQGuOPfrUL7rhIeDRx4bt9F9UaL33kB4beVtsrktDboUJKeOSpQF22T6FZ9ij1j9+LHTZzJ5mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D57wR4NO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D57wR4NO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327441F000FF;
	Tue, 15 Sep 2026 06:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789455178;
	bh=Eah6B+g7jAxax1haSb+MZiks7qvS1wg3+Vqcr5witYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D57wR4NOz9FgwhIjXidNLFFsQECFSAUTrRxkcRZI+rIlcGTIk+rQ1g5zbJn27rOj4
	 I81ZKjJnyQ9gxYVBs9LmYLD/nDgiIgkcFLC3vd+Jj+et+j9STwlfK+7reSYhxco1kV
	 pxUDs3KMBBFxEfARTruW5M6HoJRiB6Yu93VEoLr4n8MfDFnT8K1OmAYqQz/RQzU55h
	 0Cg2yeuVu2YRNZLOxRRmri8oMKvAPDB1mAtUaHMI93FSSG+NpqM0hu3LieNekRdXJS
	 7m5bfmZszjN+lJBfwGC4Ns8wBi/6exlYtUK4VDq5wbj6GdCm0zb/EocY/qe0je6p/2
	 wlLTqi8AH0dZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext2: reject xattr value overlapping the entry area
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guanglei Zhu" <zhugl3@xiaopeng.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260915064453.249419-1-zhugl3@xiaopeng.com>
References: <20260915064453.249419-1-zhugl3@xiaopeng.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 06:52:57 +0000
Message-Id: <20260915065258.327441F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> ext2_xattr_entry_valid() checks that a value ends within the block but
> not that it starts after the entry area, so a corrupted block can place
> a value inside the entries.  ext2_xattr_set() then underflows the free
> space calculation:
>=20
> 	free =3D min_offs - ((char*)last - (char*)header) - sizeof(__u32);
>=20
> and writes the new value before the start of the block:
>=20
> 	val =3D (char *)header + min_offs - size;
>=20
> Check that the value area does not overlap the entry area and refuse
> such a block instead.
>=20
> Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915064453.2494=
19-1-zhugl3@xiaopeng.com?part=3D1

