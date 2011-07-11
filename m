From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: avoid finding next leaf if newext->ee_block
 smaller than fex->ee_block
Date: Mon, 11 Jul 2011 13:07:18 -0400
Message-ID: <20110711170718.GM28763@thunk.org>
References: <1309421014-6148-1-git-send-email-sanbai@taobao.com>
 <1309421014-6148-2-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54510 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967Ab1GKRHW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jul 2011 13:07:22 -0400
Content-Disposition: inline
In-Reply-To: <1309421014-6148-2-git-send-email-sanbai@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 30, 2011 at 04:03:34PM +0800, Robin Dong wrote:
> If newext->ee_block is smaller than (or equal to) fex->ee_block, the call of
> ext4_ext_next_leaf_block will be useless. We need to call it only after
> newext->ee_block is greater than fex->ee_block.
> 
> Signed-off-by: Robin Dong <sanbai@taobao.com>

Added to the ext4 tree, but I cleaned up the one-line summary of the
patch:

    ext4: remove redundant goto in ext4_ext_insert_extent()

It's important that the one-line summary be much more "big picture" so
that people who are looking through the git history can understand
what the commit does.  Also, I added an explicit

From: Robin Dong <sanbai@taobao.com>

.... so that the attribution was the same as what was in your
Signed-off-by (instead of your hao.bigrat address).  If that wasn't
your intent, let me know and I'll fix it before I lock it into the
master branch.

In the future, if you are sending the patch from a different e-mail
address, it would be useful if you explicitly add a "From: " line in
the body so it's clear.  I made the assumption in this case based on
the general practice of other taobao engineers, but as I said, let me
know if you would want something else.

Thanks!!

							- Ted
