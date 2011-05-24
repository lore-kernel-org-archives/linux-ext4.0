From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4:Teach ext4_ext_split to caculate extents
 efficiently.
Date: Tue, 24 May 2011 17:07:21 -0400
Message-ID: <20110524210721.GD26055@thunk.org>
References: <1306143057-16962-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45257 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab1EXVHZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 17:07:25 -0400
Content-Disposition: inline
In-Reply-To: <1306143057-16962-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 23, 2011 at 05:30:57PM +0800, Yongqiang Yang wrote:
> @@ -982,20 +997,13 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
>  			err = -EIO;
>  			goto cleanup;
>  		}
> -		while (path[i].p_idx <= EXT_MAX_INDEX(path[i].p_hdr)) {
> -			ext_debug("%d: move %d:%llu in new index %llu\n", i,
> -					le32_to_cpu(path[i].p_idx->ei_block),
> -					ext4_idx_pblock(path[i].p_idx),
> -					newblock);
> -			/*memmove(++fidx, path[i].p_idx++,
> -					sizeof(struct ext4_extent_idx));
> -			neh->eh_entries++;
> -			BUG_ON(neh->eh_entries > neh->eh_max);*/
> -			path[i].p_idx++;
> -			m++;
> -		}
> +		/* start copy indexes */
> +		m = EXT_MAX_INDEX(path[i].p_hdr) - path[i].p_idx++;
> +		ext_debug("cur 0x%p, last 0x%p\n", path[i].p_idx,
> +				EXT_MAX_INDEX(path[i].p_hdr));
> +		ext4_ext_show_move(inode, path, newblock, i);
>  		if (m) {
> -			memmove(++fidx, path[i].p_idx - m,
> +			memmove(++fidx, path[i].p_idx,
>  				sizeof(struct ext4_extent_idx) * m);
>  			le16_add_cpu(&neh->eh_entries, m);
>  		}

So the old code mutates path[i].p_idx, where as your new code doesn't.
The one thing that scares me is that ext4_ext_insert_index() is passed
&path[at], the function preferences path[at].p_idx.

Have you looked at this case?

					- Ted
