From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/18] e2fsck: toggle checksum verification error
 reporting appropriately
Date: Mon, 28 Jul 2014 00:38:26 -0700
Message-ID: <20140728073826.GB404@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003453.28334.47494.stgit@birch.djwong.org>
 <20140727233721.GA6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24680 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaG1Hib (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 03:38:31 -0400
Content-Disposition: inline
In-Reply-To: <20140727233721.GA6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 27, 2014 at 07:37:22PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 25, 2014 at 05:34:53PM -0700, Darrick J. Wong wrote:
> > There are a few mistakes in the checksum verification error reporting
> > logic.  First, when we're doing a re-check of an inode that failed
> > earlier, we must never ignore checksum errors.  Second, if we're
> > performing sanity checks after an initial checksum verification
> > failure, then we /should/ disable checksum error reporting for
> > block_iterate because that function will re-read the inode from disk.
> > This fixes the numerous "inode checksum failure" problems that cause
> > e2fsck to abort.
> 
> I'm starting to wonder if we just set IGNORE_CSUM_ERRORS when we open
> the file system, and explicitly check the checksums in e2fsck.  It
> might make the logic clearer, especially when we start trying to be a
> bit more sophisticated in handling checksum errors.

We could make e2fsck verify the checksums itself, though we'd have to provide a
way for either (a) libext2fs to provide the raw buffer data to e2fsck or (b)
e2fsck to find the block number in question and (re)read the raw buffer, since
the checksums are computed against the on-disk structures.

This could get a bit nasty for EA and extent handling, since e2fsck doesn't
touch the underlying blocks directly, and the checksums are per-block, not per
FS object.

> Otherwise, if we get a checksum error, we would have to set the flag
> and then retry the read.

Also doable.

--D
> 
> 					- Ted
