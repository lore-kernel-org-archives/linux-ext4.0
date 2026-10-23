Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792736938;
	b=jo+GBrlgC+ZTRbfI0zZccKOhYm6K7ZX+6MFJTXJNFLJL8o4KpGTUmlZkRE9FjDkIMz2s
	 PAH+JUZQHHnKUs/RAHMCyWEaIdz5MhJNC+T+il2NFL7WGFA+b3dHSO9fIiHDlM1ihYEfW
	 zyZCfmst+e+ypLQjxByK4dLrSa9UzOZLcLC60pMO47dALZwC0+mDiuf6OtO9KlNR2EdFW
	 RHdLr2PqlElGFl09qCCBCwLwYK2dc9+R1MI5o1kacVMg5anpKtg5j2uaaNZhZtXmzRDkh
	 HXTZYwt6yAmLvphL97PyHCogIY719aQ+UMAA7uMDGHra4EewVAlx6PYxohdNKGhm8Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792736938;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1Di5xN7Zc92A6Ig070I0x8rw2VNucuIA9liPdB+ZryI=;
	b=QPIFAnppkdKOCRA0NsDHxi26oNFNAQnjmY6ixqqqLrQDz6Ej11YGAYRRwMxNQwrAmcku
	 vR6/b9h/oVom9yzEmMEkEwUVMGQCeS81a7eUmwbHBx8/Wr7GVax8lK6+b5zFk4fLTzWO3
	 Rc/dpQlJfDXhi+VobGDIXh7Q6o+YzBaSbeS7ukD6jEU/oJRmz3/pMtsGJbWAlRd97tqBA
	 xoqri+YDbcPX348qe3Q8ymHhi02yMntD2ZlJUYsI73lde0LTdw/ZklCJY87R8evMthvNq
	 Mm4q/aCbRnCeks4oGJLwEYQ4RdZRcP55lduIKCGdgEFf7vARW+js6suQNOO7WpQ15HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cvsigUFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD61606A31A
	for <linux-ext4@vger.kernel.org>; Fri, 23 Oct 2026 06:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cvsigUFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB241F01825;
	Fri, 23 Oct 2026 06:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792736937;
	bh=1Di5xN7Zc92A6Ig070I0x8rw2VNucuIA9liPdB+ZryI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cvsigUFlXYZThWYR8i0lrf7HARY+OybYlOLB1LOaOCbuesV2vmYGa/4zshfyweZxj
	 uraTsVajIY6iZYAwq4jOIg2krTWT8rgLNY0mI4ghX8NnDUYJdrwCy5AEYKGYQdIJXF
	 RBjszl+lQdticj8Hg8zkPUzxHhqZ4Um6oUnSMb9NdlRm00cvU/G+ZVUIjFRo+YJ3Re
	 7vusBvptaVVwvf6ebR+8YdOr70DTWtI38G+t35SQ3C5Q0prrInjB0Vt0LviVIvLI6+
	 4ba0wgGP9e5D6dlUNbF6G+e1xWsqE1Z83h5sUvR6IlQRiQAWotzfXkTSxParLgHmLa
	 GOnCMCSPP0cxg==
Message-ID: <sashiko-outbox-182350@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/6] ext4: put folio on partial writeback validation
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Julian Sun" <sunjunchao@bytedance.com>, linux-ext4@vger.kernel.org
Cc: tytso@mit.edu
In-Reply-To: <20261023061851.45579-5-sunjunchao@bytedance.com>
References: <20261023061851.45579-1-sunjunchao@bytedance.com>
 <20261023061851.45579-5-sunjunchao@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 06:28:56 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> mpage_submit_partial_folio() takes a reference with filemap_get_folio(),
> but returns without dropping it if the mapping position fails the
> WARN_ON_ONCE() check. Release the lookup reference before returning
> -EINVAL. Leave the folio locked for the caller's cleanup.
>=20
> Fixes: ded2d726a304 ("ext4: fix stale data if it bail out of the extents =
mapping loop")
> Cc: stable@vger.kernel.org
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023061851.4557=
9-1-sunjunchao@bytedance.com?part=3D4

