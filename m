From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 2/3] e2fsprogs/tune2fs: rewrite metadata checksums
 when resizing inode size
Date: Tue, 2 Dec 2014 22:30:28 -0500
Message-ID: <20141203033028.GP13618@thunk.org>
References: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36063 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaLCDac (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 22:30:32 -0500
Content-Disposition: inline
In-Reply-To: <1415956537-11212-2-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2014 at 05:15:36PM +0800, Xiaoguang Wang wrote:
> When we use tune2fs -I new_ino_size to change inode size, if everything is OK,
> the corresponding ext4_group_desc.bg_free_blocks_count will be decreased, so
> obviously, we need to re-compute the group descriptor checksums, and the inode
> 's size has also changed, we also need to recompute the checksums of inodes for
> metadata_csum filesystem, so here we choose to call a rewrite_metadata_checksums(),
> this will fix checksum issues.
> 
> Meanwhile, the patch will trigger an existing memory write overflow, which will
> casue segfault, please see the next patch.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
