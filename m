From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: call ext4_es_lru_add() after handling cache miss
Date: Thu, 18 Jul 2013 20:46:03 +0800
Message-ID: <20130718124603.GA14274@gmail.com>
References: <1373984980-9895-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1373984980-9895-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On Tue, Jul 16, 2013 at 10:29:40AM -0400, Theodore Ts'o wrote:
> If there are no items in the extent status tree, ext4_es_lru_add() is
> a no-op.

Sorry, but I don't understand your point of view.  Now ext4_es_lru_add
is used to set i_touch_when and put this inode into the tail of lru if
this inode hasn't been no matter whether there has an item in extent
status tree.  So only we need to do is to call this function when we
think the item of extent status tree in this inode needs to be kept in
memory.  That is why I call this function in ext4_*_map_blocks() because
we always use these two functions to get a block mapping.  So that means
that this inode is accessed recently and it should be kept in memory as
much as possible than other inodes.

Ah, maybe I got your point.  You mean that if ther are no item in the
extent status tree, we don't need to reclaim the item from it, right?
IMHO, when ext4_*_map_blocks() are called, that means that we will put
some items into the extent status tree if there are no item in the tree.
So I don't think we need to worry about it.

> So it is not sufficient to call ext4_es_lru_add() before we
> try to lookup an entry in the extent status tree.  We also need to
> call it at the end of ext4_ext_map_blocks(), after items have been
> added to the extent status tree.

I don't think we only need to call ext4_es_lru_add() in
ext4_ext_map_blocks() when an item is added to the tree because extent
status tree is also useful for a indirect-based file.  That is why I
call ext4_es_insert_extent() in ext4_map_blocks().  Please correct me if
I miss something.

Thanks,
                                                - Zheng

> 
> This could lead to inodes with that have extent status trees but which
> are not in the LRU list, which means they won't get considered for
> eviction by the es_shrinker.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Zheng Liu <wenqing.lz@taobao.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/ext4/extents.c | 5 +++--
>  fs/ext4/inode.c   | 7 ++-----
>  2 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index cfdc51e..a618738 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4385,8 +4385,9 @@ out2:
>  	}
>  
>  out3:
> -	trace_ext4_ext_map_blocks_exit(inode, flags, map, err ? err : allocated);
> -
> +	trace_ext4_ext_map_blocks_exit(inode, flags, map,
> +				       err ? err : allocated);
> +	ext4_es_lru_add(inode);
>  	return err ? err : allocated;
>  }
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 3c5edf2..ea2cbf1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -514,10 +514,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		  "logical block %lu\n", inode->i_ino, flags, map->m_len,
>  		  (unsigned long) map->m_lblk);
>  
> -	ext4_es_lru_add(inode);
> -
>  	/* Lookup extent status tree firstly */
>  	if (ext4_es_lookup_extent(inode, map->m_lblk, &es)) {
> +		ext4_es_lru_add(inode);
>  		if (ext4_es_is_written(&es) || ext4_es_is_unwritten(&es)) {
>  			map->m_pblk = ext4_es_pblock(&es) +
>  					map->m_lblk - es.es_lblk;
> @@ -1529,11 +1528,9 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
>  		  "logical block %lu\n", inode->i_ino, map->m_len,
>  		  (unsigned long) map->m_lblk);
>  
> -	ext4_es_lru_add(inode);
> -
>  	/* Lookup extent status tree firstly */
>  	if (ext4_es_lookup_extent(inode, iblock, &es)) {
> -
> +		ext4_es_lru_add(inode);
>  		if (ext4_es_is_hole(&es)) {
>  			retval = 0;
>  			down_read((&EXT4_I(inode)->i_data_sem));
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
