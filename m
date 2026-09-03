Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119F14A4991
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 12:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788440228; cv=none; b=G19m8pImxFlXas3QZ5JInWo30V6OUoua7dJcQNHtn1dcAqjHh2yPkvVq73JCIyN691AeEzs6c2l0yriLcws1g8YUJ6mw0Y1wpjCiJ6gcYJt1nmjB4e43BxImJMORM+eEkF7IEfltUkxvVfMIhnZ3Z4ZHoKxicuaCLs4FwTyWVU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788440228; c=relaxed/simple;
	bh=39EbkpJYowkwsPKw5mDci/snYpA7iiJtN7ls6USbVDs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jiP+Fzwo0YqT+SjlUqeSeTB+zSMfF6DA2lw0IKIOVWvHQY6iMiIXAVRv7IPSjpuGEXvMzNjiQRq7TvSN363LdmoGUwSXDg3DXgjTMM07qS2PGjkIghhDneLIdjYe1ybjgE/BEXxpJeNQOdhAn95ZyQia1ab4Rdf/ZigVcNo686E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JhFLDGSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhFLDGSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B622B1F00A3A;
	Thu,  3 Sep 2026 12:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788440226;
	bh=CVA5d5955oZ5AnSKD6HB4ytWiBY48590sd8j8ioyi84=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JhFLDGSYvZPZEmbGvE6xpKF5uYy34sYux0wfe39S+U1YFuLznQyRyXDPQeNUGduWO
	 LfAavSKalksCD65sGSTIlMPP4FFEKG3Ro5FJ2M0U4Huxol5cT00ABRcolHazpvNx1R
	 kHyTRjd97KqFyQ+qn4nXUflcL0O3l4os5p/jKphEXTH1Fd2k7gpoMhm5Lc9ZsldkNT
	 ESonb03aeRbHbpJqH10bQhZPnpOs1Naty5zoPpOCgW3RfoJIm7yr/jzlO1aU7FQXog
	 SAi+5woFjyIlNysYW12B2ZNXaVAAIbK5LuCvQy8HXOgAurHfQHP60NVOaOcb0MV5Bq
	 4lA1zjnOLWupA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 10/31] ext4: add iomap address space operations for
 buffered I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhang Yi" <yi.zhang@huaweicloud.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
In-Reply-To: <20260903123543.2302999-11-yi.zhang@huaweicloud.com>
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-11-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 03 Sep 2026 12:57:06 +0000
Message-Id: <20260903125706.B622B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>

> From: Zhang Yi <yi.zhang@huawei.com>
>=20
> Introduce initial support for iomap in the buffered I/O path for regular
> files on ext4.
>=20
>   - Add a new inode state flag EXT4_STATE_BUFFERED_IOMAP to indicate the
>     inode uses iomap instead of buffer_head for buffered I/O
>   - Add helper ext4_inode_buffered_iomap() to check the flag
>   - Add new address space operations ext4_iomap_aops with callbacks that
>     will use generic iomap implementations
>   - Add ext4_iomap_aops to ext4_set_aops() when the flag is set
>=20
> The following callbacks(read_folio(), readahead(), writepages()) are
> provided as placeholders and will be implemented in later patches.
>=20
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260903123543.2302=
999-1-yi.zhang@huaweicloud.com?part=3D10

