From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] mke2fs: Make s_inodes_per_group >= 8 in
 ext2fs_initialize.
Date: Sat, 14 May 2011 23:28:58 -0400
Message-ID: <20110515032858.GF21165@thunk.org>
References: <1304955522-4148-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55042 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab1EOD3D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 May 2011 23:29:03 -0400
Content-Disposition: inline
In-Reply-To: <1304955522-4148-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 09, 2011 at 11:38:42PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> current mkfs.ext4 fails if we tried with the following parameters.
> mkfs.ext4  -m 0 -N 16 -O ^has_journal,^resize_inode,^uninit_bg,extent,meta_bg -b 1024 /dev/sdb3
> It will cause segfault, but it is caused by another issue. See my patch
> "mke2fs: Avoid segmentation fault in ext2fs_alloc_generic_bmap". And
> with that patch, the mkfs.ext4 will fail with the error:
> /dev/sdb3: Memory allocation failed while setting up superblock
> 
> The reason is that in ext2fs_initialize, we align s_inodes_per_group
> to 8, but fails to consider the case that s_inodes_per_group < 8.
> So make at least 8 inodes for s_inodes_per_group.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>

Thanks, I've added this to the "next" branch of e2fsprogs.

	     	   	       	      - Ted
