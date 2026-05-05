Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D942010EE
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 00:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777940445; cv=none; b=cLbVxyMO5+ubjnh35stzGIgKUwMb75SJ+MyG1IIjeRku0QFxKMCe8TInlFYvLbQXe5JmSDcC4OYfiGiZNNtHGwn+/ajO9Kl4io3lOQuJmFBYL5KDv5VGwUvbNASyHA3nMQW0A1NPyiBP5sNiMUNfnh9IN/QSVE2gch6EJHUqvWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777940445; c=relaxed/simple;
	bh=M/lsMOAyoZykQXvDD0oTFDeuliSmAuWdS+PVa91+T0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KS666zxChUBnL+X5VS2iUYKa7UZxRPP+B7ROyf553KzS+Y4ezKfGNtEeLBTZMFi3FJ9Ltag0g5AKvjuC9yXPlU1R9+raRumrItBnmulLbwcjLIWA3PGJd026N+569WkLhkdarOiAvqntfojWre8dNFLbpROWeoz24vBJtZ3g99o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ud2Lpmkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ud2Lpmkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576BBC2BCB8;
	Tue,  5 May 2026 00:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777940445;
	bh=M/lsMOAyoZykQXvDD0oTFDeuliSmAuWdS+PVa91+T0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ud2Lpmkj0jOuvuqvwIjNnXdASGUVTSqPCbzJZ3nqydW4D5Swi1EJOa5rWKRtliMCb
	 tdae0atmX+lswNPGcXl3WXXdUtEyV71+IlR3YxtMeWe6V5LMcYvrqo7Eh+A6rtYxbO
	 sF9XP9RvkTXoYVpvd25QKdYOv2AALT1ZFVxcwJpZ/uWcnmgzhB/6VBKtiIQJ/MjOoI
	 5831/+8T4oVPgJGlSefzQaI+xW0nfLYr/C3bQA8CnpXuhWstEJEh+sQq0nvngvvJgO
	 WCUx0Ovh51MnYE0Hj3sRhPCkSozCeJpBm7JV+/MWlLqS2EExx8sDnpckwaFAv+Vt8l
	 ANwDwRz+t0jLQ==
Date: Mon, 4 May 2026 17:20:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 6/7] libsupport: fix gcc -Wall warnings
Message-ID: <20260505002044.GG1101423@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260504233301.2345652-7-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504233301.2345652-7-tytso@mit.edu>

On Mon, May 04, 2026 at 07:33:00PM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  lib/support/cache.c | 12 +++++++++---
>  lib/support/cache.h |  2 +-
>  lib/support/list.h  |  8 ++++----
>  3 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/support/cache.c b/lib/support/cache.c
> index aec785347..ece0adece 100644
> --- a/lib/support/cache.c
> +++ b/lib/support/cache.c
> @@ -15,6 +15,12 @@
>  #include <stdint.h>
>  #include <errno.h>
>  
> +#ifdef __GNUC__
> +#define EXT2FS_ATTR(x) __attribute__(x)
> +#else
> +#define EXT2FS_ATTR(x)
> +#endif
> +
>  #include "config.h"
>  #include "list.h"
>  #include "cache.h"
> @@ -711,7 +717,7 @@ cache_node_put(
>  
>  void
>  cache_node_set_priority(
> -	struct cache *		cache,
> +	struct cache *		cache EXT2FS_ATTR((unused)),
>  	struct cache_node *	node,
>  	int			priority)
>  {
> @@ -820,7 +826,7 @@ cache_flush(
>  {
>  	struct cache_hash	*hash;
>  	struct cache_node	*node;
> -	int			i;
> +	unsigned int		i;
>  	bool			still_dirty = false;
>  
>  	if (!cache->flush)
> @@ -848,7 +854,7 @@ cache_report(
>  	const char	*name,
>  	struct cache	*cache)
>  {
> -	int		i;
> +	unsigned int	i;
>  	unsigned long	count, index, total;
>  	unsigned long	hash_bucket_lengths[HASH_REPORT + 2] = { 0 };
>  
> diff --git a/lib/support/cache.h b/lib/support/cache.h
> index 71fb9762f..cd0e8c20e 100644
> --- a/lib/support/cache.h
> +++ b/lib/support/cache.h
> @@ -83,7 +83,7 @@ typedef unsigned int (*cache_node_resize_t)(const struct cache *c,
>  					    unsigned int curr_size,
>  					    int dir);
>  
> -static inline unsigned int cache_gradual_resize(const struct cache *cache,
> +static inline unsigned int cache_gradual_resize(const struct cache *cache EXT2FS_ATTR((unused)),
>  						unsigned int curr_size,
>  						int dir)
>  {
> diff --git a/lib/support/list.h b/lib/support/list.h
> index 0ec8de525..54e8e2360 100644
> --- a/lib/support/list.h
> +++ b/lib/support/list.h
> @@ -148,13 +148,13 @@ static __always_inline bool __list_del_entry_valid(struct list_head *entry)
>  	return ret;
>  }
>  #else
> -static inline bool __list_add_valid(struct list_head *new,
> -				struct list_head *prev,
> -				struct list_head *next)
> +static inline bool __list_add_valid(struct list_head *new EXT2FS_ATTR((unused)),
> +				struct list_head *prev EXT2FS_ATTR((unused)),
> +				struct list_head *next EXT2FS_ATTR((unused)))
>  {
>  	return true;
>  }
> -static inline bool __list_del_entry_valid(struct list_head *entry)
> +static inline bool __list_del_entry_valid(struct list_head *entry EXT2FS_ATTR((unused)))
>  {
>  	return true;
>  }
> -- 
> 2.53.0
> 
> 
