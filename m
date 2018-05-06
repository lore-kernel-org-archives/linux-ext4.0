From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: kernel panic: EXT4-fs (device loop0): panic forced after error
Date: Sun, 6 May 2018 09:31:54 -0400
Message-ID: <20180506133154.GS29205@thunk.org>
References: <000000000000019f50056b7f0890@google.com>
 <20180506022428.GQ29205@thunk.org>
 <d295f575-ba4b-b0ba-a856-405f9d393c9d@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: syzbot <syzbot+a9a45987b8b2daabdc88@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, syzkaller@googlegroups.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d295f575-ba4b-b0ba-a856-405f9d393c9d@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 06, 2018 at 02:03:57PM +0900, Tetsuo Handa wrote:
> 
> Since syzbot is hitting this error path inside mount() request, calling
> panic() when something went wrong inside mount() request might be
> overkill. We can recover without shutting down the system, can't we?

We could add a full kernel-mode fsck which gets run before mount ---
the question is how much complexity we want to add.  If SELinux is
enabled, then we have to check xattr consinsistency, etc., etc.

> > I could mark this as a one-off invalid bug, but if syzkaller is going
> > to be generating classes of corrupted file systems like this, and are
> > going to be complaing about how this causes the kernel to crash, then
> > we have a fundamental syzkaller BUG.
> > 
> If we won't try to recover this case, this specific report would be
> marked as "#syz invalid".

I can do that for this specific case.  Howevre, I'd rather not have to
mark a large number of reports as invalid, if syz is going to produce
a large number of such things.  Which is why I'm raising the questihon
--- is there any way we can make syz smart enough to not raise false
positvies in this case?

In the future I can see the repro attempting to actually do stuff with
the mounted file system, which is why I want to put my foot down now
before the only answer really is adding a kernel-mode fsck before the
file system is allowed to be mounted.

Root is always going to be able to crash the system.  For example,
suppose syzkaller creates a repros which opens /dev/mem and starts
scribbling all over it.  Would we be happy if it started creating
large number of reports for that class of "bug"?

						- Ted
