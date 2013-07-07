From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: disable resize_inode feature if 64bit feature is
 enabled
Date: Sun, 7 Jul 2013 11:41:40 -0400
Message-ID: <20130707154140.GA11993@thunk.org>
References: <1372928710-10461-1-git-send-email-guaneryu@gmail.com>
 <20130705012128.GA11793@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Eryu Guan <guaneryu@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35671 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab3GGPln (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Jul 2013 11:41:43 -0400
Content-Disposition: inline
In-Reply-To: <20130705012128.GA11793@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 05, 2013 at 09:21:28AM +0800, Zheng Liu wrote:
> Do we really need to check it?  My point is that we just clear
> RESIZE_INODE flag if 64BIT flag is enabled.

It's better to use the resize_inode for file systems that are smaller
than 16TB, even if the 64-bit flag is enabled, since using the meta_bg
style resizing spreads out the block group descriptors, which
increases the time to mount the file system.  Using the resize_inode
will defer the need to go to the meta_bg-style resizing until we cross
the 16TB boundary.

Cheers,

						- Ted
