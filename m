From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 07/51] e2fsck: Verify and correct inode checksums
Date: Mon, 19 Dec 2011 12:12:21 -0800
Message-ID: <20111219201221.GL8233@tux1.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011403.20947.54324.stgit@elm3c44.beaverton.ibm.com> <701CAD1A-51A8-4F0F-8323-4B2091BF8F78@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50329 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab1LSURE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 15:17:04 -0500
Received: from /spool/local
	by e3.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 19 Dec 2011 15:17:03 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBJKCUtN113300
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 15:12:31 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBJKCOSQ011119
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 15:12:26 -0500
Content-Disposition: inline
In-Reply-To: <701CAD1A-51A8-4F0F-8323-4B2091BF8F78@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 19, 2011 at 11:28:24AM +0100, Andreas Dilger wrote:
> On 2011-12-14, at 2:14 AM, Darrick J. Wong wrote:
> > Detect mismatches of the inode and checksum, and prompt the user to fix the
> > situation.
> > 
> > @@ -739,6 +740,12 @@ void e2fsck_pass1(e2fsck_t ctx)
> > 		pctx.ino = ino;
> > 		pctx.inode = inode;
> > 		ctx->stashed_ino = ino;
> > +
> > +		/* Clear corrupt inode */
> > +		if (pctx.errcode == EXT2_ET_INODE_CSUM_INVALID &&
> > +		    fix_problem(ctx, PR_1_INODE_CSUM_INVALID, &pctx))
> > +			goto clear_inode;
> 
> If the user enters "n" here to clear the inode, does it make sense to
> also ask if they want the checksum be corrected?  If this is also "n"
> (as is the case with "e2fsck -n") then nothing is done, but in some
> cases it makes sense to allow the user to keep the inode rather than
> only having the option to erase it.

I was thinking something like this might work:

if (csum_invalid)
	ask and then jump to clear_inode;

...all other inode sanity checks go here...

if (csum_was_invalid)
	ask and correct inode checksum;

That way, if the inode manages to survive all the other sanity checks, the user
has the opportunity to save the inode.  If the inode contains junk, then the
user will probably clear the inode on account of the garbage.

Come to think of it, this is probably a good idea for everything else.  I
think?

> > diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> > index f042b89..89dc72b 100644
> > --- a/e2fsck/problem.c
> > +++ b/e2fsck/problem.c
> > @@ -934,7 +934,12 @@ static struct e2fsck_problem problem_table[] = {
> > +	/* inode checksum does not match inode */
> > +	{ PR_1_INODE_CSUM_INVALID,
> > +	  N_("@i %i checksum does not match @i.  "),
> > +	  PROMPT_FIX, PR_PREEN_OK },
> 
> Also, "PROMPT_FIX" is misleading if the "fix" is to erase the inode.
> It should instead be "PROMPT_CLEAR_INODE".

Ok.

--D
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

