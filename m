From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in rb_insert_color
Date: Wed, 20 Dec 2017 09:05:39 +0100
Message-ID: <CACT4Y+Y9SRDEZA5sbOAQ5NAbmMT=ae-uPQ2np4s+Eug9-b-MHw@mail.gmail.com>
References: <94eb2c1170ce36bd770560ad6d3a@google.com> <20171219215906.GA12465@gmail.com>
 <CACT4Y+Y1ZP=q1DUDxWG4jLyLXGs5XkyTz=H+ozd3V6Az6Npjng@mail.gmail.com> <20171220075947.GA6565@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot
        <bot+eb13811afcefe99cfe45081054e7883f569f949d@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, "Theodore Ts'o" <tytso@mit.edu>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:35160 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdLTIGA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Dec 2017 03:06:00 -0500
Received: by mail-pg0-f48.google.com with SMTP id q20so11654040pgv.2
        for <linux-ext4@vger.kernel.org>; Wed, 20 Dec 2017 00:06:00 -0800 (PST)
In-Reply-To: <20171220075947.GA6565@zzz.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 20, 2017 at 8:59 AM, Eric Biggers <ebiggers3@gmail.com> wrote:
> On Wed, Dec 20, 2017 at 08:50:40AM +0100, Dmitry Vyukov wrote:
>> >
>> > The line number in lib/rbtree.c seems to be slightly off.  Looking at the
>> > disassembly:
>> >
>> >         ffffffff825b5ea0 <rb_insert_color>:
>> >         ffffffff825b5ea0:       55                      push   %rbp
>> >         ffffffff825b5ea1:       48 8b 17                mov    (%rdi),%rdx
>> >         ffffffff825b5ea4:       48 89 e5                mov    %rsp,%rbp
>> >         ffffffff825b5ea7:       48 85 d2                test   %rdx,%rdx
>> >         ffffffff825b5eaa:       0f 84 4c 01 00 00       je     ffffffff825b5ffc <rb_insert_color+0x15c>
>> >         ffffffff825b5eb0:       48 8b 02                mov    (%rdx),%rax
>> >         ffffffff825b5eb3:       a8 01                   test   $0x1,%al
>> >         ffffffff825b5eb5:       75 5e                   jne    ffffffff825b5f15 <rb_insert_color+0x75>
>> >         ffffffff825b5eb7:       48 8b 48 08             mov    0x8(%rax),%rcx
>> >
>> > It crashed on 'mov 0x8(%rax),%rcx' which corresponds to
>> > 'tmp = gparent->rb_right;' at lib/rbtree.c:131.  So 'parent' was the root node,
>> > but its color was red, while it is supposed to be black.
>> >
>> > No idea how that happened, but it's almost certainly not an ext4 bug.  In fact
>> > there is another report of this same crash that has a different call trace:
>> >
>> >         Call Trace:
>> >          key_alloc_serial security/keys/key.c:170 [inline]
>> >          key_alloc+0x54c/0x5b0 security/keys/key.c:319
>> >          keyring_alloc+0x4d/0xb0 security/keys/keyring.c:503
>> >          install_process_keyring_to_cred.part.3+0x38/0x80 security/keys/process_keys.c:192
>> >          install_process_keyring_to_cred security/keys/process_keys.c:634 [inline]
>> >          install_process_keyring security/keys/process_keys.c:217 [inline]
>> >          lookup_user_key+0x4ed/0x7c0 security/keys/process_keys.c:574
>> >          SYSC_add_key security/keys/keyctl.c:114 [inline]
>> >          SyS_add_key+0xec/0x260 security/keys/keyctl.c:62
>> >          entry_SYSCALL_64_fastpath+0x1f/0x96
>>
>>
>> My first hypothesis for an non-explainable, non-reproducible
>> corruption would be a data race. Is there all locking in place?
>
> It doesn't seem to be a locking problem.  In the ext4 case the rbtree is
> associated with a struct file's dir_private_info, which is protected by
> ->f_pos_lock (taken early in sys_getdents()).

But this won't prevent somebody else to mess with the struct without
taking the lock.

> And in the keyrings case, the
> rbtree is protected by key_serial_lock.
