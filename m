From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: check return value of kstrtoull correctly in
 reserved_clusters_store
Date: Fri, 23 Jun 2017 01:09:39 -0400
Message-ID: <20170623050937.v2c44cyp3i7mtpnv@thunk.org>
References: <20170615095730.36627-1-yuchao0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, chao@kernel.org,
        Miao Xie <miaoxie@huawei.com>
To: Chao Yu <yuchao0@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34888 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754504AbdFWFJu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Jun 2017 01:09:50 -0400
Content-Disposition: inline
In-Reply-To: <20170615095730.36627-1-yuchao0@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 15, 2017 at 05:57:30PM +0800, Chao Yu wrote:
> kstrtoull returns 0 on success, however, in reserved_clusters_store we
> will return -EINVAL if kstrtoull returns 0, it makes us fail to update
> reserved_clusters value through sysfs.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Miao Xie <miaoxie@huawei.com>

Thanks, applied.

					- Ted
