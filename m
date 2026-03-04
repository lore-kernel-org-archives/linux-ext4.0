Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCE537FF66;
	Wed,  4 Mar 2026 13:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772631600; cv=none; b=G5kYA5jo/DhmNTxr8SB5Oki1zMyWrT+JMLLjHl3It58GG4yrTE6xOMVsVQuAjnp/HSRFs9aYk2Fqibls57xYqnyd8O+3JTamjinlYlCBFyjCH6Vbbhw1pRxqNpgJAmAYWrN50L7BWDcTTxKhAlo7iWnq2FpiIq1DWOJQNNX8DMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772631600; c=relaxed/simple;
	bh=IgVErusGbBVUvuBX5aaGbT+VBaSMQ9ieeAk3Mhvg7ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=THQqt5PNfa92P0+52/UGjR/d7x53E1FkSfud30TFA4z7nUzuZOinkkXfgTZLcmtK5L1nV0AsZCAwVea9whXxZJZSUBRUysR1d2429xYjpQFl91/69k2jAwhQSBz+h5UOip3KoyhHxnSYsaeR5f+WfV/qGZqYYUHQtpWKcyVt/I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxHpF5jF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxHpF5jF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79464C19423;
	Wed,  4 Mar 2026 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772631600;
	bh=IgVErusGbBVUvuBX5aaGbT+VBaSMQ9ieeAk3Mhvg7ag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TxHpF5jF632zcGOUPVYUAwPxtaLg9GeT4g9b8AGgvI/Zf/6MLbRx0eOYaqs/Tz2rX
	 WoDEX6icwQJ1AHKZfguDJaIB5cRqgN1uNpOv4nw+AYXXvVUCpbmoMjrLnMIhhOnQAJ
	 ixhvNXxrQ81HxbnMc+0ijk9fkkvUodWYyN2hDg4t0D2BLcdjZjB1xUPcC220usP4K5
	 kDlhOs/7zTcneZ5s7xZHMkkhmUYqSA5oFrsG/nXHoGJs4jaz9M9poyaP5RQ/6MPFlF
	 MFFV70+MuyvqSNLnJjWu3+ok2FdzzAItsx9wpeoCzA8GpbDpOahu3g0wyN6Baqx8Kv
	 2jiP7V/X8SUig==
Date: Wed, 4 Mar 2026 14:39:54 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>, Jens Axboe <axboe@kernel.dk>, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <20260304-dachboden-minibar-620c6f7d69fc@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-53-jack@suse.cz>

On Tue, Mar 03, 2026 at 11:34:10AM +0100, Jan Kara wrote:
> Nobody is calling mark_buffer_dirty_inode() with internal bdev inode and
> it doesn't make sense for internal bdev inode to have any metadata
> buffer heads. Just drop the pointless invalidate_mapping_buffers() call.

s/invalidate_mapping_buffers/invalidate_inode_buffers/g?

> 
> CC: Jens Axboe <axboe@kernel.dk>
> CC: linux-block@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  block/bdev.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index ed022f8c48c7..ad1660b6b324 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -420,7 +420,6 @@ static void init_once(void *data)
>  static void bdev_evict_inode(struct inode *inode)
>  {
>  	truncate_inode_pages_final(&inode->i_data);
> -	invalidate_inode_buffers(inode); /* is it needed here? */
>  	clear_inode(inode);
>  }
>  
> -- 
> 2.51.0
> 
