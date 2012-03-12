From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 08/54] e2fsck: Verify and correct inode checksums
Date: Mon, 12 Mar 2012 15:49:13 -0700
Message-ID: <20120312224913.GQ15164@tux1.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com> <20120306235812.11945.3055.stgit@elm3b70.beaverton.ibm.com> <20120310050928.GC5652@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40284 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789Ab2CLWtU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 18:49:20 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 12 Mar 2012 18:49:19 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 14D6E6E804A
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 18:49:16 -0400 (EDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2CMnF1q336006
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 18:49:15 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2CMnDG1006361
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 16:49:15 -0600
Content-Disposition: inline
In-Reply-To: <20120310050928.GC5652@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 10, 2012 at 12:09:28AM -0500, Ted Ts'o wrote:
> On Tue, Mar 06, 2012 at 03:58:12PM -0800, Darrick J. Wong wrote:
> > Detect mismatches of the inode and checksum, and prompt the user to fix the
> > situation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> The new problem definitions were inserted into the wrong place in
> problem.c.  This is something that was picked up by a unit test in the
> e2fsck directory:
> 
> LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./tst_problem
> *** Unordered problem table:
> curr code = 0x00010065: The bad @b @i looks @n.  
> *** prev code = 0x00010067: @i %i passes checks, but checksum does not match @i.  
> *** This is a programming error in e2fsck
> make[1]: *** [check] Error 1
> 
> The fix was simple; just move the new lines in problem.c down two lines.
> 
> >  	/* Quota inode is user visible */
> >  	{ PR_1_QUOTA_INODE_NOT_HIDDEN,
> >  	  N_("@q @i is visible to the user.  "),
> > - 	  PROMPT_CLEAR, PR_PREEN_OK },
> > +	  PROMPT_FIX, PR_PREEN_OK },
> 
> PR1_QUOTA_INODE_NOT_HIDDEN isn't currently used, so there's no point
> changing it now.  Depending on how this bit of the first class quota
> patch gets implemented, the message might change completely.

Ugh, that looks like a merge error on my end.  Sorry and thanks for fixing it.

--D

