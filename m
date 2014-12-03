From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 1/3] e2fsprogs/tune2fs: fix memory leak in
 inode_scan_and_fix()
Date: Tue, 2 Dec 2014 21:07:08 -0500
Message-ID: <20141203020708.GL13618@thunk.org>
References: <1415785780-3832-3-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <1415956537-11212-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com
To: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35923 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbaLCCHN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Dec 2014 21:07:13 -0500
Content-Disposition: inline
In-Reply-To: <1415956537-11212-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 14, 2014 at 05:15:35PM +0800, Xiaoguang Wang wrote:
> When we use ext2fs_open_inode_scan() to iterate inodes and finish
> jobs, we also need a ext2fs_close_inode_scan(scan) operation, but in
> inode_scan_and_fix(), we forgot to call it, fix this error.
> 
> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
