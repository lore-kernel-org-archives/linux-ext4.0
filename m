Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EB7389101;
	Wed,  4 Mar 2026 13:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631533; cv=none; b=B05UE9VIxHeBOUhlvGNV7wIEhXldRGrTQ1DrCO/hvu9SdSI+g6b4irgTbYLz6AWcXFhVH6O/3oKCaVWEHgvXO64ry5hN/VzRGTVn72cA7U4C03/JLzftlPwOQIheqVZrq14PCwMzuB1I7dd5oKThj/1Q6N1Mp4Jiep25zFzQS4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631533; c=relaxed/simple;
	bh=9Gu41Q7tWvFsmLiy2GzG+FeazMjJOugDDDVf94ibiOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnZyWhVrD6j0nwXP8Y8iPTcHXte0l/s4FhwexxXQ27X0Gqw4CVZIe37XD1vZwx70dd76wpwM544mMsnkdRo6HXITalhSqnqqO6Zsxtb45KVtTwLiRCXoWLFYGAefyph7WejUu7u6l5fICnBKNOjpXvSM7b9saaLCkiIJKOXHTVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aOmZC+qm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aOmZC+qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609B9C19423;
	Wed,  4 Mar 2026 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772631532;
	bh=9Gu41Q7tWvFsmLiy2GzG+FeazMjJOugDDDVf94ibiOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aOmZC+qmGcMNUWoK1VMUGr6qSifG9f+/P/l07kDDW+5tFJVzCIb5FjTTwHh7tRNb8
	 MmdTjNQI3NcWEDgEh2opMdW5fc+YvW1uSibKvrtH+1rSxYMX19tqC95uPTFVwxno2C
	 YX/K4cLc5NCZpey966c88ikl9JrXUCb6D9MAIiITidXt8NKo/I87KSVDp4bIlwpeE8
	 wKgrtHScCsZpt//F3pLzblKhRQX+Tx0rVHfhxOz5l5N0eNIEZ/Obj4g31eDmtAWdS1
	 pBVsn8rCgw5ArWEAjz2DV1UNSPfHtuPMx5G6bEZssIyJRkZ3WFDmA3b2gmDtDfHJU3
	 F9S64NMbnc9kw==
Date: Wed, 4 Mar 2026 14:38:47 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 16/32] fs: Fold fsync_buffers_list() into
 sync_mapping_buffers()
Message-ID: <20260304-bildmaterial-deckname-1995a115de52@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-48-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-48-jack@suse.cz>

On Tue, Mar 03, 2026 at 11:34:05AM +0100, Jan Kara wrote:
> There's only single caller of fsync_buffers_list() so untangle the code
> a bit by folding fsync_buffers_list() into sync_mapping_buffers(). Also
> merge the comments and update them to reflect current state of code.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c | 180 +++++++++++++++++++++++-----------------------------
>  1 file changed, 80 insertions(+), 100 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 1c0e7c81a38b..18012afb8289 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -54,7 +54,6 @@
>  
>  #include "internal.h"
>  
> -static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
>  static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
>  			  enum rw_hint hint, struct writeback_control *wbc);
>  
> @@ -531,22 +530,96 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
>   * @mapping: the mapping which wants those buffers written
>   *
>   * Starts I/O against the buffers at mapping->i_private_list, and waits upon
> - * that I/O.
> + * that I/O. Basically, this is a convenience function for fsync().  @mapping
> + * is a file or directory which needs those buffers to be written for a
> + * successful fsync().
>   *
> - * Basically, this is a convenience function for fsync().
> - * @mapping is a file or directory which needs those buffers to be written for
> - * a successful fsync().
> + * We have conflicting pressures: we want to make sure that all
> + * initially dirty buffers get waited on, but that any subsequently
> + * dirtied buffers don't.  After all, we don't want fsync to last
> + * forever if somebody is actively writing to the file.
> + *
> + * Do this in two main stages: first we copy dirty buffers to a
> + * temporary inode list, queueing the writes as we go. Then we clean
> + * up, waiting for those writes to complete. mark_buffer_dirty_inode()
> + * doesn't touch b_assoc_buffers list if b_assoc_map is not NULL so we
> + * are sure the buffer stays on our list until IO completes (at which point
> + * it can be reaped).
>   */
>  int sync_mapping_buffers(struct address_space *mapping)
>  {
>  	struct address_space *buffer_mapping =
>  				mapping->host->i_sb->s_bdev->bd_mapping;
> +	struct buffer_head *bh;
> +	int err = 0;
> +	struct blk_plug plug;
> +	LIST_HEAD(tmp);
>  
>  	if (list_empty(&mapping->i_private_list))
>  		return 0;
>  
> -	return fsync_buffers_list(&buffer_mapping->i_private_lock,
> -					&mapping->i_private_list);
> +	blk_start_plug(&plug);
> +
> +	spin_lock(&buffer_mapping->i_private_lock);
> +	while (!list_empty(&mapping->i_private_list)) {
> +		bh = BH_ENTRY(list->next);


Stray "list" reference? Shouldn't this be
BH_ENTRY(mapping->i_private_list.next)?
