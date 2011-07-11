From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix a double free of sbi->s_group_info in
 ext4_mb_init_backend
Date: Mon, 11 Jul 2011 18:44:08 -0400
Message-ID: <20110711224408.GT28763@thunk.org>
References: <1310398016-8104-1-git-send-email-tm@tao.ma>
 <1310398016-8104-2-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56664 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab1GKWoM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 18:44:12 -0400
Content-Disposition: inline
In-Reply-To: <1310398016-8104-2-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 11, 2011 at 11:26:56PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> If we meet with an error in ext4_mb_add_groupinfo, we kfree
> sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)], but fail to
> reset it to NULL. So the caller ext4_mb_init_backend will try to kfree
> it again and causes a double free. So fix it by resetting it to NULL.
> 
> Some typo in comments of mballoc.c are also changed.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Added to the ext4 tree, thanks.

						- Ted
