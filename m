Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794870080;
	b=YWHJ7xBqM8niSHxmhCFOCCttzGMkCKk+HnUrHJ/zLk0mS0ABL1poSiNjCjVPRaa68ycj
	 /NcL3Wy7/xNvRwhdHox8VlMvzPkxm6MkJGztpzqRZSvVhEy6SW8ffFN2S3QtUlAZbxUYO
	 YgcHJ7aJvKD4WMFGlxUPfk+wVebhtCwnXuylG7Fqc8m8ELVnqVNxxS51YzsrfgJwuIHU7
	 gPs/96gtgNb8Yso+v1bWfY4WQTZtFO1w+vy9Vy8KcKDksr/0l0FpaxQzN+OHbitURFg/g
	 xmi9W8ff2++k3VsUROj6UHL4wGUARNCAFFD77435gUzJmC00tsp81A2bmZiVEoyHkkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794870080;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=71SNAf4uv9b2FndV2ULwhSnXNI+lMZguIe0QvnUNp28=;
	b=W8NBNg+rTM0OGIC0ziqbVK2s3dhjZWr4h1sDT5cXxI2crXIRo2axpR7o4rSibP8oW6Ae
	 zMenXxY7ShSUO7oZGkKNfbiH7o1O+KKoZ4vxX1OHjhjU2zbOoMew12TVl+QXkwRRF3aKT
	 M2AaOcj4YlwyxYVo6bmor8Xkwg9ymnmtZu6SRUgJb29HK0NUHssYU4OF6+z/WdP0CwKVn
	 7/h87bZSdxdMQJcM8bsm7k5i4TpIAMQkRfQ44upiZSeo+neyyaOhjg9C0vghTIOJ0Plqd
	 zDagXbjVoJMLfMZ7h9+lk+AeYMR8y7+otTsDF4KO45NZ6Tk/k9Z505NRKCxrKl1dSbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SIxVrEXK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE49606A329
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 23:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SIxVrEXK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743901F000C7;
	Mon, 16 Nov 2026 23:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794870080;
	bh=71SNAf4uv9b2FndV2ULwhSnXNI+lMZguIe0QvnUNp28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SIxVrEXKBczbN5B1RQ2IeKDNUsvRPobnmGsUQJW/VONGYqWWjW8hEc0QfOC5Nw5Wu
	 WYhJ5EcT1PSVR5KBZu5DWAIbyNk1L/UxIioMwj5u6KgybmgFlAfITE4033ueuQc8Of
	 kxH7o/CSFsKTNa181c6Rysbn/w94MGBNZxQiVUc6rrsApOTLWIxJ7cAD0Kzm8u0tDK
	 tsfkFp5LUMVVLwl2/OfbyneyXgyxcUb4u+ixGLujol8uTmx2AE1BsxDgN1mzBsDLH3
	 9OajkyW4FsaVIOHtU57B4czrc+6oi2R8v/CBqLwahY97+XhjUDScixO/78g85glwK5
	 2W1SK/HruSuzg==
Date: Mon, 16 Nov 2026 23:01:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Alberto Garcia <berto@igalia.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: Re: [PATCH v3] e2fsck: set the encrypt feature if the filesystem has
 encrypted inodes
Message-ID: <20261116230119.GG229817@google.com>
References: <20261116225208.108150-1-berto@igalia.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116225208.108150-1-berto@igalia.com>

On Mon, Nov 16, 2026 at 11:52:06PM +0100, Alberto Garcia wrote:
> A filesystem without the encrypt feature can still contain encrypted
> inodes, either due to corruption or because the image was crafted that
> way.
> 
> e2fsck currently accepts such inodes without complaint. Since those
> inodes can be decrypted, this should be fixed by setting the encrypt
> feature on the filesystem.
> 
> Note that the Linux kernel does not currently support encryption when
> the block size is larger than the page size. After this change, such
> a filesystem will be rejected at mount time (see the kernel commit
> 709f0f1f1bf5, "ext4: add checks for large folio incompatibilities
> when BS > PS"). However, since this depends on the page size of the
> machine where the filesystem is mounted, and the kernel could lift
> that limitation in the future, e2fsck does not take it into account.
> 
> Fix this by adding a new problem (PR_1_ENCRYPT_FEATURE) and a
> regression test.
> 
> Signed-off-by: Alberto Garcia <berto@igalia.com>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
