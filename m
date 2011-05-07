From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: mounting ext3 with another superblock doesn't work?
Date: Sat, 7 May 2011 10:38:38 +0300
Message-ID: <BANLkTi=njeXFvoh1NDP1a1Ajiy5nWSeiFg@mail.gmail.com>
References: <031c613316176c32f09748706a086be2@imap.dd24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Mike Swanson <mikeonthecomputer@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36125 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1EGHik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 May 2011 03:38:40 -0400
Received: by eyx24 with SMTP id 24so1164648eyx.19
        for <linux-ext4@vger.kernel.org>; Sat, 07 May 2011 00:38:39 -0700 (PDT)
In-Reply-To: <031c613316176c32f09748706a086be2@imap.dd24.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Christoph,

=46irst, sending this question to linux-ext4 is your best bet.
Second, I have this email from Mike, who had the exact same problem.
I gave him some advice (off the list for some reason).

So you can do one 2 things:
1. take comfort that you are not alone
2. ask Mike if my advice helped him or if he found other ways to
overcome the problem. I think he used an LVM snapshot to make
some experiments before actually making changing to the fs.

Your situation may be even better off than Mike's.
If you really hit ctrl-C after overwriting only super block and inode b=
lock #0,
then you haven't really lost much 'information'
the super block and inode block #0 from a new formatted fs, should cont=
ain
roughly the exact same 'information', the only exception is files (not
directories) created
at the root dir. those file inodes information would have been been los=
t.

Again, if you have a way to make a full backup of your drive,
before doing any experiments, that would be wise...
Also, when you attempt to mount the fs, better try readonly mount.
If there are lost files or your drive, you don't want to overwrite thei=
r data.

Good luck,
Amir.

---------- Forwarded message ----------
=46rom: Amir Goldstein <amir73il@gmail.com>
Date: Sun, Dec 19, 2010 at 11:01 PM
Subject: Re: Accidental mkfs.ext4 on wrong volume already formatted wit=
h ext4...
To: Mike Swanson <mikeonthecomputer@gmail.com>


On Sat, Dec 18, 2010 at 12:12 PM, Mike Swanson
<mikeonthecomputer@gmail.com> wrote:
> Hey,
>
> In some stupid late night adventures, I accidentally ran mke2fs on my
> normal /home volume (1.3TB, about 600GB used....) rather than a new
> volume I had intended... I quickly realized my mistake and did ^C
> though I'm not sure what my options are now for possible recovery....
>
> # mkfs.ext4 /dev/freedom/home
> mke2fs 1.41.12 (17-May-2010)
> Filesystem label=3D
> OS type: Linux
> Block size=3D4096 (log=3D2)
> Fragment size=3D4096 (log=3D2)
> Stride=3D0 blocks, Stripe width=3D0 blocks
> 85196800 inodes, 340787200 blocks
> 17039360 blocks (5.00%) reserved for the super user
> First data block=3D0
> Maximum filesystem blocks=3D0
> 10400 block groups
> 32768 blocks per group, 32768 fragments per group
> 8192 inodes per group
> Superblock backups stored on blocks:
> =A0 =A0 =A0 =A032768, 98304, 163840, 229376, 294912, 819200, 884736, =
1605632, 2654208,
> =A0 =A0 =A0 =A04096000, 7962624, 11239424, 20480000, 23887872, 716636=
16, 78675968,
> =A0 =A0 =A0 =A0102400000, 214990848
>
> Writing inode tables: ^C 41/10400
> #
>
> "dumpe2fs -o superblock=3D20480000" seems to give the old superblock
> metadata still... filesystem create time, last write, etc, though
> running e2fsck results in this:
> # e2fsck -n -b 20480000 /dev/freedom/home
> e2fsck 1.41.12 (17-May-2010)
> Superblock has an invalid journal (inode 8).
> Clear? no
>
> e2fsck: Illegal inode number while checking ext3 journal for /dev/fre=
edom/home
>
>
> I'm in a panic and I don't know what to do.. if anyone can help
> recover data from this accident it would be much appreciated

Oh, what a mess...

I cannot offer you much, but I will try to assess your situation and
offer some tips I would try.
I do not offer fixing tools nor have those tips ever been tested by mys=
elf.
I do hope that I am not mumbling nonsense and planting fake hopes...

It appear from the logs, that you have wiped the super block and all
of it's backups
and the first 41 block groups inode tables.

Maybe you have a working copy of your super block and maybe you don't,
but assuming you know the parameters you used to format the partition
in the first place, recovering a sane super block shouldn't be too hard=
=2E
I think Fsck can fix the most of the fields later (???)
The real problem is the lost inodes.

What you know for sure is that you have wiped the root inode (2)
resize inode (7), journal inode (8) and every file
which was ever created in the root directory.

So suppose you have the ability to format a file system , which looks t=
he same
as your file system when it was created (using same mkfs parameters and
preferably the same mkfs version), you can use that to copy a sane vers=
ion
of root, resize, and journal inodes.

The journal inode should be identical to the one you wiped (it never
changes after mkfs).
The resize inode also never changes unless you did online resize, but
it can be fixed by fsck.
The root inode (containing the root directory) will now contain just
one block, but
hopefully that is the same block as in your file system, so if you may
be able to recover some
files or more importantly, the directories under root, which lead to
the entire un-wiped file system.

I would even try to manually allocate the next 11 adjacent blocks to
the root inode,
which may contain more root directory entries.

If all that fails and you still want to manually fix your file system,
the directories under root, should be the first inode in some block
group inode table,
and it's parent directory =A0is the root inode.
There may be a utility that can use that info to recover a file
system, but I don't know it.

I hope any of this helps.
Good luck,
Amir.



On Sat, May 7, 2011 at 3:09 AM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> Hi.
>
> Few minutes ago, being too tired, I unfortunately did a mkfs.ext3 on =
an
> already existing ext3 fs (instead of fsck.ext3).
> It unfortunately didn't warn me that there's already an fs on it but
> started right away with it's evil work[0] until I ^C-ed it[0] in pani=
c.
>
> I know this list is about devel, but unfortunately I don't know a bet=
ter
> place to ask experts (sorry).
>
>
> When I scan the fs with testdisk it seems to find some superblocks, h=
aving
> the old fs label:
> superblock 32768, blocksize=3D4096 [data1]
> superblock 98304, blocksize=3D4096 [data1]
> superblock 163840, blocksize=3D4096 [data1]
> superblock 229376, blocksize=3D4096 [data1]
> superblock 294912, blocksize=3D4096 [data1]
> superblock 819200, blocksize=3D4096 [data1]
> superblock 884736, blocksize=3D4096 [data1]
> superblock 1605632, blocksize=3D4096 [data1]
> superblock 2654208, blocksize=3D4096 [data1]
> superblock 4096000, blocksize=3D4096 [data1]
>
> Could it be that these are still valid ones?
>
> When I try to mount e.g.:
> # mount -t ext3 -o sb=3D$((32768*4)) /dev/sdc1 /mnt/
> mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
> =A0 =A0 =A0 missing codepage or helper program, or other error
> =A0 =A0 =A0 In some cases useful info is found in syslog - try
> =A0 =A0 =A0 dmesg | tail =A0or so
>
> ...it doesn't work however.
>
> Any ideas?
>
> Thanks,
> Chris.
>
> btw: Please CC me as I'm off list.
>
>
> [0]mke2fs 1.41.12 (17-May-2010)
> Filesystem label=3D
> OS type: Linux
> Block size=3D4096 (log=3D2)
> Fragment size=3D4096 (log=3D2)
> Stride=3D0 blocks, Stripe width=3D0 blocks
> 45793280 inodes, 183143000 blocks
> 9157150 blocks (5.00%) reserved for the super user
> First data block=3D0
> Maximum filesystem blocks=3D4294967296
> 5590 block groups
> 32768 blocks per group, 32768 fragments per group
> 8192 inodes per group
> Superblock backups stored on blocks:
> =A0 =A0 =A0 =A032768, 98304, 163840, 229376, 294912, 819200, 884736, =
1605632, 2654208,
> =A0 =A0 =A0 =A04096000, 7962624, 11239424, 20480000, 23887872, 716636=
16, 78675968,
> =A0 =A0 =A0 =A0102400000
>
> Writing inode tables: ^C00/5590
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
