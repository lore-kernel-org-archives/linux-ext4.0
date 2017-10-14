From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [2/2] libext2fs: Skip start_blk adjustment when stride and
 flex_bg is set
Date: Sat, 14 Oct 2017 10:50:57 -0400
Message-ID: <20171014145057.36c5cvd2p5avfmah@thunk.org>
References: <1503581739-6385-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47344 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753763AbdJNOvA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 14 Oct 2017 10:51:00 -0400
Content-Disposition: inline
In-Reply-To: <1503581739-6385-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 24, 2017 at 03:35:39PM +0200, Lukas Czerner wrote:
> Currently some stride optimization is done in
> ext2fs_allocate_group_table() by adjusting start_blk block where we
> start allocating block, or inode bitmaps.
> 
> However in flex_bg case this is currently useless since the values are
> going to be overridden anyway. Moreover in flex_bg case the group might
> already be full and the stride optimization will fail. As a result file
> system resize might fail needlessly in some situations.
> 
> It can be shown by this example:
> 
> mke2fs -b 1024 -i 1024 -E stride=8192 -t ext4 /dev/loop0 1024000
> resize2fs /dev/loop0 102400000
> resize2fs 1.43.5 (04-Aug-2017)
> Resizing the filesystem on /dev/loop0 to 102400000 (1k) blocks.
> ./resize/resize2fs: Could not allocate block in ext2 filesystem while trying to resize /dev/loop0
> Please run 'e2fsck -fy /dev/loop0' to fix the filesystem
> after the aborted resize operation.
> 
> Fix this by not doing the stride adjustment in case of flex_bg.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
