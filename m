From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: Refreshed rootfs.img for kvm-xfstests
Date: Tue, 10 Jan 2017 13:48:03 +0100
Message-ID: <CAJrWOzAebGpyLTJL2XsP8r4zjrbG030cLEXUVUK0t2sW8=g_Gg@mail.gmail.com>
References: <20170109231450.objek3yirxbtbgzn@thunk.org> <20170110033845.qkjg6qzfjxy5i54k@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:34973 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031070AbdAJMsZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Jan 2017 07:48:25 -0500
Received: by mail-it0-f44.google.com with SMTP id c20so73998735itb.0
        for <linux-ext4@vger.kernel.org>; Tue, 10 Jan 2017 04:48:24 -0800 (PST)
In-Reply-To: <20170110033845.qkjg6qzfjxy5i54k@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 10, 2017 at 4:38 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Jan 09, 2017 at 06:14:50PM -0500, Theodore Ts'o wrote:
>> There is an updated rootfs.img file available at:
>>
>>     https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests
>
> ... and here are the latest test results using gce-xfstests on the
> ext4.git's dev branch (which includes Roman's fixes).  I've annotated
> the test failures report here and attached a compressed copy of the
> runtests.log file:
>
> CMDLINE: full
> FSTESTIMG: gce-xfstests/xfstests-201701091217
> FSTESTVER: e2fsprogs    v1.43.3-30-g8df85fb (Sun, 4 Sep 2016 21:32:35 -0400)
> FSTESTVER: fio          fio-2.16 (Mon, 19 Dec 2016 23:12:56 -0700)
> FSTESTVER: quota                2b37958 (Tue, 9 Aug 2016 19:17:56 +0200)
> FSTESTVER: xfsprogs     v4.9.0-1-g07d66eb (Sat, 7 Jan 2017 23:27:26 -0500)
> FSTESTVER: xfstests-bld 39124a6 (Mon, 9 Jan 2017 11:09:14 -0500)
> FSTESTVER: xfstests     linux-v3.8-1306-gbeffdf1 (Sun, 8 Jan 2017 20:30:22 -0500)
> FSTESTVER: kernel       4.10.0-rc3-ext4-00014-g2b3864b32403 #195 SMP Mon Jan 9 01:32:06 EST 2017 x86_64
> FSTESTCFG: "all"
> FSTESTSET: "-g auto"
> FSTESTEXC: ""
> FSTESTOPT: "aex"
> MNTOPTS: ""
> CPUS: "2"
> MEM: "7477.96"
> MEM: 7680 MB (Max capacity)
> BEGIN TEST 4k: Ext4 4k block Mon Jan  9 12:26:16 EST 2017
> Passed all 245 tests
> BEGIN TEST 1k: Ext4 1k block Mon Jan  9 13:16:48 EST 2017
> Failures: generic/018 generic/270 generic/273
>    generic/018 -- defrag test failure --- ignore
>    generic/270 -- known lockdep problem in quota code
>    generic/273 -- we aren't reserving enough blocks on a 2GB 1k file system,
>        so ENOSPC block reservation test is failing.
> BEGIN TEST ext3: Ext4 4k block emulating ext3 Mon Jan  9 14:13:51 EST 2017
> Failures: generic/382
>    generic/382 -- quota test which doesn't take indirect blocks into account.
> BEGIN TEST encrypt: Ext4 encryption Mon Jan  9 14:57:29 EST 2017
> Failures: ext4/022 generic/382
>    ext4/022 -- ENOSPC test involving encryption and xattr
>    generic/382 -- quota test which should be suppresed with encryption
> BEGIN TEST nojournal: Ext4 4k block w/ no journal Mon Jan  9 15:22:05 EST 2017
> Failures: ext4/301
>    ext4/301 -- defrag failure with no journal?
> BEGIN TEST ext3conv: Ext4 4k block w/nodelalloc and no flex_bg Mon Jan  9 16:07:55 EST 2017
> Failures: generic/347
>    generic/347 --- file system got corrupted?!?
> BEGIN TEST adv: Ext4 advanced features (inline_data, metadata_csum, 64bit) Mon Jan  9 16:53:22 EST 2017
> Failures: generic/396 generic/399
>    generic/396 --- fscrypt releated: file system got corrupted?!?
>    generic/399 --- fscrypt releated: file system never filled up?!?
> BEGIN TEST dioread_nolock: Ext4 4k block w/dioread_nolock Mon Jan  9 17:39:38 EST 2017
> Passed all 245 tests
> BEGIN TEST data_journal: Ext4 4k block w/data=journal Mon Jan  9 18:25:55 EST 2017
> Failures: generic/347
>    generic/347 -- file system got corruptd?!?
> BEGIN TEST bigalloc: Ext4 4k block w/bigalloc Mon Jan  9 19:35:00 EST 2017
> Failures: ext4/004 generic/204 generic/219 generic/235 generic/273 generic/399
>    ext4/004 --- dump restore failure (with bigalloc --- not surprising)
>    generic/204 --- ENOSPC during test
>    generic/219 --- too many blocks used (quota accounting)
>    generic/235 --- clusters vs blocks accounting in quota code
>    generic/273 --- not reserving enough space (porter not complete)
>    generic/399 --- fscrypt releated: file system corrupted?!?
> BEGIN TEST bigalloc_1k: Ext4 1k block w/bigalloc Mon Jan  9 20:17:46 EST 2017
> Failures: ext4/004 generic/204 generic/235 generic/273nnn
>    ext4/004 --- dump restore failure (with bigalloc --- not surprising)
>    generic/204 --- ENOSPC during test
>    generic/235 --- clusters vs blocks accounting in quota code
>    generic/273 --- not reserving enough space (porter not complete)?!?
>
> Some of these are test bugs that we should fix or suppress.  Others,
> such as the new encryption tests causing corrupted file systems in the
> more exotic file system configurations, are definitely bugs that we
> need to fix.
>

I retested the following configurations on 69973b830859 ("Linux 4.9"):

./kvm-xfstests.sh -c nojournal    ext4/301
./kvm-xfstests.sh -c ext3conv     generic/347
./kvm-xfstests.sh -c adv          generic/396 generic/399
./kvm-xfstests.sh -c data_journal generic/347
./kvm-xfstests.sh -c bigalloc     generic/399
./kvm-xfstests.sh -c bigalloc_1k  generic/273

all of the tests from list have failed.

This is not very much helpful, but at least that can be a starting
point for bisecting.

When there was a successful xfstests run at least for some of
the configurations?  Would be nice to have a "good" reference.

--
Roman
