From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 2][PATCH 2/5] cleanups: Add extent sanity checks
Date: Tue, 10 Jul 2007 16:30:20 -0700
Message-ID: <20070710163020.196d32a0.akpm@linux-foundation.org>
References: <1183275382.4010.121.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762791AbXGJXbB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jul 2007 19:31:01 -0400
In-Reply-To: <1183275382.4010.121.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:36:22 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> with the patch all headers are checked. the code should become
> more resistant to on-disk corruptions. needless BUG_ON() have
> been removed. please, review for inclusion.
> 
> ...

> @@ -269,6 +239,70 @@
>  	return size;
>  }
>  
> +static inline int
> +ext4_ext_max_entries(struct inode *inode, int depth)

Please remove the `inline'.

`inline' is usually wrong.  It is wrong here.  If this function has a
single callsite (it has) then the compiler will inline it.  If the function
later gains more callsites then the compiler will know (correctly) not to
inline it.

We hope.  If we find the compiler still inlines a function as large as this
one then we'd need to use noinline and complain at the gcc developers.

> +{
> +	int max;
> +
> +	if (depth == ext_depth(inode)) {
> +		if (depth == 0)
> +			max = ext4_ext_space_root(inode);
> +		else
> +			max = ext4_ext_space_root_idx(inode);
> +	} else {
> +		if (depth == 0)
> +			max = ext4_ext_space_block(inode);
> +		else
> +			max = ext4_ext_space_block_idx(inode);
> +	}
> +
> +	return max;
> +}
> +
> +static int __ext4_ext_check_header(const char *function, struct inode *inode,
> +					struct ext4_extent_header *eh,
> +					int depth)
> +{
> +	const char *error_msg = NULL;

Unneeded initialisation.

> +	int max = 0;
> +
> +	if (unlikely(eh->eh_magic != EXT4_EXT_MAGIC)) {
> +		error_msg = "invalid magic";
> +		goto corrupted;
> +	}
> +	if (unlikely(le16_to_cpu(eh->eh_depth) != depth)) {
> +		error_msg = "unexpected eh_depth";
> +		goto corrupted;
> +	}
> +	if (unlikely(eh->eh_max == 0)) {
> +		error_msg = "invalid eh_max";
> +		goto corrupted;
> +	}
> +	max = ext4_ext_max_entries(inode, depth);
> +	if (unlikely(le16_to_cpu(eh->eh_max) > max)) {
> +		error_msg = "too large eh_max";
> +		goto corrupted;
> +	}
> +	if (unlikely(le16_to_cpu(eh->eh_entries) > le16_to_cpu(eh->eh_max))) {
> +		error_msg = "invalid eh_entries";
> +		goto corrupted;
> +	}
> +	return 0;
> +
> +corrupted:
> +	ext4_error(inode->i_sb, function,
> +			"bad header in inode #%lu: %s - magic %x, "
> +			"entries %u, max %u(%u), depth %u(%u)",
> +			inode->i_ino, error_msg, le16_to_cpu(eh->eh_magic),
> +			le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max),
> +			max, le16_to_cpu(eh->eh_depth), depth);
> +
> +	return -EIO;
> +}
> +
>
> ...
>
> +	i = depth = ext_depth(inode);
>

Mulitple assignments like this are somewhat unpopular from the coding-style
POV.  

We have a local variable called `i' which is not used as a simple counter
and which has no explanatory comment.  This is plain bad.  Please find a
better name for this variable.  Review the code for other such lack of
clarity - I'm sure there's more.


> -	BUG_ON(le16_to_cpu(eh->eh_entries) > le16_to_cpu(eh->eh_max));
> -	BUG_ON(eh->eh_magic != EXT4_EXT_MAGIC);

Yeah, this patch improves things a lot.

How well-tested is it?  Have any of these errors actually been triggered?

>  			path[i].p_hdr = ext_block_hdr(path[i].p_bh);
> -			if (ext4_ext_check_header(__FUNCTION__, inode,
> -							path[i].p_hdr)) {
> -				err = -EIO;
> -				goto out;
> -			}
>  		}
>  
> -		BUG_ON(le16_to_cpu(path[i].p_hdr->eh_entries)
> -			   > le16_to_cpu(path[i].p_hdr->eh_max));
> -		BUG_ON(path[i].p_hdr->eh_magic != EXT4_EXT_MAGIC);
> -
>  		if (!path[i].p_idx) {
>  			/* this level hasn't been touched yet */
>  			path[i].p_idx = EXT_LAST_INDEX(path[i].p_hdr);
> @@ -1873,17 +1890,24 @@
>  				i, EXT_FIRST_INDEX(path[i].p_hdr),
>  				path[i].p_idx);
>  		if (ext4_ext_more_to_rm(path + i)) {
> +			struct buffer_head *bh;
>  			/* go to the next level */
>  			ext_debug("move to level %d (block %llu)\n",
>  				  i + 1, idx_pblock(path[i].p_idx));
>  			memset(path + i + 1, 0, sizeof(*path));
> -			path[i+1].p_bh =
> -				sb_bread(sb, idx_pblock(path[i].p_idx));
> -			if (!path[i+1].p_bh) {
> +			bh = sb_bread(sb, idx_pblock(path[i].p_idx));
> +			if (!bh) {
>  				/* should we reset i_size? */
>  				err = -EIO;
>  				break;
>  			}
> +			BUG_ON(i + 1 > depth);

ouch.  Couldn't we do WARN_ON then return -EIO here?

> +			if (ext4_ext_check_header(inode, ext_block_hdr(bh),
> +							depth - i - 1)) {
> +				err = -EIO;
> +				break;
> +			}
> +			path[i+1].p_bh = bh;

Really that should have been "i + 1".  checkpatch misses this.  It seems to
be missing more stuff that it used to lately.
