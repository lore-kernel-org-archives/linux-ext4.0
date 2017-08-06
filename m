From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4, project: expand inode extra size if possible
Date: Sun, 6 Aug 2017 01:05:33 -0400
Message-ID: <20170806050533.es7njbwt35ogt3qf@thunk.org>
References: <1499360993-17130-1-git-send-email-miaoxie@huawei.com>
 <1499360993-17130-4-git-send-email-miaoxie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, lixi@ddn.com, yi.zhang@huawei.com,
        adilger@dilger.ca, wshilong@ddn.com, sihara@ddn.com
To: Miao Xie <miaoxie@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41478 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751258AbdHFFFj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 6 Aug 2017 01:05:39 -0400
Content-Disposition: inline
In-Reply-To: <1499360993-17130-4-git-send-email-miaoxie@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 07, 2017 at 01:09:53AM +0800, Miao Xie wrote:
> when upgrading from old format, try to set project id
> to old file first time, it will return EOVERFLOW, but if
> that file is dirtied(touch etc), changing project id will
> be allowed, this might be confusing for users, we could
> try to expand @i_extra_iszie here too.
> 
> Reported-by: Zhang Yi <yi.zhang@huawei.com>
> Signed-off-by: Miao Xie <miaoxie@huawei.com>
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Thanks, applied.

				- Ted
