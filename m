Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36D937A85E
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 12:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790598468; cv=none; b=fhAkxF57AMb1To+bssTQo/to+FggL8B8iPCgXOzLuKzKYMHCRkeBkALi7zkjwjEZp+ATZS/jrGKiYDQF5/nOyiuykA+SUbpwZgs8+Ze7Su5p4R+0WzhiWNnClC9RCzzwhz7+kjhQdw3IT0jJr3JSfp/78ZJxhhmiVosjEJPbyPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790598468; c=relaxed/simple;
	bh=j/DsYTyGVTERhxpb64kUBAotDJXonFVxZHNAvUynTxg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lvf12ysXMQXyZ5zqJF57TtfVzHTp1JyISXi/TzhIjFp/qKsDXHQRgsKNtZMspI0+3C0VG1DYJwpPoCmWw03sYG5hvzXf3a+aX3B9/lm/UCLvH+ythJQjEH5EDs2X1KOF/UL9ERi6j78q3NAD/w74lI+MlYUeZQi9q1u8vbrntA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Re0F6Djc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Re0F6Djc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1600D1F000FF;
	Mon, 28 Sep 2026 12:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790598467;
	bh=j/DsYTyGVTERhxpb64kUBAotDJXonFVxZHNAvUynTxg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Re0F6DjcG1G85AHCtHYO5kx8eE+psgjUs9m8KsDg5aCHwVgdSQb+Ql5aKiXp0FAnJ
	 MwThvIXaYOMorrXPu/CfzpLHi67U1qFy3SAViqwj7y/xgipWkSwkNaUOZefHLsLXb3
	 /wOG6DjF3Rjz/IPzZm+KLYU23XbDE4atmc1qkMAcjNBaLNcF70r7IgKNFWokaNTBbn
	 CgbQxhif3ZDJl+zoHV56d3XWyqkqPsBq4q4K1hr9NeRaXMtlJeBy7Ne+fJOrSBf/VG
	 FV4QIuPEi2R127PJIpsOdtVrthDC7OMNsMZ8fCg8IDJPdnm7Jm4gYVqwV2p5TW0ZPf
	 PkwLYWlMBiYOw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/4] mm/truncate: clarify return value of
 truncate_inode_partial_folio()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20260928120833.3440834-5-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
 <20260928120833.3440834-5-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 12:27:46 +0000
Message-Id: <20260928122747.1600D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> With the earlier rework the callers no longer rely on the return value
> of truncate_inode_partial_folio() to decide whether to adjust the
> truncation range. The pstart/pend out-parameters carry that information
> instead. The callers now only use the return value as a flag indicating
> whether the loop should be reset to pick up newly split sub-folios on
> the shmem path.
>=20
> Return true if at least one split succeeded, and false otherwise.
> This clarifies the existing confusing return value semantics.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928120833.3440=
834-1-yi.zhang@huaweicloud.com?part=3D4

