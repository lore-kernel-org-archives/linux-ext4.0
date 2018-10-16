Return-Path: <SRS0=eFe4=M4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49258 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbeJPXos (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:48 -0400
Date: Tue, 16 Oct 2018 11:53:41 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+85da7ac734f7ba432ee4@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING in ext4_invalidatepage
Message-ID: <20181016155341.GF8983@thunk.org>
References: <0000000000002753c60577b9f707@google.com>
 <CACT4Y+bdR3ch9q_FCND4YmqjunYBVbEk3n167DT0r0GqzVKL-g@mail.gmail.com>
 <20181009013425.GB3369@thunk.org>
 <CACT4Y+a08tYAgXKEiTO+A-RDrSNk-RdhDxvGCM6bAbk5bckH6A@mail.gmail.com>
 <20181015180821.GE8983@thunk.org>
 <CACT4Y+bs72L4GKF7K6zHHqDGfURymzUke7UT6CKtakLWu+f94g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+bs72L4GKF7K6zHHqDGfURymzUke7UT6CKtakLWu+f94g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 16, 2018 at 04:02:07PM +0200, Dmitry Vyukov wrote:
> I am not sure how exactly this should be classified. To significant
> degree these "$FOO" discriminations are informational and only really
> affect the data format passed in.

The problem is that putting something which is simply and plainly
*wrong* is going to be actively misleading.  You *have* to know what
ioctl you are trying to be trying to execute because some of them
require input data structures that you have to fill in, or that it
requires a file descriptor as opposed to an integer or a pointer to a
struct.  I assume you're not just picking ioctl numbers purely at
random, right?

So I assume you had a table that said, this ioctl, 0x6611 takes a file
descriptor, and has thus-and-so-a-name.  If that name is wrong, I'd
say it's pretty clearly a bug, right?

(I'll again gently point out that a tiny amount of work in making
syzkaller a tiny bit more developer toil would make it much more
effective, since all of this extra developer toil --- now I know I
can't even trust the $FOO discriminators to be right --- makes
syzkaller less scalable by pursuading developers that it's not
worthwhile to pay attention...)

> > The patch I referenced in my previous e-mail protects against
> > additional scenarios where someone might be trying to punch a whole
> > into a file that is being swapped into the bootloader ioctl.  This
> > particular ioctl isn't yet being used by anyone, so it had some other
> > issues as well, such as not interacting well with inline_data-enabled
> > file systems --- not that any bootloader would be small enough that it
> > would fit in an inline_data inode, but we're basically proofing the
> > code against a malicious (or buggy) root-privileged program... such as
> > syzbot.  :-)
> 
> ... or paving the way to opening all of this to non-root users. Why
> not if not bugs? ;)

The intent behind this particular ioctl is used to install a boot
loader.  It will *never* be opened to non-root users.  It doesn't even
make sense to make it available to pseudo-containers-root users.  :-)

							- Ted
