From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug 12829] kernel complains on ENOSPC
Date: Mon, 6 Apr 2009 14:58:23 -0400
Message-ID: <20090406185823.GE7376@mit.edu>
References: <bug-12829-13602@http.bugzilla.kernel.org/> <20090310163824.6C767108042@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40810 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770AbZDFS6b (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Apr 2009 14:58:31 -0400
Content-Disposition: inline
In-Reply-To: <20090310163824.6C767108042@picon.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh,

What's the status of this patch; do you think we still need it?  If
so, can you add a proper commit log and signed-off-by, tell me that
you've tested it, etc.?

Thanks!!

	    	    	  	 - Ted


On Tue, Mar 10, 2009 at 09:38:24AM -0700, bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12829
> 
> 
> 
> 
> 
> ------- Comment #4 from aneesh.kumar@linux.vnet.ibm.com  2009-03-10 09:38 -------
> This patch will not fix the problem. But i guess we need this change
> 
> -aneesh
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 4415bee..671f215 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4652,11 +4652,11 @@ out1:
>         if (ar->len < inquota)
>                 DQUOT_FREE_BLOCK(ar->inode, inquota - ar->len);
>  out3:
> -       if (!ar->len) {
> +       if (ar->len < reserv_blks) {
>                 if (!EXT4_I(ar->inode)->i_delalloc_reserved_flag)
>                         /* release all the reserved blocks if non delalloc */
>                         percpu_counter_sub(&sbi->s_dirtyblocks_counter,
> -                                               reserv_blks);
> +                                               reserv_blks - ar->len);
>         }
> 
>         trace_mark(ext4_allocate_blocks,
> 
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are the assignee for the bug, or are watching the assignee.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
