From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add action of moving index in ext4_ext_rm_idx
 for Punch Hole
Date: Wed, 27 Jul 2011 21:33:04 -0400
Message-ID: <20110728013304.GC3133@thunk.org>
References: <1311665699-22023-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37401 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473Ab1G1BdJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2011 21:33:09 -0400
Content-Disposition: inline
In-Reply-To: <1311665699-22023-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 26, 2011 at 03:34:59PM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> The old function ext4_ext_rm_idx is used only for truncate case because
> it just remove last index in extent-index-block. When punching hole,
> it usually needed to remove "middle" index, therefore we must move indexes
> which after it forward.
> 
> (I create a file with 1 depth extent tree and punch hole in the middle of it,
> the last index in index-block strangly gone, so I find out this bug)
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Thanks, added to the ext4 tree.

					- Ted
