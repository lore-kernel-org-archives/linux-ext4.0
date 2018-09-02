From: Chao Yu <chao@kernel.org>
Subject: Re: [f2fs-dev] [PATCH v2 3/5] f2fs: cache NULL when both default_acl
 and acl are NULL
Date: Sun, 2 Sep 2018 15:55:52 +0800
Message-ID: <900e5d34-f95a-279d-2d1b-bd8333be7f55@kernel.org>
References: <20180831143352.22970-1-cgxu519@gmx.com>
 <20180831143352.22970-3-cgxu519@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        devel@lists.orangefs.org
To: Chengguang Xu <cgxu519@gmx.com>, jack@suse.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jaegeuk@kernel.org, yuchao0@huawei.com,
        shaggy@kernel.org, hubcap@omnibond.com, martin@omnibond.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180831143352.22970-3-cgxu519@gmx.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2018/8/31 22:33, Chengguang Xu wrote:
> default_acl and acl of newly created inode will be initiated
> as ACL_NOT_CACHED in vfs function inode_init_always() and later
> will be updated by calling xxx_init_acl() in specific filesystems.
> Howerver, when default_acl and acl are NULL then they keep the value
> of ACL_NOT_CACHED, this patch tries to cache NULL for acl/default_acl
> in this case.
> 
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Acked-by: Chao Yu <yuchao0@huawei.com>

Thanks,
