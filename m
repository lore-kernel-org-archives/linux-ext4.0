From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/54] e2fsck: on read error, don't rewrite blocks past
 the end of the fs
Date: Tue, 27 Jan 2015 12:35:07 -0500
Message-ID: <20150127173507.GM2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073657.13308.5523.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35540 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758806AbbA0RhR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 12:37:17 -0500
Content-Disposition: inline
In-Reply-To: <20150127073657.13308.5523.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:36:57PM -0800, Darrick J. Wong wrote:
> If e2fsck encounters a read error on a block past the end of the
> filesystem, don't bother trying to "rewrite" the block.  We might
> still want to re-try the read to capture FS data marooned past the end
> of the filesystem, but in that case e2fsck ought to move the block
> back inside the filesystem.
> 
> This enables e2fuzz to detect writes past the end of the FS due to
> software bugs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, but if we have a block which is past the end of the file
system, why did we try to read it in the first place?

Was it because e2fsck was told to ignore a file system inconsistency?
Or because e2fsck didn't notice before trying to read a block?  If so,
we should look to see if there is some way we could have caught this
error in the first place.  So it might be useful to run e2fuzz and
call abort() if we try to read past the end of the file system, so we
can get a stack dump and understand what happened....

    	  	     	 	    	 - Ted
