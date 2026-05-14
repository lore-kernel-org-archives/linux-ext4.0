Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F9C2989B5;
	Thu, 14 May 2026 03:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778730852; cv=none; b=PKwmug7fSuCI5yx9qIRNNtlgQOnidRUZM26lIO7VTZm0Buhr2LqeUwS/zVOM0A7Z/21dCa7TV7573LpVKY54gpMihkl4UpUZvvajPDuZH83eBXmR5aZqyB03n7UfW5RpBBbybA8vSWu56K8ayRaRDCNK7DNJEv91Ky8wwMW1+dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778730852; c=relaxed/simple;
	bh=8PtDRdXMVSbjnST+Cs0Dn1Z2/E315hAZtklcn942KsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H/1QYSGmKfPlgdhenqZf7kBhRnBNqAzQlF1gtN5dv0XBNGuvHnrLSjn4Xba6lSx18nVJQfyUeh4SCbc5XM0Hl+G8lODLwJH6pHtbdKHSFE/5KP+/sxBr8loJ6MJH7wot5LEFVIZMzRYPozqbYLsHX4jN3L2XzdTsHcMFft0k0wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFobv/Al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFobv/Al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710ABC2BCB7;
	Thu, 14 May 2026 03:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778730851;
	bh=8PtDRdXMVSbjnST+Cs0Dn1Z2/E315hAZtklcn942KsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gFobv/AlwQ+0/2J67Xr5lnaYxSS5tAqfjty33eet0pXkhE4YYHYHjCFpo01D6bYJ0
	 sO0j1vr2yoIuVWJHltZr9e2ZGMa975F9kLQria7yQSJVoa/CD/x40T8p0jj42aBNUG
	 L6XSeG8Lyu9vMCwrwDviN5fWORWofdsDLOMJQJ0YZngy9KcNhAwrdIhMmSE3ubRxbq
	 mwRKUj41Y7F4jiLmMdwrdd0Yhfbd4P5jcLs4UB4MtmEEnMSTkYuyopJpUwJKHQVEUK
	 orSGmH1V3xQ3hChhF+yywzPs/zkMuYVdsxXfVkE/BlSi4CShiNQMvwhDKtBs+rKVuZ
	 1s9dMSYRich6Q==
Date: Wed, 13 May 2026 20:52:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, linux-crypto@vger.kernel.org,
	ardb@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com
Subject: Re: [PATCH RFC 01/17] lib/crc: add crc32c_flip_range() for
 incremental CRC update
Message-ID: <20260514035248.GA2816@sol>
References: <20260508121539.4174601-1-libaokun@linux.alibaba.com>
 <20260508121539.4174601-2-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508121539.4174601-2-libaokun@linux.alibaba.com>

On Fri, May 08, 2026 at 08:15:23PM +0800, Baokun Li wrote:
> When a contiguous range of bits in a buffer is flipped, the CRC32c
> checksum can be updated incrementally without re-scanning the entire
> buffer, by exploiting the linearity of CRCs over GF(2):
> 
>   New_CRC = Old_CRC ^ CRC(flip_mask << trailing_bits)
> 
> Introduce crc32c_flip_range() which computes this delta using
> precomputed GF(2) shift matrices and nibble-indexed lookup tables.
> The implementation decomposes nbits and trailing_bits into
> power-of-2 components and combines them via the CRC concatenation
> property:
> 
>   CRC(A || B) = shift(CRC(A), len(B)) ^ CRC(B)
> 
> This gives O(log N) complexity with only ~9.8KB of static tables
> (fits in L1 cache).  The current maximum supported buffer size is
> 64KB (INCR_MAX_ORDER = 19, i.e. 2^19 bits = 524288 bits = 64KB).

It will be a little while before I can do a full review of this, but
just a high-level comment: "only ~9.8KB of static tables (fits in L1
cache)" isn't ideal.  Large tables tend to microbenchmark well, then
have worse real-world performance due to lots of other things contending
for the L1 cache.

Another consideration is that basically every Linux kernel has
CONFIG_CRC32 enabled, regardless of whether they would actually find
this new functionality useful.

I'm not necessarily saying this should be its own option, especially if
it's useful for ext4 even in the non-LBS case.  But I do think it would
be nice if it could be a bit smaller and more memory-optimized.

Anyway, I'll look into the algorithm more when I have time.

- Eric
