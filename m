From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Free resources in the error path of ext4_mb_init.
Date: Thu, 6 Oct 2011 10:22:20 -0400
Message-ID: <20111006142220.GA19049@thunk.org>
References: <1313767689-2786-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33685 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964979Ab1JFP66 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Oct 2011 11:58:58 -0400
Content-Disposition: inline
In-Reply-To: <1313767689-2786-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2011 at 11:28:08PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In commit 79a77c5ac, we move ext4_mb_init_backend after the allocation
> of s_locality_group to avoid memory leak in error path, but there are
> still some other error paths in ext4_mb_init that need to do the same
> work. So this patch adds all the error patch for ext4_mb_init. And all
> the pointers are reset to NULL in case the caller may double free them.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

but I had to reorder the cleanup code for
"out_free_groupinfo_slab" and "out_free_locality_groups" in the
following patch hunk....


> @@ -2513,11 +2512,19 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>  
>  	if (sbi->s_journal)
>  		sbi->s_journal->j_commit_callback = release_blocks_on_commit;
> +
> +	return 0;
> +
> +out_free_groupinfo_slab:
> +	ext4_groupinfo_destroy_slabs();
> +out_free_locality_groups:
> +	free_percpu(sbi->s_locality_groups);
> +	sbi->s_locality_groups = NULL;

Since we first allocate the groupinfo slabs, and then the locality
groups, so the cleanup paths need to do things in the opposite
order.

						- Ted
