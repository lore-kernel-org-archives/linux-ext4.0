From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/14] misc: add fuse2fs, a FUSE server for e2fsprogs
 (v4.3)
Date: Mon, 15 Jun 2015 15:21:45 -0400
Message-ID: <20150615192145.GD5003@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002240.10785.35238.stgit@birch.djwong.org>
 <20150611001337.GI24181@thunk.org>
 <20150615183705.GC7063@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36628 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbbFOTVr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Jun 2015 15:21:47 -0400
Content-Disposition: inline
In-Reply-To: <20150615183705.GC7063@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 15, 2015 at 11:37:05AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 10, 2015 at 08:13:37PM -0400, Theodore Ts'o wrote:
> > On Wed, May 13, 2015 at 05:22:40PM -0700, Darrick J. Wong wrote:
> > > This is the initial implementation of a FUSE server based on
> > > e2fsprogs.  The point of this program is to enable ext4 to run on any
> > > OS that FUSE supports (and doesn't already have a native driver), such
> > > as MacOS X, BSDs, and Windows.  The code requires FUSE API v28, which
> > > is available in Linux fuse and osxfuse releases that are available as
> > > of August 2013.
> > 
> > Thanks, applied.
> 
> Hi Ted,
> 
> There's a merge error with this patch; the commit in -next removes all
> the Makefile dependencies from misc/Makefile.in, whereas the patch
> adds entries for {journal,revoke,recovery}.o.
> 
> This breaks a clean build because make doesn't know that it has
> to generate profile.h for mke2fs.c.

It wasn't caused by a merge error; this patch added
$(srcdir)/do_journal.c to SRCS (I'm guessing this was a cut and paste
error), and this caused the "make depend" to blow out, and this caused
the Makefile to lose all of its dependencies.  (To be fair, one of my
commits, 81f95d43d: "libext2fs, libe2p, misc: git rid of jfs_user.h"
also had a bug which caused "make depend" to fail as well.)

Anyway, I'll check in a fix.  Thanks for the report!

						- Ted

P.S.  Could you take a look at my reply to your patch #16/14?
