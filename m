From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: fix ext4_debug format
Date: Wed, 28 Dec 2011 19:01:45 -0500
Message-ID: <20111229000145.GG12370@thunk.org>
References: <CAGBYx2YchtAbkc1b_V2AdEHb=_9sRLKU8W+hjFuTH8VNh1-FHw@mail.gmail.com>
 <1321525196-16009-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xiaoqiangnk@gmail.com, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52253 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab1L2ABv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Dec 2011 19:01:51 -0500
Content-Disposition: inline
In-Reply-To: <1321525196-16009-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 17, 2011 at 06:19:56PM +0800, Zheng Liu wrote:
> v1->v2:
>  * format flags by %x instead of %d for more readable
> 
> Fix ext4_debug format in ext4_ext_handle_uninitialized_extents() and
> ext4_end_io_dio().
> 
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>

Applied with the patch summary: "ext4: add missing spaces to debugging
printk's".

					- Ted
