From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/37] resize2fs: fix check for collision between old GDT
 and superblock on sparse_super2 fs
Date: Sun, 11 May 2014 23:35:23 -0400
Message-ID: <20140512033523.GK5480@thunk.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
 <20140501231308.31890.72322.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33830 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaELDfZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 May 2014 23:35:25 -0400
Content-Disposition: inline
In-Reply-To: <20140501231308.31890.72322.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 01, 2014 at 04:13:08PM -0700, Darrick J. Wong wrote:
> In reserve_sparse_super2_last_group, the old_desc check should only be
> performed if ext2fs_super_and_bgd_loc2() gave us a location -- a
> return value of 0 means that there is no old-style GDT block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
