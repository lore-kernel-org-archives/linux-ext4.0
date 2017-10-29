From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add support for online resizing with bigalloc.
Date: Sun, 29 Oct 2017 11:06:09 -0400
Message-ID: <20171029150609.ngislvfqc3gwysuy@thunk.org>
References: <20171025044208.86545-1-harshads@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: harshads <harshads@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40938 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750916AbdJ2PoW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 29 Oct 2017 11:44:22 -0400
Content-Disposition: inline
In-Reply-To: <20171025044208.86545-1-harshads@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(If you work for a company which supports enterprise distros, please
keep reading.  I have a question for you below.) 

On Tue, Oct 24, 2017 at 09:42:08PM -0700, harshads wrote:
> This patch adds support for online resizing on bigalloc file system by
> implementing EXT4_IOC_RESIZE_FS ioctl. Old resize interfaces (add
> block groups and extend last block group) are left untouched. Tests
> performed with cluster sizes of 1, 2, 4 and 8 blocks (of size 4k) per
> cluster. I will add these tests to xfstests.
> 
> Signed-off-by: Harshad Shirwadkar <harshads@google.com>

Can you talk more about what sort of testing you have done?  What file
system sizes did you use?

I'm guessing you didn't test the old resize ioctls, because they are
currently broken.  I did a quick test because the code paths that are
touched by this patch are also used by the old resize ioctls, and the
following is failing:

mke2fs -t ext4 -Fq /dev/vdc 1G
mount /dev/vdc
export RESIZE2FS_KERNEL_VERSION=3.2.0
strace -o /tmp/st-$RESIZE2FS_KERNEL_VERSION resize2fs /dev/vdc 5G
umount /dev/vdc

>From a quick check, and it looks like this broke sometime between 4.1
and 4.4.  It works on 3.18 and 4.1, and but it failed for me in 4.4.

The 4.1 kernel was released in June 2015, and 4.4 kernel was released
in January 2016.  E2fsprogs v1.42 started using the new resize ioctl,
which was released in November 2011.  So if we take an enterprise
distro which was initially released > 5-6 years ago, and it upgrades
to a kernel newer than 4.1-4.4, the resize2fs from e2fsprogs 1.41.x
(or earlier) will not be able to do online resize.

The question is whether or not we care at this point.  We could use
the observation that our lack of good testing, sometime in second half
of 2015, we broke online resize backwards compatibility with e2fsprogs
from before 2011, given that no one screamed --- perhaps we can just
rip out support for the old resize ioctls entirely.

Or we can try to fix the old resize ioctl's, and then add better
resize testing to xfstests.

What do the maintainers from the enterprise distro's think?

						- Ted
