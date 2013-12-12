From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 34/74] e2fsck: in rehash, mark newly allocated extent
 blocks as found
Date: Thu, 12 Dec 2013 13:27:33 -0500
Message-ID: <20131212182733.GE13547@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012207.30655.92282.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39459 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab3LLS1h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Dec 2013 13:27:37 -0500
Content-Disposition: inline
In-Reply-To: <20131211012207.30655.92282.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:22:07PM -0800, Darrick J. Wong wrote:
> When we're rehashing directories, it's possible that an extent block
> (or a map block) could be (silently) allocated by the underlying
> libext2fs when expanding the directory.  This silent allocation is not
> captured in block_found_map, which is disastrous if later the rehash
> process expands another directory and uses that same block from
> before without realizing that it's now in use.
> 
> Therefore, if we notice that the free block count has dropped by more
> than what e2fsck allocated itself during the expansion, we iterate the
> directory's blocks a second time to ensure that these silent
> allocations are marked in the found blocks bitmap.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
