From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] e2fsck: fix problem report typo
Date: Thu, 7 Jan 2016 10:44:03 -0800
Message-ID: <20160107184403.GB28338@birch.djwong.org>
References: <20160107183118.GB8716@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32387 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbcAGSoI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Jan 2016 13:44:08 -0500
Content-Disposition: inline
In-Reply-To: <20160107183118.GB8716@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 07, 2016 at 01:31:18PM -0500, Eric Whitney wrote:
> Remove the stray left parenthesis.  Observed while testing bigalloc_1k
> filesystems with shared/298 on 32 bit ARM running 4.3 kernels.
> 
> v2: Modify the expect files for the relevant regression tests.

Looks ok now,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> ---
>  e2fsck/problem.c                            | 2 +-
>  tests/f_compress_extent_tree_level/expect.1 | 2 +-
>  tests/f_extent_oobounds/expect.1            | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index a7da94d..7bd660d 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1255,7 +1255,7 @@ static struct e2fsck_problem problem_table[] = {
>  
>  	/* Inode extent tree could be narrower */
>  	{ PR_1E_CAN_NARROW_EXTENT_TREE,
> -	  N_("@i %i @x tree (at (level %b) could be narrower.  "),
> +	  N_("@i %i @x tree (at level %b) could be narrower.  "),
>  	  PROMPT_FIX, PR_NO_OK | PR_PREEN_NO | PR_PREEN_OK },
>  
>  	/* Pass 2 errors */
> diff --git a/tests/f_compress_extent_tree_level/expect.1 b/tests/f_compress_extent_tree_level/expect.1
> index 1159f24..a359c99 100644
> --- a/tests/f_compress_extent_tree_level/expect.1
> +++ b/tests/f_compress_extent_tree_level/expect.1
> @@ -10,7 +10,7 @@ Level Entries       Logical      Physical Length Flags
>   1/ 1   2/  3    19 -    19   104 -   104      1 
>   1/ 1   3/  3    21 -    21   105 -   105      1 
>  Pass 1: Checking inodes, blocks, and sizes
> -Inode 12 extent tree (at (level 1) could be narrower.  Fix? yes
> +Inode 12 extent tree (at level 1) could be narrower.  Fix? yes
>  
>  Pass 1E: Optimizing extent trees
>  Pass 2: Checking directory structure
> diff --git a/tests/f_extent_oobounds/expect.1 b/tests/f_extent_oobounds/expect.1
> index 59e1952..056689f 100644
> --- a/tests/f_extent_oobounds/expect.1
> +++ b/tests/f_extent_oobounds/expect.1
> @@ -3,7 +3,7 @@ Inode 12, end of extent exceeds allowed value
>  	(logical block 15, physical block 200, len 30)
>  Clear? yes
>  
> -Inode 12 extent tree (at (level 1) could be narrower.  Fix? yes
> +Inode 12 extent tree (at level 1) could be narrower.  Fix? yes
>  
>  Inode 12, i_blocks is 154, should be 94.  Fix? yes
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
