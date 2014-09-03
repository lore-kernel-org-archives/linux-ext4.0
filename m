From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] ext4: pass allocation_request struct to
 ext4_(alloc,splice)_branch
Date: Wed, 3 Sep 2014 18:25:52 +0200
Message-ID: <20140903162552.GD17066@quack.suse.cz>
References: <1409695549-18605-1-git-send-email-tytso@mit.edu>
 <1409695549-18605-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbaICQZ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Sep 2014 12:25:56 -0400
Content-Disposition: inline
In-Reply-To: <1409695549-18605-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-09-14 18:05:47, Ted Tso wrote:
> Instead of initializing the allocation_request structure in
> ext4_alloc_branch(), set it up in ext4_ind_map_blocks(), and then pass
> it to ext4_alloc_branch() and ext4_splice_branch().
> 
> This allows ext4_ind_map_blocks to pass flags in the allocation
> request structure without having to add Yet Another argument to
> ext4_alloc_branch().
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

BTW:
> -			goal = new_blocks[i] = ext4_new_meta_blocks(handle, inode,
> -							goal, 0, NULL, &err);
> +			ar->goal = new_blocks[i] = ext4_new_meta_blocks(handle,
> +				    ar->inode, ar->goal, 0, NULL, &err);
  This seems to suggest ext4_new_meta_blocks() would be better off by
taking allocation_request argument as well?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
