From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext4: optimize block allocation on grow indepth
Date: Tue, 23 Sep 2014 12:00:31 +0200
Message-ID: <20140923100031.GD2359@quack.suse.cz>
References: <1411455752-2332-1-git-send-email-dmonakhov@openvz.org>
 <1411455752-2332-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbaIWKAe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 06:00:34 -0400
Content-Disposition: inline
In-Reply-To: <1411455752-2332-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 23-09-14 11:02:32, Dmitry Monakhov wrote:
> It is reasonable to prepent newly created index to older one.
...
> -	newblock = ext4_ext_new_meta_block(handle, inode, NULL,
> -		newext, &err, flags);
> +	/* Try to prepend new index to old one */
> +	if (ext_depth(inode))
> +		goal = ext4_idx_pblock(EXT_FIRST_INDEX(ext_inode_hdr(inode)));
> +	if (goal > le32_to_cpu(es->s_first_data_block)) {
> +		flags |= EXT4_MB_HINT_TRY_GOAL;
> +		goal--;
> +	} else
> +		goal =  ext4_inode_to_goal_block(inode);
> +	newblock = ext4_new_meta_blocks(handle, inode, goal, flags,
> +					NULL, &err);
>  	if (newblock == 0)
>  		return err;
  Hum, did you actually observe any improvement in file layout with this
patch?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
