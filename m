Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41044 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726100AbeLJFxO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 10 Dec 2018 00:53:14 -0500
Date: Mon, 10 Dec 2018 00:53:07 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
        Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH 1/2] ext4: try to merge unwritten extents who are also
 not under io
Message-ID: <20181210055307.GI1840@mit.edu>
References: <20181125085031.7141-1-xiaoguang.wang@linux.alibaba.com>
 <7fef258e-0095-cfa2-aeb4-5d4d99cfd2e6@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7fef258e-0095-cfa2-aeb4-5d4d99cfd2e6@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 25, 2018 at 05:06:41PM +0800, Xiaoguang Wang wrote:
> Hi,
> 
> There will be no [PATCH 2/2], which was caused by my mistake, sorry, only one patch in this mail.
> I have run xfstests "-g auto" for this patch, most test cases work well, such
> cases will fail:
> generic/107 generic/223 generic/347 generic/388 generic/422 generic/475 generic/484, but
> even though I do not apply this patch, these cases still may fail.
> 
> No matter whether this patch is applied, generic/107, generic/388 and generic/475 sometimes pass,
> sometimes fail, other 4 test cases always fail.
> 
> Apply LiuBo's "Ext4: fix slow writeback under dioread_nolock and nodelalloc" and this patch, this
> slow writeback issue described in Liu Bo's patch will go.

Hi, my apologies for not responding earlier.  I had been
waiting/hoping that Eric Whitney, who has last made a lot of changes
around the extent status tree management, would take a look at your
changes and comment.

The other thing which I'm very much wondering about is why you are
seeing such a large number of test failures.  What sort of file system
configuration and kernel version are you seeing these failures?  My
current test runs aren't showing anything like this --- and neeither
is Eric Whitney's testing.  I've attached a recent test report below.

					- Ted

TESTRUNID: ltm-20181208020855
KERNEL:    kernel 4.20.0-rc4-xfstests-00010-ge647e29196b7 #772 SMP Wed Dec 5 19:38:26 EST 2018 x86_64
CMDLINE:   full --kernel gs://gce-xfstests/bzImage
CPUS:      2
MEM:       7680

ext4/4k: 444 tests, 2 failures, 42 skipped, 4272 seconds
  Failures: ext4/034 generic/388 
ext4/1k: 455 tests, 4 failures, 54 skipped, 4624 seconds
  Failures: ext4/034 generic/383 generic/388 generic/454 
ext4/ext3: 503 tests, 3 failures, 104 skipped, 3857 seconds
  Failures: ext4/034 generic/235 generic/388 
ext4/encrypt: 512 tests, 1 failures, 123 skipped, 2828 seconds
  Failures: ext4/034 
ext4/nojournal: 494 tests, 2 failures, 95 skipped, 3407 seconds
  Failures: ext4/301 generic/113 
ext4/ext3conv: 443 tests, 2 failures, 42 skipped, 4240 seconds
  Failures: ext4/034 generic/388 
ext4/adv: 448 tests, 5 failures, 48 skipped, 4165 seconds
  Failures: ext4/034 generic/388 generic/399 generic/477 generic/519 
ext4/dioread_nolock: 443 tests, 2 failures, 42 skipped, 4424 seconds
  Failures: ext4/034 generic/388 
ext4/data_journal: 490 tests, 4 failures, 90 skipped, 4954 seconds
  Failures: ext4/034 generic/371 generic/388 generic/475 
ext4/bigalloc: 429 tests, 6 failures, 49 skipped, 4957 seconds
  Failures: ext4/034 generic/204 generic/219 generic/273 generic/388 
    generic/500 
ext4/bigalloc_1k: 443 tests, 7 failures, 63 skipped, 3717 seconds
  Failures: ext4/034 generic/204 generic/273 generic/383 generic/388 
    generic/454 generic/500 
Totals: 4352 tests, 752 skipped, 38 failures, 0 errors, 45223s

FSTESTIMG: gce-xfstests/xfstests-201812071306
FSTESTPRJ: gce-xfstests
FSTESTVER: blktests b237a09 (Mon, 26 Nov 2018 11:35:33 -0800)
FSTESTVER: fio  fio-3.2 (Fri, 3 Nov 2017 15:23:49 -0600)
FSTESTVER: fsverity bdebc45 (Wed, 5 Sep 2018 21:32:22 -0700)
FSTESTVER: ima-evm-utils 0267fa1 (Mon, 3 Dec 2018 06:11:35 -0500)
FSTESTVER: quota  59b280e (Mon, 5 Feb 2018 16:48:22 +0100)
FSTESTVER: stress-ng 977ae357 (Wed, 6 Sep 2017 23:45:03 -0400)
FSTESTVER: syzkaller 4b6d14f2 (Tue, 27 Nov 2018 13:16:46 +0100)
FSTESTVER: xfsprogs v4.19.0 (Fri, 9 Nov 2018 14:31:04 -0600)
FSTESTVER: xfstests-bld c07ca47 (Fri, 7 Dec 2018 12:56:06 -0500)
FSTESTVER: xfstests linux-v3.8-2234-g8636a571 (Fri, 7 Dec 2018 12:59:13 -0500)
FSTESTSET: -g auto
FSTESTOPT: aex
