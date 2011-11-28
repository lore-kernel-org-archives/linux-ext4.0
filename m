From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 34/62] ext2: remove the second argument of
 k[un]map_atomic()
Date: Mon, 28 Nov 2011 15:15:18 +0100
Message-ID: <20111128141518.GA6366@quack.suse.cz>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
 <1322371662-26166-35-git-send-email-amwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Cong Wang <amwang@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab1K1OPU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 09:15:20 -0500
Content-Disposition: inline
In-Reply-To: <1322371662-26166-35-git-send-email-amwang@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 27-11-11 13:27:14, Cong Wang wrote:
> 
> Signed-off-by: Cong Wang <amwang@redhat.com>
  Acked-by: Jan Kara <jack@suse.cz>

									Honza

> ---
>  fs/ext2/dir.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
> index 47cda41..378bf28 100644
> --- a/fs/ext2/dir.c
> +++ b/fs/ext2/dir.c
> @@ -645,7 +645,7 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
>  		unlock_page(page);
>  		goto fail;
>  	}
> -	kaddr = kmap_atomic(page, KM_USER0);
> +	kaddr = kmap_atomic(page);
>  	memset(kaddr, 0, chunk_size);
>  	de = (struct ext2_dir_entry_2 *)kaddr;
>  	de->name_len = 1;
> @@ -660,7 +660,7 @@ int ext2_make_empty(struct inode *inode, struct inode *parent)
>  	de->inode = cpu_to_le32(parent->i_ino);
>  	memcpy (de->name, "..\0", 4);
>  	ext2_set_de_type (de, inode);
> -	kunmap_atomic(kaddr, KM_USER0);
> +	kunmap_atomic(kaddr);
>  	err = ext2_commit_chunk(page, 0, chunk_size);
>  fail:
>  	page_cache_release(page);
> -- 
> 1.7.4.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
