From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 18/31] libext2fs: Badblocks should handle 48-bit block
 numbers correctly
Date: Tue, 8 Oct 2013 12:03:31 -0400
Message-ID: <20131008160331.GI17896@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012837.28415.1138.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43703 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430Ab3JHQDs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Oct 2013 12:03:48 -0400
Content-Disposition: inline
In-Reply-To: <20131001012837.28415.1138.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:28:37PM -0700, Darrick J. Wong wrote:
> Currently, the badblocks code assumes 32-bit block numbers.  This leads to
> unfortunate results, because feeding a badblocks file to mke2fs with 64-bit
> block numbers causes libext2fs to rip off the upper 32 bits of the block number
> and then assign a truncated block number to the badblocks file.
> 
> This is just as well, since the code that writes to the bb inode doesn't know
> about extents anyway.  Rather than continuing to open-code block map
> manipulation, simply use existing library functions to truncate the old bb
> inode, mark all badblocks in use, and then assign them to the badblocks file.
> We can even use extents now.
> 
> (It's arguable that badblocks is a vestigial organ now, but perhaps someone is
> using it?  I use it to stress-test disk block allocation, but I might just be
> nutty.)
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yeah, I think badblocks is vestigal at this point, and for huge disk
arrays, almost certainly block replacement will be handed at the LVM,
storage array, or HDD level.  So it might be better simply to have
mke2fs throw an error if there is an attempt to hand it a 64-bit block
number.

							- Ted
