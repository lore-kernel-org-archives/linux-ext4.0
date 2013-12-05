From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mke2fs: Fix block bitmaps initalization with -O
 ^resize_inode
Date: Wed, 4 Dec 2013 21:04:10 -0800
Message-ID: <20131205050410.GA10143@birch.djwong.org>
References: <52662BBA.70503@rs.jp.nec.com>
 <20131123013336.GD10269@birch.djwong.org>
 <20131126012706.GF10269@birch.djwong.org>
 <003101ceea7f$08d3fda0$1a7bf8e0$@rs.jp.nec.com>
 <20131127005505.GG10269@birch.djwong.org>
 <00d301ceec16$de11fec0$9a35fc40$@rs.jp.nec.com>
 <20131130200624.GA9541@birch.djwong.org>
 <20131204234435.GF19914@thunk.org>
 <20131205012210.GC10150@birch.djwong.org>
 <20131205020340.GA8404@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>,
	"'ext4 development'" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37612 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3LEFER (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Dec 2013 00:04:17 -0500
Content-Disposition: inline
In-Reply-To: <20131205020340.GA8404@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[resend without accidentally dropping the cc's]

On Wed, Dec 04, 2013 at 09:03:40PM -0500, Theodore Ts'o wrote:
> On Wed, Dec 04, 2013 at 05:22:10PM -0800, Darrick J. Wong wrote:
> > > 2) The IETF rule of "be conservative in what you send, and liberal in
> > > what you accept" applies.
> > 
> > I'm not convinced that we /need/ Akira's patch to clear BLOCK_UNINIT on any
> > group containing its own metadata, but I doubt it'd harm anything other than
> > make e2fsck slower.
> > 
> > It would certainly be the conservative-send route though.
> 
> The place where we are being conserviative what we send is that we
> clear BLOCK_UNINIT for block groups that don't have any data blocks,
> but which has metadata blocks belonging to *other* block groups,
> because there were some kernel implementations in the past that didn't
> handle this correctly.
> 
> But if you have a block group that has only its metadata, that's
> perfectly fine.  And that's easy to test; if you create a file system
> like this:
> 
>      touch /tmp/foo.img
>      mke2fs -t ext2 -O uninit_bg /tmp/foo.img 1800000
> 
> ... then by definition every single block group has its own metadata,
> and if there were problems with block groups that had its own metadata
> blocks, we wouldn't be able to set BLOCK_UNINIT on any block group at
> all.
> 
> It looks like we are currently clearing BLOCK_UNINIT for block groups
> that contain superblocks and backup superblocs.  To be honest, I don't
> remember why we are currently doing this.  I *think* the kernel and

Looking at the git history, that chunk of ext2fs_reserve_super_and_bgd() landed
there when you were trying to clean up libext2fs, though there's no obvious
reason why we need to unset BLOCK_UNINIT there too.  Oh well, it can't hurt.

> all modern e2fsprogs should be able to do the right thing, if we set
> BLOCK_UNINIT on all block groups.

Fortunately, they do, and have since the initial ext4dev code in 2006-7.

--D
> 
> 				- Ted
