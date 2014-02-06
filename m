From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: Disallow tune2fs enabling sparse_super with
 ext4 meta_bg enabled
Date: Thu, 6 Feb 2014 15:15:02 -0500
Message-ID: <20140206201502.GJ19884@thunk.org>
References: <28989C0C9F1C0A428470D967B5FCED3727189D@BPXM22GP.gisp.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54899 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbaBFUPW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Feb 2014 15:15:22 -0500
Content-Disposition: inline
In-Reply-To: <28989C0C9F1C0A428470D967B5FCED3727189D@BPXM22GP.gisp.nec.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 24, 2014 at 02:55:57AM +0000, Akira Fujita wrote:
> When meta_bg feature is enabled, group descriptor block is allocated
> every 128 block group (or every 64 block group if 64bit feature is enabled).
> 
> In such situation, files in block group more than #128 will be removed
> if sparse_super feature is enabled with tune2fs and
> afterwards necessary e2fsck running.
> 
> Because tune2fs does not reallocate group descriptor blocks
> but just set sparse_super feature.
> If ext4 has sparse_super, ext2fs_descriptor_block_loc2() called
> by e2fsck thinks the block group (e.g. #128) that it has group descriptor block
> at the head offset. But that offset is used as backup super block before.
> So e2fsck fixes ext4 based on invalid group descriptor blocks and this
> cause data lost.
> 
> The patch avoids this problem simply by disallow tune2fs enabling
> sparse_super if meta_bg is enabled.
> 
> Steps to reproduce:
> 
> 1. Create ext4 which has meta_bg, ^sparse_super and 129+ block groups.
> # mke2fs -t ext4 -O meta_bg,^resize_inode,^sparse_super DEV 17G
> # mount DEV /MP
> 
> 2. Create direcotry and files which use block group #128's metadata.
> # echo $((8192*128+1)) > /sys/fs/ext4/DEV/inode_goal
> # mkdir /MP/DIR
> # for i in $(seq 1 100); do dd if=/dev/urandom of=/MP/DIR/file$i bs=1024 count=10; done
> 
> 3. Enable sparse_super with tune2fs then execute e2fsck.
>    Data in block group #128 will be lost!!
> # umount DEV
> # tune2fs -O sparse_super DEV
> # e2fsck/e2fsck -yf DEV
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.ne.cocm>

Applied, thanks.

						- Ted
