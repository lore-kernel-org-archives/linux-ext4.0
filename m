From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: do not reference pa_inode from group_pa
Date: Sun, 18 Dec 2011 16:09:51 -0500
Message-ID: <20111218210951.GA9922@thunk.org>
References: <1324180146-10036-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53755 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1LRVJy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 16:09:54 -0500
Content-Disposition: inline
In-Reply-To: <1324180146-10036-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 18, 2011 at 11:49:06AM +0800, Yongqiang Yang wrote:
> pa_inode in group_pa is set NULL in ext4_mb_new_group_pa, so
> pa_inode should be not referenced.
> 
> Reported-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, applied.

					- Ted
