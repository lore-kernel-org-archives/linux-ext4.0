From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Date: Wed, 18 Apr 2012 10:19:08 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1204181015050.5310@dhcp-27-109.brq.redhat.com>
References: <1334681618-9452-1-git-send-email-wenqing.lz@taobao.com> <4F8DAAFE.40500@redhat.com> <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab2DRITQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Apr 2012 04:19:16 -0400
In-Reply-To: <D225F088-A53F-4962-97AD-13C850BBA722@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 17 Apr 2012, Andreas Dilger wrote:

> On 2012-04-17, at 10:40, Eric Sandeen <sandeen@redhat.com> wrote:
> > On 4/17/12 11:53 AM, Zheng Liu wrote:
> >> 
> >> fallocate is a useful system call because it can preallocate some disk blocks
> >> for a file and keep blocks contiguous.  However, it has a defect that file
> >> system will convert an uninitialized extent to be an initialized when the user
> >> wants to write some data to this file, because file system create an
> >> unititalized extent while it preallocates some blocks in fallocate (e.g. ext4).
> > 
> > That's a security-driven design feature, not a defect.  :)
> > 
> >> I try to make ext4 support this new flag, and run a simple test in my own
> >> desktop to verify it.  The machine has a Intel(R) Core(TM)2 Duo CPU E8400, 4G
> >> memory and a WDC WD1600AAJS-75M0A0 160G SATA disk.  I use the following script
> >> to tset the performance.
> >> 
> >> #/bin/sh
> >> mkfs.ext4 ${DEVICE}
> >> mount -t ext4 ${DEVICE} ${TARGET}
> >> fallocate -l 27262976 ${TARGET}/test # the size of the file is 256M (*)
> > 
> > That's only 26MB, but the below loop writes to a max offset of around
> > 256M.
> > 
> >> time for((i=0;i<2000;i++)); do dd if=/dev/zero of=/mnt/sda1/test_256M \
> >>    conv=notrunc bs=4k count=1 seek=`expr $i \* 16` oflag=sync,direct \
> >>    2>/dev/null; done
> > 
> > You fallocate ${TARGET}/test but dd to /mnt/sda1/test_256M ?  I presume
> > those should be the same file.
> > 
> > So the testcase as shown above seems fairly wrong, no?  Is that what you
> > used for the numbers below?
> 
> I auspect the real problem may be the lazy inode table zeroing being done in the kernel. If the test is run immediately after formatting the filesystem, then the kernel thread is busy writing to the disk in the background and interfering with your benchmark.
> 
> Please format the filesystem with "-E lazy-itable-init=0", to avoid this behavior.  

That's right. Or you can mount it with -o noinit_itable to prevent
kernel from initializing the inode table. But I would expect that this
will not have such a huge impact since it is done in both w/ and w/o
case.

-Lukas

> 
> Secondly, your test program is not doing random writes to disk, but rather doing writes at 64kB intervals. There is logic in the uninitialized extent handling that will write zeros to an entire extent, rather than create many fragmented uninitialized extents.  It may be possible that you are zeroing out the entire file, and writing 16x as much data as you expect.
> 
> Cheers, Andreas
> 
> >> * I write a wrapper program to call fallocate(2) with FALLOC_FL_NO_HIDE_STALE
> >>  flag because the userspace tool doesn't support the new flag.
> >> 
> >> The result:
> >>    w/o        w/
> >> real    1m16.043s    0m17.946s    -76.4%
> >> user    0m0.195s    0m0.192s    -1.54%
> >> sys    0m0.468s    0m0.462s    -1.28%
> > 
> > I think that the missing information here is some profiling to show where
> > the time was spent in the "w/o" case.  What, exactly, in ext4 extent
> > management is so darned slow that we have to poke security holes in the
> > filesytem to get decent performance?
> > 
> > However,, the above also seems like an alarmingly large difference, and
> > one that I can't attribute to unwritten extent conversion overhead.
> > 
> > If I test the seeky dd to a prewritten file (to eliminate extent
> > conversion):
> > 
> > # dd if=/dev/zero of=/mnt/scratch/test bs=1M count=256
> > # sync
> > 
> > vs. to a fallocated file (which requires extent conversion):
> > 
> > # fallocate -l 256m /mnt/scratch/test
> > 
> > and then do your seeky dd test after each of the above:
> > 
> > # time for((i=0;i<2000;i++)); do dd if=/dev/zero of=/mnt/scratch/test \
> >    conv=notrunc bs=4k count=1 seek=`expr $i \* 16` oflag=sync,direct \
> >    2>/dev/null; done
> > 
> > On ext4, I get about 59.9 seconds in the pre-written case, 65.2 seconds in the fallocated case.
> > 
> > On xfs, I get about 52.5 seconds in the pre-written case, 52.7 seconds in the fallocated case.
> > 
> > I don't see anywhere near the slowdown you show above, certainly
> > nothing bad enough to warrant opening the big security hole.
> > Am I missing something?
> > 
> > The ext4 delta is a bit larger, though, so it seems worth investigating
> > the *root cause* of the extra overhead if it's problematic in your
> > workloads...
> > 
> > -Eric
> > 
> > 
> >> Obviously, this flag will bring an secure issue because the malicious user
> >> could use this flag to get other user's data if (s)he doesn't do a
> >> initialization before reading this file.  Thus, a sysctl parameter
> >> 'fs.falloc_no_hide_stale' is defined in order to let administrator to determine
> >> whether or not this flag is enabled.  Currently, this flag is disabled by
> >> default.  I am not sure whether this is enough or not.  Another option is that
> >> a new Kconfig entry is created to remove this flag during the kernel is
> >> complied.  So any suggestions or comments are appreciated.
> >> 
> >> Regards,
> >> Zheng
> >> 
> >> Zheng Liu (3):
> >>      vfs: add FALLOC_FL_NO_HIDE_STALE flag in fallocate
> >>      vfs: add security check for _NO_HIDE_STALE flag
> >>      ext4: add FALLOC_FL_NO_HIDE_STALE support
> >> 
> >> fs/ext4/extents.c      |    7 +++++--
> >> fs/open.c              |   12 +++++++++++-
> >> include/linux/falloc.h |    5 +++++
> >> include/linux/sysctl.h |    1 +
> >> kernel/sysctl.c        |   10 ++++++++++
> >> 5 files changed, 32 insertions(+), 3 deletions(-)
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
