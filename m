From: tytso@mit.edu
Subject: Re: Kernel does not respect tune2fs -E mount_opts=foo
Date: Tue, 23 Aug 2016 15:48:49 +0000
Message-ID: <20160823154849.GA15892@thunk.org>
References: <CAJZVDJDeLePt1RYAtLQ-NzZ0R5nwRb_wwBW9H7dcgD2zG8_m=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Marcos Mello <marcosfrm@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57742 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752931AbcHWQoC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 23 Aug 2016 12:44:02 -0400
Content-Disposition: inline
In-Reply-To: <CAJZVDJDeLePt1RYAtLQ-NzZ0R5nwRb_wwBW9H7dcgD2zG8_m=g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The problem you are running into is not something we can fix,
unfortunately, or at least not in a full and general way.  The problem
is that there are certain mount options which are parsed by the mount
command (in userspace) and then translated to a mount flag, which is
then passed to the mount command as a bitmask, and which is
interpreted by the VFS layer before calling the file system.

The mount options field in the superblock is parsed by the ext4 file
system along with options that were not parsed by the mount binary,
passed to the VFS, which then passed it to ext4 file system driver.

In theory, we could interpret relatime in ext4 and replicate its
effects.  For relatime, this is trivial to do.  There may be other
mount options which are interepted by the mount userspace program, and
implemented in the VFS, where this would be much less easy to do.

> Other options like noacl, nouser_xattr, are ignored too. This
> filesystem is not listed in fstab.

This is exactly the same issue.

Cheers,

					- Ted
