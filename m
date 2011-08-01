From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: let ext4_init_inode_table() handle errors right
Date: Mon, 1 Aug 2011 06:33:14 -0400
Message-ID: <20110801103314.GA21388@thunk.org>
References: <1311259507-11716-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33586 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab1HAKdS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 06:33:18 -0400
Content-Disposition: inline
In-Reply-To: <1311259507-11716-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 21, 2011 at 10:45:07PM +0800, Yongqiang Yang wrote:
> This patch lets ext4_init_inode_table() handle errors right.
> ext4_init_inode_table() should down_write() alloc_sem which
> has been up_write()ed and stop the started journal handle.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>

Thanks, added to the ext4 patch tree.

						- Ted
