From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: remove unused argument in
 ext4_ext_next_leaf_block
Date: Sat, 23 Jul 2011 21:55:02 -0400
Message-ID: <20110724015502.GE3469@thunk.org>
References: <1311301421-10533-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45893 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1GXBzF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Jul 2011 21:55:05 -0400
Content-Disposition: inline
In-Reply-To: <1311301421-10533-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 22, 2011 at 10:23:39AM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> The argument "inode" in function ext4_ext_next_allocated_block looks useless,
> so clean it.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Thanks, added to the ext4 tree.

					- Ted
