Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794859526;
	b=4OHYu2hlPBSRRoV2wi6PqU1MmpVPDuVX+KJCTnG7D2tHDe2uDWQs9Iwo9PSiRrgn2Iws
	 AnWs+ODhdqq9oVXvOKdylmGYaOfRjbul/nWY6jboKX33Lq4YUI56JaPs0mkYFNUM5f+N5
	 T0iXLrUPC1ev0D9JgqH/pSqa3Y0BLy5+vcRqoGCDj6+sT5yz8UqdHrUXez2fmesGA/ROd
	 Q7TsNR/RooGZ5lDKioCftpD2YyFaqUZB756RlOcZYz7FzVq0xIDRHRhmuhZoECp/28cHd
	 jTRwCwTwkK8QFMW3Eazgo32XrUbhOwVxppX48oGIpno7oy/qG4FN2BbmqPOVa7BVTzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859526;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=l10KwZnyY8coN9NQid+WKk5YmcYQIwYBCQlgLcj1qYI=;
	b=o7EbYi1G/JmZhP3qBfJHRd/yxzpResqFJvwbfJZWh7Ia/DxL7g/xjzSJ0yFVb6IAZVAS
	 aa85dA059lt+N3pzg9RNQUdTEGVx0ce1T3yMCVs6+LvuoQeJANM+Y2KYjx4Tjgp2hh5iq
	 cMj97ooDViEoCd5HKLhrIMrgRKs/aqQPn9BiqFmsBUy+nAmzpOlPM28Nqv1gRx/FSOU3P
	 T66GPLKiRs2IdYkjkX8iJYhDFAm43NO8XvzHzDX4+tsZZEchD/bn+MJPKqSrMBvUpjlgN
	 FkdU+t0/beaAYBXJX74FMr5yIIzqmXZi+vS51c/cuFM0FL7h64c74KV98w88vvtHxLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nRp9sI7J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52F2606A8A1;
	Mon, 16 Nov 2026 20:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nRp9sI7J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B0E1F000C5;
	Mon, 16 Nov 2026 20:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794859526;
	bh=l10KwZnyY8coN9NQid+WKk5YmcYQIwYBCQlgLcj1qYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nRp9sI7JCZx3gq9LvgUoM2Lfg03vzU4e3rIkXftRbvJXSIgnWKmf6raxsWNDsD/NS
	 RH2gupg0X8Ypq4c9MbQaYyLfIJzxdHf7o64ZBCERTX2yWofJPDXcHQIvck3z3sHFK+
	 ZLibemkSlskMRXiiR/lUsVj0pQy/R6Ll5A49L8sfg+Qa1k64Knzi+vS1+e8nqIX0tB
	 5ZEflWAcs8Ko2P/NypGbo+qtba0FEMtIUuW/1uZxA19PtvFlkZmH6EJ28DB8gBLOiY
	 EveC18Is3ngrgkYJ1z5PEgnsZ/FlYYusVypTqdMnFxoygEJCwFPTV/GafMoI2Wu3yb
	 pOIyWHYucQEng==
Date: Mon, 16 Nov 2026 20:05:24 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Sarthak Kukreti <sarthakkukreti@google.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
	Dmitry Torokhov <dtor@google.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] libfs: reject casefolded names that fold to ".",
 "..", or empty
Message-ID: <20261116200524.GD229817@google.com>
References: <20261113065332.929085-1-sarthakkukreti@google.com>
 <20261113065332.929085-2-sarthakkukreti@google.com>
 <878q2swoxp.fsf@cartola>
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
In-Reply-To: <878q2swoxp.fsf@cartola>

On Mon, Nov 16, 2026 at 02:34:26PM -0500, Gabriel Krisman Bertazi wrote:
> Hi Sarthak,
> 
> Ugh. I agree this is a problem, but I'm also trying to understand first
> the real impact beyond filesystem complaints during lookup, if any:
> 
>   1. Looking up ".\u202e" folds to "." and matches the on-disk "." entry
>      (de->inode == dir->i_ino) in generic_ci_match(), triggering
>      EXT4_ERROR_INODE ("linked to parent dir") in ext4_lookup().
>   2. Looking up "..\u202e" folds to ".." and matches the on-disk ".."
>      entry, returning -ELOOP via d_splice_alias() (or triggering
>      EXT4_ERROR_INODE on the root directory).
> 
> These two look like a "do stupid things, get stupid prizes" with no
> further repercussions beyond the error message.  Sure, we can fix them
> to throw EINVAL, but are there bigger repercussions I'm missing?

For one: if the filesystem is mounted with errors=remount-ro or
errors=panic, then EXT4_ERROR_INODE is more than a log message.

> But the way I'd suggest be handled is by rejecting the ignorable code
> points lookup (all, but variant selectors for the reasons above), early
> in the lookup path for case-insensitive directories so they never even
> get to the filesystem.  Wdyt?

If variation selectors are still allowed (e.g., "..\ufe00", that
wouldn't actually fix this bug though, right?

- Eric
