From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: kernel panic: EXT4-fs (device loop0): panic forced after error
Date: Sun, 6 May 2018 16:30:47 -0400
Message-ID: <20180506203046.GV29205@thunk.org>
References: <000000000000019f50056b7f0890@google.com>
 <20180506022428.GQ29205@thunk.org>
 <d295f575-ba4b-b0ba-a856-405f9d393c9d@I-love.SAKURA.ne.jp>
 <20180506133154.GS29205@thunk.org>
 <201805062340.HFC78625.VFFFOHSOtQMOJL@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot+a9a45987b8b2daabdc88@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201805062340.HFC78625.VFFFOHSOtQMOJL@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 06, 2018 at 11:40:10PM +0900, Tetsuo Handa wrote:
> > We could add a full kernel-mode fsck which gets run before mount ---
> > the question is how much complexity we want to add.  If SELinux is
> > enabled, then we have to check xattr consinsistency, etc., etc.
> 
> You are thinking too complicated. I'm not asking for kernel-mode fsck.

That is the logical outcome of what you are asking for.  There will
*always* be a point after which where we can't atomically unwind the
mount, and we have to proceed.  And after that point, when we detect
an inconsistency all we can do is what the system administrator
requested that we do.  Sure, for this particular case, we can
significantly add more complexity and decrease the maintainability of
the code paths involved.  But there will always be another case
(e.g,. xattr's being read by SELinux or IMA) that will happen during
the mount, and are we expected to catch all of those cases?

We do catch a lot of cases where we refuse the mount and complain that
the file system is badly corrupted.  This just doesn't happen to be
one of them.

> I'm just suggesting that mount() request returns an error to the caller
> (and the administrator invokes fsck etc. as needed).
> 
> We are fixing bugs which occur during mount operation (e.g.
> 
>   https://groups.google.com/d/msg/syzkaller-bugs/Yp4q8n-MijM/yDX3zl1XBQAJ
>   https://groups.google.com/d/msg/syzkaller-bugs/4C4oiBX8vZ0/W6pi8NdbBgAJ
>   https://groups.google.com/d/msg/syzkaller-bugs/QBnHAQBy2pI/ccf-yL5bBgAJ

These are different because there are kernel OOPS or warning messages.
This is neither a kernel OOPS or a WARN_ON or BUG_ON.

> And extX filesystem is different from other filesystems that it invokes
> error action specified by errors= parameter rather than return an error to
> the caller.

Syzkaller (or anyone else) can mount the file system with
errors=continue or errors=remount-ro if it wants to override the
requested behavior of the flag in the superblock which is manipulated
by tune2fs.

						- Ted
