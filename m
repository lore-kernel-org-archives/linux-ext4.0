From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: avoid unneeded lookup when xattr name is invalid
Date: Mon, 12 May 2014 10:00:44 -0400
Message-ID: <20140512140044.GC31376@thunk.org>
References: <1397199813-71623-1-git-send-email-zhenzhang.zhang@huawei.com>
 <5347967B.5090401@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34613 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaELOBf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2014 10:01:35 -0400
Content-Disposition: inline
In-Reply-To: <5347967B.5090401@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 11, 2014 at 03:15:07PM +0800, Zhang Zhen wrote:
> In ext4_xattr_set_handle() we have checked the xattr name's length. So we should
> also check it in ext4_xattr_get() to avoid unneeded lookup caused by invalid name.
> 
> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>

Applied, although I dropped this bit:

> In addition, we deleted the check of NULL in ext4_xattr_set_handle(), because in all
> the callers of the ext4_xattr_set_handle(), the name can't be NULL.

Verifying this is non-trivial, since there are many non-local
users of this function, and in order to make sure this is true you
need to verify (at least) the callers of the callers.  I could be
convinced to turn this into a BUG_ON(!name), or "if
(unlikely(!name))", but leaving the check in is a good idea, since
even if it is true today, it's not necessarily guarantted to be true N
years in the future.

					- Ted
