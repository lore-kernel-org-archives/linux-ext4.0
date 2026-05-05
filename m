Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2E32641FC
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 00:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777940407; cv=none; b=r/pLzAGNPIZLsXPYYlSIttjv6Mtrbcju1YGRRPETTnypy6B7HeZtNCCkTepzcusd/2ni++hEL87eIUFxTX9U+BRGOLf5KemjQW+wkUfNaBWCIX0DgzhVtheHgv9Z+Qrla58Y7vSlKeTTRkITUka5eOrJtyO5ie7AZS5JZhpQBqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777940407; c=relaxed/simple;
	bh=70NGkJJQHN+W/0oT0IMBNC1O81CEJA+4pi5sBD8iM6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UYiNLF55hrYbZrqXPQatsR7B1ULmKdFVW4xScopWdUt4mUtyRY5rpvjzD6WQce0t1dBf1lBmqBoqmOAPM755bWiPLMrA8eM4kNU/jyy3QPpIZ8u+g9PziiXclwGQHOjz6eYB/C2AJT1VyzzEdWAAKfitwumpNGkR9ESK+PAhtJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F+9opm+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F+9opm+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3F5C2BCB8;
	Tue,  5 May 2026 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777940406;
	bh=70NGkJJQHN+W/0oT0IMBNC1O81CEJA+4pi5sBD8iM6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F+9opm+VvFWKv2zPq0ZxJubc1EBHf+0h2oK4N+EdUjS9POpLqShYiHvyoI7JKNiuL
	 yCnJdzIQRvMl9c7W+IQIO3Hdyr4QlpuH8S8z2tghJokjPCOA1SbHsQelntz1spvG3w
	 VsMZ8GfkPNyW+nqR3F+Sh1eUKtoSx0Yg2pZtgComOfs48W6aeKifNq7CWRFNOAXVPK
	 mqwobUHb8QDPKB/EMk2g56vIbE9pP5E69VUnrZPsTme3ywTpS7EGDWun3QGJgRpeMG
	 KurIboFCXCBU3WJcON5o8ULewdaSUYWmFCb6Hqrg0ehsaj048qXLdAGttfHu3qy9rx
	 POsPx5s7EIVgg==
Date: Mon, 4 May 2026 17:20:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 4/7] fuse[24]fs: suppress clang warnings which were
 breaking the github CI
Message-ID: <20260505002006.GE1101423@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260504233301.2345652-5-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504233301.2345652-5-tytso@mit.edu>

On Mon, May 04, 2026 at 07:32:58PM -0400, Theodore Ts'o wrote:
> fuse[24]fs.c defines some functions which might or might not be used
> depending on the version of the fuse library installed on the system.
> Unfortunately while gcc won't complain if there are static inline
> functions which are not used, clang will only suppress such complaints
> if the static inline functions are in a header file.

<groan>

> Since the github CI runs a test build with -Wall -Werror this was
> breaking the CI build.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fuse4fs/fuse4fs.c | 21 +++++++++++++++++++++
>  misc/fuse2fs.c    | 21 +++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/fuse4fs/fuse4fs.c b/fuse4fs/fuse4fs.c
> index 13e1aae4b..b883083f8 100644
> --- a/fuse4fs/fuse4fs.c
> +++ b/fuse4fs/fuse4fs.c
> @@ -502,6 +502,27 @@ static inline off_t FUSE4FS_FSB_TO_B(const struct fuse4fs *ff, blk64_t bno)
>  	return bno << ff->blocklog;
>  }
>  
> +#ifdef __clang__
> +#define SUPPRESS_UNUSED_FUNCTION(func)    (void)func
> +/*
> + * These functions might or might not be used depending on the version
> + * of the fuse library installed on the system.  Unfortunately while
> + * gcc won't complain if there are static inline functions which are
> + * not used, clang will only suppress such complaints if the static
> + * inline functions are in a header file.
> + */
> +void fuse2fs_shut_up_stupid_clang_warnings(void)
> +{
> +	SUPPRESS_UNUSED_FUNCTION(fuse2fs_shut_up_stupid_clang_warnings);

Why is this stupid recursive shi ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
even necessary?

> +	SUPPRESS_UNUSED_FUNCTION(round_up);
> +	SUPPRESS_UNUSED_FUNCTION(round_down);
> +	SUPPRESS_UNUSED_FUNCTION(FUSE4FS_B_TO_FSBT);
> +	SUPPRESS_UNUSED_FUNCTION(FUSE4FS_OFF_IN_FSB);
> +	SUPPRESS_UNUSED_FUNCTION(FUSE4FS_B_TO_FSB);
> +	SUPPRESS_UNUSED_FUNCTION(FUSE4FS_FSB_TO_B);

Hrmm some of these aren't strictly necessary, but ... oh.  The first
three are actively used in the punch hole helpers, but that only applies
on a platform that *supports* hole punching.  So my guess is that these
clang warnings appear on macos, where there isn't holepunching?

--D

> +}
> +#endif
> +
>  static double gettime_monotonic(void)
>  {
>  #ifdef CLOCK_MONOTONIC
> diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
> index 0f4781bc4..c46cfc236 100644
> --- a/misc/fuse2fs.c
> +++ b/misc/fuse2fs.c
> @@ -339,6 +339,27 @@ static inline off_t FUSE2FS_FSB_TO_B(const struct fuse2fs *ff, blk64_t bno)
>  	return bno << ff->blocklog;
>  }
>  
> +#ifdef __clang__
> +#define SUPPRESS_UNUSED_FUNCTION(func)    (void)func
> +/*
> + * These functions might or might not be used depending on the version
> + * of the fuse library installed on the system.  Unfortunately while
> + * gcc won't complain if there are static inline functions which are
> + * not used, clang will only suppress such complaints if the static
> + * inline functions are in a header file.
> + */
> +void fuse2fs_shut_up_stupid_clang_warnings(void)
> +{
> +	SUPPRESS_UNUSED_FUNCTION(fuse2fs_shut_up_stupid_clang_warnings);
> +	SUPPRESS_UNUSED_FUNCTION(round_up);
> +	SUPPRESS_UNUSED_FUNCTION(round_down);
> +	SUPPRESS_UNUSED_FUNCTION(FUSE2FS_B_TO_FSBT);
> +	SUPPRESS_UNUSED_FUNCTION(FUSE2FS_OFF_IN_FSB);
> +	SUPPRESS_UNUSED_FUNCTION(FUSE2FS_B_TO_FSB);
> +	SUPPRESS_UNUSED_FUNCTION(FUSE2FS_FSB_TO_B);
> +}
> +#endif
> +
>  static double gettime_monotonic(void)
>  {
>  #ifdef CLOCK_MONOTONIC
> -- 
> 2.53.0
> 
> 
