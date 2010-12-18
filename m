From: Mike Swanson <mikeonthecomputer@gmail.com>
Subject: Accidental mkfs.ext4 on wrong volume already formatted with ext4...
Date: Sat, 18 Dec 2010 02:12:54 -0800
Message-ID: <AANLkTi=a_CXxERvKVVVcvn4kCSa+NoEzuVN9Qxb25mXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50961 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab0LRKMz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 Dec 2010 05:12:55 -0500
Received: by wyb28 with SMTP id 28so1453595wyb.19
        for <linux-ext4@vger.kernel.org>; Sat, 18 Dec 2010 02:12:54 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey,

In some stupid late night adventures, I accidentally ran mke2fs on my
normal /home volume (1.3TB, about 600GB used....) rather than a new
volume I had intended... I quickly realized my mistake and did ^C
though I'm not sure what my options are now for possible recovery....

# mkfs.ext4 /dev/freedom/home
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
85196800 inodes, 340787200 blocks
17039360 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=0
10400 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
	102400000, 214990848

Writing inode tables: ^C 41/10400
#

"dumpe2fs -o superblock=20480000" seems to give the old superblock
metadata still... filesystem create time, last write, etc, though
running e2fsck results in this:
# e2fsck -n -b 20480000 /dev/freedom/home
e2fsck 1.41.12 (17-May-2010)
Superblock has an invalid journal (inode 8).
Clear? no

e2fsck: Illegal inode number while checking ext3 journal for /dev/freedom/home


I'm in a panic and I don't know what to do.. if anyone can help
recover data from this accident it would be much appreciated
