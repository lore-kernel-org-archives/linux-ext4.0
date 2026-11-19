Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104880;
	b=y+PROYM+TYetiOCQpfdTKN8s3KCNS9a5VP0yGPEjXUGrFQ/mgYRPo2MahBJjKoaAB/dm
	 avJQg6QLB5Q2/KHvBsMvCdPvhMGzo2uY/b/jOOdVYTyTbgpYS68evVO0GtNhXENa7A6tk
	 kCgNN+8sCfU+G5cVdT32RmA+CjGlSQMflVmPhAnY3YdB6ZX+x2IIZN8UL4JRSLMYdesxl
	 T9Udii8kSyt+j7I8ZU2elmtfY9IoZ+IF40O+6FAUkLyif4zqBon65+6uncjmp7l0R3XgV
	 qH8WsXScD0L74yb6qTO4Z8floU9ic9q5Ag5qOzo7k8WRm8S20c2rDqp2G3+0G/wVAFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104880;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=i3zXJBT0gTcRNCqtC4YboQ7RWbFyiBmM88O9WmPlixE=;
	b=eG08XJ504h/9fgjxp/97mTxpvm+CosWBUu1dUcy+y4mXrH+ZdyaFTe7g/0NXvwoidSaN
	 QuV4Z32Iy3RetND33HG/9YcVoglcwoyYIYGSzbQEuE+npTSw9xIFO3WYK03OutYcT+sU5
	 PnJOuUg4XASiZyo9yNwSimst40hJ57sjWiJ2PM6Xcm92wYZcy7dFfbz7hPVWcUIo9OuuF
	 UojUMT6MbOGFYA8LHlRfG/hoTHDho57UmBuI8aIrJaaPR6L8JZfLLzPZX9CIXtjnogKQo
	 bGYSzBhZRZcG1r8FuNTkeafAySdHiPRNSGOBsJQ41LGeDCcOyNfxxkhrZQM1pze4/7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KvZX4dD4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C1E606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KvZX4dD4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCB81F000C4;
	Thu, 19 Nov 2026 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104879;
	bh=i3zXJBT0gTcRNCqtC4YboQ7RWbFyiBmM88O9WmPlixE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=KvZX4dD4nD52pn+MCBYeo3ldNrxGSXJ/SAF2gsc8KOg5XIrfKXgPFOvbfoOWuLuMH
	 hmbC+0w7JVGumyCWoszLqRq7vuqpKn3VJUC+jcq4VgjkUc0mPp7yIrVo5kUmmczQnA
	 qeMwdQ0Ho5qEhKhEZfHo+YkWfBSG2Cvxo/+5Iq92tEzGFvQ+UL4OLxnumBUoiEF8Ob
	 MeYZkotqd29g0JVJKBX8hlncDmEcPoHT1ojEXKuiQsh6M49xxteef5WCkUI4tnFth6
	 M521COjjou2+jIj9xwn9XgolGIPhitWbmXH+SCRgeWzbgcV9pQqruHxFIQNW0gY9fS
	 wmLt05svRqXKQ==
Message-ID: <sashiko-outbox-223499@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 23/26] ext4: add KUnit tests for
 fs/ext4/move_extent.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-24-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-24-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:14:39 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

> Add a KUnit test suite (ext4_move_extent_test) covering online extent
> swapping and validation helpers in fs/ext4/move_extent.c:
>=20
> - Ordered i_data_sem lock acquisition/release in
>   ext4_double_down_write_data_sem() and ext4_double_up_write_data_sem()
> - File, feature, and mode checks in mext_check_validity() (same inode,
>   cross-sb, non-regular, bigalloc, DAX, data journaling, encrypted,
>   non-extent, SUID/SGID, immutable/append, swapfile, quota, zero size)
> - Sub-page alignment, EXT_MAX_BLOCKS bounds, and EOF clamping in
>   mext_check_adjust_range()
> - End-to-end ext4_move_extents() across origin/donor holes, unwritten
>   extent moves, written MEXT_COPY_DATA with extent splitting and page
>   cache preservation, unwritten-origin zeroing, and -EBUSY release
>=20
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D23

