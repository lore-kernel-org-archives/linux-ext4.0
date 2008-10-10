From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH][5/15] e2fsprogs-uninit-fixes.patch
Date: Fri, 10 Oct 2008 14:26:20 -0400
Message-ID: <20081010182619.GC8645@mit.edu>
References: <1223289070.4007.85.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Kalpak Shah <Kalpak.Shah@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51396 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757709AbYJJS0X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 14:26:23 -0400
Content-Disposition: inline
In-Reply-To: <1223289070.4007.85.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 06, 2008 at 04:01:10PM +0530, Kalpak Shah wrote:
> Bug fixes for uninit_bg feature:
> - display correct inode number during BG_INO_UNINIT and INOREF_IN_USED
> errors
> - restart e2fsck only once in case of above errors
> - initialize bitmaps properly considering whether block group is uninit
> or not (needed for e2freefrag)
> 
> Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

> Bug fixes for uninit_bg feature:
> - display correct inode number during BG_INO_UNINIT and INOREF_IN_USED errors
> - restart e2fsck only once in case of above errors
> - initialize bitmaps properly considering uninit or not (needed for e2freefrag)
> 
> Index: e2fsprogs-1.41.1/debugfs/set_fields.c
> ===================================================================
> --- e2fsprogs-1.41.1.orig/debugfs/set_fields.c
> +++ e2fsprogs-1.41.1/debugfs/set_fields.c
> @@ -566,6 +566,7 @@ void do_set_block_group_descriptor(int a
>  	}
>  
>  	set_gd = current_fs->group_desc[set_bg];
> +	set_sb = *current_fs->super;
>  
>  	if (ss->func(ss, argv[3]) == 0) {
>  		current_fs->group_desc[set_bg] = set_gd;

Why is this needed?  None of the table entries used by
set_block_group_descriptor requires set_sb to be set?


> Index: e2fsprogs-1.41.1/e2fsck/problem.c
> ===================================================================
> --- e2fsprogs-1.41.1.orig/e2fsck/problem.c
> +++ e2fsprogs-1.41.1/e2fsck/problem.c
> @@ -1301,12 +1301,12 @@ static struct e2fsck_problem problem_tab
>  
>  	/* Inode found in group where _INODE_UNINIT is set */
>  	{ PR_2_INOREF_BG_INO_UNINIT,
> -	  N_("@i %i found in @g %g where _INODE_UNINIT is set.  "),
> +	  N_("@i %N found in @g %g where _INODE_UNINIT is set.  "),
>  	  PROMPT_FIX, PR_PREEN_OK },
>  
>  	/* Inode found in group unused inodes area */
>  	{ PR_2_INOREF_IN_UNUSED,
> -	  N_("@i %i found in @g %g unused inodes area.  "),
> +	  N_("@i %N found in @g %g unused inodes area.  "),
>  	  PROMPT_FIX, PR_PREEN_OK },
>  

This doesn't look right.  %N prints pctx.num, which is set to the
directory entry's offset.  It looks like %Di is the correct expansion,
and maybe something like this:

    @E references @i %Di in @g %g where _INODE_UNINIT is set.\n

and

    @E references @i %Di in @g %g unused inods area.\n

							- Ted
