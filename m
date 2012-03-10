From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 29/54] e2fsck: Check extended attribute block checksums
Date: Sat, 10 Mar 2012 00:22:31 -0500
Message-ID: <20120310052231.GD5652@thunk.org>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
 <20120307000032.11945.89164.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59455 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab2CJFWi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 00:22:38 -0500
Content-Disposition: inline
In-Reply-To: <20120307000032.11945.89164.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 06, 2012 at 04:00:32PM -0800, Darrick J. Wong wrote:
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index d910629..ad6887e 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -961,6 +961,21 @@ static struct e2fsck_problem problem_table[] = {
>  	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
>  	  PROMPT_FIX, 0 },
>  
> +	/* Extended attribute block checksum for inode does not match. */
> +	{ PR_1_EA_BLOCK_CSUM_INVALID,
> +	  N_("Extended attribute @a @b %b checksum for @i %i does not "
> +	     "match.  "),
> +	  PROMPT_CLEAR, 0 },
> +
> +	/*
> +	 * Extended attribute block passes checks, but checksum for inode does
> +	 * not match.
> +	 */
> +	{ PR_1_EA_BLOCK_CSUM_INVALID,
          ^^^^^^^^^^^^^^^^^^^^^^^^^^

This should be PR_1_EA_BLOCK_ONLY_CSUM_INVALID.  This was discovered
again via the tst_problem unit test in the e2fsprogs regression test
suite:

LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./tst_problem
*** Duplicate in problem table:
curr code = 0x0001006a: Extended attribute @a @b %b passes checks, but checksum for @i %i does not match.  
*** prev code = 0x0001006a: Extended attribute @a @b %b checksum for @i %i does not match.  
*** This is a fatal programming error in e2fsck

    	      	    		      	 - Ted
