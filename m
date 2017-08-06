From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/4] ext4: restructure ext4_expand_extra_isize
Date: Sun, 6 Aug 2017 00:47:59 -0400
Message-ID: <20170806044759.h2jm3nhxv6gqemuy@thunk.org>
References: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
 <1499360993-17130-2-git-send-email-miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lixi@ddn.com, yi.zhang@huawei.com,
        adilger@dilger.ca, wshilong@ddn.com, sihara@ddn.com
To: Miao Xie <miaoxie@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41434 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbdHFEsE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Aug 2017 00:48:04 -0400
Content-Disposition: inline
In-Reply-To: <1499360993-17130-2-git-send-email-miaoxie@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 07, 2017 at 01:09:51AM +0800, Miao Xie wrote:
> Current ext4_expand_extra_isize just tries to expand extra isize, if
> someone is holding xattr lock or some check fails, it will give up.
> So rename its name to ext4_try_to_expand_extra_isize.
> 
> Besides that, we clean up unnecessary check and move some relative checks
> into it.
> 
> Signed-off-by: Miao Xie <miaoxie@huawei.com>
> Reviewed-by: Wang Shilong <wshilong@ddn.com>

Thanks, applied.

					- Ted
