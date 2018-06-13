From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in ext4_set_page_dirty
Date: Wed, 13 Jun 2018 17:55:42 +0200
Message-ID: <CACT4Y+bwuRKAXj7gkPa3=ADk7JMBRd61YCWr=6bRkd6fmz_fCQ@mail.gmail.com>
References: <089e0825cec8180a2b0568c4ee1d@google.com> <0000000000003a8d73056cb11ca3@google.com>
 <20180521125000.hlgdsvlzlr7xw3bx@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot <syzbot+9a44753ac327c557796a@syzkaller.appspotmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180521125000.hlgdsvlzlr7xw3bx@quack2.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 21, 2018 at 2:50 PM, Jan Kara <jack@suse.cz> wrote:
> On Sun 20-05-18 23:07:02, syzbot wrote:
>> syzbot has found a reproducer for the following crash on:
>>
>> HEAD commit:    771c577c23ba Linux 4.17-rc6
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=108c9f37800000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=982e2df1b9e60b02
>> dashboard link: https://syzkaller.appspot.com/bug?extid=9a44753ac327c557796a
>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>> syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=1655584f800000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15134357800000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+9a44753ac327c557796a@syzkaller.appspotmail.com
>>
>> WARNING: CPU: 0 PID: 4577 at fs/ext4/inode.c:3894
>> ext4_set_page_dirty+0x28d/0x330 fs/ext4/inode.c:3894
>> Kernel panic - not syncing: panic_on_warn set ...
>
> Looking at the reproducer, this is the issue we have been speaking about at
> LSF/MM - direct IO read dirties pages after writeback has written them out
> and so we don't expect them to be dirtied. If someone told me I would not
> believe this is possible to hit by fuzzing ;) Good job from the syzkaller
> guys!

Thanks, Jan! Very nice to hear.
I believe we are not yet at the limit of what's possible :)
