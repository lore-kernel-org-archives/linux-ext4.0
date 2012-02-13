From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: remove unnecessary assignments in xattr.c
Date: Mon, 13 Feb 2012 18:21:04 -0500
Message-ID: <20120213232104.GH21641@thunk.org>
References: <1320672724-4432-1-git-send-email-wenqing.lz@taobao.com>
 <1320672724-4432-3-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57470 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab2BMXVK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Feb 2012 18:21:10 -0500
Content-Disposition: inline
In-Reply-To: <1320672724-4432-3-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 07, 2011 at 09:32:03PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> In some functions, 'error' variable is assigned but not used when the result
> of if statement is false.
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

I really wouldn't worry about this.  It increases the size of both the
source and the binary, and if there are architectures where registers
are especially precious, it's easy enough for the compiler to optimize
appropriately.

					- Ted
