From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [e2fsprogs PATCH] libsupport: fix error handling in
 quota_write_inode
Date: Mon, 24 Jul 2017 15:17:22 -0400
Message-ID: <20170724191722.lhlikwpuzt3te6mf@thunk.org>
References: <1500879686-741-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        miaoxie@huawei.com
To: "zhangyi (F)" <yi.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55486 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756844AbdGXTRZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Jul 2017 15:17:25 -0400
Content-Disposition: inline
In-Reply-To: <1500879686-741-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 24, 2017 at 03:01:26PM +0800, zhangyi (F) wrote:
> The error return value of quota_file_create() is no longer < 0,
> and the error handling in quota_write_inode() is incorrect,
> fix these. This also fix a tune2fs segfault that currently
> occurs when we add project and quota features to an inode
> exhaustion ext4 filesystem.
> 
> Fixes: a701823a3150("libsupport: fix gcc -Wall nits")
> 
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

Applied, thanks!

					- Ted
