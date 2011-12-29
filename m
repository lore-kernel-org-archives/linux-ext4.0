From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove useless functions in inode.c
Date: Wed, 28 Dec 2011 20:30:38 -0500
Message-ID: <20111229013038.GI12370@thunk.org>
References: <1322138234-3479-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41404 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab1L2Bao (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 20:30:44 -0500
Content-Disposition: inline
In-Reply-To: <1322138234-3479-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 24, 2011 at 08:37:14PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> No user uses ext4_block_truncate_page() and ext4_block_zero_page_range()
> functions. They should be removed.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied, thanks.

					- Ted
