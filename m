From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Tue, 6 Sep 2011 09:37:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org> <4E66478E.90102@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:44346 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731Ab1IFQht (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 12:37:49 -0400
In-Reply-To: <4E66478E.90102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 Sep 2011 at 11:17, Eric Sandeen wrote:
> It's probably not a bug or flaw; orphan inodes can occur for legitimate
> reasons (fs goes down while someone is holding open an unlinked file),

The filesystem is being constantly accessed by an application, holding at 
least one file open (readonly). And then there is this mechanism trying to 
remount the filesystem rw and then ro again every day. I guess this equals
the scenario of "fs goes down (remount!) while someone is holding open a 
file"?

> Did you happen to also get a message like this on the original mount?
>                 ext4_msg(sb, KERN_ERR, "write access "
>                         "unavailable, skipping orphan cleanup");

I think I've seen this message before, but I'm nore sure where and it's 
not in the logs of this particular system.

> See also commit: 
>
> commit ead6596b9e776ac32d82f7d1931d7638e6d4a7bd
> Author: Eric Sandeen <sandeen@redhat.com>
> Date:   Sat Feb 10 01:46:08 2007 -0800
> 
>     [PATCH] ext4: refuse ro to rw remount of fs with orphan inodes

Yes, I've seen this commit when I was searching where this message came
from. And I think I understand now why this is happening, but 
still...if I may ask: can't this be handled more elegantly? Do other 
filesystems have the same problem?

Right now the procedure is to pause the application, stop the nfs exports,
unmount, fsck, mount, start nfs exports and resume the application. And
every few days/weeks this has to be repeated, "just because" these daily
remounts occur (which are the main reason for this, I suppose).

Thanks for replying,
Christian.
-- 
BOFH excuse #190:

Proprietary Information.
