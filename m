From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Refreshed rootfs.img for kvm-xfstests
Date: Tue, 10 Jan 2017 22:05:58 -0500
Message-ID: <20170111030558.p65scetj7ouu25tw@thunk.org>
References: <20170109231450.objek3yirxbtbgzn@thunk.org>
 <20170110033845.qkjg6qzfjxy5i54k@thunk.org>
 <CAJrWOzAebGpyLTJL2XsP8r4zjrbG030cLEXUVUK0t2sW8=g_Gg@mail.gmail.com>
 <CAJrWOzBPn98QPptcJWNUpaTBzCWvqN-N3f8Sk+J7zje8v0Qx7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Roman Penyaev <roman.penyaev@profitbricks.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33330 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936074AbdAKDGE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 10 Jan 2017 22:06:04 -0500
Content-Disposition: inline
In-Reply-To: <CAJrWOzBPn98QPptcJWNUpaTBzCWvqN-N3f8Sk+J7zje8v0Qx7w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 10, 2017 at 04:07:49PM +0100, Roman Penyaev wrote:
> > I retested the following configurations on 69973b830859 ("Linux 4.9"):
> >
> > ./kvm-xfstests.sh -c nojournal    ext4/301
> > ./kvm-xfstests.sh -c ext3conv     generic/347
> > ./kvm-xfstests.sh -c adv          generic/396 generic/399
> > ./kvm-xfstests.sh -c data_journal generic/347
> > ./kvm-xfstests.sh -c bigalloc     generic/399
> > ./kvm-xfstests.sh -c bigalloc_1k  generic/273
> >
> > all of the tests from list have failed.
> 
> I executed the list above on these kernels:
> 
> c8d2bc9bc39e ("Linux 4.8")
> 523d939ef98f ("Linux 4.7")
> 2dcd0af568b0 ("Linux 4.6")
> b562e44f507e ("Linux 4.5")
> 
> and the picture stays the same: tests continue to fail.
> (once I saw '-c data_journal generic/347' on 4.6 has passed, but
>  I failed to repeat this success).

Hi Roman,

It's important to remember that xfstests keep adding new tests and
changing existing ones.  So for example, here below is a test of
4.7.0-rc1 with the ext4 changes that went into 4.8 during the merge
window.  You'll see that these test failures above mostly aren't
represented.  (One exception is ext4/301 in nojournal mode; that's
been one that has been failing for a while.  As far as I know, main
user of nojournal mode is Google, and we don't use e4defrag, so it's
not been a high priority for meto track down.)

The test report attached below was run on July 17th, using xfstests
git repo from March 15th, and so a number of these tests simply
weren't not in the xfstests yet:

% git log --reverse --pretty=%cd\n tests/generic/347 | head -1
Mon May 9 10:55:24 2016 +1000n
% git log --reverse --pretty=%cd\n tests/generic/273 | head -1
Tue Mar 26 11:43:49 2013 -0500n
=% git log --reverse --pretty=%cd\n tests/generic/396 | head -1
Sat Dec 24 16:47:12 2016 +0800n
% git log --reverse --pretty=%cd\n tests/generic/399 | head -1
Sat Dec 24 16:48:58 2016 +0800n

So very often a git bisect isn't the best way to debug a test failure.
In some cases a bug that was found in another file system (such as
btrfs, or f2fs) when introduced as a generic test, ends up tickling a
bug (often a different kind of bug with different symptoms) in ext4.

Cheers,

						- Ted

Subject: xfstests results 201607170254 - 4.7.0-rc1-ext4-00021-g7bc9491

CMDLINE: full
FSTESTVER: e2fsprogs    v1.43.1-22-g25c4a20 (Wed, 8 Jun 2016 18:11:27 -0400)
FSTESTVER: fio          fio-2.6-8-ge6989e1 (Thu, 4 Feb 2016 12:09:48 -0700)
FSTESTVER: quota                81aca5c (Tue, 12 Jul 2016 16:15:45 +0200)
FSTESTVER: xfsprogs     v4.5.0 (Tue, 15 Mar 2016 15:25:56 +1100)
FSTESTVER: xfstests-bld 4247cb8 (Sat, 16 Jul 2016 21:58:00 -0400)
FSTESTVER: xfstests     linux-v3.8-1105-gacd7210 (Fri, 15 Jul 2016 11:16:57 -0400)
FSTESTVER: kernel       4.7.0-rc1-ext4-00021-g7bc9491 #320 SMP Sun Jul 17 02:51:56 EDT 2016 x86_64
FSTESTCFG: "4k 1k ext3 encrypt nojournal ext3conv adv dioread_nolock data_journal bigalloc bigalloc_1k"
FSTESTSET: "-g auto"
FSTESTEXC: ""
FSTESTOPT: "aex"
MNTOPTS: ""
CPUS: "2"
MEM: "7496.82"
MEM: 7680 MB (Max capacity)
BEGIN TEST 4k: Ext4 4k block Sun Jul 17 02:55:55 EDT 2016
Passed all 224 tests
BEGIN TEST 1k: Ext4 1k block Sun Jul 17 03:44:54 EDT 2016
Failures: generic/018 generic/273
BEGIN TEST ext3: Ext4 4k block emulating ext3 Sun Jul 17 04:37:46 EDT 2016
Passed all 180 tests
BEGIN TEST encrypt: Ext4 encryption Sun Jul 17 05:25:58 EDT 2016
Failures: ext4/020 generic/269
BEGIN TEST nojournal: Ext4 4k block w/ no journal Sun Jul 17 05:52:50 EDT 2016
Failures: ext4/301
BEGIN TEST ext3conv: Ext4 4k block w/nodelalloc and no flex_bg Sun Jul 17 06:36:35 EDT 2016
Failures: generic/347
BEGIN TEST adv: Ext4 advanced features (inline_data, metadata_csum, 64bit) Sun Jul 17 07:23:25 EDT 2016
Passed all 223 tests
BEGIN TEST dioread_nolock: Ext4 4k block w/dioread_nolock Sun Jul 17 08:12:27 EDT 2016
Passed all 224 tests
BEGIN TEST data_journal: Ext4 4k block w/data=journal Sun Jul 17 09:01:46 EDT 2016
Failures: generic/018 generic/347
BEGIN TEST bigalloc: Ext4 4k block w/bigalloc Sun Jul 17 10:09:25 EDT 2016
Failures: ext4/004 generic/204 generic/219 generic/235 generic/273
BEGIN TEST bigalloc_1k: Ext4 1k block w/bigalloc Sun Jul 17 11:02:40 EDT 2016
Failures: ext4/004 generic/204 generic/235 generic/273
