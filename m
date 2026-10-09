Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A20453A26
	for <linux-ext4@vger.kernel.org>; Fri,  9 Oct 2026 06:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791527879; cv=none; b=ZKAdGGCZ0duM9tc8H2i6wK1XnuKsjgbL5G/nJDtvFpdC+WwErtkJKUQdXjxqOvJzBUsqMJhppvJ2dBBHVmXuxlLduulrhj129FximeCyzANduTmlAyVzPYOyURwz6Q1QWg4EzTBR21PcU+CfMlcBi60jPZKpqDEjgnkkEX9ZlcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791527879; c=relaxed/simple;
	bh=yyj1mWemD6jYU62vz5+8oEhwESHb+gdfHZVlJMnQb7U=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=mcuFwbJfsn3yaLfQoqU1CzmhXLL+wSxiDvQPCVws2d3MF6yyb3wJzSlxkkIif+sy5PVI4XFp2CBeSJoyyFZazcTqGUUrcVsnhUVObTwdy5+HYBOsum4+d07kPkFIXpVX8P/FgBl4oh9hnu5d357LSCa4xSZgHFe3rmSRfBkvGJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKXF+Av7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKXF+Av7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BF91F000FF;
	Fri,  9 Oct 2026 06:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791527877;
	bh=oy3aAVSpvrhYbBRV7pntfEwaabQfJMU1tQ8ECWrnYBo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CKXF+Av7p/qpyKtEDdt4UoMQaL2gJgIJsMlXR5gKzwTSr8LQYJnpDpz0ZstkorgW+
	 lvVKcm7BvFO19pz3plefcppUZOCRyPP+BTQo+jZGICeMK8SQNqridOPvZdwKQK2Mc1
	 PB9HMlZ1LWMIE8Kl6Ddh1pUiJl/+ci+Vvnzt0ax911wUpNkQMWU8oGbFHVkKl2/HFW
	 ODBtTOvWjMM5nXLj5snKoHMy8Bf26dFhSH8UKJH/9z0T7n0AdDSxQl8B/UVwNcms0a
	 RJBEimmUHI1JI+27C5XZ1AzC9VC9lE7tHiklc5RldbV+hgqS1r1BFQdrFTY/o4cz26
	 3o+9AmYCtFqfw==
Message-ID: <sashiko-outbox-164953@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ext4: fix buffer_head leak in ext4_ind_map_blocks()
 error path
Reply-To: sashiko-reviews@lists.linux.dev
To: guolingxing <guolingxing@tju.edu.cn>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261009062846.327298-1-guolingxing@tju.edu.cn>
References: <20261009062846.327298-1-guolingxing@tju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 06:37:56 +0000
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> When ext4_ind_map_blocks() is called with EXT4_GET_BLOCKS_CREATE on
> a non-extent mapped inode of a filesystem with the bigalloc feature
> enabled, it fails with -EFSCORRUPTED via 'goto out'.  However, at
> this point ext4_get_branch() has already acquired buffer_head
> references for the chain of indirect blocks, which are stored in
> the stack variable 'chain'.  Since 'goto out' skips the cleanup
> loop that releases these references, they are leaked permanently
> (each failed allocation can leak up to 3 buffer_heads, and repeated
> allocation attempts keep pinning the corresponding pages in memory).
>=20
> Jump to 'cleanup' instead, so that the chain of buffer_heads is
> properly released before the error is returned.
>=20
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009062846.3272=
98-1-guolingxing@tju.edu.cn?part=3D1

