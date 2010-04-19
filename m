From: Jan Kara <jack@suse.cz>
Subject: Re: busy inodes -> ext3 umount crash
Date: Mon, 19 Apr 2010 16:11:58 +0200
Message-ID: <20100419141158.GB5439@quack.suse.cz>
References: <4BC8A7C1.20102@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>, adilger@sun.com,
	linux-ext4@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, mszeredi@suse.cz
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37073 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243Ab0DSOLz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 10:11:55 -0400
Content-Disposition: inline
In-Reply-To: <4BC8A7C1.20102@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

On Fri 16-04-10 20:09:05, Jiri Slaby wrote:
> with mmotm 2010-04-05-16-09 and much older (I hadn't camera to take a
> picture) I sometimes get a BUG() trace in ext3 umount code:
> http://www.fi.muni.cz/~xslaby/sklad/panics/ext3_1.png
> http://www.fi.muni.cz/~xslaby/sklad/panics/ext3_2.png
  I see several "Busy inodes on umount" messages from several filesystems
and then the complaint on dm-1 about ext3 orphan inodes on umount (which are
actually directories with i_nlink == 0). I guess these are actually caused by
the same bug - some leak in inode references. I think this is a bug
specific to mmotm since otherwise we'd be seeing much more reports of this.
Looking at the patches in mmotm,
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch caught
my eye but frankly I don't see how we could leak dentry because of that
change. Certainly a path taken by dput() changes but the new one does
dentry_iput() as well.

> I have no idea how to reproduce it :(, but it usually happens when I do
> shutdown/kexec.
  If it's the patch I suspect above, then moving one directory over another
one might trigger the leak which would be later spotted on umount of the
filesystem. Or maybe to trigger the leak you have to have a process which
has its CWD in the directory you are going to delete by the rename... not
sure.

> Those busy inodes are pretty common in current kernels, I don't know if
> that's related -- I doubt it since it is for different bdevs.
  I think it is related - if the busy inode is a deleted one, then you get
exactly the WARN_ON you are reporting... So if you can easily reproduce
the "busy inodes" message then I'd start with debugging that one. Do you
see it also with vanilla kernels?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
