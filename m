From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: kernel panic: EXT4-fs (device loop0): panic forced after error
Date: Tue, 12 Jun 2018 16:01:15 +0200
Message-ID: <CACT4Y+Z+2YW_VALJzzQr6hLsviA=dXk3iFqwVf+P5zqojeC9Zg@mail.gmail.com>
References: <000000000000019f50056b7f0890@google.com> <20180506022428.GQ29205@thunk.org>
 <d295f575-ba4b-b0ba-a856-405f9d393c9d@I-love.SAKURA.ne.jp>
 <20180506133154.GS29205@thunk.org> <201805062340.HFC78625.VFFFOHSOtQMOJL@I-love.SAKURA.ne.jp>
 <20180506203046.GV29205@thunk.org> <CACT4Y+YhpkZt2ufQo+hBV8FkAPE+wzxM1PUhQSZbQFWFR9bW_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+a9a45987b8b2daabdc88@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+YhpkZt2ufQo+hBV8FkAPE+wzxM1PUhQSZbQFWFR9bW_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 14, 2018 at 11:12 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Sun, May 6, 2018 at 10:30 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
>> On Sun, May 06, 2018 at 11:40:10PM +0900, Tetsuo Handa wrote:
>>> > We could add a full kernel-mode fsck which gets run before mount ---
>>> > the question is how much complexity we want to add.  If SELinux is
>>> > enabled, then we have to check xattr consinsistency, etc., etc.
>>>
>>> You are thinking too complicated. I'm not asking for kernel-mode fsck.
>>
>> That is the logical outcome of what you are asking for.  There will
>> *always* be a point after which where we can't atomically unwind the
>> mount, and we have to proceed.  And after that point, when we detect
>> an inconsistency all we can do is what the system administrator
>> requested that we do.  Sure, for this particular case, we can
>> significantly add more complexity and decrease the maintainability of
>> the code paths involved.  But there will always be another case
>> (e.g,. xattr's being read by SELinux or IMA) that will happen during
>> the mount, and are we expected to catch all of those cases?
>>
>> We do catch a lot of cases where we refuse the mount and complain that
>> the file system is badly corrupted.  This just doesn't happen to be
>> one of them.
>>
>>> I'm just suggesting that mount() request returns an error to the caller
>>> (and the administrator invokes fsck etc. as needed).
>>>
>>> We are fixing bugs which occur during mount operation (e.g.
>>>
>>>   https://groups.google.com/d/msg/syzkaller-bugs/Yp4q8n-MijM/yDX3zl1XBQAJ
>>>   https://groups.google.com/d/msg/syzkaller-bugs/4C4oiBX8vZ0/W6pi8NdbBgAJ
>>>   https://groups.google.com/d/msg/syzkaller-bugs/QBnHAQBy2pI/ccf-yL5bBgAJ
>>
>> These are different because there are kernel OOPS or warning messages.
>> This is neither a kernel OOPS or a WARN_ON or BUG_ON.
>>
>>> And extX filesystem is different from other filesystems that it invokes
>>> error action specified by errors= parameter rather than return an error to
>>> the caller.
>>
>> Syzkaller (or anyone else) can mount the file system with
>> errors=continue or errors=remount-ro if it wants to override the
>> requested behavior of the flag in the superblock which is manipulated
>> by tune2fs.
>
>
> Filed https://github.com/google/syzkaller/issues/599 to always pass
> errors=remount-ro when mounting ext4.

This was fixed in syzkaller. With this commit:
https://github.com/google/syzkaller/commit/deb0e69e1028ba3152631c3f1d2fac98c12e33a5
syzkaller should always pass errors=continue when mounting ext2/3/4.

#syz invalid
