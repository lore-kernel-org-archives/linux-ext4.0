From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/19] e2fsck: use root dir for lost+found when really
 desperate
Date: Mon, 4 Aug 2014 17:58:58 -0700
Message-ID: <20140805005858.GU8628@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181159.12496.97356.stgit@birch.djwong.org>
 <20140803022553.GC24826@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38096 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaHEA7E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 20:59:04 -0400
Content-Disposition: inline
In-Reply-To: <20140803022553.GC24826@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 02, 2014 at 10:25:53PM -0400, Theodore Ts'o wrote:
> On Fri, Aug 01, 2014 at 11:11:59AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If we're totally unable to allocate a lost+found directory, ask the
> > user if he would like to dump orphaned files in the root directory.
> > Hopefully this enables the user to delete enough files so that a
> > subsequent run of e2fsck will make more progress.  Better to cram lost
> > files in the rootdir than the current behavior, which is to fail at
> > linking them in, thereby leaving them as lost files.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Applied, although I changed:
> 
> > +		printf("Delete some files and re-run e2fsck.\n\n");
> 
> to:
> 
> 		printf(_("Delete some files and re-run e2fsck.\n\n"));

I don't see this in the tree on kernel.org, but I'm sending you a patch to
change it to a fix_problem anyway.

--D
> 
> for proper internationalization support.  Usually, I like to run all
> messages through problem.c, like this:
> 
> 	fix_problem(ctx, PR_3_PASS_HEADER, &pctx);
> 
> 	{ PR_3_PASS_HEADER,
> 	  N_("Pass 3: Checking @d connectivity\n"),
> 	    PROMPT_NONE, 0 },
> 
> and I may change this over at some point, but I'll leave it as a
> printf for now.
> 
> Thanks!!
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
