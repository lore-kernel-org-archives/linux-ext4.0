From: Zach Brown <zab@redhat.com>
Subject: Re: [PATCH] ext4: Prevent race while waling extent tree
Date: Thu, 8 Nov 2012 13:52:33 -0800
Message-ID: <20121108215233.GB1282@lenny.home.zabbo.net>
References: <1352372929-18513-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757166Ab2KHVwg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 16:52:36 -0500
Content-Disposition: inline
In-Reply-To: <1352372929-18513-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 08, 2012 at 12:08:49PM +0100, Lukas Czerner wrote:
> +		down_read(&EXT4_I(inode)->i_data_sem);
>  		error = ext4_ext_walk_space(inode, start_blk, len_blks,
>  					  ext4_ext_fiemap_cb, fieinfo);
> +		up_read(&EXT4_I(inode)->i_data_sem);

Can this deadlock?  ext4_ext_fiemap_cb() seems to be doing all kinds of
exciting things that might also try and acquire the i_data_sem, like
GFP_KERNEL allocs (reclaim -> writepage) and copying to userspace (mmap
fault -> readpage -> get blocks).

It seems like the safer fix is to broaden the sampling lock coverage to
include referencing all the extent data but to release it around the
callback.

No?

- z
