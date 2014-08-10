From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/21] libext2fs: strict inline data overwrite should not
 return ENOSPC
Date: Sun, 10 Aug 2014 18:27:29 -0400
Message-ID: <20140810222729.GR15431@thunk.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010536.2611.51390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53459 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaHJW1d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Aug 2014 18:27:33 -0400
Content-Disposition: inline
In-Reply-To: <20140805010536.2611.51390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2014 at 06:05:36PM -0700, Darrick J. Wong wrote:
> If we're doing a strict overwrite (same data size) of data in an
> inline data file, we should be able to skip the size check.  If the
> in-core EA representation is fine but the on-disk EA is slightly
> corrupt (this happens when fixing minor errors in an inline dir), the
> ext2fs_xattr_inode_max_size() call, which reads the disk EA, can lead
> us to think that there's no space when in reality there is no issue
> with doing a strict overwrite.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

						- Ted
