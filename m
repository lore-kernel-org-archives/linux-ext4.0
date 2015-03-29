From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 22/54] libext2fs: ext2fs_new_block2() should call
 alloc_block hook
Date: Sat, 28 Mar 2015 23:08:42 -0400
Message-ID: <20150329030842.GC19097@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073757.13308.47791.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38550 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbbC2DIo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Mar 2015 23:08:44 -0400
Content-Disposition: inline
In-Reply-To: <20150127073757.13308.47791.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:37:57PM -0800, Darrick J. Wong wrote:
> If ext2fs_new_block2() is called without a specific block map, we
> should call the alloc_block hook before checking fs->block_map.  This
> helps us to avoid a bug in e2fsck where we need to allocate a block
> but instead of consulting block_found_map, we use the FS bitmaps,
> which (prior to pass 5) could be wrong.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
