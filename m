From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: fix forgetten xattr lock protection in
 ext4_expand_extra_isize
Date: Sun, 6 Aug 2017 00:28:22 -0400
Message-ID: <20170806042822.4qu56ztznvw73mqw@thunk.org>
References: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lixi@ddn.com, yi.zhang@huawei.com,
        adilger@dilger.ca, wshilong@ddn.com, sihara@ddn.com
To: Miao Xie <miaoxie@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41404 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751223AbdHFE21 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Aug 2017 00:28:27 -0400
Content-Disposition: inline
In-Reply-To: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 07, 2017 at 01:09:50AM +0800, Miao Xie wrote:
> We should avoid the contention between the i_extra_isize update and
> the inline data insertion, so move the xattr trylock in front of
> i_extra_isize update.
> 
> Signed-off-by: Miao Xie <miaoxie@huawei.com>
> Reviewed-by: Wang Shilong <wshilong@ddn.com>

Thanks, applied.

					- Ted
