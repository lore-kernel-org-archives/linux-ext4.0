Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793051112;
	b=rPUDywjlJngp4XXTwW421NC5DVwnqW1XGacCxI7Ypm4j9uTd0ucQvR10wosEuqyPcXkQ
	 4rhtcFyxIcjin/udaVeViMywRIpJow1CA5qDPGkrQmvgWtySGwCXfiKlmKZQJner6/Lau
	 ZoH+b1SPJuErf6Z47WUWoJ+pRdcafyU4VYmjKMB+EBMknCyy5k3kSIlKVu2F4LTY7D8L1
	 ucNXiU8GTReQR+9Vs+2gYsNImPYf6Z/iC1TEugxY7BqdKwz+xXlOe8KGSeJaQkcO7n7oK
	 +3mFlyJ9ooZvmX+7NoTMS8cWoyHZaYXRVf9uh+DvrZqh5qq/TDdLACnNMqDy4vYqODQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793051112;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bc0btPimZJPlaibGvFgoFV5rNJ8djwhej9Lb7S3UTg8=;
	b=aRn5h8AIpmDONotfBeAPjPRaczx6bQJSFam+k/5HgCjs2ArYWgUGyG3sO+cLwMefjr+x
	 yUxfFQXNJdlJgcUtfYqP0eWPKw6UsnRFV5aG+jpAHt6TCBI0559RijGW63UlXfE5FpI8e
	 ipuDT362UGHVV00C8R5LTun4LglfUqV5YsHlQF/Yx/n/RelUbfF7gDuN4H1FhhkYIo9Oh
	 IyjsWIu65eQO16hNS9bmBJRruU54zJRtJVO7L4WoydbQT6Q8oi5ebLePB07E8cTSlliQW
	 6eadkDqs80U/raf3uxcod/fpMebdOmfUq2xTQvQ/jf0EkNTaiqQMKfcK6GWx3HlM4IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DSornXuF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434C3606A33B;
	Mon, 26 Oct 2026 21:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DSornXuF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4121F031F4;
	Mon, 26 Oct 2026 21:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793051111;
	bh=bc0btPimZJPlaibGvFgoFV5rNJ8djwhej9Lb7S3UTg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DSornXuFjTL3O00BcpO78tRklJtdIjNguOzqis7mRJrCkb5JekXEu7W9SehNBNvVW
	 2VNgGwhZcxfVYHOqxFDbAk6BlcXwSR3+7lVhMH4WK0Pg1ukRRIFd8JwwDsxm5D/3b4
	 wkw6WHn03VP2FsbGCXtt86fhjo9cfM+ZvqtZptJua67PPQTiO1a3+Acymx9Qz8QxcK
	 p6HTCVMqd7Ch6MDQmf5gUn1FV/6DMrMJWVvGmJjZn8HawAHgMeaZAy85oUMDtNn2GH
	 Qqv7wWU8arbr3his/HvAqlXb/k6WnCbkfspK7RQvAVWACFdK9+WxHhTBPlc9SFFl+4
	 j9Yx/mIhKUzsg==
Date: Mon, 26 Oct 2026 14:45:07 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Jan Kara <jack@suse.com>, Timothy Day <timday@thelustrecollective.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v2] ext2: Make sbi an proper alias for EXT2_SB(sb) in
 ext2_fill_super()
Message-ID: <20261026214507.GB1330439@ax162>
References: <20261023-ext2-fix-context-analysis-clang-24-v2-1-a33961453899@kernel.org>
 <CANpmjNODG_MBuSJvRkzUjwWqeD=hSQLWtHkre8=9Z6-3ZmTKEA@mail.gmail.com>
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
In-Reply-To: <CANpmjNODG_MBuSJvRkzUjwWqeD=hSQLWtHkre8=9Z6-3ZmTKEA@mail.gmail.com>

On Mon, Oct 26, 2026 at 11:08:30AM +0100, Marco Elver wrote:
> Right, though function-local aliases are resolved. We just aren't able
> to figure out aliases that propagate through non-local variables.

Ah okay thanks, I'll keep that in mind in case it comes up in the
future.

-- 
Cheers,
Nathan
