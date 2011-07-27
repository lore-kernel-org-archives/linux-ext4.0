From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 08/11] ext4: simplify journal handling in
 setup_new_group_blocks()
Date: Tue, 26 Jul 2011 22:23:22 -0400
Message-ID: <20110727022322.GJ19851@thunk.org>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
 <1311048137-16400-9-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, adilger@dilger.ca, amir73il@gmail.com,
	tm@tao.ma
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43328 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782Ab1G0CXZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 22:23:25 -0400
Content-Disposition: inline
In-Reply-To: <1311048137-16400-9-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 19, 2011 at 12:02:14PM +0800, Yongqiang Yang wrote:
> This patch simplifies journal handling in setup_new_group_blocks().
> 
> In previous code, block bitmap is modified everywhere in
> setup_new_group_blocks(), ext4_get_write_access() in
> extend_or_restart_transaction() is used to guarantee that the block bitmap
> stays in the new handle, this makes things complicated.
> 
> In this patch the modifications on the block bitmap are batched and done
> by ext4_set_bits() after reqesting a handle from extend_or_restart_transaction()
> with enough credits.  So ext4_get_write_access() can be removed from
> extend_or_restart_transaction().
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Applied, thanks.

						- Ted
