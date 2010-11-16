From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/7] e2fsck: Keep track of problems during the check
Date: Tue, 16 Nov 2010 14:03:04 -0600
Message-ID: <4CE2E378.1000904@redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com> <1288115658-7004-4-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab0KPUDJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 15:03:09 -0500
In-Reply-To: <1288115658-7004-4-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/26/10 12:54 PM, Lukas Czerner wrote:
> It might be useful to know whether or not there has been any problem
> during the check. This commit add new variable problem_history into
> e2fsck_struct in order to store error codes.
> 
> When problem occur and fix_problem() is invoked, problem code is stored
> into problem_history. Note that only real problem are stored, hence
> problems with PR_NO_PROBLEM are ignored. This commit also adds
> PR_NO_PROBLEM flag into problem for informative purposes only.

Unless I'm missing something, don't we already keep track of
whether we did any repairs?  Based on the exit code from e2fsck;
per the man page:

EXIT CODE
       The exit code returned by e2fsck is the sum of the following conditions:
            0    - No errors
            1    - File system errors corrected
            2    - File system errors corrected, system should
                   be rebooted
...

etc.

-Eric

> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  e2fsck/e2fsck.h   |    1 +
>  e2fsck/problem.c  |   31 +++++++++++++++++++++----------
>  e2fsck/problem.h  |    3 +++
>  e2fsck/problemP.h |    1 +
>  4 files changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index d4df5f3..a6563cc 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -216,6 +216,7 @@ struct e2fsck_struct {
>  	blk64_t	num_blocks;	/* Total number of blocks */
>  	int	mount_flags;
>  	blkid_cache blkid;	/* blkid cache */
> +	__u32 problem_history;	/* store previous problem codes */
>  
>  #ifdef HAVE_SETJMP_H
>  	jmp_buf	abort_loc;
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 8032fda..9b987b0 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -407,7 +407,7 @@ static struct e2fsck_problem problem_table[] = {
>  	/* Pass 1: Checking inodes, blocks, and sizes */
>  	{ PR_1_PASS_HEADER,
>  	  N_("Pass 1: Checking @is, @bs, and sizes\n"),
> -	  PROMPT_NONE, 0 },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  	/* Root directory is not an inode */
>  	{ PR_1_ROOT_NO_DIR, N_("@r is not a @d.  "),
> @@ -896,7 +896,7 @@ static struct e2fsck_problem problem_table[] = {
>  	{ PR_1B_PASS_HEADER,
>  	  N_("\nRunning additional passes to resolve @bs claimed by more than one @i...\n"
>  	  "Pass 1B: Rescanning for @m @bs\n"),
> -	  PROMPT_NONE, 0 },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  	/* Duplicate/bad block(s) header */
>  	{ PR_1B_DUP_BLOCK_HEADER,
> @@ -937,13 +937,13 @@ static struct e2fsck_problem problem_table[] = {
>  	/* Pass 1C: Scan directories for inodes with multiply-claimed blocks. */
>  	{ PR_1C_PASS_HEADER,
>  	  N_("Pass 1C: Scanning directories for @is with @m @bs\n"),
> -	  PROMPT_NONE, 0 },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  
>  	/* Pass 1D: Reconciling multiply-claimed blocks */
>  	{ PR_1D_PASS_HEADER,
>  	  N_("Pass 1D: Reconciling @m @bs\n"),
> -	  PROMPT_NONE, 0 },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  	/* File has duplicate blocks */
>  	{ PR_1D_DUP_FILE,
> @@ -988,7 +988,7 @@ static struct e2fsck_problem problem_table[] = {
>  	/* Pass 2: Checking directory structure */
>  	{ PR_2_PASS_HEADER,
>  	  N_("Pass 2: Checking @d structure\n"),
> -	  PROMPT_NONE, 0 },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  	/* Bad inode number for '.' */
>  	{ PR_2_BAD_INODE_DOT,
> @@ -1318,7 +1318,7 @@ static struct e2fsck_problem problem_table[] = {
>  	/* Pass 3: Checking directory connectivity */
>  	{ PR_3_PASS_HEADER,
>  	  N_("Pass 3: Checking @d connectivity\n"),
> -	  PROMPT_NONE, 0 },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  	/* Root inode not allocated */
>  	{ PR_3_NO_ROOT_INODE,
> @@ -1440,7 +1440,7 @@ static struct e2fsck_problem problem_table[] = {
>  	/* Pass 3A: Optimizing directories */
>  	{ PR_3A_PASS_HEADER,
>  	  N_("Pass 3A: Optimizing directories\n"),
> -	  PROMPT_NONE, PR_PREEN_NOMSG },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  	/* Error iterating over directories */
>  	{ PR_3A_OPTIMIZE_ITER,
> @@ -1455,7 +1455,7 @@ static struct e2fsck_problem problem_table[] = {
>  	/* Rehashing dir header */
>  	{ PR_3A_OPTIMIZE_DIR_HEADER,
>  	  N_("Optimizing directories: "),
> -	  PROMPT_NONE, PR_MSG_ONLY },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  	/* Rehashing directory %d */
>  	{ PR_3A_OPTIMIZE_DIR,
> @@ -1472,7 +1472,7 @@ static struct e2fsck_problem problem_table[] = {
>  	/* Pass 4: Checking reference counts */
>  	{ PR_4_PASS_HEADER,
>  	  N_("Pass 4: Checking reference counts\n"),
> -	  PROMPT_NONE, 0 },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  	/* Unattached zero-length inode */
>  	{ PR_4_ZERO_LEN_INODE,
> @@ -1501,7 +1501,7 @@ static struct e2fsck_problem problem_table[] = {
>  	/* Pass 5: Checking group summary information */
>  	{ PR_5_PASS_HEADER,
>  	  N_("Pass 5: Checking @g summary information\n"),
> -	  PROMPT_NONE, 0 },
> +	  PROMPT_NONE, PR_NO_PROBLEM },
>  
>  	/* Padding at end of inode bitmap is not set. */
>  	{ PR_5_INODE_BMAP_PADDING,
> @@ -1629,6 +1629,13 @@ static struct e2fsck_problem problem_table[] = {
>  	  N_("@g %g @i(s) in use but @g is marked INODE_UNINIT\n"),
>  	  PROMPT_FIX, PR_PREEN_OK },
>  
> +	{ PR_5_DONT_DISCARD,
> +	  N_("There has been some errors during the check. I will not "
> +	     "attempt to discard free data and inode blocks for safety "
> +	     "reasons. If you wish to discard free data and inode blocks, "
> +	     "run e2fsck once again.\n"),
> +	  PROMPT_NONE, PR_NO_PROBLEM },
> +
>  	/* Post-Pass 5 errors */
>  
>  	/* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
> @@ -1755,6 +1762,10 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
>  		printf(_("Unhandled error code (0x%x)!\n"), code);
>  		return 0;
>  	}
> +	/* Keep track of real problems only */
> +	if (!(ptr->flags & PR_NO_PROBLEM)) {
> +		ctx->problem_history |= code;
> +	}
>  	if (!(ptr->flags & PR_CONFIG)) {
>  		char	key[9], *new_desc;
>  
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index 7c4c156..c3431ac 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -983,6 +983,9 @@ struct problem_context {
>  /* Inode in use but group is marked INODE_UNINIT */
>  #define PR_5_INODE_UNINIT		0x050019
>  
> +/* Do not attempt to discard */
> +#define PR_5_DONT_DISCARD		0x05001A
> +
>  /*
>   * Post-Pass 5 errors
>   */
> diff --git a/e2fsck/problemP.h b/e2fsck/problemP.h
> index 6161189..ee6c1a3 100644
> --- a/e2fsck/problemP.h
> +++ b/e2fsck/problemP.h
> @@ -41,3 +41,4 @@ struct latch_descr {
>  #define PR_PREEN_NOHDR	0x040000 /* Don't print the preen header */
>  #define PR_CONFIG	0x080000 /* This problem has been customized
>  				    from the config file */
> +#define PR_NO_PROBLEM	0x100000 /* Use No as an answer if preening */

