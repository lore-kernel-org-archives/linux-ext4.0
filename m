From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/24] debugfs: allow bmap to allocate blocks
Date: Tue, 22 Jul 2014 13:52:04 -0400
Message-ID: <20140722175203.GI25291@thunk.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225243.31374.87869.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50680 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbaGVUkE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:40:04 -0400
Content-Disposition: inline
In-Reply-To: <20140718225243.31374.87869.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2014 at 03:52:43PM -0700, Darrick J. Wong wrote:
> Allow set_inode_field's bmap command in debugfs to allocate blocks,
> which enables us to allocate blocks for indirect blocks and internal
> extent tree blocks.  True, we could do this manually, but seems like
> unnecessary bookkeeping activity for humans.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
