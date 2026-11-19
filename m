Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104999;
	b=WgFbVsu6Rm3Zypo4EnSbXSbKZRJUA06nFIK/fZa4SfJgBHbCYZNdk/pvIhxAtTqHr9Zf
	 FCdcl8IjEPIeL8BRj22Aec+Mgr0ZxNXOC03GfvYJDRAzSZx+EGGR5PMBbt5+B9Npt5gUq
	 yPDUtm2P+xO0vHfXwDjq7tJNZpjmVxL7mo2MgVANE2fefGulgz3yaRNOQ6c0KBDhxyihw
	 AK959b3+P0eB2hC13OctCsOnqCMSpp9gXu1B+OrIadt4PMXU7Myu1f8nLTMuRi3qBTA2+
	 d4VOw5mhMZaOLUDB/RdkwTWnQr7ZE5wpWxW/O9D2cOiORBVeFhDWYhgG2bU8NGZIBvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104999;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=imQpIEAk4uhg87zC12+EPXc9M6h41xfAp5o73LRWSvs=;
	b=S4Eu7W7FzIs9VkxecRA4OoYWYZqMa/VFeOvXm+R07c5pl1hVFUZSWG0YdwYz2mvU6ct6
	 jE1LWT0f/TY2xGzRqlBadk790yj5UNZYNFCHjpQVMZqpZOH+sr2VtGIGjXlK1SxQcPmNp
	 /5cfo2JbsHQ9AQYdbISsEdGn5fFKCcBfTmRfdv/EvXSX96CsipviBounpOdAZsKFjD6HJ
	 X+OfaONFbk9QwLHzeeyX8UZ5zlRs4HwHBZJ6ipuRfyytGPK5FepyFiVF0L9f5RZk/qr9A
	 mFrpM5t6telISbZTcH9icFF+1xWV8jWt/lqJ8xchz7ZAMrt8+rGm/blK5LhjhTokQBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WyLXE0X7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F3606A320
	for <linux-ext4@vger.kernel.org>; Thu, 19 Nov 2026 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WyLXE0X7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1602D1F000C4;
	Thu, 19 Nov 2026 16:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104999;
	bh=imQpIEAk4uhg87zC12+EPXc9M6h41xfAp5o73LRWSvs=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=WyLXE0X7KcEIMvABOUYzd3ceTrEJzAdsHCez16OHo/n9IPAkT2ZxSt7QGhRvVIufh
	 KfCRVijIxCKOa9D2C+G9kqGnY1SWyuDwUpq7yf01r1pcDCj/5OBaVxcSIln1cI5vJh
	 W5zqkqnDptXuQ7Pcn5nI6x86vJ9UX8ogopPHqwPzfxAiEBi5Ib4ig/IDbDr/iZOuy7
	 IUmpqiZGag5cmkdEQzkf8Wv7ep1XAoXZ2j0vyOuWVQafKB+I9EafxaDewLsDjjiOW4
	 dSwTWBXLgLtDsuX73p/BRRmG8/XL1IapsLJwOdSdOFvJfdZocaRaHwK+GCoKXUFXyE
	 UNwZgmzoKogsw==
Message-ID: <sashiko-outbox-223502@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH -v2 18/26] ext4: add KUnit tests for fs/ext4/resize.c
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhlb2RvcmUgVHMnbw==?= <tytso@mit.edu>, "Ext4 Developers List" <linux-ext4@vger.kernel.org>
In-Reply-To: <20261119155658.1940864-19-tytso@mit.edu>
References: <20261119155658.1940864-1-tytso@mit.edu>
 <20261119155658.1940864-19-tytso@mit.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 16:16:38 +0000
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] ext4: NULL b_bdev in resize_init_mock_bh() crashes
  trace_block_dirty_buffer()
--

commit de282382ebae06ada6fcade5556ed1357d9a76d9
Author: Theodore Ts'o <tytso@mit.edu>

ext4: add KUnit tests for fs/ext4/resize.c

This commit adds a KUnit test suite for fs/ext4/resize.c and routes
resize metadata I/O through stubbable helpers so online resize paths can
be tested in memory.

> diff --git a/fs/ext4/resize-test.c b/fs/ext4/resize-test.c
> new file mode 100644
> index 0000000000000..81c9fd96816c6
> --- /dev/null
> +++ b/fs/ext4/resize-test.c
> @@ -0,0 +1,1336 @@

[ ... ]

> +static void resize_init_mock_bh(struct buffer_head *bh, struct folio *fo=
lio,
> +				u8 *data, size_t size, sector_t blocknr)
> +{
> +	memset(bh, 0, sizeof(*bh));
> +	bh->b_folio =3D folio;
> +	bh->b_data =3D (char *)data;
> +	bh->b_size =3D size;
> +	bh->b_blocknr =3D blocknr;
> +	atomic_set(&bh->b_count, 2);
> +	set_buffer_uptodate(bh);
> +}

[Severity: Low]
Should resize_init_mock_bh() also set bh->b_bdev (for example, to
&ctx->bdev)?  Because these tests run without a journal and do not stub
__ext4_handle_dirty_metadata(), ext4_handle_dirty_metadata() calls
mark_buffer_dirty() -> trace_block_dirty_buffer(), which dereferences
bh->b_bdev->bd_dev when the block:block_dirty_buffer tracepoint is
enabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119155658.1940=
864-1-tytso@mit.edu?part=3D18
