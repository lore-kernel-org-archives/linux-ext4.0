From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/18] e2fsck: reserve blocks for root/lost+found
 directory repair
Date: Mon, 28 Jul 2014 00:27:47 -0700
Message-ID: <20140728072747.GA404@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003345.28334.14376.stgit@birch.djwong.org>
 <20140726194703.GI6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20541 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaG1H1w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 03:27:52 -0400
Content-Disposition: inline
In-Reply-To: <20140726194703.GI6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 03:47:03PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 25, 2014 at 05:33:45PM -0700, Darrick J. Wong wrote:
> > +static void reserve_block_for_lnf_repair(e2fsck_t ctx)
> > +{
> > +	blk64_t		blk = 0;
> > +	errcode_t	err;
> > +	ext2_filsys	fs = ctx->fs;
> > +	const char	*name = "lost+found";
> > +	ext2_ino_t	ino;
> > +
> > +	ctx->lnf_repair_block = 0;
> > +	if (!ext2fs_lookup(fs, EXT2_ROOT_INO, name, sizeof(name)-1, 0, &ino))
> > +		return;
> 
> Let me guess... this originally read:
> 
> 	const char	name[] = "lost+found";
> 
> But you changed it without rerunning the regression tests.  :-(

Oops.

Actually, I /did/ rerun the regression tests, and nothing blew up.  Now I'm
puzzling over why it worked.  I'll look into that tomorrow.

Thanks for catching that.

--D
> 
> Another reason why there is no such thing as not running the
> regression tests too many times, even after the most trivial changes.
> 
> I'll fix this up and commit it, with the following comment added:
> 
>     [ Fixed up an obvious C trap: const char * and const char [] are not
>       the same thing when you are taking the size of the parameter.
>       People, run your regression tests!  Like spinache, it's good for you.  :-)
>       -- tytso ]
> 
> 						- Ted
> 
