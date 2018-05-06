From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: kernel panic: EXT4-fs (device loop0): panic forced after error
Date: Sun, 6 May 2018 09:50:02 -0400
Message-ID: <20180506135002.GT29205@thunk.org>
References: <000000000000019f50056b7f0890@google.com>
 <20180506022428.GQ29205@thunk.org>
 <d295f575-ba4b-b0ba-a856-405f9d393c9d@I-love.SAKURA.ne.jp>
 <CACT4Y+YDy2GTXV=q6B+zqXtnz5nsZsbisxy1T=_R=PLNdAqcog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot <syzbot+a9a45987b8b2daabdc88@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+YDy2GTXV=q6B+zqXtnz5nsZsbisxy1T=_R=PLNdAqcog@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, May 06, 2018 at 11:15:45AM +0200, Dmitry Vyukov wrote:
> >> I don't get why syzbot considers this a bug.  It created a corrupted
> >> file system, mounted it as root, and said file system had the flag
> >> which says, "panic if you find a file system corruption".
> > In what world is this a security bug?
> 
> Do you mean why syzbot considers kernel panics as something to report?
> Or why syzbot has not understood why this panic is somehow special?
> syzbot doesn't report only security problems. It just reports bugs.
> E.g. NULL derefs and deadlocks are also not security bugs, but are
> reported.

EXT4-fs (device loop0): panic forced after error

This is working as intended.  See the tune2fs man page.

     -e error-behavior
              Change the behavior of the kernel code when errors are
              detected.  In all cases, a filesystem error will cause
              e2fsck(8) to check the filesystem on the next boot.
              error-behavior can be one of the following:

                   continue    Continue normal execution.

                   remount-ro  Remount filesystem read-only.

                   panic       Cause a kernel panic.


> Can you please give me background regarding purpose of this flag?
> What's the intended use case? And what exactly is corrupted?

When the file system is corrupted, you might not want to continue
processing.  If you have some kind High Availability system available,
having the system shutdown so the secondary/backup system can take
over for the corrupted file system.  This might be better than
continuing to steer the spaceship, or continuning to control the x-ray
dosage received by a patient, etc., etc.

> If kernel detects that an image is corrupted during mount shouldn't it
> just report an error?

The problem is that this would, in the general case, putting in a full
or partial kernel-mode fsck and requiring it to be run before mount.
Sure, I could add more complexity in the system to bypass the check in
iget() if it is being called from mount, but what if SELinux is
running and it tries to fetch an xattr?  Or what if Syzkaller's
repro.c decides to start reading or writing files, or deleting files
in the directory?

More generally, root can always do stuff which will cause the system
to crash or shut down.  It can kexec a file containing garbage; it can
call the shutdown system call.  Presumably it is not reasonable to
require the kexec(2) system call to validate the image before
transfering control to it?  After all, that would require solving the
Halting Problem.  :-)

> If I am reading this correctly, any USB cable
> that plug into my computer can shut it down. Or maybe even existing
> cables can shut down all computers in a country on a remote command.
> Am I missing something here?

If you have physical access to the machine, you can shut it down.  And
there cases when shutting down a system or even all of the computers
in a cluster is the right thing to do.  Not shutting down the computer
could actually have harmful physical effects (e.g., a transformer
blowing up, a centrifuge tearing itself apart[1], etc.)  The system
administrator should have the choice to set up a file system such that
if an inconsistency is detected.

						- Ted

[1] Although if the centrifuge is in Iran, and you are in the NSA,
that might be considered a feature, not a bug.  Of course, if the
transformer is in the US or Germany, and the entity triggering a bug
which causes it to blow up is sponsored by Russia, then of course
that's a different story.  :-)
