From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: can't recover ext4 on lvm from ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
Date: Thu, 5 Jan 2012 09:45:01 -0500
Message-ID: <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu>
References: <217150909.20120105113759@eikelenboom.it> <197607646.20120105142107@eikelenboom.it>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Sander Eikelenboom <linux@eikelenboom.it>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:46750 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337Ab2AEOpI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jan 2012 09:45:08 -0500
In-Reply-To: <197607646.20120105142107@eikelenboom.it>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jan 5, 2012, at 8:21 AM, Sander Eikelenboom wrote:

> Hmm it seems to be over by reverting from a 3.2.0 to a 3.1.5 kernel, =
i now can copy the files after the fsck without it being remounted-ro d=
ue to the error.

Hmm=85  So the question is whether this is caused by changes to ext4 or=
 in the device-mapper / LVM.

The error which ext4 is reporting is that a block bitmap appears to be =
corrupted; the block group descriptors are reporting that there are 322=
58 free blocks, while only 32254 free blocks are found in the block bit=
map.  Since one or the other is must be wrong, and continuing could pot=
entially cause data loss, the file system gets mounted remounted read-o=
nly.

What's funny is that fsck didn't report anything wrong.   That implies =
that the LVM volume is returning different block contents, at least und=
er some circumstances.

Hmm=85. can you try reproducing this?   What happens if you now reboot =
into 3.2?   Do you still get the file system getting remounted read-onl=
y?    Can you try running dumpe2fs on the file system before and after =
running e2fsck, and when you try to reproduce it, can you make a specia=
l note of the EXT4-fs error message:

[  220.748928] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:739:=
 group 1687, 32254 clusters in bitmap, 32258 in gd

Do the numbers stay the same each time you reproduce the problem?   And=
 are there any changes in the output of dumpe2fs (run diff; it will pro=
bably be a very tiny difference).

Also, what is the underlying devices underlying the LVM?   Are you usin=
g a MD device?   Or is the 200T volume spread out across multiple hard =
drives directly (i.e., no RAID)?

-- Ted


>=20
> --
> Sander
>=20
>=20
> This is a forwarded message
> From: Sander Eikelenboom <linux@eikelenboom.it>
> To: "Theodore Ts'o" <tytso@mit.edu>
> Date: Thursday, January 5, 2012, 11:37:59 AM
> Subject: can't recover ext4 on lvm from ext4_mb_generate_buddy:739: g=
roup 1687, 32254 clusters in bitmap, 32258 in gd
>=20
> =3D=3D=3D8<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DOriginal message=
 text=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> I'm having some troubles with a ext4 filesystem on LVM, it seems bric=
ked and fsck doesn't seem to find and correct the problem.
>=20
> Steps:
> 1) fsck -v -p -f the filesystem
> 2) mount the filesystem
> 3) Try to copy a file
> 4) filesystem will be mounted RO on error  (see below)
> 5) fsck again, journal will be recovered, no other errors
> 6) start at 1)
>=20
>=20
> I think the way i bricked it is:
> - make a lvm snapshot from that lvm logical disk
> - mount that lvm snapshot as RO
> - try to copy a file from that mounted RO snapshot to a diffrent dir =
on the lvm logical disk the snapshot is from.
> - it fails and i can't recover (see above)
>=20
>=20
> Is there a way to recover from this ?
>=20
>=20
>=20
> [  220.748928] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:73=
9: group 1687, 32254 clusters in bitmap, 32258 in gd
> [  220.749415] Aborting journal on device dm-2-8.
> [  220.771633] EXT4-fs error (device dm-2): ext4_journal_start_sb:327=
: Detected aborted journal
> [  220.772593] EXT4-fs (dm-2): Remounting filesystem read-only
> [  220.792455] EXT4-fs (dm-2): Remounting filesystem read-only
> [  220.805118] EXT4-fs (dm-2): ext4_da_writepages: jbd2_start: 9680 p=
ages, ino 4079617; err -30
> serveerstertje:/mnt/xen_images/domains/production# cd /
> serveerstertje:/# umount /mnt/xen_images/
> serveerstertje:/# fsck -f -v -p /dev/serveerstertje/xen_images
> fsck from util-linux-ng 2.17.2
> /dev/mapper/serveerstertje-xen_images: recovering journal
>=20
>     277 inodes used (0.00%)
>       5 non-contiguous files (1.8%)
>       0 non-contiguous directories (0.0%)
>         # of inodes with ind/dind/tind blocks: 41/41/3
>         Extent depth histogram: 69/28/2
> 51890920 blocks used (79.18%)
>       0 bad blocks
>      41 large files
>=20
>     199 regular files
>      53 directories
>       0 character device files
>       0 block device files
>       0 fifos
>       0 links
>      16 symbolic links (16 fast symbolic links)
>       0 sockets
> --------
>     268 files
> serveerstertje:/#
>=20
>=20
>=20
>=20
> System:
> - Kernel 3.2.0
> - Debian Squeeze with:
> ii  e2fslibs                              1.41.12-4stable1           =
          ext2/ext3/ext4 file system libraries
> ii  e2fsprogs                             1.41.12-4stable1           =
          ext2/ext3/ext4 file system utilities
>=20
> =3D=3D=3D8<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DEnd of original message t=
ext=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
>=20
> --=20
> Best regards,
> Sander                            mailto:linux@eikelenboom.it<Message=
01.eml>

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
