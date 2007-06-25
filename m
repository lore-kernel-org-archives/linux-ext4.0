From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH 3/3]  ext4: extent macros cleanup
Date: Mon, 25 Jun 2007 15:06:33 +0400
Message-ID: <467FA1B9.30702@clusterfs.com>
References: <20070622121509.GA395@localhost.sw.ru> <20070622121835.GD395@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>, devel@openvz.org
To: Dmitry Monakhov <dmonakhov@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:53598 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbXFYLHC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2007 07:07:02 -0400
In-Reply-To: <20070622121835.GD395@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Acked-off-by: Alex Tomas <alex@clusterfs.com>


Dmitry Monakhov wrote:
> - Replace math equation to it's macro equivalent
> - make ext4_ext_grow_indepth() indexes/leaf correct
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/extents.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 12fe3d7..1fd00ac 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -375,7 +375,7 @@ ext4_ext_binsearch_idx(struct inode *inode, struct ext4_ext_path *path, int bloc
>  	ext_debug("binsearch for %d(idx):  ", block);
>  
>  	l = EXT_FIRST_INDEX(eh) + 1;
> -	r = EXT_FIRST_INDEX(eh) + le16_to_cpu(eh->eh_entries) - 1;
> +	r = EXT_LAST_INDEX(eh);
>  	while (l <= r) {
>  		m = l + (r - l) / 2;
>  		if (block < le32_to_cpu(m->ei_block))
> @@ -440,7 +440,7 @@ ext4_ext_binsearch(struct inode *inode, struct ext4_ext_path *path, int block)
>  	ext_debug("binsearch for %d:  ", block);
>  
>  	l = EXT_FIRST_EXTENT(eh) + 1;
> -	r = EXT_FIRST_EXTENT(eh) + le16_to_cpu(eh->eh_entries) - 1;
> +	r = EXT_LAST_EXTENT(eh);
>  
>  	while (l <= r) {
>  		m = l + (r - l) / 2;
> @@ -922,8 +922,11 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
>  	curp->p_hdr->eh_max = cpu_to_le16(ext4_ext_space_root_idx(inode));
>  	curp->p_hdr->eh_entries = cpu_to_le16(1);
>  	curp->p_idx = EXT_FIRST_INDEX(curp->p_hdr);
> -	/* FIXME: it works, but actually path[0] can be index */
> -	curp->p_idx->ei_block = EXT_FIRST_EXTENT(path[0].p_hdr)->ee_block;
> +	
> +	if (path[0].p_hdr->eh_depth)
> +	  curp->p_idx->ei_block = EXT_FIRST_INDEX(path[0].p_hdr)->ei_block;
> +	else
> +	  curp->p_idx->ei_block = EXT_FIRST_EXTENT(path[0].p_hdr)->ee_block;
>  	ext4_idx_store_pblock(curp->p_idx, newblock);
>  
>  	neh = ext_inode_hdr(inode);
