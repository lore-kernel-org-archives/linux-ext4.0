From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: [RFC][PATCH] fstest: regression test for ext4 crash consistency bug
Date: Fri, 1 Sep 2017 07:21:57 -0500
Message-ID: <CAFk8rvYC4wTw15CF0wTdYLXLBp-FL+Y0xDtcins+uHu5gfrm-A@mail.gmail.com>
References: <7f4519d6-9e3f-c036-b72d-8a387bf657d3@utexas.edu>
 <CAOQ4uxgRafGec=HFq1strxC5NM0jwNgbu5ZyP1g+c64=b399+A@mail.gmail.com> <CAOQ4uxgOu5yNV3zQ9WnJU_AQtpe9G9cxQQL52fWsXd=5bvGLaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:34762 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdIAMW7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Sep 2017 08:22:59 -0400
Received: by mail-vk0-f52.google.com with SMTP id s199so175345vke.1
        for <linux-ext4@vger.kernel.org>; Fri, 01 Sep 2017 05:21:58 -0700 (PDT)
In-Reply-To: <CAOQ4uxgOu5yNV3zQ9WnJU_AQtpe9G9cxQQL52fWsXd=5bvGLaQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Apologies for spam, resending plain text so it appears in the archives.


On Wed, Aug 30, 2017 at 11:06 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> [now really CC Ted]
>
> On Thu, Aug 31, 2017 at 7:05 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Thu, Aug 31, 2017 at 4:28 AM, Ashlie Martinez <ashmrtn@utexas.edu> wrote:
>>> Amir,
>>>
>>> I have been working on CrashMonkey more and I have jerry-rigged together a
>>> test in CrashMonkey that calls into `fsx` with the minimal test case you
>>> made. I am able to reproduce the ext4 error that you found along with a few
>>> other potential errors.
>>>
>>> A quick point, I run fsck with `-yf` instead of `-nf` that xfstests runs
>>> with. The reason for this is that CrashMonkey would like to report on
>>> fixable and unfixable errors in the future.
>>>
>>
>> That makes sense, but keep in mind that 'fixable' error may still loose data
>> when fixing them with -y. Perhaps you should consider running fsck is auto
>> fixing mode (i.e. e2fsck -p) when available, to classify errors as
>> 'safely fixable'
>> I believe the error these test encountered are 'safely fixable', but
>> didn't check.
>>
>>> Running the ported test case, I find that CrashMonkey encounters the
>>> following errors:
>>> 1. Incorrect inode size and incorrect free data block and inode counts
>>> (fixable)
>>> 2. incorrect free data block and inode counts (fixable)
>>> 3. `Superblock needs_recovery flag is clear, but journal has data` notice
>>> along with errors present in case 1
>>> 4. `Superblock needs_recovery flag is clear, but journal has data` notice
>>> with no other errors
>>>
>>> For the incorrect i_size errors, I get the output `Inode 12, i_size is
>>> 147456, should be 163840.` which I can also reproduce with your 501 xfstests
>>> test case.
>>>
>>> When free data blocks and inode errors occur, the message is `Free blocks
>>> count wrong (8795, counted=8714).` and `Free inodes count wrong (2549,
>>> counted=2546).`
>>>
>>> I have not had a chance to look into the above errors to find their root
>>> causes.
>>>
>>
>> I believe this is what you get when you fsck -yf before trying to mount when
>> the orphan list is not empty. You should avoid doing that.

Do you know what the kernel does when a file system like that is mounted? The
link you posted below has a comment about the kernel checking the file system
faster than fsck can. Do you know how it accomplishes this? Should the
mount -o errors=remount-ro; unmount sequence be done for all file systems or
just a select few for which the kernel knows how to handle? Does following the
mount/unmount, check sequence just mean that the kernel will silently (from the
perspective of normal users) fix some issues with the file system much like
fsck does when it is run (though perhaps less thoroughly than fsck)?

>>
>> See what the greatest ext4 crash test experiment of them all is doing
>> and read the comment to understand why:
>> https://android.googlesource.com/platform/system/core/+/marshmallow-mr1-dev/fs_mgr/fs_mgr.c#96
>> 1. mount -o  errors=remount-ro; umount
>> 2. e2fsck -y
>>
>> So upstream Android never runs e2fsck -f. It will only check fs if kernel marked
>> that fs has errors.
>> Although Cyanogenmod did add -f and I imagine that many vendors do as well.
>>
>> As one who hacked and crashed a lot of Android devices, I can attest that I have
>> observed both data loss and corrupted (non booting) fs, but the rest
>> of the 2 billion
>> crash test monkeys don't seem to be bothered ;-)
>>
>>> In total, CrashMonkey ran 1000 different tests. Of those, 344 passed without
>>> fsck complaining. The remaining 656 tests saw fsck complain about something.
>>> All of these tests consisted of unique sequences of bios, but may contain
>>> equivalent crash states.
>>>
>>> The larger range of test results is due to the fact that CrashMonkey runs
>>> many tests from just the single workload you made. These tests consist of
>>> replaying some number of bio write operations, so it tests states different
>>> than you 500 xfstest which I believe only replays to sync operations (i.e.
>>> it never stops replay before a recorded fsync).
>>
>> That is correct. test 500 (temporary name) is mostly focused on checking
>> data consistency of files after fsync. detecting metadata consistency errors
>> is a by product. I do intend to add more tests focused on metadata consistency.
>> Josef already wrote an fsstress script that should be converted to an xfstest
>> which replays the log to every FUA and fsck.
>>
>>>
>>> If you're interested, you can find the CrashMonkey code (and branch) at
>>> https://github.com/utsaslab/crashmonkey/tree/ext4_regression_bug. If you
>>> would like to run it, you should clone and build you xfstest in your home
>>> directory so that the jerry-rigged CrashMonkey test case can find it.
>>> Directions for running this test case in CrashMonkey should be at the top of
>>> the README.
>>
>> You seem to have misspelled 'fsx' in README and in the code as 'xfs'.
>> Funny, I always mistype it as 'sfx' :)

:) thanks for pointing that out, it's hard enough to spell it properly
half the time since
the test suite it's in is xfstests. Thank you for all the other
feedback and links too.

>>
>> Cheers,
>> Amir.
