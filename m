From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: restoring ext3 filesystem overwritten by ext4
Date: Sat, 21 Jul 2012 09:17:34 -0700
Message-ID: <12869D43-E068-4F4B-9A06-D0A35DA5CB40@whamcloud.com>
References: <CAGFSy5kJFtBH5ogrppKNXht24bPc+9qQhvupqEyhkShxdpHNaw@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: David Hayes <davemellow@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62323 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2GUQRp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jul 2012 12:17:45 -0400
Received: by pbbrp8 with SMTP id rp8so8070227pbb.19
        for <linux-ext4@vger.kernel.org>; Sat, 21 Jul 2012 09:17:45 -0700 (PDT)
In-Reply-To: <CAGFSy5kJFtBH5ogrppKNXht24bPc+9qQhvupqEyhkShxdpHNaw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-21, at 1:49, David Hayes <davemellow@gmail.com> wrote:

> This is a general question about whether it should be possible to
> effectively undo a mkfs.ext4 on a partition which previously held an
> ext3 filesystem. I'm just a user, not a developer, so I'm not familiar
> with the details of where backup superblocks get written etc. I had no
> luck finding any old filesystem information with testdisk, so I'm
> wondering whether ext4 might overwrite all the superblocks by
> coincidence of choosing the same blocks in the partition to write them
> as mkfs.ext3 did, or something.

Yes, though it is no coincidence. For the same filesystem size, the same superblocks will be used. It is likely that different group descriptor blocks would be used, because of flex_bg. If you have a newer kernel it is possible the inode tables were not zeroed out, which would otherwise have clobbered a large part of the data. 

> If the answer to the above is "yes" I'll respond with more specific
> details if required.


First thing - do NOT mount the filesystem. Make a copy of the whole partition using "dd" for experimentation.  If the ext4 filesystem has never been mounted, there is at least some chance the data can be recovered. 

Unfortunately, the new group descriptors will be in the same place as the old ones. It is necessary to do something like "mke2fs -t ext3 -S" to rebuild the old group descriptors and then run "e2fsck -fy" to see if there is anything in the inode tables to recover. 

Cheers, Andreas