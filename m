From: Bastien Traverse <bastien.traverse@gmail.com>
Subject: mke2fs options for large media archive filesystem
Date: Sun, 02 Feb 2014 17:20:11 +0100
Message-ID: <52EE703B.3010703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:40529 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaBBQUH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Feb 2014 11:20:07 -0500
Received: by mail-wg0-f50.google.com with SMTP id l18so11032250wgh.29
        for <linux-ext4@vger.kernel.org>; Sun, 02 Feb 2014 08:20:06 -0800 (PST)
Received: from [192.168.1.67] (66-83-190-109.dsl.ovh.fr. [109.190.83.66])
        by mx.google.com with ESMTPSA id uc9sm17308025wib.2.2014.02.02.08.20.04
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 02 Feb 2014 08:20:05 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everybody,

I'm looking for advices concerning mkfs.ext4 parameters to use in
the following use case:

I'm planning to move my media partition (holding
my Documents, Music, Pictures & Downloads folders) from ntfs to ext4 as
well as to a larger partition (380 GiB to 900 GiB) on a new HDD. I'd
like to optimise mkfs.ext4 for this specific use case, default options
leading to not-so-optimal values (e.g. quite some wasted space because
of inappropriate inode_ratio value: account of this can be found here[1]
and there[2]).

I currently have between 93128 (df -i) and 111957 (ls -Ra | wc -l) used
inodes in this fs (btw does anybody know why I come up with such a
difference between the two methods? I don't know whether ntfs use inodes
in a compatible way with unix utilities...), for a total size of 369
GiB. Average file size revolves around 4 MiB, and if I extrapolate those
numbers to the new 900G fs I must be able to fit at least between 227141
and 273066 inodes on it, to accommodate for the same usage (900/369=2,43
so I should be able to put 2,43 times what I currently have in it if
usage remains stable).

The questions I have concern a) inode number setting, b) bigalloc
feature and c) any other tuning I could do.

a) inode number
I ran simulations of mkfs.ext4 on an up-to-date Archlinux (x86_64) to
get the characteristics of the future fs (900 GiB LUKS encryted logical
volume):
$ mkfs.ext4 -V
mke2fs 1.42.8 (20-Jun-2013)
	Using EXT2FS Library version 1.42.8

Standard mkfs.ext4 command (with no reserved space) creates 59 millions
inodes:
# mkfs.ext4 -n -m 0 /dev/data/data
mke2fs 1.42.8 (20-Jun-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
58982400 inodes, 235929600 blocks
0 blocks (0.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
7200 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
102400000, 214990848

59 millions is definitely far more inodes than I want/ever need, so I
tried with the largest mke2fs.conf preset pertaining to inode_ratio (-T
largefile4). I get 230400 inodes:
# mkfs.ext4 -n -m 0 -T largefile4 /dev/data/data
mke2fs 1.42.8 (20-Jun-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
230400 inodes, 235929600 blocks
0 blocks (0.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
7200 block groups
32768 blocks per group, 32768 fragments per group
32 inodes per group
Superblock backups stored on blocks:
32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
102400000, 214990848

Now this might be a bit short seeing considering my projections, and
largefile is probably still too much. So I think I'd either manually
specify the number of inodes I want with the -N option to be around 400
000, or  I'd use the -i option to set the bytes-per-inode ratio to 2 MiB
(-i 2097152), therefore setting it between largefile (1 MiB) and
largefile4 (4MiB). Any hints on which method should be preferred?

b) bigalloc feature
I discovered this option while going through man mkfs.ext4 and found
more info on it in an LWN article (https://lwn.net/Articles/469805/) as
well as the ext4 wiki (https://ext4.wiki.kernel.org/index.php/Bigalloc).
Although it seems to perfectly fit my use case, I'm a bit wary because
of the warnings displayed in man page and wiki about possible problems.
Moreover I saw that Arch e2fsprogs is currently out-of-date with version
1.42.9 being in [Testing] for a month already. Changelog indicates that
a large number of bugs concerning bigalloc have been fxed in this release...
So, can I safely use bigalloc feature right now with mk2fs.ext4, setting
the cluster size to 1 MiB?

Simulation run with those options gave me following output:
# mkfs.ext4 -n -m 0 -i 2097152 -O bigalloc -C 1M /dev/data/data
mke2fs 1.42.8 (20-Jun-2013)

Warning: the bigalloc feature is still under development
See https://ext4.wiki.kernel.org/index.php/Bigalloc for more information

Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Cluster size=1048576 (log=10)
Stride=0 blocks, Stripe width=0 blocks
461216 inodes, 235929600 blocks
0 blocks (0.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
29 block groups
8388608 blocks per group, 32768 clusters per group
15904 inodes per group
Superblock backups stored on blocks:
	8388608, 25165824, 41943040, 58720256, 75497472, 209715200, 226492416

Which is far closer to what I want, but not to the expense of stability...

c) Other options
Are there any other options that could fit my use case? What do people
around here generally use for their media archives?

Regards,
- Bastien


[1] https://forums.gentoo.org/viewtopic-t-906642-start-0.html
[2] http://ubuntuforums.org/showthread.php?t=1758514
