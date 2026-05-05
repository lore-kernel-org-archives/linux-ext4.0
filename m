Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C8819046E
	for <linux-ext4@vger.kernel.org>; Tue,  5 May 2026 00:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777940103; cv=none; b=USuXt2KXDkhaZpbOKLogsrnQAan1i5a14NWFul/Hjn6JCh2QcHm1Ou+oWM6z5XmHS5LNJ5/swVtTpr5malYz1RXsIi9Pj7lxqvDDOulRAhAYjwhf9jLlkjL42daZkS0s8JbJ96nX/C/tSmusowJx1clHLQy0Qcx6EJJuw5k0jgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777940103; c=relaxed/simple;
	bh=95rdiVZpodAaf+FPcn95KGaGBkDwEVRh7zJrAbM2byQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jMEuj/dg8iN61jCLoT0pzEyvpFJGqfOszDGE9RFUwtjyqqM6hsYFDDvl2NiDS0Vzm6gb/eED3pjouR7CmQlLPjNXu6KSYvRnH4TwP7uj1Qwj3JNGTsL0OZyybL8D8xSh/2Dpld3rm5512rWSgeV3iO8OHu+q6SrL/GnJ/wbRR58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5jxhOKx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5jxhOKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E18C2BCB9;
	Tue,  5 May 2026 00:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777940103;
	bh=95rdiVZpodAaf+FPcn95KGaGBkDwEVRh7zJrAbM2byQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R5jxhOKxcNDOuy3dGKZv8IXBiq1GCf75nF7BZrrO/sj9zzgc5mAdviBnVT/qvl9lm
	 /tPrQIvtB1GCc/qmYGuhhucG+vM2OXr/AfFaIHVozwEbKMG6yEMYrc7mfntH7fu6uq
	 eBrCR+0pJGV6KkLrtK1UTQfwok/3lSqGg6L272K21SKX7Qgwe4laG5c/Uk2XdwLKeQ
	 r4nN8yAUF5Cnk67aLqQ4hDJAjvdgKNKgxxVIRwyI0wN2rR3s2+CPe5U6eNtL+jVe1U
	 yXzamaCo+IrW6+Wu2vunT0UD9XB1q9q+3v7yZFipq9XqDJzpnRycwekSF80ZoMOERD
	 fjUS142p5RR0Q==
Date: Mon, 4 May 2026 17:15:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/7] libsupport: don't use bzero in cache.c
Message-ID: <20260505001502.GD1101423@frogsfrogsfrogs>
References: <20260504233301.2345652-1-tytso@mit.edu>
 <20260504233301.2345652-4-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504233301.2345652-4-tytso@mit.edu>

On Mon, May 04, 2026 at 07:32:57PM -0400, Theodore Ts'o wrote:
> The bzero() function is deprecated and not available in some
> platforms.  It's not needed in any case because we can just use an
> automatic initializer.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Fixes: 30b3c80ed6bc ("libsupport: add a cache")

Yeesh.  What a sordid legacy this function has (see manpage). :(
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  lib/support/cache.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/lib/support/cache.c b/lib/support/cache.c
> index f9669e3fc..aec785347 100644
> --- a/lib/support/cache.c
> +++ b/lib/support/cache.c
> @@ -850,7 +850,7 @@ cache_report(
>  {
>  	int		i;
>  	unsigned long	count, index, total;
> -	unsigned long	hash_bucket_lengths[HASH_REPORT + 2];
> +	unsigned long	hash_bucket_lengths[HASH_REPORT + 2] = { 0 };
>  
>  	if ((cache->c_hits + cache->c_misses) == 0)
>  		return;
> @@ -886,8 +886,6 @@ cache_report(
>  		cache->c_mrus[i].cm_count * 100 / cache->c_count);
>  
>  	/* report hash bucket lengths */
> -	bzero(hash_bucket_lengths, sizeof(hash_bucket_lengths));
> -
>  	for (i = 0; i < cache->c_hashsize; i++) {
>  		count = cache->c_hash[i].ch_count;
>  		if (count > HASH_REPORT)
> -- 
> 2.53.0
> 
> 
