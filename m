From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] e2fsprogs: add a function computing old desc
 blocks without reserved ones
Date: Mon, 23 Jan 2012 11:45:27 -0500
Message-ID: <20120123164527.GA4439@thunk.org>
References: <1325674932-26069-1-git-send-email-xiaoqiangnk@gmail.com>
 <1325674932-26069-3-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34114 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2AWSJ4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jan 2012 13:09:56 -0500
Content-Disposition: inline
In-Reply-To: <1325674932-26069-3-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 04, 2012 at 07:02:12PM +0800, Yongqiang Yang wrote:
> If first_meta_bg > desc_blocks, ext2fs_open reads more decs_blocks,
> however desc buffer in memory is allocated based on desc_blocks.
> Maybe there are similar problems in other places, so this patch adds a
> function which computes right old_desc_blocks.
> 
> The problem can be reproduced by setting first_meta_bg.

s_first_meta_bg should never be greater than desc_blocks.  If it is,
the file system is corrupt.  This is something that we should check in
ext2fs_open() and in e2fsck as well.

A much better thing to do would be to have ext2fs_open simply fail the
open with an EXT2_ET_CORRUPT_SUPERBLOCK error.  Then e2fsck will
automatically try using the backup superblock, which will hopefully
allow the user to recover from the corrupted superblock.

      	       	  	       	   	     - Ted
