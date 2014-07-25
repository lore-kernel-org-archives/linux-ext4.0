From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/24] e2fsck: don't clobber critical metadata during
 check_blocks
Date: Thu, 24 Jul 2014 21:03:22 -0400
Message-ID: <20140725010322.GA1865@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225328.31374.71677.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55549 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbaGYBD1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jul 2014 21:03:27 -0400
Content-Disposition: inline
In-Reply-To: <20140718225328.31374.71677.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:53:28PM -0700, Darrick J. Wong wrote:
> If we encounter an inode with IND/DIND/TIND blocks or internal extent
> tree blocks that point into critical FS metadata such as the
> superblock, the group descriptors, the bitmaps, or the inode table,
> it's quite possible that the validation code for those blocks is not
> going to like what it finds, and it'll ask to try to fix the block.
> Unfortunately, this happens before duplicate block processing (pass
> 1b), which means that we can end up doing stupid things like writing
> extent blocks into the inode table, which multiplies e2fsck'
> destructive effect and can render a filesystem unfixable.
> 
> To solve this, create a bitmap of all the critical FS metadata.  If
> before pass1b runs (basically check_blocks) we find a metadata block
> that points into these critical regions, continue processing that
> block, but avoid making any modifications, because we could be
> misinterpreting inodes as block maps.  Pass 1b will find the
> multiply-owned blocks and fix that situation, which means that we can
> then restart e2fsck from the beginning and actually fix whatever
> problems we find.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
