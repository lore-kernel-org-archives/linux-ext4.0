From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] ext4: use stream-alloc when mb_group_prealloc set
 to zero
Date: Wed, 26 Oct 2011 05:17:10 -0400
Message-ID: <20111026091710.GS31921@thunk.org>
References: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46798 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab1JZJRN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Oct 2011 05:17:13 -0400
Content-Disposition: inline
In-Reply-To: <1316070580-10723-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 03:09:37PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> The kernel will crash on 
> 
> ext4_mb_mark_diskspace_used:
> 	BUG_ON(ac->ac_b_ex.fe_len <= 0);
> 
> after we set /sys/fs/ext4/sda/mb_group_prealloc to zero and create new files in an ext4 filesystem.
> 
> The reason is: ac_b_ex.fe_len also set to zero(mb_group_prealloc) in ext4_mb_normalize_group_request
> because the ac_flags contains EXT4_MB_HINT_GROUP_ALLOC.
> 
> I think when someone set mb_group_prealloc to zero, it means DO NOT USE GROUP PREALLOCATION,
> so we should set alloc-strategy to STREAM in this case.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Thanks, applied.

						- Ted
