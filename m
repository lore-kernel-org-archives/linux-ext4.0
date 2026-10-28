Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793150009;
	b=RRHV132Ku9WMwXjS82nuROq/V+LDYTUYnjb902hMS3jomhpSEaHBJxbgNxfOdV2rPc1p
	 tht7tqOSya/Agz/iot7qpMMhra9rLwe1Z18zfuS4Z0nHcb1SEQz2t5opoQZqrDd9BX8eK
	 tdNpOCGIFJo3/oQ1QNKN0oMn8W0AzsdYfc1PLu78p5MYkDyXBsLq9w1AfAnZ3x6ELXPbv
	 Gkx0is5pHrBx/B3RBHgMXPZFHAdKZ4AGkB78madwhxkbXg1ZS+GwRHdy6Uoqxa/jPtHp2
	 Xk5BxxC1sqapngRkb+bAw+R8XNLtKb3R5KyX8lLcMG3OYYUiYb5S6udpK57BEpLAPqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793150009;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=sFo8TCnrO7TJ2lKbVEd0YQroZ7AW4x/RtCUnc2uNLcA=;
	b=JL0h2zByZcsBrZXtkRJgvzftXHg0RTfUbdCqxcUr9XHTLS/RaHmJLMgrjvLumgEFy+mS
	 dQjOx3lPlFhvvSFvXpSU8VOqccz24g8t7wGhyDGrMNM83nNVmvnlfODM3FAtk2WT/hrS1
	 CfDGLJf3eFMz8zdE4mpa6z2IDf+zAXprsYosmNUXpywS2/mEGpveqaxfFRekqnh7ox3xy
	 cYmneq93U4NFNJqVb8txdNIpEhQ5+VDGAlKBAcurW0XZRNhi5cAXbqiDeOxrgewKirsNC
	 2m1Fts2kMiVVSQ2Fy8INw4UDumpt47lqwxQuKqqeUIGkm29joiB5/1H7Sc6zqimTYUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZylZybYp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2691A606A31D;
	Wed, 28 Oct 2026 01:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZylZybYp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EC01F01825;
	Wed, 28 Oct 2026 01:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793150009;
	bh=sFo8TCnrO7TJ2lKbVEd0YQroZ7AW4x/RtCUnc2uNLcA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZylZybYppaKvUBpFJWOx+h9hZDGGvXJ9HVhSeXCSLP+IHvoMBN6mH3SXRdZLYkfz2
	 26vNjAvJvyyHa+piM1NwTPBdg8ISXDXUlwfvazgpGPGg7xenIvP+runEoDL170tAe9
	 1dPXPCCGmG3oY/0zPR/jRPn2tC7pDdfVj70aVGLRCcZa5fWGtf/wcmU68tFklqc/e/
	 S+GYZGyOaZqZdR1+rzeWdzR4CumCFj4pzfPaWbtbsokQzWB3pJp+HW8tDc8z3h1l3M
	 0EQDp0lSP7fxpNWTV7vvJJ1tgQHR5JxcQeu0R+Nrl92b5BHq93Itv0hdodxKd5Zgvf
	 p2ZhYvCenDYZg==
Date: Tue, 27 Oct 2026 18:13:27 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org,
	Zhihao Cheng <chengzhihao1@huawei.com>, Jan Kara <jack@suse.cz>,
	Yao Kai <yaokai34@huawei.com>, Zhang Yi <yi.zhang@huawei.com>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 6.12] ext4: validate readdir offset before accessing
 dirent
Message-ID: <20261028011327.GA1893@quark>
References: <20261028003746.31943-1-ebiggers@kernel.org>
 <sashiko-outbox-187298@kernel.org>
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
In-Reply-To: <sashiko-outbox-187298@kernel.org>

[+Cc recipients that Sashiko dropped]

Should the Sashiko configuration for linux-ext4 be updated to enable
reply-all?  That would be my preference, and various other lists already
use that setting.

On Wed, Oct 28, 2026 at 01:02:25AM +0000, sashiko-bot@kernel.org wrote:
> [Severity: Medium]
> What happens in ext4_readdir() if a corrupted de->rec_len in the rescan loop
> advances i past sb->s_blocksize?
> 
> In fs/ext4/dir.c:ext4_readdir(), when !inode_eq_iversion(inode, info->cookie)
> triggers a rescan (for instance after ext4_dir_llseek()), the loop only checks
> the lower bound of de->rec_len before adding it to i and updating ctx->pos:

Sounds like this fix was incomplete but the backport is still safe.

- Eric
