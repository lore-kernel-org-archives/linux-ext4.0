Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794554819;
	b=hUPsP4DAsKFzAKwqERK3F8CQG28n27aVHONlmqGlkahA1dI69yFGpG8KNh3sn92uRQ/Y
	 7waeJN39KmlosIa7fDjKW978uUJZ3B/IHlNcy+o1OQtPrBHA0cSAZ7IazMwXYSSotZEqH
	 ASSyO8iIYwXbH8iXg+UPeOgo8PI2o82xfkBwv9rv56N6sE4OAOKyp6vm31YrEzDzcMr3m
	 tCJdGpBnjoQcd2AWxhk8JlYCYJGIXkQSyW+Kj+8876p9X57fqYryR3zdryTjbPYZc1y/7
	 H/6hkhJ5ccqpKDjLoBy/C0gqHlxl2EMn6Wu+gtce8bJwxWB6UaCLmW0xuSwIDLnEwdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794554819;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DYHniJB35d/WdQJtZVNf8qfDAJQcAmjOcwxAFZrGwPQ=;
	b=VsGNVaq8gmGTry0qkj7kYtgjz9d+dTDjxPJ3f08/2Ll/BOdpUp1cjbj4R4dsiCiDZhNm
	 B8YkS9jwlE75Ce/DDVwk1R7wUYhVChjmLNRmRxEGkh4afcgWcTVi1yf5IUMM97APiRL7r
	 MAWq57mPQSBkp5bKUSc1s+Z/399Jcw1hW7jlmDZhTCrFX1u7e8GUiAcGsKygJJo7fWkqe
	 1hmpLp+qpU88cElcS1DpLEf55bBQ0GKFhSBx6owaot+1Uno9UiMYItwdhm6yQf7JRTcts
	 of4kJgSKIMRU30seeAFU5qAvRD++7FzjUgAyooogx92chBSxPNPktCWuMFxpCYNO2LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSKhSlXZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465E0606A323
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 07:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSKhSlXZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3D31F000C4;
	Fri, 13 Nov 2026 07:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794554818;
	bh=DYHniJB35d/WdQJtZVNf8qfDAJQcAmjOcwxAFZrGwPQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BSKhSlXZFJ+mntgryqot32Ymz6nPmHR3dUgi+Qw0vW1AQ5vVYa6dxUoAtGzZTEmpE
	 kxqjny7FlsiDpZ5+k0tpBF57XFij/Fn95ZeHWBfPw0v7YBJgVJwOpOL4L1z1VKjJNI
	 W4+FYkg13umLf1iRQ1igl4Wl6Yl4aEzWlUljez8A+4e7z+Yk84/GuGsPTrO5Ay0Hbf
	 LgXQ7ZEZTfPUpCHjV2nMJvutZcNUoFrgl5Os0UmeTkM0u9IYFDYJwLmQS09gd/awwb
	 49QSlR1Hl16YYSzhNmk8i38Z3d4JEA0IerCb212TFH3KiUa5FXhGABs9Os/WFc4N15
	 1kJ3jCNjzTVWw==
Message-ID: <sashiko-outbox-212347@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 8/8] ext4: support dma-buf registered buffers for
 direct I/O
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mengmeng Zhao" <mengmeng.zhao@linux.dev>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20261113070621.273953-9-mengmeng.zhao@linux.dev>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261113070621.273953-9-mengmeng.zhao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 07:26:58 +0000
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
> Advertise FMODE_CAN_DMABUF_IO for inodes that can support dma-buf I/O
> and implement ->init_dma_buf_io_ctx() by registering the buffer against
> the filesystem's block device.  The capability follows
> ext4_dio_alignment(), so an inode that can never do direct I/O -
> fs-verity, data=3Djournal or inline data - is refused at open, and
> encrypted inodes are refused on the inode flag, which is set even
> without CONFIG_FS_ENCRYPTION.  The inode is rechecked at registration
> because DAX can be enabled after the file was opened.
>=20
> A dma-buf iterator has no pages to copy from, so it must never reach the
> page cache.  ext4_buffered_read_iter() and ext4_buffered_write_iter() are
> the single sinks of the buffered fallbacks and refuse it there; a short
> direct I/O write still reports its progress, and the DAX write path
> refuses at its entry instead of after starting a journal handle.
>=20
> Signed-off-by: Mengmeng Zhao <zhaomengmeng@kylinos.cn>
> Signed-off-by: Li Wang <liwang@kylinos.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113070621.2739=
53-1-mengmeng.zhao@linux.dev?part=3D8

