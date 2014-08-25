From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 03/27] libext2fs: byteswap inode when performing the
 sanity scan
Date: Sun, 24 Aug 2014 22:01:16 -0400
Message-ID: <20140825020116.GJ6236@thunk.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
 <20140816234610.11171.63032.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47173 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbaHYCBU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Aug 2014 22:01:20 -0400
Content-Disposition: inline
In-Reply-To: <20140816234610.11171.63032.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 16, 2014 at 04:46:10PM -0700, Darrick J. Wong wrote:
> On BE platforms, we need to swap the inode bytes after doing the
> checksum verification but before looking at i_blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
