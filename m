From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix readdir error in case
 inline_data+^dir_index.
Date: Fri, 19 Apr 2013 18:00:18 -0400
Message-ID: <20130419220018.GB13249@thunk.org>
References: <1365608030-3806-1-git-send-email-tm@tao.ma>
 <1365608228-3950-1-git-send-email-tm@tao.ma>
 <1365608228-3950-2-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, zab@redhat.com
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42987 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933335Ab3DSWBU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Apr 2013 18:01:20 -0400
Content-Disposition: inline
In-Reply-To: <1365608228-3950-2-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 10, 2013 at 11:37:08PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> Zach reported a problem that if inline data is enabled, we don't
> tell the difference between the offset of '.' and '..'. And a
> getdents will fail if the user only want to get '.'. And what's
> worse, we may meet with duplicate dir entries as the offset
> for inline dir and non-inline one is quite different.
> 
> This patch just try to resolve this problem if dir_index
> is disabled. In this case, f_pos is the real offset with
> the dir block, so for inline dir, we just pretend as if
> we are a dir block and returns the offset like a norml
> dir block does.
> 
> Reported-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, applied.

					- Ted
