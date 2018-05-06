From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: kernel panic: EXT4-fs (device loop0): panic forced after error
Date: Sun, 6 May 2018 11:15:45 +0200
Message-ID: <CACT4Y+YDy2GTXV=q6B+zqXtnz5nsZsbisxy1T=_R=PLNdAqcog@mail.gmail.com>
References: <000000000000019f50056b7f0890@google.com> <20180506022428.GQ29205@thunk.org>
 <d295f575-ba4b-b0ba-a856-405f9d393c9d@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+a9a45987b8b2daabdc88@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d295f575-ba4b-b0ba-a856-405f9d393c9d@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 6, 2018 at 7:03 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> On 2018/05/06 11:24, Theodore Y. Ts'o wrote:
>> On Sat, May 05, 2018 at 05:57:02PM -0700, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following crash on:
>>>
>>> EXT4-fs error (device loop0): ext4_iget:4756: inode #2: comm
>>> syz-executor909: root inode unallocated
>>> Kernel panic - not syncing: EXT4-fs (device loop0): panic forced after error
>>
>> I don't get why syzbot considers this a bug.  It created a corrupted
>> file system, mounted it as root, and said file system had the flag
>> which says, "panic if you find a file system corruption".
> In what world is this a security bug?

Hi Ted,

Do you mean why syzbot considers kernel panics as something to report?
Or why syzbot has not understood why this panic is somehow special?
syzbot doesn't report only security problems. It just reports bugs.
E.g. NULL derefs and deadlocks are also not security bugs, but are
reported.


> "panic if file system error occurred (so that we won't continue with
> inconsistent state)", doesn't it?
>
> Since syzbot is hitting this error path inside mount() request, calling
> panic() when something went wrong inside mount() request might be
> overkill. We can recover without shutting down the system, can't we?

Can you please give me background regarding purpose of this flag?
What's the intended use case? And what exactly is corrupted?
If kernel detects that an image is corrupted during mount shouldn't it
just report an error? If I am reading this correctly, any USB cable
that plug into my computer can shut it down. Or maybe even existing
cables can shut down all computers in a country on a remote command.
Am I missing something here?


>> In what world is this a security bug?  There's a *reason* why I've
>> always said people who want to containers to be allowed to mount
>> arbitrary file systems controlled by potentially malicious container
>> users are insane....
>>
>> I could mark this as a one-off invalid bug, but if syzkaller is going
>> to be generating classes of corrupted file systems like this, and are
>> going to be complaing about how this causes the kernel to crash, then
>> we have a fundamental syzkaller BUG.
>>
>>                                       - Ted
>
> If we won't try to recover this case, this specific report would be
> marked as "#syz invalid".
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/d295f575-ba4b-b0ba-a856-405f9d393c9d%40I-love.SAKURA.ne.jp.
> For more options, visit https://groups.google.com/d/optout.
