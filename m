From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: kernel panic: EXT4-fs (device loop0): panic forced after error
Date: Sat, 5 May 2018 22:24:28 -0400
Message-ID: <20180506022428.GQ29205@thunk.org>
References: <000000000000019f50056b7f0890@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzkaller@googlegroups.com
To: syzbot <syzbot+a9a45987b8b2daabdc88@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000000000000019f50056b7f0890@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, May 05, 2018 at 05:57:02PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> EXT4-fs error (device loop0): ext4_iget:4756: inode #2: comm
> syz-executor909: root inode unallocated
> Kernel panic - not syncing: EXT4-fs (device loop0): panic forced after error

I don't get why syzbot considers this a bug.  It created a corrupted
file system, mounted it as root, and said file system had the flag
which says, "panic if you find a file system corruption".

In what world is this a security bug?  There's a *reason* why I've
always said people who want to containers to be allowed to mount
arbitrary file systems controlled by potentially malicious container
users are insane....

I could mark this as a one-off invalid bug, but if syzkaller is going
to be generating classes of corrupted file systems like this, and are
going to be complaing about how this causes the kernel to crash, then
we have a fundamental syzkaller BUG.

					- Ted
