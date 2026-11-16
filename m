Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794856735;
	b=A7Xcwvgua6bUITNgTOIey/D9NGewGl7aKipLF3HVMQ5+RoUj98LuUV4fvGdKWsC9zSN7
	 X89YtjF+/V0Cry0rY8GvRF2HfsyVrVlyztNr2sBtKAEYlgjAm/d3R2E8S9Xz/houuNiAY
	 Q/qhuKM33sWnYUFBWjmZ1CXZi6dtwnluHfB3cwQP/IBxgEZ3XNV6JwL6NNH8nMrfgT4Oy
	 oI7Y1WRriDmNbNe2UdwVRt3RTjw5UYSCcWtFGXMIfyygxWGJMZSDeW6O5es58GG4IcERv
	 /YttsSQD/TBqWqgZoCVT8tWyhskRUCrTOT36SSojv4QjJkta6dsxv86GWtKsWE8Hbuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794856735;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LxeVN5nYup5ru2WqL9jeRt78Rp+RpGWP2vLZSKcN5xY=;
	b=qkGRpD4R2cOidKnUbS6bJ28tqdzhghVgu5DufA/c1BhxWVEo3ALmFk8//ej2qqjasGld
	 ue8Lw5teFqHigYgCJMBLzqKPjE9tknAIvVcdMdfftptGLvePhS2rP+niVlwRIL8mMqO4r
	 GGm2ZbIAzD/G2hRJx9+7IortWFvk5yEWTu0hpT//NfZpLEOr/AAVmrrLyk07azg1lD/G3
	 ALLWr2wO7769seB42mQKewl++lkFQXhqH5q5a4cdmKZKhtJhfGhcCYBtdybitn5QfQlb8
	 5W+XMuS3JtsIR8bPqOZO0Zcf0RVb3HlS+XcNwe0MQJBKyqYEobkEiuj98zoai5s1B5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="PNf/3VNZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361D1606A31C
	for <linux-ext4@vger.kernel.org>; Mon, 16 Nov 2026 19:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PNf/3VNZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BA51F000C4;
	Mon, 16 Nov 2026 19:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794856735;
	bh=LxeVN5nYup5ru2WqL9jeRt78Rp+RpGWP2vLZSKcN5xY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PNf/3VNZJktoHGZpIQeUWO/zdhcS13rj1Q+1zNbQHvusaTWX4vOH/tIlAfK2kSSgi
	 bQLTRgnbSfKcgK7thoaqnhk10Y/ms8cNN2vDqGEiLbiaMfvG0GjqXzH/Ea4YnqPYte
	 s+1ak6N1TpkOBFuWW9ZjTC98wHMynKl0l2lcSRsjFgGMXke/V2iNFpcvaA+4ePOweL
	 SQseMeXqIYDBHpPBaLhbkAbH/VZ0fMpjNetunyic+9S0IIIhXdb0CddIS7GOFvMHk5
	 2vy2LUGN73t/LiV8PctNtGIGUoU0xbc5a6HdO6omcQi7EfbSndbgvH5p9NXGIyXd1a
	 uun+wu7y9B+dw==
Date: Mon, 16 Nov 2026 19:18:53 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Alberto Garcia <berto@igalia.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: Re: [PATCH v2] e2fsck: set the encrypt feature if the filesystem has
 encrypted inodes
Message-ID: <20261116191853.GB229817@google.com>
References: <20261116142812.85180-1-berto@igalia.com>
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
In-Reply-To: <20261116142812.85180-1-berto@igalia.com>

On Mon, Nov 16, 2026 at 03:28:11PM +0100, Alberto Garcia wrote:
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
