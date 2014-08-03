From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/19] e2fsck: offer to clear inode table blocks that are
 insane
Date: Sat, 2 Aug 2014 22:46:54 -0400
Message-ID: <20140803024653.GH24826@thunk.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
 <20140801181234.12496.95546.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@orale.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41954 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbaHCCq7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Aug 2014 22:46:59 -0400
Content-Disposition: inline
In-Reply-To: <20140801181234.12496.95546.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 11:12:34AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new behavior flag to the inode scan functions; when specified,
> this flag will do some simple sanity checking of entire inode table
> blocks.  If all the checksums are ok, we can skip checksum
> verification on individual inodes later on.  If more than half of the
> inodes look "insane" (bad extent tree root or checksum failure) then
> ext2fs_get_next_inode_full() can return a special status code
> indicating that what's in the buffer is probably garbage.
> 
> When e2fsck' inode scan encounters the 'inode is garbage' return code
> it'll offer to zap the inode straightaway instead of trying to recover
> anything.  This replaces the previous behavior of asking to zap
> anything with a checksum error (strict_csum).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@orale.com>

Applied, thanks!!

					- Ted
