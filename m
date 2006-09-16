From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [patch] 48bit extents in e2fsprogs
Date: Sat, 16 Sep 2006 12:16:43 -0600
Message-ID: <20060916181643.GI6441@schatzie.adilger.int>
References: <20060915120540.GA23824@openx1.frec.bull.fr> <20060915165743.GH6441@schatzie.adilger.int> <20060915181100.GA29801@moule.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:7093 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1750843AbWIPSQv
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Sep 2006 14:16:51 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060915181100.GA29801@moule.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 15, 2006  20:11 +0200, Alexandre Ratchov wrote:
> On Fri, Sep 15, 2006 at 10:57:43AM -0600, Andreas Dilger wrote:
> > - the check for ee_start_hi and ei_leaf_hi fields (PR_1_EXTENT_HI) needs to
> >   be fixed (I don't see it changed here) so that it considers that an error
> >   only if INCOMPAT_64BIT flag is set and the filesystem is > 2^32 blocks.
> >   That is in e2fsck_ext_block_verify()
> > - (FYI) In my definition of PR_1_EXTENT_HI I recently added the PR_PREEN_NOMSG
> >   flag because users were confused about the "High 16 bits of extent/index
> >   block set" message even though it is harmless for 32-bit filesystems.
> 
> just to be sure to get it right: we allow 32bit file-systems to have extents
> with _hi bits set, right? (and *_hi are ignored)

Well, this is an undesirable side-effect of the old 32-bit extents code.
e2fsck should just clear the _hi fields for 32-bit filesystems.  For
larger filesystems it should assume they are valid.  That means that the
PR_1_EXTENT_HI checks should just be skipped for > 32-bit filesystems.

> so we can't simply assume that extents are always 48bit, in which case it
> would be enough to just check that they are inside the block group (that
> would detect extents with *_hi set as corrupt).

For now I wouldn't change the ext4 code.  The latest CFS e2fsprogs and kernel
code clears the _hi fields correctly, and we can get our users to run an
e2fsck before they ever start using ext4-based code (which likely won't be
for a year or more) if they have a filesystem which still has _hi values set.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

