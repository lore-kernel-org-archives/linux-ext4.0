From: thanumalayan mad <madthanu@gmail.com>
Subject: Re: e2fsck exit codes
Date: Tue, 14 Feb 2017 11:00:51 -0800
Message-ID: <CAJ6LpRpe6KfwoWvCw6cDwWg6=BxtcbXnSjLN358OgZ2obGcxsQ@mail.gmail.com>
References: <CAJ6LpRpE71KHDip2Eb380xQ8nQQUyPCrOCFekK5xuz4JFhn5Pg@mail.gmail.com>
 <20170214170101.irgf4uvvvbbepmip@thunk.org>
Reply-To: madthanu@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:33255 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbdBNTBN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Feb 2017 14:01:13 -0500
Received: by mail-ot0-f173.google.com with SMTP id 73so101371456otj.0
        for <linux-ext4@vger.kernel.org>; Tue, 14 Feb 2017 11:01:13 -0800 (PST)
In-Reply-To: <20170214170101.irgf4uvvvbbepmip@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you for the quick reply! (I was curious about the free-blocks
count too, so thanks for explaining that.) Reponses inlined:

On Tue, Feb 14, 2017 at 9:01 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> The way you can tell whether or not the file system has errors is to
> run e2fsck -fn:
>
> % e2fsck -fn /tmp/foo.img
> e2fsck 1.43.4 (31-Jan-2017)
> Warning: skipping journal recovery because doing a read-only filesystem check.
> Pass 1: Checking inodes, blocks, and sizes
> Inode 15 extent tree (at level 1) could be shorter.  Fix? no
>
> Inode 115 extent tree (at level 1) could be shorter.  Fix? no
>
> Inode 365 extent tree (at level 1) could be shorter.  Fix? no
>
> Inode 741 extent tree (at level 1) could be shorter.  Fix? no
>
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Free blocks count wrong (6830, counted=163).
> Fix? no
>
> Free inodes count wrong (2037, counted=0).
> Fix? no
>
> /tmp/foo.img: 11/2048 files (900.0% non-contiguous), 1362/8192 blocks
> % echo $?
> 0
>
> If the file system has an error that needs to be fixed, it will return
> an exit status of 4:

I also tested "fsck.ext4 -fn", and it returns 4 even when there is no
disk corruption. That said, doing a "fsck -E journal_only" followed by
a "fsck -fn" does seem to work:

=====

desky madthanu # fsck.ext4 -fn /dev/sdb
e2fsck 1.42.13 (17-May-2015)
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Entry '1' in / (2) references inode 524289 in group 64 where
_INODE_UNINIT is set.
Fix? no
Entry '1' in / (2) has deleted/unused inode 524289.  Clear? no
Entry '2' in / (2) references inode 131073 in group 16 where
_INODE_UNINIT is set.
Fix? no
Entry '2' in / (2) has deleted/unused inode 131073.  Clear? no
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Inode 2 ref count is 5, should be 3.  Fix? no
Pass 5: Checking group summary information
Block bitmap differences:  -(8871--9768) -(2105376--2106287)
Fix? no
Free blocks count wrong for group #0 (23897, counted=22999).
Fix? no
Free blocks count wrong for group #64 (24544, counted=23632).
Fix? no
Free blocks count wrong (2541777, counted=2539967).
Fix? no
Inode bitmap differences:  -(12--8192)
Fix? no
Free inodes count wrong for group #0 (8181, counted=0).
Fix? no
Free inodes count wrong (655349, counted=647168).
Fix? no
/dev/sdb: ********** WARNING: Filesystem still has errors **********
/dev/sdb: 11/655360 files (0.0% non-contiguous), 79663/2621440 blocks

desky madthanu # echo $?
4

desky madthanu # fsck.ext4 -E journal_only /dev/sdb
e2fsck 1.42.13 (17-May-2015)
/dev/sdb: recovering journal

desky madthanu # echo $?
0

desky madthanu # fsck.ext4 -fn /dev/sdb
e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (2541777, counted=2412400).
Fix? no
Free inodes count wrong (655349, counted=595281).
Fix? no
/dev/sdb: 11/655360 files (136.4% non-contiguous), 79663/2621440 blocks

desky madthanu # echo $?
0

=====

Would this be the way to proceed? I am hoping "-E journal_only" also
takes care of clearing orphan inodes and still exits with a 0. (Note:
The output I pasted above is derived from a file system created with
default options, and does not switch off uninit_bg or
lazy_itable_init.)

> See the fsck.ext4 man page, the "EXIT CODE" section for an explanation
> for how the exit codes work.

Sorry, I did read through that, but got confused about the combination
of the exit codes and command line options.

Thanks,
Thanu
