From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 14/14] misc: add fuse2fs, a FUSE server for e2fsprogs
 (v4.3)
Date: Mon, 15 Jun 2015 11:37:05 -0700
Message-ID: <20150615183705.GC7063@birch.djwong.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002240.10785.35238.stgit@birch.djwong.org>
 <20150611001337.GI24181@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45576 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbbFOShM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Jun 2015 14:37:12 -0400
Content-Disposition: inline
In-Reply-To: <20150611001337.GI24181@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2015 at 08:13:37PM -0400, Theodore Ts'o wrote:
> On Wed, May 13, 2015 at 05:22:40PM -0700, Darrick J. Wong wrote:
> > This is the initial implementation of a FUSE server based on
> > e2fsprogs.  The point of this program is to enable ext4 to run on any
> > OS that FUSE supports (and doesn't already have a native driver), such
> > as MacOS X, BSDs, and Windows.  The code requires FUSE API v28, which
> > is available in Linux fuse and osxfuse releases that are available as
> > of August 2013.
> 
> Thanks, applied.

Hi Ted,

There's a merge error with this patch; the commit in -next removes all
the Makefile dependencies from misc/Makefile.in, whereas the patch
adds entries for {journal,revoke,recovery}.o.

This breaks a clean build because make doesn't know that it has
to generate profile.h for mke2fs.c.

--D

> 
> 						- Ted
> 						
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
