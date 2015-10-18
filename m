From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fix calculation of meta_bg descriptor backups
Date: Sun, 18 Oct 2015 00:37:29 -0400
Message-ID: <20151018043729.GL2678@thunk.org>
References: <1444060102-8296-1-git-send-email-andy@leiserson.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andy Leiserson <andy@leiserson.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57139 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbbJREhc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Oct 2015 00:37:32 -0400
Content-Disposition: inline
In-Reply-To: <1444060102-8296-1-git-send-email-andy@leiserson.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 05, 2015 at 08:48:22AM -0700, Andy Leiserson wrote:
> "group" is the group where the backup will be placed, and is initialized
> to zero in the declaration. This meant that backups for meta_bg
> descriptors were erroneously written to group 1 and group
> (desc_per_block-1).
> 
> Signed-off-by: Andy Leiserson <andy@leiserson.org>

Nice catch!  I added to the commit description the following
reproduction information:

  mke2fs -Fq -t ext4 -b 1024 -O ^resize_inode /tmp/foo.img 16G
  truncate -s 24G /tmp/foo.img
  losetup /dev/loop0 /tmp/foo.img
  mount /dev/loop0 /mnt
  resize2fs /dev/loop0
  umount /dev/loop0
  dd if=/dev/zero of=/dev/loop0 bs=1024 count=2
  e2fsck -fy /dev/loop0
  losetup -d /dev/loop0
		  
Cheers,

					- Ted
