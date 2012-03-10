From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/54] e2fsck: Verify and correct inode checksums
Date: Sat, 10 Mar 2012 00:09:28 -0500
Message-ID: <20120310050928.GC5652@thunk.org>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
 <20120306235812.11945.3055.stgit@elm3b70.beaverton.ibm.com>
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
Received: from li9-11.members.linode.com ([67.18.176.11]:45420 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab2CJFJh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 00:09:37 -0500
Content-Disposition: inline
In-Reply-To: <20120306235812.11945.3055.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 06, 2012 at 03:58:12PM -0800, Darrick J. Wong wrote:
> Detect mismatches of the inode and checksum, and prompt the user to fix the
> situation.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

The new problem definitions were inserted into the wrong place in
problem.c.  This is something that was picked up by a unit test in the
e2fsck directory:

LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./tst_problem
*** Unordered problem table:
curr code = 0x00010065: The bad @b @i looks @n.  
*** prev code = 0x00010067: @i %i passes checks, but checksum does not match @i.  
*** This is a programming error in e2fsck
make[1]: *** [check] Error 1

The fix was simple; just move the new lines in problem.c down two lines.

>  	/* Quota inode is user visible */
>  	{ PR_1_QUOTA_INODE_NOT_HIDDEN,
>  	  N_("@q @i is visible to the user.  "),
> - 	  PROMPT_CLEAR, PR_PREEN_OK },
> +	  PROMPT_FIX, PR_PREEN_OK },

PR1_QUOTA_INODE_NOT_HIDDEN isn't currently used, so there's no point
changing it now.  Depending on how this bit of the first class quota
patch gets implemented, the message might change completely.

      	   		    	    	  	 - Ted
