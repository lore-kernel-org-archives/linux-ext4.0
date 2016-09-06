From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] ext4: reinforce check of i_dtime when clearing
 high fields of uid and gid
Date: Mon, 5 Sep 2016 23:01:27 -0400
Message-ID: <20160906030127.rdb5g4fo57izutpn@thunk.org>
References: <1471845085-9590-1-git-send-email-daeho.jeong@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Hobin Woo <hobin.woo@samsung.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46574 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752884AbcIFDCK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Sep 2016 23:02:10 -0400
Content-Disposition: inline
In-Reply-To: <1471845085-9590-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 22, 2016 at 02:51:25PM +0900, Daeho Jeong wrote:
> Now, ext4_do_update_inode() clears high 16-bit fields of uid/gid
> of deleted and evicted inode to fix up interoperability with old
> kernels. However, it checks only i_dtime of an inode to determine
> whether the inode was deleted and evicted, and this is very risky,
> because i_dtime can be used for the pointer maintaining orphan inode
> list, too. We need to further check whether the i_dtime is being
> used for the orphan inode list even if the i_dtime is not NULL.
> 
> We found that high 16-bit fields of uid/gid of inode are unintentionally
> and permanently cleared when the inode truncation is just triggered,
> but not finished, and the inode metadata, whose high uid/gid bits are
> cleared, is written on disk, and the sudden power-off follows that
> in order.
> 
> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
> Signed-off-by: Hobin Woo <hobin.woo@samsung.com>

Thanks, applied.

						- Ted
