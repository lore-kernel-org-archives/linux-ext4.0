From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] resize2fs: exit fix_sb_journal_backup early for
	external journal
Date: Thu, 12 Nov 2009 19:47:29 -0500
Message-ID: <20091113004729.GC32122@mit.edu>
References: <4AF88220.90908@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	mjevans1983@gmail.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34213 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbZKMC3q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Nov 2009 21:29:46 -0500
Content-Disposition: inline
In-Reply-To: <4AF88220.90908@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 09, 2009 at 02:57:04PM -0600, Eric Sandeen wrote:
> Resizing a filesystem with an external journal fails when it tries
> to read inode 0:
> 
> # touch testfs
> # truncate testfs 1342177280
> # touch testjournal
> # truncate testjournal 134217728
> # mke2fs -O journal_dev testjournal 
> # losetup /dev/loop0 testjournal 
> # mkfs.ext4 -J device=/dev/loop0 testfs 127680
> # resize2fs testfs 
> resize2fs 1.41.9 (22-Aug-2009)
> Resizing the filesystem on testfs to 327680 (4k) blocks.
> resize2fs: Illegal inode number while trying to resize testfs
> Please run 'e2fsck -fy testfs' to fix the filesystem
> after the aborted resize operation.
> 
> I think the right, simple thing to do is just bail out early
> for an external journal here, as there are no backup blocks
> to update.
> 
> Reported-by: mjevans1983@gmail.com
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied to the e2fsprogs maint branch.

					- Ted
