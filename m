From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] ext4: remove 'error' variable in
 ext4_xattr_check_block()
Date: Mon, 13 Feb 2012 18:04:08 -0500
Message-ID: <20120213230408.GG21641@thunk.org>
References: <1320672724-4432-1-git-send-email-wenqing.lz@taobao.com>
 <1320672724-4432-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56826 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab2BMXEL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 18:04:11 -0500
Content-Disposition: inline
In-Reply-To: <1320672724-4432-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 07, 2011 at 09:32:02PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> We could return directly from ext4_xattr_check_block(). Thus, we shouldn't
> need to define a 'error' variable.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
