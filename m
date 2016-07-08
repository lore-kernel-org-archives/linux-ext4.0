From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Cannot umount ext4 fs, no user-space procs using the fs, lsof
 points to jbd2
Date: Thu, 7 Jul 2016 22:39:07 -0400
Message-ID: <20160708023907.GD19871@thunk.org>
References: <CAN0j2-cmXW3wNmjDaKxD9Xd5O+rgyxGevjhFYquiTx92CBRT7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kamran Khan <krkhan@inspirated.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40200 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbcGHCjM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jul 2016 22:39:12 -0400
Content-Disposition: inline
In-Reply-To: <CAN0j2-cmXW3wNmjDaKxD9Xd5O+rgyxGevjhFYquiTx92CBRT7w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 07, 2016 at 04:38:39PM -0700, Kamran Khan wrote:
> Hi,
> 
> I am unmounting an ext4 filesystem (Ubuntu 16.04), fuser shows that no
> user-space processes are holding a handle to it:
> 
> > root@kakhan-ubuntu:/# fuser -vm /oldroot
> >                      USER        PID ACCESS COMMAND
> > /oldroot:            root     kernel mount /oldroot
> 
> lsof gives this:
> 
> > root@kakhan-ubuntu:/# lsof | grep sda
> > jbd2/sda1  368                  root  cwd       DIR               0,20      340          2 /
> > jbd2/sda1  368                  root  rtd       DIR               0,20      340          2 /
> > jbd2/sda1  368                  root  txt   unknown                                        /proc/368/exe

This is the jbd2 kernel thread for /dev/sda1; there is one of these
for each mounted file system, and the thread will automatically exit
with the relevant file system is umounted: unmount /dev/sda1.

For example:

# ps augxww | grep jbd2
root       319  0.0  0.0      0     0 ?        S    Jul02   0:45 [jbd2/sda3-8]
root      1284  0.0  0.0      0     0 ?        S    Jul02   0:00 [jbd2/dm-9-8]
root      1286  0.0  0.0      0     0 ?        S    Jul02   0:03 [jbd2/dm-8-8]
root      1303  0.0  0.0      0     0 ?        S    Jul02   0:01 [jbd2/dm-1-8]
root      1314  0.0  0.0      0     0 ?        S    Jul02   0:00 [jbd2/dm-10-8]
root      1334  0.0  0.0      0     0 ?        S    Jul02   0:00 [jbd2/dm-0-8]
root      7338  0.0  0.0  12748  2180 pts/3    S+   22:32   0:00 grep jbd2

# lsof -p 319
COMMAND   PID USER   FD      TYPE DEVICE SIZE/OFF NODE NAME
jbd2/sda3 319 root  cwd       DIR    8,3     4096    2 /
jbd2/sda3 319 root  rtd       DIR    8,3     4096    2 /
jbd2/sda3 319 root  txt   unknown                      /proc/319/exe

# lsof -p 1284
COMMAND    PID USER   FD      TYPE DEVICE SIZE/OFF NODE NAME
jbd2/dm-9 1284 root  cwd       DIR    8,3     4096    2 /
jbd2/dm-9 1284 root  rtd       DIR    8,3     4096    2 /
jbd2/dm-9 1284 root  txt   unknown                      /proc/1284/exe

# ls -l /dev/mapper/lambda-android
0 lrwxrwxrwx. 1 root root 7 Jul  2 23:02 /dev/mapper/lambda-android -> ../dm-9
# umount /dev/mapper/lambda-android

# ps augxww | grep jbd2
root       319  0.0  0.0      0     0 ?        S    Jul02   0:45 [jbd2/sda3-8]
root      1286  0.0  0.0      0     0 ?        S    Jul02   0:03 [jbd2/dm-8-8]
root      1303  0.0  0.0      0     0 ?        S    Jul02   0:01 [jbd2/dm-1-8]
root      1314  0.0  0.0      0     0 ?        S    Jul02   0:00 [jbd2/dm-10-8]
root      1334  0.0  0.0      0     0 ?        S    Jul02   0:00 [jbd2/dm-0-8]
root      7469  0.0  0.0  12748  2184 pts/3    S+   22:35   0:00 grep jbd2

So there's nothing wrong with the fact that you see a jbd2 thread for
/dev/sda1, and that's not the reason why you are having trouble unmounting /oldroot.

> I am unable to unmount the filesystem:
> 
> > root@kakhan-ubuntu:/# umount /oldroot
> > umount: /oldroot: target is busy
> >         (In some cases useful info about processes that
> >          use the device is found by lsof(8) or fuser(1).)
> 
> Can anyone please provide some pointers on how should I proceed with
> unmounting the filesystem?

This is more of a VFS question than an ext4 question, and
unfortunately fuser and lsof are not the only reliable ways if a file
system is still busy.

You might want to try searching /proc/.../mounts for any potential
mountpoints on top of /oldroot that might be left over from a process
which created a separate namespace, and hence wasn't affected by the
umount of /oldroot/proc, or /oldroot/sys, etc.

Cheers,

						- Ted
