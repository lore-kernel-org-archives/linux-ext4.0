Return-Path: <SRS0=d5+7=MT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44216 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbeJGKmz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 7 Oct 2018 06:42:55 -0400
Date: Sat, 6 Oct 2018 23:36:45 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: cgxu519 <cgxu519@gmx.com>
Cc: adilger.kernel@dilger.ca, jack@suse.com, jaegeuk@kernel.org,
        yuchao0@huawei.com, shaggy@kernel.org, hubcap@omnibond.com,
        martin@omnibond.com, devel@lists.orangefs.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        jfs-discussion@lists.sourceforge.net
Subject: Re: [PATCH v2 2/5] ext4: cache NULL when both default_acl and acl
 are NULL
Message-ID: <20181007033645.GA12046@thunk.org>
References: <20180831143352.22970-1-cgxu519@gmx.com>
 <20180831143352.22970-2-cgxu519@gmx.com>
 <f1dd02a3-78ea-0240-72cc-135ee26f6524@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1dd02a3-78ea-0240-72cc-135ee26f6524@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 12, 2018 at 11:04:35PM +0800, cgxu519 wrote:
> On 08/31/2018 10:33 PM, Chengguang Xu wrote:
> > default_acl and acl of newly created inode will be initiated
> > as ACL_NOT_CACHED in vfs function inode_init_always() and later
> > will be updated by calling xxx_init_acl() in specific filesystems.
> > Howerver, when default_acl and acl are NULL then they keep the value
> > of ACL_NOT_CACHED, this patch tries to cache NULL for acl/default_acl
> > in this case.
> > 
> > Signed-off-by: Chengguang Xu <cgxu519@gmx.com>

Applied, thanks.

						- Ted
