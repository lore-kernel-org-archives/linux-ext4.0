From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 02/14] undo-io: write out index block after every write
Date: Sat, 16 May 2015 20:18:45 -0400
Message-ID: <20150517001845.GA4489@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002121.10785.38168.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40729 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbbEQASr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 May 2015 20:18:47 -0400
Content-Disposition: inline
In-Reply-To: <20150514002121.10785.38168.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 05:21:21PM -0700, Darrick J. Wong wrote:
> Write out the undo file's index block after writing a block to the
> undo file.  This ensures that we always have a consistent undo file
> in the page cache, even if the program crashes.  When we fill up a
> key block in the undo file, we'll call fsync to force the whole
> thing to storage; this should happen about every 256 blocks given
> the usual 4K block size.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, but I'm not sure calling fsync every 256 blocks is worth it
at all; when mke2fs is writing a 128M journal, it's going to be
writing 32,768 blocks.  If we call fsync every 256 blocks, then we'll
be calling it 128 times during the course of the mke2fs, and this
doesn't count any of the other blocks overwritten by mke2fs.

The fsync() is only going to help in case of power failure --- and if
we only calling it every 256 blocks, we're going to lose data in
anyway.

This patch doesn't appear to change how often we call fsync(2), so
I'll take this, but I think we should seriously think about only
calling fync() if we're closing the undo file.

	       	    		    - Ted
