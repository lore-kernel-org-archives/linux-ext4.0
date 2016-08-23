From: Marcos Mello <marcosfrm@gmail.com>
Subject: Re: Kernel does not respect tune2fs -E mount_opts=foo
Date: Tue, 23 Aug 2016 13:01:53 -0300
Message-ID: <CAJZVDJDgz=QTARjPXDqh8YuFOiS6nO_BdTzNsb2hr5apPmLk5w@mail.gmail.com>
References: <CAJZVDJDeLePt1RYAtLQ-NzZ0R5nwRb_wwBW9H7dcgD2zG8_m=g@mail.gmail.com>
 <20160823154849.GA15892@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:36555 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753370AbcHWQI6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Aug 2016 12:08:58 -0400
Received: by mail-yb0-f179.google.com with SMTP id e31so52150693ybi.3
        for <linux-ext4@vger.kernel.org>; Tue, 23 Aug 2016 09:08:14 -0700 (PDT)
In-Reply-To: <20160823154849.GA15892@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2016-08-23 12:48 GMT-03:00  <tytso@mit.edu>:
> The problem you are running into is not something we can fix,
> unfortunately, or at least not in a full and general way.  The problem
> is that there are certain mount options which are parsed by the mount
> command (in userspace) and then translated to a mount flag, which is
> then passed to the mount command as a bitmask, and which is
> interpreted by the VFS layer before calling the file system.
>
> The mount options field in the superblock is parsed by the ext4 file
> system along with options that were not parsed by the mount binary,
> passed to the VFS, which then passed it to ext4 file system driver.
>
> In theory, we could interpret relatime in ext4 and replicate its
> effects.  For relatime, this is trivial to do.  There may be other
> mount options which are interepted by the mount userspace program, and
> implemented in the VFS, where this would be much less easy to do.
>
>> Other options like noacl, nouser_xattr, are ignored too. This
>> filesystem is not listed in fstab.
>
> This is exactly the same issue.
>

Thanks for the explanation. A hint about this limitation in tune2fs
man page would help.

Marcos
