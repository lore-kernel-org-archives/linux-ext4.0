Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f195.google.com ([209.85.166.195]:50638 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbeJ3VDT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2018 17:03:19 -0400
Received: by mail-it1-f195.google.com with SMTP id k206-v6so13383065ite.0
        for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2018 05:10:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181016155341.GF8983@thunk.org>
References: <0000000000002753c60577b9f707@google.com> <CACT4Y+bdR3ch9q_FCND4YmqjunYBVbEk3n167DT0r0GqzVKL-g@mail.gmail.com>
 <20181009013425.GB3369@thunk.org> <CACT4Y+a08tYAgXKEiTO+A-RDrSNk-RdhDxvGCM6bAbk5bckH6A@mail.gmail.com>
 <20181015180821.GE8983@thunk.org> <CACT4Y+bs72L4GKF7K6zHHqDGfURymzUke7UT6CKtakLWu+f94g@mail.gmail.com>
 <20181016155341.GF8983@thunk.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 30 Oct 2018 13:09:44 +0100
Message-ID: <CACT4Y+Zoa7mzVGKqRERgg_knN6fDYzEO_SS7TxLZhtEmesqBsw@mail.gmail.com>
Subject: Re: WARNING in ext4_invalidatepage
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+85da7ac734f7ba432ee4@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 16, 2018 at 5:53 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Tue, Oct 16, 2018 at 04:02:07PM +0200, Dmitry Vyukov wrote:
>> I am not sure how exactly this should be classified. To significant
>> degree these "$FOO" discriminations are informational and only really
>> affect the data format passed in.
>
> The problem is that putting something which is simply and plainly
> *wrong* is going to be actively misleading.  You *have* to know what
> ioctl you are trying to be trying to execute because some of them
> require input data structures that you have to fill in, or that it
> requires a file descriptor as opposed to an integer or a pointer to a
> struct.  I assume you're not just picking ioctl numbers purely at
> random, right?
>
> So I assume you had a table that said, this ioctl, 0x6611 takes a file
> descriptor, and has thus-and-so-a-name.  If that name is wrong, I'd
> say it's pretty clearly a bug, right?

We have such table and it is correct. But it is legal and fine and
actually useful in context of testing to take an ioctl that takes a
pointer to one structure and give it pointer to another structure, or
plain int or just anything else. $FOO states what data layout is used
and actual cmd number and fd type what command is executed.

> (I'll again gently point out that a tiny amount of work in making
> syzkaller a tiny bit more developer toil would make it much more
> effective, since all of this extra developer toil --- now I know I
> can't even trust the $FOO discriminators to be right --- makes
> syzkaller less scalable by pursuading developers that it's not
> worthwhile to pay attention...)

Ted, I appreciate your suggestions. And the new table-structured email
format that you proposed is great.
But there are reasons for the current syzkaller program format. It's
not just there is a typo in some table that we need to fix. The $FOO
part encodes data layout and treatment of argument values (e.g. if
0xab actually takes a byte or a word, and what's it alignment). It's
not something that can be restored from anything else. So if we lose
this information, the program will useless and confusing in other
ways. For example, consider an ioctl accepts a struct with 2 byte
fields; but we actually executed it passing a struct with 2 int
fields. Now if you look at {0x1, 0x2} you will assume that these are
the byte values, but in reality it's 0x1 int which covered both 1-byte
arguments.
Also consider that ioctl cmd is actually meaningless in itself, and
it's generally not possible to statically know what exactly ioctl will
be executed. The crucial piece is fd type. I guess it boils down to
the halting problem to statically prove what fd type we will have in a
random program. Even worse, we can have a race on fd type, so it's
non-deterministic and even not detectable dynamically. Taking this
into account any attempts to preserve matching $FOO and cmd number are
pointless.
