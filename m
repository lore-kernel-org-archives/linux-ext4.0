From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 30/31] ext4: eliminate xattr entry e_hash recalculation
 for removes
Date: Thu, 15 Jun 2017 11:10:26 +0200
Message-ID: <20170615091026.GG1764@quack2.suse.cz>
References: <20170614172340.18720-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mark Fasheh <mfasheh@versity.com>,
        Joel Becker <jlbec@evilplan.org>, Jens Axboe <axboe@fb.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Mike Christie <mchristi@redhat.com>,
        Fabian Frederick <fabf@skynet.be>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        reiserfs-devel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170614172340.18720-1-tahsin@google.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 14-06-17 10:23:40, Tahsin Erdogan wrote:
> When an extended attribute block is modified, ext4_xattr_hash_entry()
> recalculates e_hash for the entry that is pointed by s->here. This is
> unnecessary if the modification is to remove an entry.
> 
> Currently, if the removed entry is the last one and there are other
> entries remaining, hash calculation targets the just erased entry which
> has been filled with zeroes and effectively does nothing. If the removed
> entry is not the last one and there are more entries, this time it will
> recalculate hash on the next entry which is totally unnecessary.
> 
> Fix these by moving the decision on when to recalculate hash to
> ext4_xattr_set_entry().

I agree with moving ext4_xattr_rehash_entry() out of ext4_xattr_rehash().
However how about just keeping ext4_xattr_rehash() in
ext4_xattr_block_set() (so that you don't have to pass aditional argument
to ext4_xattr_set_entry()) and calling ext4_xattr_rehash_entry() when
i->value != NULL? That would seem easier and cleaner as well...

								Honza
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
> ---
>  fs/ext4/xattr.c | 50 ++++++++++++++++++++++++++------------------------
>  1 file changed, 26 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index c9579d220a0c..6c6dce2f874e 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -77,8 +77,9 @@ static void ext4_xattr_block_cache_insert(struct mb_cache *,
>  static struct buffer_head *
>  ext4_xattr_block_cache_find(struct inode *, struct ext4_xattr_header *,
>  			    struct mb_cache_entry **);
> -static void ext4_xattr_rehash(struct ext4_xattr_header *,
> -			      struct ext4_xattr_entry *);
> +static void ext4_xattr_hash_entry(struct ext4_xattr_entry *entry,
> +				  void *value_base);
> +static void ext4_xattr_rehash(struct ext4_xattr_header *);
>  
>  static const struct xattr_handler * const ext4_xattr_handler_map[] = {
>  	[EXT4_XATTR_INDEX_USER]		     = &ext4_xattr_user_handler,
> @@ -1436,7 +1437,8 @@ static int ext4_xattr_inode_lookup_create(handle_t *handle, struct inode *inode,
>  
>  static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
>  				struct ext4_xattr_search *s,
> -				handle_t *handle, struct inode *inode)
> +				handle_t *handle, struct inode *inode,
> +				bool is_block)
>  {
>  	struct ext4_xattr_entry *last;
>  	struct ext4_xattr_entry *here = s->here;
> @@ -1500,8 +1502,8 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
>  		 * attribute block so that a long value does not occupy the
>  		 * whole space and prevent futher entries being added.
>  		 */
> -		if (ext4_has_feature_ea_inode(inode->i_sb) && new_size &&
> -		    (s->end - s->base) == i_blocksize(inode) &&
> +		if (ext4_has_feature_ea_inode(inode->i_sb) &&
> +		    new_size && is_block &&
>  		    (min_offs + old_size - new_size) <
>  					EXT4_XATTR_BLOCK_RESERVE(inode)) {
>  			ret = -ENOSPC;
> @@ -1631,6 +1633,13 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
>  		}
>  		here->e_value_size = cpu_to_le32(i->value_len);
>  	}
> +
> +	if (is_block) {
> +		if (s->not_found || i->value)
> +			ext4_xattr_hash_entry(here, s->base);
> +		ext4_xattr_rehash((struct ext4_xattr_header *)s->base);
> +	}
> +
>  	ret = 0;
>  out:
>  	iput(old_ea_inode);
> @@ -1720,14 +1729,11 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			mb_cache_entry_delete(ext4_mb_cache, hash,
>  					      bs->bh->b_blocknr);
>  			ea_bdebug(bs->bh, "modifying in-place");
> -			error = ext4_xattr_set_entry(i, s, handle, inode);
> -			if (!error) {
> -				if (!IS_LAST_ENTRY(s->first))
> -					ext4_xattr_rehash(header(s->base),
> -							  s->here);
> +			error = ext4_xattr_set_entry(i, s, handle, inode,
> +						     true /* is_block */);
> +			if (!error)
>  				ext4_xattr_block_cache_insert(ext4_mb_cache,
>  							      bs->bh);
> -			}
>  			ext4_xattr_block_csum_set(inode, bs->bh);
>  			unlock_buffer(bs->bh);
>  			if (error == -EFSCORRUPTED)
> @@ -1787,7 +1793,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  		s->end = s->base + sb->s_blocksize;
>  	}
>  
> -	error = ext4_xattr_set_entry(i, s, handle, inode);
> +	error = ext4_xattr_set_entry(i, s, handle, inode, true /* is_block */);
>  	if (error == -EFSCORRUPTED)
>  		goto bad_block;
>  	if (error)
> @@ -1810,9 +1816,6 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  		}
>  	}
>  
> -	if (!IS_LAST_ENTRY(s->first))
> -		ext4_xattr_rehash(header(s->base), s->here);
> -
>  inserted:
>  	if (!IS_LAST_ENTRY(s->first)) {
>  		new_bh = ext4_xattr_block_cache_find(inode, header(s->base),
> @@ -2045,7 +2048,7 @@ int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
>  
>  	if (EXT4_I(inode)->i_extra_isize == 0)
>  		return -ENOSPC;
> -	error = ext4_xattr_set_entry(i, s, handle, inode);
> +	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
>  	if (error) {
>  		if (error == -ENOSPC &&
>  		    ext4_has_inline_data(inode)) {
> @@ -2057,7 +2060,8 @@ int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
>  			error = ext4_xattr_ibody_find(inode, i, is);
>  			if (error)
>  				return error;
> -			error = ext4_xattr_set_entry(i, s, handle, inode);
> +			error = ext4_xattr_set_entry(i, s, handle, inode,
> +						     false /* is_block */);
>  		}
>  		if (error)
>  			return error;
> @@ -2083,7 +2087,7 @@ static int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
>  
>  	if (EXT4_I(inode)->i_extra_isize == 0)
>  		return -ENOSPC;
> -	error = ext4_xattr_set_entry(i, s, handle, inode);
> +	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
>  	if (error)
>  		return error;
>  	header = IHDR(inode, ext4_raw_inode(&is->iloc));
> @@ -2909,8 +2913,8 @@ ext4_xattr_block_cache_find(struct inode *inode,
>   *
>   * Compute the hash of an extended attribute.
>   */
> -static inline void ext4_xattr_hash_entry(struct ext4_xattr_header *header,
> -					 struct ext4_xattr_entry *entry)
> +static void ext4_xattr_hash_entry(struct ext4_xattr_entry *entry,
> +				  void *value_base)
>  {
>  	__u32 hash = 0;
>  	char *name = entry->e_name;
> @@ -2923,7 +2927,7 @@ static inline void ext4_xattr_hash_entry(struct ext4_xattr_header *header,
>  	}
>  
>  	if (!entry->e_value_inum && entry->e_value_size) {
> -		__le32 *value = (__le32 *)((char *)header +
> +		__le32 *value = (__le32 *)((char *)value_base +
>  			le16_to_cpu(entry->e_value_offs));
>  		for (n = (le32_to_cpu(entry->e_value_size) +
>  		     EXT4_XATTR_ROUND) >> EXT4_XATTR_PAD_BITS; n; n--) {
> @@ -2945,13 +2949,11 @@ static inline void ext4_xattr_hash_entry(struct ext4_xattr_header *header,
>   *
>   * Re-compute the extended attribute hash value after an entry has changed.
>   */
> -static void ext4_xattr_rehash(struct ext4_xattr_header *header,
> -			      struct ext4_xattr_entry *entry)
> +static void ext4_xattr_rehash(struct ext4_xattr_header *header)
>  {
>  	struct ext4_xattr_entry *here;
>  	__u32 hash = 0;
>  
> -	ext4_xattr_hash_entry(header, entry);
>  	here = ENTRY(header+1);
>  	while (!IS_LAST_ENTRY(here)) {
>  		if (!here->e_hash) {
> -- 
> 2.13.1.508.gb3defc5cc-goog
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
