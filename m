Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B4834C83C
	for <linux-ext4@vger.kernel.org>; Wed, 15 Apr 2026 23:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776297406; cv=none; b=K5m67AW3Te3mE5rvH0GtQgu9NDkPQIKWS+vMFUKHNIelxgfh3aXuB1W/bbXzmThO8+Mod+zdkzfH76CEdsgFhA925KzbpNy9fllqpjH1b0F+2vLnGFkzz1Xeq5uQmwSpNHJ1aKYJljJo7USn3TN0acHMECn7+OlzXcZGhALrKKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776297406; c=relaxed/simple;
	bh=WedYa8zBhzwChCkA0+jjnksGsJU9fpYmcpNqM/1eKj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYRK5dDLUA57sDjfWizqPcyMBOB+jwRXVHFuC/OLOmxOaP1slwejLSmpLWw5xLjAuinHUGNxSj8ALK3831OZsNlfDcSs09OLD3mckoHM2t9srlYYM77+ctY0/mkBf/BfFnCoBaoWK+Lo75/CLbLQTSwQHuREmLpGnwCrTGxYB8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCJBkIBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCJBkIBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F1CC19424;
	Wed, 15 Apr 2026 23:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776297406;
	bh=WedYa8zBhzwChCkA0+jjnksGsJU9fpYmcpNqM/1eKj0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LCJBkIBpgqSmIIhUQOUMOym1TibUiZluDKTHChL2Z9UY/UoUj4IWN1rmsi73Kqc+O
	 0fac+kT6Nbm9rNDd0RCEBW77a8pj2161p5nJj2PJulqvpyUbwz1dSTEdN5c71usTeJ
	 xFR7OVP8PPKv0UoBsb11FvwVYp/1lC0r7/UsckVcmcobglxeNKp2g3DJ3UK3/y8zYF
	 skWDpxVEValM7PYqrCUwHwUuvX0RDlYAgcmIR2PVN1rGt0Tad9dN3AGIfPfJ15cI+y
	 yh6DPi86ADtmzh1sbHm5K2lz1SVANqu//wf7Jq6uAnV9N2bjt8bPFyHvZ2sd3vx2Qs
	 s29XqL3AJ/DnQ==
Date: Wed, 15 Apr 2026 16:56:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	jack@suse.cz
Subject: Re: [PATCH v2 2/4] ext4: skip cursor node in ext4_orphan_del()
Message-ID: <20260415235645.GA114178@frogsfrogsfrogs>
References: <20260415105505.342358-1-yebin@huaweicloud.com>
 <20260415105505.342358-3-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415105505.342358-3-yebin@huaweicloud.com>

On Wed, Apr 15, 2026 at 06:55:03PM +0800, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> This patch is prepared for displaying orphan_list information. Because
> temporary nodes may be inserted when the orphan_list is traversed and
> displayed, these temporary nodes need to be skipped.
> 
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  fs/ext4/orphan.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
> index f7e7f77e021e..a6bffe67ef75 100644
> --- a/fs/ext4/orphan.c
> +++ b/fs/ext4/orphan.c
> @@ -220,6 +220,23 @@ static int ext4_orphan_file_del(handle_t *handle, struct inode *inode)
>  	return ret;
>  }
>  
> +static inline bool ext4_is_cursor(struct inode *inode)
> +{
> +	return (inode->i_ino == 0);
> +}
> +
> +static inline struct list_head *ext4_orphan_prev_node(
> +					struct ext4_inode_info *pos,
> +					struct list_head *head)
> +{
> +	list_for_each_entry_continue_reverse(pos, head, i_orphan) {
> +		if (likely(!ext4_is_cursor(&pos->vfs_inode)))
> +			return &pos->i_orphan;
> +	}
> +
> +	return head;

Waitaminute, you inject the procfs file's cursor into the orphan list
with a phony ext4_inode_info??  That sounds like a landmine waiting to
go off the next time someone writes code that traverses the list, or
even wants to check that its non-empty.

--D

> +}
> +
>  /*
>   * ext4_orphan_del() removes an unlinked or truncated inode from the list
>   * of such inodes stored on disk, because it is finally being cleaned up.
> @@ -253,7 +270,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
>  	mutex_lock(&sbi->s_orphan_lock);
>  	ext4_debug("remove inode %llu from orphan list\n", inode->i_ino);
>  
> -	prev = ei->i_orphan.prev;
> +	prev = ext4_orphan_prev_node(ei, &sbi->s_orphan);
> +
>  	list_del_init(&ei->i_orphan);
>  
>  	/* If we're on an error path, we may not have a valid
> -- 
> 2.34.1
> 
> 
