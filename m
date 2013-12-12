From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 31/74] libext2fs: fail fileio write if we can't allocate
 a block
Date: Thu, 12 Dec 2013 13:23:08 -0500
Message-ID: <20131212182308.GB13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012147.30655.98480.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39450 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab3LLSXL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 13:23:11 -0500
Content-Disposition: inline
In-Reply-To: <20131211012147.30655.98480.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:21:47PM -0800, Darrick J. Wong wrote:
> If we're using ext2fs_file_write() to write to a hole in a file,
> ensure that we can actually allocate the block before updating i_size.
> In other words, don't update i_size and don't return success if we hit
> an error while allocating space.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
