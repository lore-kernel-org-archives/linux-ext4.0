Return-Path: <SRS0=zKcc=NK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:39624 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeJ3VJr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Oct 2018 17:09:47 -0400
Received: by mail-it1-f193.google.com with SMTP id m15so13358016itl.4
        for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2018 05:16:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20181016155341.GF8983@thunk.org>
References: <0000000000002753c60577b9f707@google.com> <CACT4Y+bdR3ch9q_FCND4YmqjunYBVbEk3n167DT0r0GqzVKL-g@mail.gmail.com>
 <20181009013425.GB3369@thunk.org> <CACT4Y+a08tYAgXKEiTO+A-RDrSNk-RdhDxvGCM6bAbk5bckH6A@mail.gmail.com>
 <20181015180821.GE8983@thunk.org> <CACT4Y+bs72L4GKF7K6zHHqDGfURymzUke7UT6CKtakLWu+f94g@mail.gmail.com>
 <20181016155341.GF8983@thunk.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 30 Oct 2018 13:16:11 +0100
Message-ID: <CACT4Y+b3rujNu+kJFaEmZzwOWSHuFYpYVJ4q3vvY62FtQ8+7xA@mail.gmail.com>
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
>> > The patch I referenced in my previous e-mail protects against
>> > additional scenarios where someone might be trying to punch a whole
>> > into a file that is being swapped into the bootloader ioctl.  This
>> > particular ioctl isn't yet being used by anyone, so it had some other
>> > issues as well, such as not interacting well with inline_data-enabled
>> > file systems --- not that any bootloader would be small enough that it
>> > would fit in an inline_data inode, but we're basically proofing the
>> > code against a malicious (or buggy) root-privileged program... such as
>> > syzbot.  :-)
>>
>> ... or paving the way to opening all of this to non-root users. Why
>> not if not bugs? ;)
>
> The intent behind this particular ioctl is used to install a boot
> loader.  It will *never* be opened to non-root users.  It doesn't even
> make sense to make it available to pseudo-containers-root users.  :-)

But it does not have to be executed on the root fs, right? Or is it?
For example, if I need to build a bootable image (which I actually
need to do for syzkaller). In the end it boils down to just creating a
local, private file with some particular contents. Should be nobody's
business, right? But for some reason on Linux creation of a local file
requires root privileges multiple times along the way. As the result I
have run the whole service as root, degrading overall security. And I
can't say that I fully trust all code and data involved, but Linux
simply does not give me any choice.
