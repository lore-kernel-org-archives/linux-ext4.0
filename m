From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: kernel panic: EXT4-fs (device loop0): panic forced after error
Date: Sun, 6 May 2018 14:03:57 +0900
Message-ID: <d295f575-ba4b-b0ba-a856-405f9d393c9d@I-love.SAKURA.ne.jp>
References: <000000000000019f50056b7f0890@google.com>
 <20180506022428.GQ29205@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        syzbot <syzbot+a9a45987b8b2daabdc88@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180506022428.GQ29205@thunk.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2018/05/06 11:24, Theodore Y. Ts'o wrote:
> On Sat, May 05, 2018 at 05:57:02PM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> EXT4-fs error (device loop0): ext4_iget:4756: inode #2: comm
>> syz-executor909: root inode unallocated
>> Kernel panic - not syncing: EXT4-fs (device loop0): panic forced after error
> 
> I don't get why syzbot considers this a bug.  It created a corrupted
> file system, mounted it as root, and said file system had the flag
> which says, "panic if you find a file system corruption".

"panic if file system error occurred (so that we won't continue with
inconsistent state)", doesn't it?

Since syzbot is hitting this error path inside mount() request, calling
panic() when something went wrong inside mount() request might be
overkill. We can recover without shutting down the system, can't we?

> 
> In what world is this a security bug?  There's a *reason* why I've
> always said people who want to containers to be allowed to mount
> arbitrary file systems controlled by potentially malicious container
> users are insane....
> 
> I could mark this as a one-off invalid bug, but if syzkaller is going
> to be generating classes of corrupted file systems like this, and are
> going to be complaing about how this causes the kernel to crash, then
> we have a fundamental syzkaller BUG.
> 
> 					- Ted

If we won't try to recover this case, this specific report would be
marked as "#syz invalid".
