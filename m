Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794601667;
	b=eagic4EkfWEO9FSku8rCADcIQrqjtuaBgfhyjCEfNlgATDYDz6uo/uocnVxn2jeGENoU
	 ZuLOBYA1xFfVyUTXgTGh6u6ir/jSxSShyiXEbcsTQqbm/i5OVZbu7O2Pvz7MNvqlPqW8f
	 8klkOpu6ZUhaLY2VQAI6vZLpAQvT+cPuAIiS70CrpvOrK9Ub3Iwauc9yAywPmRlYgt3qJ
	 IHTuP/S9BqGHXtSuOwNV6YSQeL+uPmA76qGMx2z//qR/UrmNpEHqatnGWwln5TD4Dv/Lg
	 5mbOCTRMwX53Q/4cSY0+tAQLl9yc1hfsJrlNRGAOuHcuJwKnbhs7KBMtWTL8DXxwO1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794601667;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=71E/pZZutDXFCgTmV/sYEdB+FGyLcgDDycOt6RCmmmQ=;
	b=sYVPHSP39TFgDCHhsapsEozLxlsudx+fCxEd/LSaMUmJ58rJ9QopwGS8b8DuwZDDI+o2
	 GE9U1NYDF8qZQulBi33SB6otQFAYvNzlHHgmPCziOdaYnIo4zqF28oOoS7sclISvDJS8k
	 +I40bfx7dvn0Gk7gMAk/ejA5fmc8XL7ja6sOaDubjYlj/zoVH9soF20pwlmrfIP6uu+wP
	 +QORS/IJSYGk6gBqjmf7QuvEWO9AaKZ60nrdMbBBXY2vk1v3qVPCTDy5iIGycEZBc/W+7
	 aV4EJsDwGhbgOMB5ldHQbHie8Woivl+gQ03yvz2qf5jETCyLkKG1pS+pp/LNRw0VUIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WCjLMnJu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C589D606A339
	for <linux-ext4@vger.kernel.org>; Fri, 13 Nov 2026 20:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WCjLMnJu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFC01F000C4;
	Fri, 13 Nov 2026 20:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794601667;
	bh=71E/pZZutDXFCgTmV/sYEdB+FGyLcgDDycOt6RCmmmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WCjLMnJuRn05xJ1SMiw8lPGG5my/EA4Dis4taSxWYClVdrMRF9xoO2IcFxv9wjfF6
	 lf8RslvhBTyPhD0pVFZw1WQDx+aPF9Jyg4fk5lNdb13FUihHWsGe/r4P58m1kX2m7G
	 kI2x8CA5NW2KOtc5BGJvCiIhibt1F2d63SllptEqha5/I0+TVkqJ/iCLiQcD53WnL+
	 vR0RVRrWG5LXFl0YLmv39ehjD34aT5dROa/38x0pEArWc/PlG4J4gFJvNp5/u4BOEk
	 QZyVYHDb7eY6lEem48XF+IghEuHNIbpde6yBA7AqAdZJ7ctqa5d9LDBEBolT+NkooI
	 KdFVuPBiKtIOQ==
Date: Fri, 13 Nov 2026 12:27:45 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Alberto Garcia <berto@igalia.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Baokun Li <libaokun@linux.alibaba.com>
Subject: Re: [PATCH] e2fsck: set the encrypt feature if the filesystem has
 encrypted inodes
Message-ID: <20261113202745.GA29151@quark>
References: <20261113162143.824544-1-berto@igalia.com>
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
In-Reply-To: <20261113162143.824544-1-berto@igalia.com>

On Fri, Nov 13, 2026 at 05:21:41PM +0100, Alberto Garcia wrote:
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

It's probably safe to do this by now, as I mentioned previously
(https://lore.kernel.org/linux-ext4/20260925190751.GB2060@quark/).

A few comments on the diff:

>  tests/f_encrypt_feature_missing/image.gz   | Bin 0 -> 5566 bytes

This image has a 4096-byte block of incompressible ciphertext in it.  An
empty file would exercise this new code just as well and result in a
filesystem image of around 1.5 KB.

> @@ -389,6 +389,13 @@ int add_encrypted_file(e2fsck_t ctx, struct problem_context *pctx)
>  		return 0;

The function comment of add_encrypted_file() should be updated to
mention the new behavior.

> +	/* The inode is encrypted, so the filesystem needs the encrypt feature */
> +	if (!ext2fs_has_feature_encrypt(ctx->fs->super) &&
> +	    fix_problem(ctx, PR_1_ENCRYPT_FEATURE, pctx)) {
> +		ext2fs_set_feature_encrypt(ctx->fs->super);
> +		ext2fs_mark_super_dirty(ctx->fs);
> +	}

I'm a little surprised the fix is to set the feature flag, rather than
clear the inode.  It looks like e2fsck does this for other feature flags
though, so I guess this is consistent with that.

Given that it's done this way, though, let's consider the case where
the user declines to fix this problem, either interactively or via
'e2fsck -n'.  In that case, the problem gets reported for all
thousands/millions of inodes that could have the problem.  Perhaps it
should be reported only for the first, by checking
'info->file_ranges_count == 0'?

> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index e433281f..d8766a65 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1319,6 +1319,14 @@ static struct e2fsck_problem problem_table[] = {
>  	  N_("@i %i references EA inode but @S is missing EA_INODE feature\n"),
>  	  PROMPT_FIX, PR_PREEN_OK, 0, 0, 0 },
>  
> +	/*
> +	 * Encrypted inode found but the filesystem is missing the
> +	 * encrypt feature
> +	 */
> +	{ PR_1_ENCRYPT_FEATURE,
> +	  N_("@i %i is encrypted but @S is missing ENCRYPT feature\n"),
> +	  PROMPT_FIX, PR_PREEN_OK, 0, 0, 0 },

Isn't this missing '/* xgettext:no-c-format */'?

- Eric
