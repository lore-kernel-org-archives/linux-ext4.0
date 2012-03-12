From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 29/54] e2fsck: Check extended attribute block checksums
Date: Mon, 12 Mar 2012 15:43:57 -0700
Message-ID: <20120312224357.GP15164@tux1.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com> <20120307000032.11945.89164.stgit@elm3b70.beaverton.ibm.com> <20120310052231.GD5652@thunk.org>
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
Received: from e39.co.us.ibm.com ([32.97.110.160]:33085 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2CLWoO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Mar 2012 18:44:14 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 12 Mar 2012 16:44:12 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 2B86E1FF0047
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 16:44:02 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2CMi1QB144990
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 16:44:01 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2CMhxDY012701
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 16:44:01 -0600
Content-Disposition: inline
In-Reply-To: <20120310052231.GD5652@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 10, 2012 at 12:22:31AM -0500, Ted Ts'o wrote:
> On Tue, Mar 06, 2012 at 04:00:32PM -0800, Darrick J. Wong wrote:
> > diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> > index d910629..ad6887e 100644
> > --- a/e2fsck/problem.c
> > +++ b/e2fsck/problem.c
> > @@ -961,6 +961,21 @@ static struct e2fsck_problem problem_table[] = {
> >  	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
> >  	  PROMPT_FIX, 0 },
> >  
> > +	/* Extended attribute block checksum for inode does not match. */
> > +	{ PR_1_EA_BLOCK_CSUM_INVALID,
> > +	  N_("Extended attribute @a @b %b checksum for @i %i does not "
> > +	     "match.  "),
> > +	  PROMPT_CLEAR, 0 },
> > +
> > +	/*
> > +	 * Extended attribute block passes checks, but checksum for inode does
> > +	 * not match.
> > +	 */
> > +	{ PR_1_EA_BLOCK_CSUM_INVALID,
>           ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This should be PR_1_EA_BLOCK_ONLY_CSUM_INVALID.  This was discovered
> again via the tst_problem unit test in the e2fsprogs regression test
> suite:
> 
> LD_LIBRARY_PATH=../lib DYLD_LIBRARY_PATH=../lib ./tst_problem
> *** Duplicate in problem table:
> curr code = 0x0001006a: Extended attribute @a @b %b passes checks, but checksum for @i %i does not match.  
> *** prev code = 0x0001006a: Extended attribute @a @b %b checksum for @i %i does not match.  
> *** This is a fatal programming error in e2fsck
> 
>     	      	    		      	 - Ted

Geesh, thank you for finding and fixing that one.

--D

