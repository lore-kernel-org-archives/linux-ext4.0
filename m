From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 43/74] libext2fs: don't update the summary counts when
 doing implied cluster allocation
Date: Sun, 15 Dec 2013 23:53:11 -0500
Message-ID: <20131216045311.GF28536@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012306.30655.51172.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40366 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab3LPExN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Dec 2013 23:53:13 -0500
Content-Disposition: inline
In-Reply-To: <20131211012306.30655.51172.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:23:06PM -0800, Darrick J. Wong wrote:
> When we're appending a block to a directory file or the journal file,
> and the new block is part of a cluster that has already been allocated
> to the file (implied cluster allocation), don't update the bitmap or
> the summary counts because that was performed when the cluster was
> allocated.
> 
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
