From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2] ext4: don't remove reserved inodes in ext4_unlink()
Date: Tue, 14 Oct 2014 11:19:08 +0800
Message-ID: <20141014031907.GK13950@dhcp-13-216.nay.redhat.com>
References: <20140212163825.GE14520@thunk.org>
 <1413103858-2258-1-git-send-email-guaneryu@gmail.com>
 <20141013162100.GF9738@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33625 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaJNDTO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2014 23:19:14 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so6575561pdi.19
        for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2014 20:19:13 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20141013162100.GF9738@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2014 at 12:21:00PM -0400, Theodore Ts'o wrote:
> On Sun, Oct 12, 2014 at 04:50:58PM +0800, Eryu Guan wrote:
> > Corrupted ext4_dir_entry_2 struct on disk may have wrong inode number,
> > when the inode number is 8 (EXT4_JOURNAL_INO) and the file is deleted,
> > the journal inode is gone, and unmounting such a fs could trigger the
> > following BUG_ON() in start_this_handle()....
> > 
> 
> I believe the bug that this patch is trying to fix has been addressed
> by this commit:
> 
> http://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/commit/?h=dev&id=bf8ad98e1bffa5ce178ef5e4ea803a86ac30f9e5

Yes, this patch fixes the issue I'm seeing, thanks for pointing it out!

I have one concern thouth, removing a reserved inode (I tested
EXT4_JOURNAL_INO) on corrupted ext4 returns EIO as expect but the fs
is not marked as containing error(as other EIOs in ext4_iget()) and no
error logs in dmesg. User may have no idea what happened and the
corruped fs is still being used as normal. I think EXT4_ERROR_INODE
should be called too somewhere in such case.

Thanks,
Eryu
> 
> ext4: add ext4_iget_normal() which is to be used for dir tree lookups
> If there is a corrupted file system which has directory entries that
> point at reserved, metadata inodes, prohibit them from being used by
> treating them the same way we treat Boot Loader inodes --- that is,
> mark them to be bad inodes.  This prohibits them from being opened,
> deleted, or modified via chmod, chown, utimes, etc.
> 
> In particular, this prevents a corrupted file system which has a
> directory entry which points at the journal inode from being deleted
> and its blocks released, after which point Much Hilarity Ensues.
> 
> Reported-by: Sami Liedes <sami.liedes@iki.fi>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Cc: stable@vger.kernel.org
> 
> 					- Ted
> 
> 
