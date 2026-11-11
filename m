Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794389828;
	b=Rtca4QfuD4Vdl9/+ivx6wUsknxcgtb4Sv5kuPyC50j0mmhU/ESAD4P7fuW1ffR3RCax7
	 TOrVBJdu085tV4JmpZflw/sWoNsDXuXbWyzQ6/xQRB26kVyNT866vhpnUvmEg7SK8NKV2
	 302IxzS0iSLukWlYseK+kdJ4vs0108Pqbx8BMLP9iIEORDxAuV6ARAoGkXUYsPA/s7UxK
	 BanaOt6BCYfk0Q2FOaTdBm9wX1knDLzJUrUYivoU7uTAsY5CO5qUsku1+vSovrOV0xMM9
	 W29o/pWWNTY5z7n0BVvgjjYS78pu0Fb2JbHhs+Kh1BZw4M2k5m1YuxQ+eanPbNkMTdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794389828;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=V3OCk+N8SB0awCd36HtzgSzqG30/oaImEUc9AZVKUng=;
	b=wzBZurbBF98D6A8cQwjmPZC2kjYZIaRVsP7GXo/dWF6fUR/PFVY5jCABCvUE3kEN7XGU
	 MjMxe83E06HoIhz6YPCagOiyOUs+yCrZuvn5XiED88jBp3oBQq+GEfZmMY/AQJc6kUyS/
	 7IA84gKPpMPaDpdQKuBHDhC6ZV0Zpte7yLFTEwQ6ZMt2Si1UPSjWsjJj/kirXFdiVfpBW
	 MtPNhscXVCUP7l8Y7KRiX7Ylaix1vqXw3uq9r+Vg4uprA6GHngWF1SxAnGf2Gmanielld
	 nKgdTZj1f4gz2dNUK/xm6Bpga6uFhb8VWreX40zk/hFTGIt0he8S0NgjxL+e1tATupQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S3A4M8PG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B07606A324;
	Wed, 11 Nov 2026 09:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S3A4M8PG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D071F00A05;
	Wed, 11 Nov 2026 09:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389828;
	bh=V3OCk+N8SB0awCd36HtzgSzqG30/oaImEUc9AZVKUng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S3A4M8PGrXZZOjpczvfRgaHWV379jGtDI+QSGgXmCBtKj/ifTm4o2c/Ak/jI1r70F
	 2G46uDCdpQPL2kqtHqHS5rV/1XDUQoXAxQT2YrsX0fEoyBXHynKrsDXD6F4ZFfE9Iv
	 rg9rJLzMKxS14WpcNgCywWHctZHbfmICCX40LkQshwDheWrF1im1dw2Juu+6OxXvsI
	 QR+QoVJrLogbfPB2tmdB2QXkbfq6pDu14YuQu21BrehPbP86A/CS6YUpMGnawv5j+g
	 vvsgo74iOZRxBtosfh27sXCrUErO6RMDC9/L5pG6pwW800na+FQoE9k4Xsp5ln0jFn
	 2jqesqNPs4+vQ==
Date: Wed, 11 Nov 2026 10:37:02 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 28/34] ubifs: don't set SB_RDONLY after errors
Message-ID: <20261111-perfekt-dekaden-bildband-0e31f4bd1858@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-28-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191247@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191247@kernel.org>

On Fri, Oct 30, 2026 at 04:10:12PM +0000, sashiko-bot@kernel.org wrote:
> Should ubifs_ro_mode() call sb_set_emergency_ro(c->vfs_sb) unconditionally?

Yes, the background thread doesn't hold s_umount. I'll do that.

> Does allowing ubifs_remount_ro() to run after c->ro_error is set cause a NULL
> pointer dereference on c->write_reserve_buf or trigger assertions in
> reserve_space() and ubifs_wbuf_sync_nolock()?

ubifs_remount_ro() won't sync the write-buffers or write the master node
after an error anymore and ubifs_sync_fs() fails early. See my other reply.

> Now that ubifs_reconfigure() no longer returns -EROFS on a read-only remount
> when c->ro_error is set, should the assertion at the end of
> ubifs_reconfigure() also be guarded by !c->ro_error, similar to
> ubifs_put_super()?

Yes.
