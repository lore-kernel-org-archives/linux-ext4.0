From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: fix "can't find dup_blk" error
Date: Fri, 18 Nov 2011 23:02:15 -0500
Message-ID: <20111119040215.GE4130@thunk.org>
References: <1321584758-4259-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53587 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1KSECT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Nov 2011 23:02:19 -0500
Content-Disposition: inline
In-Reply-To: <1321584758-4259-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 18, 2011 at 10:52:38AM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> After:
> 1. mke2fs -O ^has_journal,^resize_inode,^uninit_bg,extent,meta_bg,flex_bg,bigalloc /dev/sda
> 2. mount -t ext4 /dev/sda /test/
> 3. create file (8192K size, extent' e_len is 2) /test/1 ~ /test/10
> 4. use tool to change the /test/5 extent's e_len to 100, corrupt file
> 5. e2fsck -f /dev/sda

I can't replicate this.  I presume it only shows up with your
modification to the bigalloc format?

						- Ted
