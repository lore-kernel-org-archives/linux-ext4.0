From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4: journal has aborted
Date: Thu, 03 Jul 2014 18:58:48 +0400
Message-ID: <87tx6yzdxz.fsf@openvz.org>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com> <20140701082619.1ac77f1d@archvile> <20140701084206.GG9743@birch.djwong.org> <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com> <20140703134338.GE2374@thunk.org> <20140703161551.5fd13245@archvile>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: David Jander <david@protonic.nl>, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:64979 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661AbaGCO6x (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jul 2014 10:58:53 -0400
Received: by mail-la0-f43.google.com with SMTP id e16so264352lan.30
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jul 2014 07:58:51 -0700 (PDT)
In-Reply-To: <20140703161551.5fd13245@archvile>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Thu, 3 Jul 2014 16:15:51 +0200, David Jander <david@protonic.nl> wrote:
> 
> Hi Ted,
> 
> On Thu, 3 Jul 2014 09:43:38 -0400
> "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
> > On Tue, Jul 01, 2014 at 10:55:11AM +0200, Matteo Croce wrote:
> > > 2014-07-01 10:42 GMT+02:00 Darrick J. Wong <darrick.wong@oracle.com>:
> > > 
> > > I have a Samsung SSD 840 PRO
> > 
> > Matteo,
> > 
> > For you, you said you were seeing these problems on 3.15.  Was it
> > *not* happening for you when you used an older kernel?  If so, that
> > would help us try to provide the basis of trying to do a bisection
> > search.
> 
> I also tested with 3.15, and there too I see the same problem.
> 
> > Using the kvm-xfstests infrastructure, I've been trying to reproduce
> > the problem as follows:
> > 
> > ./kvm-xfstests  --no-log -c 4k generic/075 ; e2fsck -p /dev/heap/test-4k ; e2fsck -f /dev/heap/test-4k 
> > 
> > xfstests geneeric/075 runs fsx which does a fair amount of block
> > allocation deallocations, and then after the test finishes, it first
> > replays the journal (e2fsck -p) and then forces a fsck run on the
> > test disk that I use for the run.
> > 
> > After I launch this, in a separate window, I do this:
> > 
> > 	sleep 60  ; killall qemu-system-x86_64 
> > 
> > This kills the qemu process midway through the fsx test, and then I
> > see if I can find a problem.  I haven't had a chance to automate this
> > yet, and it is my intention to try to set this up where I can run this
> > on a ramdisk or a SSD, so I can more closely approximate what people
> > are reporting on flash-based media.
> > 
> > So far, I haven't been able to reproduce the problem.  If after doing
> > a large number of times, it can't be reproduced (especially if it
> > can't be reproduced on an SSD), then it would lead us to believe that
> > one of two things is the cause.  (a) The CACHE FLUSH command isn't
> > properly getting sent to the device in some cases, or (b) there really
> > is a hardware problem with the flash device in question.
> 
> Could (a) be caused by a bug in the mmc subsystem or in the MMC peripheral
> driver? Can you explain why I don't see any problems with EXT3?
> 
> I can't discard the possibility of (b) because I cannot prove it, but I will
> try to see if I can do the same test on a SSD which I happen to have on that
> platform. That should be able to rule out problems with the eMMC chip and
> -driver, right?
> 
> Do you know a way to investigate (a) (CACHE FLUSH not being sent correctly)?
> 
> I left the system running (it started from a dirty EXT4 partition), and I am
> seen the following error pop up after a few minutes. The system is not doing
> much (some syslog activity maybe, but not much more):
> 
> [  303.072983] EXT4-fs (mmcblk1p2): error count: 4
> [  303.077558] EXT4-fs (mmcblk1p2): initial error at 1404216838: ext4_mb_generate_buddy:756
> [  303.085690] EXT4-fs (mmcblk1p2): last error at 1404388969: ext4_mb_generate_buddy:757
> 
> What does that mean?
This means that it found previous error in internal ext4's log. Which is
normal because your fs was corrupted before. It is reasonable to
recreate filesystem from very beginning.

In order to understand whenever it is regression in eMMC driver it is
reasonable to run integrity test for a device itself. You can run
any integrity test you like, For example just run a fio's job
 "fio disk-verify2.fio" (see attachment), IMPORTANT this script will
 destroy data on test partition. If it failed with errors like
 follows "verify: bad magic header XXX" than it is definitely a drivers issue.

If my theory is true and it is storage's driver issue than JBD complain
simply because it do care about it's data (it does integrity checks).
Can you also create btrfs on that partition and performs some io
activity and run fsck after that. You likely will see similar corruption

--=-=-=
Content-Disposition: inline; filename=disk-veryfy2.fio

[global]
bs=4k
direct=1
rw=randwrite
ioengine=libaio
iodepth=32
runtime=3600
time_based

verify=crc32c-intel
verify_fatal=1
verify_dump=1
verify_backlog=1024
verify_async=1
verifysort=1
exitall

##############
# My volume '/dev/mmcblk1p2' size of 4gb
# In order to run this script just change job't name for example '/dev/sda'
###############
# This job will run 4 concurent threads which operate on separated regions
# [0,1gb][1gb,2gb][2gb,3gb][3gb,4gb]
#
[/dev/mmcblk1p2]
numjobs=4
offset_increment=1G
size=1G

--=-=-=


> 
> Best regards,
> 
> -- 
> David Jander
> Protonic Holland.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=--
