From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/4] ext4: cleanup ext4_expand_extra_isize_ea()
Date: Sun, 6 Aug 2017 00:56:15 -0400
Message-ID: <20170806045615.laspqgjfthvpjzqm@thunk.org>
References: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
 <1499360993-17130-3-git-send-email-miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lixi@ddn.com, yi.zhang@huawei.com,
        adilger@dilger.ca, wshilong@ddn.com, sihara@ddn.com
To: Miao Xie <miaoxie@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41460 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbdHFE4U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Aug 2017 00:56:20 -0400
Content-Disposition: inline
In-Reply-To: <1499360993-17130-3-git-send-email-miaoxie@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 07, 2017 at 01:09:52AM +0800, Miao Xie wrote:
> Clean up some goto statement, make ext4_expand_extra_isize_ea() clearer.
> 
> Signed-off-by: Miao Xie <miaoxie@huawei.com>
> Reviewed-by: Wang Shilong <wshilong@ddn.com>

Thanks, applied.

				- Ted
