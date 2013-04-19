From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: fix readdir error in case
 inline_data+dir_index.
Date: Fri, 19 Apr 2013 18:00:08 -0400
Message-ID: <20130419220008.GA13249@thunk.org>
References: <1365608030-3806-1-git-send-email-tm@tao.ma>
 <1365608228-3950-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, zab@redhat.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42984 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933335Ab3DSWBO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 18:01:14 -0400
Content-Disposition: inline
In-Reply-To: <1365608228-3950-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 10, 2013 at 11:37:07PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Zach reported a problem that if inline data is enabled, we don't
> tell the difference between the offset of '.' and '..'. And a
> getdents will fail if the user only want to get '.' and what's worse,
> if there is a conversion happens when the user calls getdents
> many times, he/she may get the same entry twice.
> 
> In theroy, a dir block would also fail if it is converted to a
> hashed-index based dir since f_pos will become a hash value, not the
> real one, but it doesn't happen. And a deep investigation
> shows that we uses a hash based solution even for a normal dir if
> the dir_index feature is enabled.
> 
> So this patch just adds a new htree_inlinedir_to_tree for inline dir,
> and if we find that the hash index is supported, we will do like what
> we do for a dir block.
> 
> Reported-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, applied.

					- Ted
