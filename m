From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Wed, 3 Jun 2009 11:56:11 -0700
Message-ID: <20090603115611.6bbbaf55.akpm@linux-foundation.org>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: axboe@kernel.dk, hirofumi@mail.parknet.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
	artem.bityutskiy@nokia.com
To: Denis Karpov <ext-denis.2.karpov@nokia.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841AbZFCS5F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 14:57:05 -0400
In-Reply-To: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed,  3 Jun 2009 18:05:14 +0300
Denis Karpov <ext-denis.2.karpov@nokia.com> wrote:

> 
> Hello, 
> 
> these patches are resent (a bit re-worked and separated from other stuff).
> The issue was discussed here:
> http://marc.info/?l=linux-fsdevel&m=124402900920380&w=2
> 
> Summary:
> 
> 1. Generic mechanism for notifications of user space about file system's
>    errors/inconsistency on a particular partition using:
> 
>      - sysfs entry /sys/block/<bdev>/<part>/fs_unclean
>      - uevent KOBJ_CHANGE, uevent's environment variable FS_UNCLEAN=[0:1]
> 
>    Userspace might want to monitor these notifications (poll2() on sysfs 
>    file or udevd's rule for uevent) and fix the fs damage.
>    Filesystem can be marked clean again by writing '0' to the 
>    corresponding 'fs_unclean' sysfs file.
> 
>    Currently some file systems remount themselves r/o on critical errors
>    (*FAT; EXT2 depending on 'errors' mount option), userspace is generally
>    unaware of such events. This feature will allow user space to become 
>    aware of possible file system problems and do something about them 
>    (e.g. run fsck automatically or with user's consent).
>    [PATCH 1]
> 
> 2. Make FAT and EXT2 file systems use the above mechanism to optionally
>    notify user space about errors. Implemented as 'notify' mount option
>    (PATCH 3,4).
>    FAT error reporting facilities had to be re-factored (PATCH 2) in 
>    order to simplify sending error notifications.
> 
> Adrian Hunter and Artem Bityutskiy provided input and ideas on implementing
> these features.
> 

hm, I'm uncertain on the desirability or otherwise of the overall feature.

Are there users or distros or device manufacturers asking for this? 
Where did the requirement come from?

What downstream application will handle the uevent messages?  Do you
have some userspace design/plan in mind?

IOW, it would be useful if we were told more about all of this, rather
than just staring at a kernel patch!

One part of the design which you didn't describe, but which I inferred
is that you intend that userspace will see the FS_UNCLEAN=1 messages
and will then poll all the /sys/block/<bdev>/<part>/fs_unclean files to
work out which partition(s) got the error, correct?  Please spell all
that out in the changelog.

What use is the FS_UNCLEAN=0 message?  I don't get that.  Again, please
cover this in the description.

The "unclean" term doesn't seem a good fit.  It usually means "has
in-memory data which needs writing back".  But here you've redefined
"unclean" to mean "got an IO error" or "detected metadata
inconsistency", or perhaps "dunno, please run fsck to find out".  This
all should be spelled out in exacting detail and thought about, please.

