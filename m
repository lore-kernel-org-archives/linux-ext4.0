From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix resize when resizing within single group
Date: Mon, 20 Feb 2012 23:03:28 -0500
Message-ID: <20120221040328.GF25249@thunk.org>
References: <1328173555-26452-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Milan Broz <mbroz@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37458 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514Ab2BUEDa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 23:03:30 -0500
Content-Disposition: inline
In-Reply-To: <1328173555-26452-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 02, 2012 at 10:05:55AM +0100, Lukas Czerner wrote:
> When resizing file system in the way that the new size of the file
> system is still in the same group (no new groups are added), then we can
> hit a BUG_ON in ext4_alloc_group_tables()
> 
> BUG_ON(flex_gd->count == 0 || group_data == NULL);
> 
> because flex_gd->count is zero. The reason is the missing check for such
> case, so the code always extend the last group fully and then attempt to
> add more groups, but at that time n_blocks_count is actually smaller
> than o_blocks_count.
> 
> It can be easily reproduced like this:
> 
> mkfs.ext4 -b 4096 /dev/sda 30M
> mount /dev/sda /mnt/test
> resize2fs /dev/sda 50M
> 
> Fix this by checking whether the resize happens within the singe group
> and only add that many blocks into the last group to satisfy user
> request. Then o_blocks_count == n_blocks_count and the resize will exit
> successfully without and attempt to add more groups into the fs.
> 
> Also fix mixing together block number and blocks count which might be
> confusing and can easily lead to off-by-one errors (but it is actually
> not the case here since the two occurrence of this mix-up will cancel
> each other).
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Milan Broz <mbroz@redhat.com>

Thanks, applied.

						- Ted
