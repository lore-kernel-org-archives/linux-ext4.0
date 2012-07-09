From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3 v3] ext4: add a new flag for ext4_map_blocks
Date: Mon, 9 Jul 2012 10:49:02 -0400
Message-ID: <20120709144902.GD3649@thunk.org>
References: <1341152506-32649-1-git-send-email-wenqing.lz@taobao.com>
 <1341152506-32649-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Tao Ma <tm@tao.ma>,
	Eric Sandeen <sandeen@redhat.com>,
	Robin Dong <hao.bigrat@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38030 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab2GIOtF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 10:49:05 -0400
Content-Disposition: inline
In-Reply-To: <1341152506-32649-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 01, 2012 at 10:21:45PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> EXT4_GET_BLOCKS_NO_LOCK flag is added to indicate that we don't need to acquire
> i_data_sem lock in ext4_map_blocks.  Meanwhile, it lets _ext4_get_block do not
> start a new journal because when we do a overwrite dio, there is no any
> metadata that needs to be modified.
> 
> We define a new function called ext4_get_block_write_nolock, which is used in
> dio overwrite nolock.  In this function, it doesn't try to acquire i_data_sem
> lock and doesn't start a new journal as it does a lookup.
> 
> CC: Tao Ma <tm@tao.ma>
> CC: Eric Sandeen <sandeen@redhat.com>
> CC: Robin Dong <hao.bigrat@gmail.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

						- Ted
