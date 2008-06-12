From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Thu, 12 Jun 2008 14:07:30 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
 <20080611105945.GB9008@skywalker> <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
 <18563.1213215457@alphaville.zko.hp.com> <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de>
 <18513.345.553912.449710@frecb006361.adech.frec.bull.fr>
 <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:39832 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbYFLOHh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jun 2008 10:07:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by node6.dwd.de (Postfix) with ESMTP id E7485C58428
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jun 2008 14:07:35 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node6.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 08886-87 for <linux-ext4@vger.kernel.org>;
	Thu, 12 Jun 2008 14:07:35 +0000 (UTC)
In-Reply-To: <20080612131928.GB18229@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Ted

On Thu, 12 Jun 2008, Theodore Tso wrote:

> On Thu, Jun 12, 2008 at 12:00:54PM +0000, Holger Kiehl wrote:
>> Yes, that is the one I took. Just to make sure, I downloaded it
>> again (and the linux-2.6.26-rc5 tree) and now it works. When I
>> compare the two patchsets the one I pulled this morning had patches
>> from 7 June and this one has more and they are from 11th June.
>
> Note that you don't have to download things from scratch, necessarily;
> the git command "git pull" will (if you havent made any changes in the
> git repository; if you have there are a few more steps you might have
> to take) pull down any newer changes and update your patch directory
> directly.
>
> Note that after you type "git pull", you may find that the
> ext4-patch-queue has been rebased to a newer version of the kernel.
> For example, the patch queue is currently against 2.6.26-rc5.  The
> latest bleedig edge kernel as released by Linus in his git tree of the
> kernel already has these patches:
>
> ext4-fix-use-of-uninitalized-data.patch
> ext4-fix-uninit-block-group-initialization-with-FLEX_BG.patch
> ext4-fix-onine-resize-bug.patch
> fix-journal-checksum-mem-leak
> jbd2-if-a-journal-checksum-error-is-detected-propa.patch
> show-journal-async-commit-option
> jbd2-Fix-barrier-fallback-code-to-re-lock-the-buffe.patch
> ext4-enable-barriers-by-default.patch
>
> from the patch series.  But, he hasn't released an official kernel
> release for 2.6.26-rc5 yet.  So in the near future, the ext4 patch
>
I think this should be 2.6.26-rc6?

> queue will probably get rebased against one of the "daily snapshots",
> as found in /pub/linux/kernel/v2.6/snapshots on ftp.kernel.org.  So
> for example, 2.6.26-rc5-git6 is the sixth snapshot since -rc5 was
> released.  There is a patch against -rc5 named
> patch-2.6.26-rc5-git6.bz2 as located in the aforementioned directory
> on ftp.kernel.org, or if you are tracking Linus's kernel git tree, the
> file patch-2.6.26-rc5-git6.id proclaims that -rc5-git6 is git id
> 631025b.  You will see that when you look at the first line of the
> series file in the ext4 patch queue, where it currently states:
>
> # BASE 2.6.26-rc5
>
> and where it will in the future say something like this:
>
> # BASE 2.6.26-rc5-git6
>
> That can be used by automated scripts to automatically determine which
> version of the Linux kernel should be grabbed before trying to apply
> the latest version of the ext4 patch queue.  In general we try to use
> mainly official -rc1, -rc2, etc. release points, but after Linus
> pulled down some stable bug fixes, we will sometimes use a daily git
> snapshot release such as -rc5-git6 as described above.
>
> Hope this helps,
>
Yes, thanks a lot. I still have not yet managed to get this to work
with git. But downloading linux-2.6.26-rc5.tar.bz2 and then copying
the ext4-patch-queue into linux-2.6.26-rc5/patches and then using
quilt pull did get all the patches applied.

Here are the first test results:

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ext4(patchqueue)16G 59727  98 252733 52 110177 25 55821  98 296739 42  1553   5
                 16G 61047  99 239242 48 111664 25 55706  98 297151 42  1545   4
                 16G 60503  99 241532 47 109655 25 55671  98 297648 42  1552   3

That is with 2.6.26-rc5 + ext4-patch-queue and filesystem was created with
latest e2fsprogs snapshot as you suggested and formated with the following
command:

    mke2fs -t ext4dev /dev/md7

Besides, I am doing those tests on a software raid 1+0. I think that is also
the reason why barriers are disabled by defaults:

    Jun 12 12:17:48 helena kernel: kjournald2 starting.  Commit interval 15 seconds
    Jun 12 12:17:48 helena kernel: EXT4 FS on md7, internal journal
    Jun 12 12:17:48 helena kernel: EXT4-fs: mounted filesystem with writeback data mode.
    Jun 12 12:17:48 helena kernel: EXT4-fs: file extents enabled
    Jun 12 12:17:48 helena kernel: EXT4-fs: mballoc enabled
    Jun 12 12:18:26 helena kernel: JBD: barrier-based sync failed on md7 - disabling barriers

If one compares the results with those of 2.6.25.4 (without ext4-patch-queue):

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ext4 (2.6.25.4) 16G 52965  98 224199 89 108440 32 56389  99 303792 42  1526   4
                 16G 52792  98 223980 92 107685 32 56350  98 303066 42  1532   4
                 16G 52994  98 222354 92 107802 32 56386  99 303727 41  1455   4

This is quit an improvement but still does not match those numbers two years
ago.

However there must be still some bug, I am unable to run my own afdbench
benchmark on this (2.6.26-rc5 + ext4-patch-queue). It starts fine but then
about 3 minutes into the test (the test runs ~60 minutes) all process start
hanging in D-state (here a list):

    afdbench 16381  0.0  0.0   4064   760 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd3 0 0 1 22765b95/0/48511fd7_2db_0
    afdbench 16388  0.0  0.0   4064   760 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd3 3 0 1 22765b95/0/48511fd7_2dc_0
    nobody   16391  0.0  0.0  44304  1444 ?        Ss   13:08   0:00 /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
    afdbench 16395  0.0  0.0   4064   760 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd3 5 0 1 22765b95/0/48511fd7_2dd_0
    nobody   16397  0.0  0.0  44304  1448 ?        Ss   13:08   0:00 /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
    nobody   16400  0.0  0.0  44304  1448 ?        Ss   13:08   0:00 /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
    afdbench 16404  0.0  0.0  44328   992 ?        D    13:08   0:00 /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
    afdbench 16409  0.0  0.0  44328   996 ?        D    13:08   0:00 /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
    afdbench 16411  0.0  0.0  44328   996 ?        D    13:08   0:00 /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
    afdbench 16848  0.0  0.0   4064   716 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 2 0 0 820dc3d0/0/48511fdd_2f3_0
    afdbench 16855  0.0  0.0   4064   712 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 1 0 7 cd52409d/0/48511fdd_2f3_0
    afdbench 16857  0.0  0.0   4064   708 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 0 0 8 e1d94fe0/0/48511fdd_2f3_0
    afdbench 16861  0.0  0.0   4064   708 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 2 0 9 26686393/0/48511fdd_2f3_0
    afdbench 16865  0.0  0.0   4064   704 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 0 0 10 ae36cee/0/48511fdd_2f3_0
    afdbench 16871  0.0  0.0   4064   716 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd2 1 0 0 bca9d45f/0/48511fdd_2d8_0
    afdbench 16876  0.0  0.0   4064   716 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 1 0 0 820dc3d0/0/48511fdd_2f4_0
    afdbench 16878  0.0  0.0   4064   772 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 0 0 6 b8cf511a/0/48511fdd_2f4_0
    nobody   16879  0.0  0.0  44304  1448 ?        Ss   13:08   0:00 /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
    afdbench 16881  0.0  0.0   4064   704 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 0 0 7 cd52409d/0/48511fdd_2f4_0
    afdbench 16885  0.0  0.0  44404  1024 ?        D    13:08   0:00 /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
    afdbench 16886  0.0  0.0   4064   712 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 2 0 8 e1d94fe0/0/48511fdd_2f4_0
    afdbench 16890  0.0  0.0   4064   716 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd2 2 0 0 bca9d45f/0/48511fdd_2d9_0
    afdbench 16891  0.0  0.0   4064   712 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 0 0 9 26686393/0/48511fdd_2f4_0
    afdbench 16892  0.0  0.0   4064   712 ?        D    13:08   0:00 sf_ftp /home/afdbench/afd1 1 0 10 ae36cee/0/48511fdd_2f4_0

This time there is no OOPS and system is still up running without any
problem (except any process wanting to write something to this filesystem
gets stuck forever).

What can I do to help find the problem? The system is still up with all those
process hanging in D-state.

Thanks,
Holger

