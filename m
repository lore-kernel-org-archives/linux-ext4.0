From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] e2image: perform in-place move
Date: Thu, 26 Dec 2013 00:24:44 -0500
Message-ID: <20131226052444.GB13533@thunk.org>
References: <52AF2AC0.2030103@ubuntu.com>
 <1387211599-25789-1-git-send-email-psusi@ubuntu.com>
 <20131225045826.GC13142@thunk.org>
 <20131226044857.GA13533@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43452 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab3LZFYs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Dec 2013 00:24:48 -0500
Content-Disposition: inline
In-Reply-To: <20131226044857.GA13533@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 25, 2013 at 11:48:57PM -0500, Theodore Ts'o wrote:
> Sigh, I've had to revert this change since it is causing test
> failures.  **Please** run the regression test suite before you submit
> patches.

I figured out the problem.  The issue is that you changed e2image to
no longer truncate the output file (i.e., you removed O_TRUNC).

The test failure was caused by the fact that previously written data
blocks that were in unallocated blocks weren't getting over written,
and so this would cause the md5 checksums to break.  I can work around
this in the test by deleting the output files, but I think I'll also
modify your comment to avoid the truncate only when trying to create a
raw image dump.  For qcow2 and normal e2image files, it's better to
keep the existing behavior of truncating the output when we first open
it.

This change of your also turned up a bug which I had to fix up.  It
could happen today when people used e2image to copy a file system to
another block device:

commit aa2c743331f392e49d5b168b5e3d8c8a8084b8b4
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Dec 25 16:33:52 2013 -0500

    e2image: only skip writing zero blocks when writing to a new file
    
    The e2image progam was originally intended to create image files.
    However, some people have started using e2image to copy a file system
    from one block device to another, since it is more efficient than
    using dd because it only copies the blocks which are in use.  If we
    are doing this, however, we must not skip writing blocks which are all
    zero in the source device, since they may not be zero in the
    destination device.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Phillip Susi <psusi@ubuntu.com>

						- Ted
