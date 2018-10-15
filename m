Return-Path: <SRS0=/GAa=M3=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44362 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbeJPByo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 15 Oct 2018 21:54:44 -0400
Date: Mon, 15 Oct 2018 14:08:21 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+85da7ac734f7ba432ee4@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING in ext4_invalidatepage
Message-ID: <20181015180821.GE8983@thunk.org>
References: <0000000000002753c60577b9f707@google.com>
 <CACT4Y+bdR3ch9q_FCND4YmqjunYBVbEk3n167DT0r0GqzVKL-g@mail.gmail.com>
 <20181009013425.GB3369@thunk.org>
 <CACT4Y+a08tYAgXKEiTO+A-RDrSNk-RdhDxvGCM6bAbk5bckH6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+a08tYAgXKEiTO+A-RDrSNk-RdhDxvGCM6bAbk5bckH6A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 15, 2018 at 03:22:42PM +0200, Dmitry Vyukov wrote:
> Now that you mention EXT4_IOC_SWAP_BOOT, I think I looked at the wrong
> program, there is a subsequent one that does ioctl(0x6611) where
> 0x6611 is in fact EXT4_IOC_SWAP_BOOT. So I think it's this one:
> 
> 05:23:28 executing program 5:
> r0 = creat(&(0x7f00000001c0)='./file0\x00', 0x0)
> socketpair$unix(0x1, 0x1, 0x0, &(0x7f0000000380)={0xffffffffffffffff,
> <r1=>0xffffffffffffffff})
> write$RDMA_USER_CM_CMD_CREATE_ID(r0, &(0x7f0000000240)={0x0, 0x18,
> 0xfa00, {0x0, &(0x7f0000000200)}}, 0x20)
> ioctl$PERF_EVENT_IOC_ENABLE(r1, 0x8912, 0x400200)
> ioctl$EXT4_IOC_SETFLAGS(r0, 0x6611, &(0x7f0000000000)=0x4000)

Ah, so is it a bug in Syzkaller that it is printing
ioctl$EXT4_IOC_SETFLAGS when 0x6611 is in fact EXT4_IOC_SWAP_BOOT,
right?

> I've tried to manually reply this program and the whole log too, but
> it does not reproduce. This may be related to the fact that filesystem
> accumulates too much global state, so probably first relevant part
> happened long time ago, and then second relevant part happened later
> and triggered the warning. But just re-doing the second part does not
> reproduce the bug.

It was probably some other process racing with EXT4_IOC_SWAP_BOOT.
The patch I referenced in my previous e-mail protects against
additional scenarios where someone might be trying to punch a whole
into a file that is being swapped into the bootloader ioctl.  This
particular ioctl isn't yet being used by anyone, so it had some other
issues as well, such as not interacting well with inline_data-enabled
file systems --- not that any bootloader would be small enough that it
would fit in an inline_data inode, but we're basically proofing the
code against a malicious (or buggy) root-privileged program... such as
syzbot.  :-)

						- Ted
