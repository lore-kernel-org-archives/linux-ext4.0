Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867478;
	b=A9RuHG3qnUiuYphiFVqIzOkM4Pn7PMAkt8lgAYbWS/397/90wcQ5L481WaIlY9v2Ytbw
	 LzyQqgSTOK/ITVN2eqXyI930yJwfVMW9qBrwAGbBvOo6mAIY/byaYfzaNjk9aFslbba8E
	 0k/0u8rQrtwwnqEpf4yGQPVLaL3u7I8o1SEh9ENufABFWbPrmJrXGJ+/NNbPoG9rvK4hi
	 7A8soarEB3uLC9OBKXpoEpUvxelF4k41fs5wAy0RhHLaxbMQgLt6/rlAi25AdFLQi41NG
	 xCdFLpBjxgyhWB8qGJQTBwtYXbGvdwbh3Ko3bs6+1zGHMoAZUM0sAj6DcplmzlPRqCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867478;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IGRRZW3J6UJvu7JeelLqLUevH1B+4V5oWdry0fvPc5s=;
	b=Yd/ujMaldT6Ckqyr4Gm3vGwDZOAqce6UkoKkmIwX5Df3B5KNmyisAECEUtvhllkt459a
	 M3/xwuER8SKsMbi3gkWFv+k9FsoaFvCGmnZ7hEmV/wDRMbL5BdyLw8a4Kuv370mCoiuSW
	 QVnDrf0elaLBeciuOFDc3O9Fn0cF2fNOjckXN1/k0AREvOCBhBOLoXJ9xukOa+C00wK2Z
	 BwoSV8ymRGvKMImbVzPtIAHOQv3o1c9NJFZ2MHEWvTkllfSYm2cxBSyGVJ5VgQp38BNsk
	 3UTy75ja9MfzRy961Ao6PXja0rmLoLGaK7JhHosFVryskLTohkXk0MDEyFU+NRRIhsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iUELJt1e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67532606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 22:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iUELJt1e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D64E1F000C4;
	Mon, 16 Nov 2026 22:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794867478;
	bh=IGRRZW3J6UJvu7JeelLqLUevH1B+4V5oWdry0fvPc5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iUELJt1eOd/g9UyDCTbz2fTcx1RBh59CAtYyrnE1cGc/5OZBvL+NG/cEXMDw+tH6e
	 E6o/dfdPjb4XPzA4dd4+kByQo+te+AvaZfFtEc05mTtAg9dzBNX0IOZIgwRqZ9+bbe
	 QntjMQqPn9q/jSKHpU7GhxDfWoMcUZJMzAz+0b8plJrwTsXu+kraVWHniavXXpoigm
	 A/u8FeGK+apI/2x0g42xklyjs736IY5iSxWjnelThuMeHO7fccfL6GNH0eOaAsDEXy
	 gpOwuEUz7cm2aMaQFmR4ITorlM9aqwVmHN7PGsYyg0c4om54NOF7VYYLNzM2xH1Zq/
	 JgQvwvXXCxRgg==
Date: Mon, 16 Nov 2026 22:17:56 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Alberto Garcia <berto@igalia.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: Re: [PATCH v2] e2fsck: set the encrypt feature if the filesystem has
 encrypted inodes
Message-ID: <20261116221756.GF229817@google.com>
References: <20261116142812.85180-1-berto@igalia.com>
 <20261116191853.GB229817@google.com>
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
In-Reply-To: <20261116191853.GB229817@google.com>

On Mon, Nov 16, 2026 at 07:18:53PM +0000, Eric Biggers wrote:
> On Mon, Nov 16, 2026 at 03:28:11PM +0100, Alberto Garcia wrote:
> > A filesystem without the encrypt feature can still contain encrypted
> > inodes, either due to corruption or because the image was crafted that
> > way.
> > 
> > e2fsck currently accepts such inodes without complaint. Since those
> > inodes can be decrypted, this should be fixed by setting the encrypt
> > feature on the filesystem.
> > 
> > Note that the Linux kernel does not currently support encryption when
> > the block size is larger than the page size. After this change, such
> > a filesystem will be rejected at mount time (see the kernel commit
> > 709f0f1f1bf5, "ext4: add checks for large folio incompatibilities
> > when BS > PS"). However, since this depends on the page size of the
> > machine where the filesystem is mounted, and the kernel could lift
> > that limitation in the future, e2fsck does not take it into account.
> > 
> > Fix this by adding a new problem (PR_1_ENCRYPT_FEATURE) and a
> > regression test.
> > 
> > Signed-off-by: Alberto Garcia <berto@igalia.com>
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> 

As I mentioned on v1 though, it would be nice if the function comment of
add_encrypted_file() were to be updated to mention the new behavior.

- Eric
