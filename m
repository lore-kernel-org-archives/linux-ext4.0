From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Tue, 17 Apr 2012 12:40:14 -0500
Message-ID: <4F8DAAFE.40500@redhat.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015Ab2DQRkV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Apr 2012 13:40:21 -0400
In-Reply-To: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/17/12 11:53 AM, Zheng Liu wrote:
> Hi list,
> 
> fallocate is a useful system call because it can preallocate some disk blocks
> for a file and keep blocks contiguous.  However, it has a defect that file
> system will convert an uninitialized extent to be an initialized when the user
> wants to write some data to this file, because file system create an
> unititalized extent while it preallocates some blocks in fallocate (e.g. ext4).

That's a security-driven design feature, not a defect.  :)

> Especially, it causes a severe degradation when the user tries to do some
> random write operations, which frequently modifies the metadata of this file.
> We meet this problem in our product system at Taobao.  Last month, in ext4
> workshop, we discussed this problem and the Google faces the same problem.  So
> a new flag, FALLOC_FL_NO_HIDE_STALE, is added in order to solve this problem.

Which then opens up severe security problems.

> When this flag is set, file system will create an inititalized extent for this
> file.  So it avoids the conversion from uninitialized to initialized.  If users
> want to use this flag, they must guarantee that file has been initialized by
> themselves before it is read at the same offset.  This flag is added in vfs so
> that other file systems can also support this flag to improve the performance.
> 
> I try to make ext4 support this new flag, and run a simple test in my own
> desktop to verify it.  The machine has a Intel(R) Core(TM)2 Duo CPU E8400, 4G
> memory and a WDC WD1600AAJS-75M0A0 160G SATA disk.  I use the following script
> to tset the performance.
> 
> #/bin/sh
> mkfs.ext4 ${DEVICE}
> mount -t ext4 ${DEVICE} ${TARGET}
> fallocate -l 27262976 ${TARGET}/test # the size of the file is 256M (*)

That's only 26MB, but the below loop writes to a max offset of around
256M.

> time for((i=0;i<2000;i++)); do dd if=/dev/zero of=/mnt/sda1/test_256M \
> 	conv=notrunc bs=4k count=1 seek=`expr $i \* 16` oflag=sync,direct \
> 	2>/dev/null; done

You fallocate ${TARGET}/test but dd to /mnt/sda1/test_256M ?  I presume
those should be the same file.

So the testcase as shown above seems fairly wrong, no?  Is that what you
used for the numbers below?

> * I write a wrapper program to call fallocate(2) with FALLOC_FL_NO_HIDE_STALE
>   flag because the userspace tool doesn't support the new flag.
> 
> The result:
> 	w/o 		w/
> real	1m16.043s	0m17.946s	-76.4%
> user	0m0.195s	0m0.192s	-1.54%
> sys	0m0.468s	0m0.462s	-1.28%

I think that the missing information here is some profiling to show where
the time was spent in the "w/o" case.  What, exactly, in ext4 extent
management is so darned slow that we have to poke security holes in the
filesytem to get decent performance?

However,, the above also seems like an alarmingly large difference, and
one that I can't attribute to unwritten extent conversion overhead.

If I test the seeky dd to a prewritten file (to eliminate extent
conversion):

# dd if=/dev/zero of=/mnt/scratch/test bs=1M count=256
# sync

vs. to a fallocated file (which requires extent conversion):

# fallocate -l 256m /mnt/scratch/test

and then do your seeky dd test after each of the above:

# time for((i=0;i<2000;i++)); do dd if=/dev/zero of=/mnt/scratch/test \
	conv=notrunc bs=4k count=1 seek=`expr $i \* 16` oflag=sync,direct \
	2>/dev/null; done

On ext4, I get about 59.9 seconds in the pre-written case, 65.2 seconds in the fallocated case.

On xfs, I get about 52.5 seconds in the pre-written case, 52.7 seconds in the fallocated case.

I don't see anywhere near the slowdown you show above, certainly
nothing bad enough to warrant opening the big security hole.
Am I missing something?

The ext4 delta is a bit larger, though, so it seems worth investigating
the *root cause* of the extra overhead if it's problematic in your
workloads...

-Eric


> Obviously, this flag will bring an secure issue because the malicious user
> could use this flag to get other user's data if (s)he doesn't do a
> initialization before reading this file.  Thus, a sysctl parameter
> 'fs.falloc_no_hide_stale' is defined in order to let administrator to determine
> whether or not this flag is enabled.  Currently, this flag is disabled by
> default.  I am not sure whether this is enough or not.  Another option is that
> a new Kconfig entry is created to remove this flag during the kernel is
> complied.  So any suggestions or comments are appreciated.
> 
> Regards,
> Zheng
> 
> Zheng Liu (3):
>       vfs: add FALLOC_FL_NO_HIDE_STALE flag in fallocate
>       vfs: add security check for _NO_HIDE_STALE flag
>       ext4: add FALLOC_FL_NO_HIDE_STALE support
> 
>  fs/ext4/extents.c      |    7 +++++--
>  fs/open.c              |   12 +++++++++++-
>  include/linux/falloc.h |    5 +++++
>  include/linux/sysctl.h |    1 +
>  kernel/sysctl.c        |   10 ++++++++++
>  5 files changed, 32 insertions(+), 3 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

