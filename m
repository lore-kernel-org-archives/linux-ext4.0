From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/18] e2fsck: toggle checksum verification error
 reporting appropriately
Date: Sun, 27 Jul 2014 19:37:22 -0400
Message-ID: <20140727233721.GA6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003453.28334.47494.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59593 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaG0XhY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 19:37:24 -0400
Content-Disposition: inline
In-Reply-To: <20140726003453.28334.47494.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:34:53PM -0700, Darrick J. Wong wrote:
> There are a few mistakes in the checksum verification error reporting
> logic.  First, when we're doing a re-check of an inode that failed
> earlier, we must never ignore checksum errors.  Second, if we're
> performing sanity checks after an initial checksum verification
> failure, then we /should/ disable checksum error reporting for
> block_iterate because that function will re-read the inode from disk.
> This fixes the numerous "inode checksum failure" problems that cause
> e2fsck to abort.

I'm starting to wonder if we just set IGNORE_CSUM_ERRORS when we open
the file system, and explicitly check the checksums in e2fsck.  It
might make the logic clearer, especially when we start trying to be a
bit more sophisticated in handling checksum errors.

Otherwise, if we get a checksum error, we would have to set the flag
and then retry the read.

					- Ted
