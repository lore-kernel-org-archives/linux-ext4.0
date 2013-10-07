From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/31] libext2fs: Only link an inode into a directory once
Date: Mon, 7 Oct 2013 11:53:09 -0700
Message-ID: <20131007185309.GE6860@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012655.28415.38313.stgit@birch.djwong.org>
 <20131007131727.GC4540@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43535 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3JGSxO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Oct 2013 14:53:14 -0400
Content-Disposition: inline
In-Reply-To: <20131007131727.GC4540@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 09:17:27AM -0400, Theodore Ts'o wrote:
> On Mon, Sep 30, 2013 at 06:26:55PM -0700, Darrick J. Wong wrote:
> > The ext2fs_link helper function link_proc does not check the value of ls->done,
> > which means that if the function finds multiple empty spaces that will fit the
> > new directory entry, it will create a directory entry in each of the spaces.
> > Instead of doing that, check the done value and don't do anything more if we've
> > already added the directory entry.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Thanks, applied.
> 
> One minor nit, which I'll generally fix myself when I have the chance:
> 
> I generally like to fill comments at column 70, and in general, to try
> to keep the summary line under 76 columns if possible, so that "git
> log" doesn't wrap on 80 column screens.  It's not always possible to
> do the latter, but it's something I will try to do.  Also, personally
> prefer to use a lowercase to start the description since these
> constraints generally mean the summary line can't be a complete
> sentence.

Ok.  Assuming that you're reformatting the descriptions of the patches you're
taking into your tree, I'll reformat the descriptions on the ones that don't
make it in or require rework.

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
