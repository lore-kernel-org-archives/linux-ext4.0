From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/18] dumpe2fs: add switch to disable checksum
 verification
Date: Mon, 28 Jul 2014 00:48:39 -0700
Message-ID: <20140728074839.GC404@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003416.28334.11698.stgit@birch.djwong.org>
 <20140726205808.GP6725@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28662 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaG1Hsp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 03:48:45 -0400
Content-Disposition: inline
In-Reply-To: <20140726205808.GP6725@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 26, 2014 at 04:58:08PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 25, 2014 at 05:34:16PM -0700, Darrick J. Wong wrote:
> > Add a -n switch to turn off checksum verification.
> 
> Instead of adding a -n flag, I wonder if the better thing to do is if
> the various functions that might return a checksum error error out, we
> print a warning message indicating checksum failure occured, and then
> retry with EXT2_FLAG_IGNORE_CSUM_ERRORS.  That is, either retry the
> ext2fs_open with the IGNORE_CSUM_ERRORS, or if the file system is
> already open, or in EXT2_FLAG_IGNORE_CSUM_ERRORS into fs->flags and
> then retry the ext2fs_read_bitmaps() or whatever.
> 
> What do you think?

My reason for this approach is that forcing the user to tack on "-n" makes it
less likely that a checksum error will be buried in the output and forgotten.

That said I don't have any objection to this approach either.  The checksum
complaint could be printed at the end.  I think the error message should also
tell the user to run e2fsck.

--D
> 
> 					- Ted
