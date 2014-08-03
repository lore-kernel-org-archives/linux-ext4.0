From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/19] libext2fs: Don't cache inodes that fail checksum
 verification
Date: Sat, 2 Aug 2014 22:50:33 -0400
Message-ID: <20140803025033.GJ24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181247.12496.53055.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41966 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbaHCCuf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:50:35 -0400
Content-Disposition: inline
In-Reply-To: <20140801181247.12496.53055.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:12:47AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If an inode fails checksum verification, don't stuff a copy of it in
> the inode cache, because this can cause the library to fail to return
> the "corrupt inode" error code.
> 
> In general, this happens if ext2fs_read_inode_full() is called twice
> on an inode with an incorrect checksum.  If fs->flags has
> EXT2_FLAG_IGNORE_CSUM_ERRORS set during the first call and *unset*
> during the second call, the cache hit during the second call fails to
> return EXT2_ET_INODE_CSUM_INVALID as you'd expect.  This happens
> during fsck because the first read_inode call happens as part of
> check_blocks and the second call happens during inode checksum
> revalidation.  A file system with a slightly corrupt non-extent inode
> will trigger this.
> 
> While we're at it, make the inode read function consistent with the
> rest of libext2fs -- copy the metadata object into the caller's buffer
> even if it fails checksum verification.  This will help e2fsck avoid a
> double re-read later on down the line.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
