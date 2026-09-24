Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B88E48A8B1
	for <linux-ext4@vger.kernel.org>; Thu, 24 Sep 2026 15:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790262400; cv=none; b=BWKctVQSfuvdI2wFHlQVZbMPYIevTDELAh/jES3yIM6bNt0miSXzhSlZf00qcts7maCrPskivQp8aMkSk/xhvQDbI4GE6nCG7s82DeSjP/uBzyL7HDIgOOSjehssNQT12gDSnP7BJ1EZNDrR/tFXt63Tz0dAog1DbqBxMa8XdD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790262400; c=relaxed/simple;
	bh=dR/AXRB8ORhLi43o7kaVMZRjbaeU6Fl62QB8LwkdU/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lAZqGjyu/P2ODGWfl0Jc1wwNvDh6/VvFLiGHl7APmoRuzdJwZsY9mzFFJLmkw5GC+YeHgGLOmM0ELoj40Et1oWsrZMbOSjmMXYermBMkZx6OU+V66XBiQJ3R1nlaiuJjK+s0EF8QtU6eBJgLVJZlOcvvsBuV2wfwbDrK7/6NXnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8dk95jD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8dk95jD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 670B71F000FF;
	Thu, 24 Sep 2026 15:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790262397;
	bh=7jrCD/G6gR6J/aIeziDS18+5ha3akhhMiulp1gsFSQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n8dk95jDhRg8fIimIUrFpMeYCJHph0oAmL4P4D2/Rtxn5xwpaahaDb0ff3rZVB6BY
	 b/X5or2Xp9OnBnMzTuLsQ/lfvN+SJzf7HtdyEd8eaAezVlrzMeihw2SxbTm72qT4XJ
	 GZLii/cub3VnQOWklnziUCe8/dCdddID6vhG6jdiLAAp5hlcqLVpt+/coASVD8D5dj
	 GGe2E9G/3l1twTXwwTXzhXQmrQ/Rkx6YwkksiODzsVva5AeQ2cbIBWHu0n3GH0stZn
	 7OWsrkO2aH9w1Yb1/2+asWzGjFMKPxElNHlo6KvZUoy49mE3Xc3t82ZJKCMdlprzdK
	 HO9TGc+YTOfKQ==
Date: Thu, 24 Sep 2026 08:06:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: mark data=journal as deprecated and will be
 removed in January 2028.
Message-ID: <20260924150636.GF6239@frogsfrogsfrogs>
References: <20260924145924.341425-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924145924.341425-1-tytso@mit.edu>

On Thu, Sep 24, 2026 at 10:59:24AM -0400, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Woooooooo
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  Documentation/admin-guide/ext4.rst | 6 ++++--
>  fs/ext4/super.c                    | 1 +
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
> index ac0c709ea9e7..7aa586c27e37 100644
> --- a/Documentation/admin-guide/ext4.rst
> +++ b/Documentation/admin-guide/ext4.rst
> @@ -172,7 +172,8 @@ When mounting an ext4 filesystem, the following option are accepted:
>    data=journal
>          All data are committed into the journal prior to being written into the
>          main file system.  Enabling this mode will disable delayed allocation
> -        and O_DIRECT support.
> +        and O_DIRECT support.  This feature is deprecated and support
> +	will be removed in January 2028.
>  
>    data=ordered	(*)
>          All data are forced directly out to the main file system prior to its
> @@ -420,7 +421,8 @@ There are 3 different data modes:
>    consistent state.  This mode is the slowest except when data needs to be read
>    from and written to disk at the same time where it outperforms all others
>    modes.  Enabling this mode will disable delayed allocation and O_DIRECT
> -  support.
> +  support.  The data=journal feature is deprecated and support will be
> +  removed in January 2028.
>  
>  /proc entries
>  =============
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a187112cafaf..8da79cc8593f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5049,6 +5049,7 @@ static int ext4_load_and_init_journal(struct super_block *sb,
>  static int ext4_check_journal_data_mode(struct super_block *sb)
>  {
>  	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
> +		printk(KERN_WARNING "EXT4-fs: The data=journal mount option is deprecated and support will be removed in January 2028\n");
>  		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting with "
>  			    "data=journal disables delayed allocation, "
>  			    "dioread_nolock, O_DIRECT and fast_commit support!\n");
> -- 
> 2.53.0
> 
> 
