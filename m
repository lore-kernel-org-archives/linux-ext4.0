Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793729879;
	b=MX+frnRgH35V4woxQ0s00civOv/jmYU7dZVgAo2gZasTzqrs+w5Q/BXTgGxq9wmpGJiu
	 J8K/IZeOsEqfDK8rU/wRFsUJo3bdHQH0SxpihAOBMb+oZJwJxJn9jugST8fwRRTMEW/BY
	 p4VyiHvqh51TT8neCF7Go7wmVt/nFurpQ6kFmpKMzgEOO/kL+ezlqtjLW/c8Kb8+kLof+
	 1K+PM1XdTa85YGVC3oOvnWYFFD1XRo+vi429omTj8t/8FvqF6tjI7GZjOROusHJSKILv2
	 c7+imXBNmxwOHJjBfaWioVnluM1DKZGIJBZm2VVCEgnW9nxXmhD+V8I5gYn7NNZjCUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793729879;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=JPfBxuzzEE7KvkqimyPoXojo7KxSVDk0J6om8MLBKvM=;
	b=U3o6ew43JSsVIZ1hhicO0PGTUkz9ryJ1Skk0tWIXEl6JjIxE44i/nNjCh+yZOrPqIzsL
	 ijubcFnkmQQ51vL4zvZiAqlhXa1R4/0F8D1ZLxCYoWhzAIfoQL01LwOyLyBRy4fXarHRg
	 3mGqKMmrxp7+GaiustmUMdyL89ZIUVgSYriRwO7fD1+ddlUK2cUHENLAbQlMYcyRVTfn1
	 OMmoNVGtaJEg2Bk0doMCwD3yuVVgvGMYn8k9KUMwqXyHkuVVRPWjxfZDEYHDnSA4P24id
	 eDU3fjJtHZKiAMFPpN7nOcGpcLbANjombE1M7nNjDwJFIBwzgPH+wFTsqJX77rLpKag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cYJ0xKPO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723F4606A324
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 18:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cYJ0xKPO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C261F0093A;
	Tue,  3 Nov 2026 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729879;
	bh=JPfBxuzzEE7KvkqimyPoXojo7KxSVDk0J6om8MLBKvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cYJ0xKPOTqS32Ar9DQVkqqNTCGdv3S49T2/wab0KO0vfF8JB1tAQneyKhJZz2ETBZ
	 1uaQ8RTsK/NrbxR1ddclVKvSsp29+tyFprevmXcw8wR2R5LFVLmzYLBhoTiWhlGVvU
	 F2470d+AOSkoi1SpR4ddGFwYncfUZniFJakcGRTw4QgiuwHCNWkG8AwEUxfyM8xC5K
	 4kbiAta7Xdsl1W34FZDVSLrP899z/4sgcIkdvgws4zFIqfCG2LcINBQ+lXIUO7GQc8
	 D/sWfjA/lWzH2Y/NY0u8Xp9ZIDS5g915wBo8crzoobensrNe3nKOpvjMajfts1gWDc
	 EXEWZA1/IcfAQ==
Date: Tue, 3 Nov 2026 18:17:57 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Bartos-Elekes Zsolt <muszi@kite.hu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Subject: Re: PROBLEM: NULL pointer dereference in ext4_mb_load_buddy_gfp
Message-ID: <20261103181757.GA2224825@google.com>
References: <6b2dbf1d-43b8-f9e9-a2b6-e538f295bf94@kite.hu>
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
In-Reply-To: <6b2dbf1d-43b8-f9e9-a2b6-e538f295bf94@kite.hu>

On Tue, Nov 03, 2026 at 03:26:08PM +0100, Bartos-Elekes Zsolt wrote:
> Linux version 6.1.191 (me@hostname) (gcc (Debian 12.2.0-14+deb12u1) 12.2.0,

Yes, the stable maintainers broke ext4 in 6.1.191.  The fix is
https://lore.kernel.org/linux-ext4/20261102-ext4-ntfs3-null-folio-v1-1-4fd91ee23a4a@elliotjb.com/

- Eric
