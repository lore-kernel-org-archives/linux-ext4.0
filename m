From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH] fstests: regression test for ext4 crash consistency bug
Date: Sun, 27 Aug 2017 13:41:52 +0300
Message-ID: <CAOQ4uxhxz-xu-5x4qr_4YDa2JQwaWQXTB7cvqPVDytDPX9MdWA@mail.gmail.com>
References: <1503829290-10103-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eryu Guan <eguan@redhat.com>, Josef Bacik <jbacik@fb.com>,
        fstests <fstests@vger.kernel.org>,
        Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:33350 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdH0Klx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Aug 2017 06:41:53 -0400
In-Reply-To: <1503829290-10103-1-git-send-email-amir73il@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 27, 2017 at 1:21 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> This test is motivated by a bug found in ext4 during random crash
> consistency tests.
>
> This test uses device mapper flakey target to demonstrate the bug
> found using device mapper log-writes target.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Ted,
>
> While working on crash consistency xfstests [1], I stubmled on what
> appeared to be an ext4 crash consistency bug.
>
> The tests I used rely on the log-writes dm target code written
> by Josef Bacik, which had little exposure to the wide community
> as far as I know.  I wanted to prove to myself that the found
> inconsistency was not due to a test bug, so I bisected the failed
> test to the minimal operations that trigger the failure and wrote
> a small independent test to reproduce the issue using dm flakey target.
>
> The following fsck error is reliably reproduced by replaying 3 fsx ops
> (write, zero_range, mapwrite) on overlapping regions, then
> emulating a crash, followed by mount and umount:
>
>   ./ltp/fsx -d --replay-ops /tmp/8995.fsxops /mnt/scratch/testfile
>   1 write 0x3e5ec thru    0x3ffff (0x1a14 bytes)
>   2 zero  from 0x20fac to 0x27d48, (0x6d9c bytes)
>   3 mapwrite      0x216ad thru    0x23dfb (0x274f bytes)
>   All 4 operations completed A-OK!
>   _check_generic_filesystem: filesystem on /dev/mapper/ssd-scratch is inconsistent
>   *** fsck.ext4 output ***
>   fsck from util-linux 2.27.1
>   e2fsck 1.42.13 (17-May-2015)
>   Pass 1: Checking inodes, blocks, and sizes
>   Inode 12, i_size is 147456, should be 163840.  Fix? no
>

Sorry, I wanted to report a different (additional) error - re-sending..
