Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554668;
	b=n5XHAvBEdwZj3wnvTqPijmSJD7EFO75xmLFVn+1w0+BWLNscRy+wRhulUTo5ur+SRUX+
	 gvDRmPNuS+Lhp6zgQaFx3i/OdCpfeNUx+rx597LpaqcYfph3H3Ja+JXJzV30QXY72fSYV
	 HbxTc8rx4xOXEql3E4WPUdjdXDGdeB0XFVgqZ6vmMGjgCHRMqxb5aW028zZtjTh44y68V
	 fymrLcmf5MHcTFvWqp6OSd6RL8mJ0xqZfJinjHLH54j03LvmQ0l9vvZ16TSgJsAPGBJp+
	 5tHMEATie4amEnYZxpZ10OhISzxTqbweHedgIrfHWCbwaSK3vHIiksMDP1cnwAswzxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554668;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=1Pfpm2DEgtd/M8vzlL52ORiyhgwwlRXB/nF4cCNvKZ0=;
	b=uJxp/xWyPl7Prq107MZFzJyho+rqfu6/FC10R5GPnbK+oCo4uBpchw9IVmA/879kg5kj
	 nQLB4LBPbPv0+Nh9IkbOuC/O7DetQGXuOQzu4i5a0JSCiXJHLshI5wtE21pOq45eDMQBQ
	 LoeZkVh7mMwE8s7NMZww+lL+VtniuuuCTy03WGInCy1kQMDU14m20w0BzwNYYNviOcMBI
	 B9YVB2vSqy8T25LJ4jOMYfUtOykYdebgs126pcXPc09hIPMLeJz6inmXnaB7SGtpOqatU
	 YPlCe+TIo0kEvPD2EuzF5mI7fhBG+XByIx+DlSKk26X07BaDn95byDyqrYnJZBQnjeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F0kCRMgm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3011606A31C
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F0kCRMgm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1694D1F000C4;
	Fri, 13 Nov 2026 07:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794554668;
	bh=1Pfpm2DEgtd/M8vzlL52ORiyhgwwlRXB/nF4cCNvKZ0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F0kCRMgm3ZC+npBArv7zFUJxQO2mSXp+p3ope0d2/f6IWRJba6Ga9241smAEc2s//
	 TiCoTdncrTCp4PU+p47kA954tSTtHOnppjvnkAowYfqUZZquSPvNr5ptpg0ydLeY5E
	 cTGHpnoCR9VjrxdsujmW8ZrgtdRL1qOinwPA0eJQO6iw2EgEEmoD8WgY3ae72zqaiE
	 wg+1gD++bANyD1vH/Gw8qAqH+7yw+FpCWcx31+io+lk+2tOohVrVx20jDOv22NsuAa
	 1091Ts1wNZFCifFdsapG55yojRXpIaSkWUaQGiUuTIom6gGJPatYmQo/YyOlXydOBb
	 k80RcGw050g/Q==
Message-ID: <sashiko-outbox-212341@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 6/8] fs: add FMODE_CAN_DMABUF_IO and require it
 for dma-buf I/O contexts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mengmeng Zhao" <mengmeng.zhao@linux.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113070621.273953-7-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261113070621.273953-7-mengmeng.zhao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:24:27 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> From: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
>=20
> Add a file mode bit for files that can be the target of dma-buf I/O and
> require it when a buffer is registered.  Block device files set it when
> the backing disk supports dma-buf I/O, and filesystems can set it for
> inodes whose data can be reached without the page cache.  The bit is
> coarse: a driver that installs ->init_dma_buf_io_ctx for every
> namespace, like nvme, still decides per device at registration.
>=20
> dma_buf_io_ctx_create() is the only caller of ->init_dma_buf_io_ctx, so
> the capability and the O_DIRECT requirement are checked there for every
> file type rather than in each helper; O_DIRECT belongs at registration
> because F_SETFL can change it afterwards.  Add bdev_can_dmabuf_io() so
> the open-time and registration checks share one predicate.
>=20
> Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113070621.2739=
53-1-mengmeng.zhao@linux.dev?part=3D6

