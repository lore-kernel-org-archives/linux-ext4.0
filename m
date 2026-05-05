Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220172010EE
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 00:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777940422; cv=none; b=rTVwGOXdqZ3hmC6tQLUpbdX4e9pZIAVc3PuRFBJxkN8I813BV5PZFEMnz6Nsy41yLTWY3hne9Ws6ytqZcpUGeos8rkILvgUFKpwtJpyqFtOxhVcTzowHvuAa7muOEy1dRC6YiH0IBfvKnliDRq6jQvjDTqCB+hucIpNrS5mROU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777940422; c=relaxed/simple;
	bh=rCAablyPIDi3A9r4vYkgEII81majNTg7OpFqoM36EY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jNPR4nfanmMI7vqhNpooPsoIOt8cgCJmYjCAxDGJd6Wqp1RQlezZoMHOVBR7sTjVg81fyqmtehNUHR12+Cnhp06dfE4B75uj0DvIO5bK79w73CY/cySGnBHMOKUa9TMSa71TelahtltMa8ld4g4LbGF9XcQtP2wv6fmrX2+QQNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NS3DCfbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NS3DCfbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F07FC2BCB8;
	Tue,  5 May 2026 00:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777940421;
	bh=rCAablyPIDi3A9r4vYkgEII81majNTg7OpFqoM36EY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NS3DCfbqz1i7UWCAe4wq6yb7jsRd8zthlANn54GGNOy8Y4RRD2Ht71w/Vv9jOku6r
	 1oRKVsCOup8HoX5fHf0GQy2Y5czeHQHQqN7lysON63VtayzsPFexb41BUnV/IpwrYC
	 11mTtp2ksVu2hk0sxTikEAAHP2Tx9Ny2lkO5owOqlYIsUgEdae8IrkhUboFu/Wr5uT
	 HFZ9OWycBMavj8kRZIO6Cwi2nHNTqJH6E6tiHQVTwTtKcdby55NUF0oL2IvJ4u4wiI
	 BOWcBOwVeFPTK+6K+PzZ7W32T9srtXLUgl7OC/MTdMNtJXfxt7IyV0BK2GoWEbb6Wu
	 BedmtghaM76eA==
Date: Mon, 4 May 2026 17:20:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 5/7] libsupport: remove the LIST_HEAD macro from list.h
Message-ID: <20260505002021.GF1101423@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260504233301.2345652-6-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504233301.2345652-6-tytso@mit.edu>

On Mon, May 04, 2026 at 07:32:59PM -0400, Theodore Ts'o wrote:
> The LIST_HEAD macro is defined by both the Linux kernel's list.h and
> <sys/queue.h> (originally from BSD).  The problem is that on MacOS,
> some system header file pulls in <sys/queue.h> leading to a macro
> redefiniction conflict.  Since we don't use LIST_HEAD in e2fsprogs,
> the simplest mitigation is to just comment out the definition of LIST_HEAD.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Fixes: 37dafcc0894b ("libsupport: port the kernel list.h to libsupport")

Sounds fine to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  lib/support/list.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/lib/support/list.h b/lib/support/list.h
> index 0e00e446d..0ec8de525 100644
> --- a/lib/support/list.h
> +++ b/lib/support/list.h
> @@ -36,8 +36,17 @@ static inline void list_head_destroy(struct list_head *list)
>  
>  #define LIST_HEAD_INIT(name) { &(name), &(name) }
>  
> +#if 0
> +/*
> + * This conflicts with the LIST_HEAD defined in <sys/queue.h>.  We
> + * don't include it in e2fsprogs, but some systems' header files might
> + * pull it in, leading to the macro redefinition conflict.
> + * Fortunately, we also don't need LIST_HEAD in e2fsprogs, so just
> + * drop this convenience macro.
> + */
>  #define LIST_HEAD(name) \
>  	struct list_head name = LIST_HEAD_INIT(name)
> +#endif
>  
>  /**
>   * INIT_LIST_HEAD - Initialize a list_head structure
> -- 
> 2.53.0
> 
> 
