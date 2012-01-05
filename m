From: Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: can't recover ext4 on lvm from ext4_mb_generate_buddy:739: group 1687, 32254 clusters in bitmap, 32258 in gd
Date: Thu, 5 Jan 2012 21:04:34 +0100
Message-ID: <193489064.20120105210434@eikelenboom.it>
References: <217150909.20120105113759@eikelenboom.it> <197607646.20120105142107@eikelenboom.it> <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu> <4910694144.20120105171428@eikelenboom.it> <20120105181535.GB26382@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	<dm-devel@redhat.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120105181535.GB26382@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thursday, January 5, 2012, 7:15:35 PM, you wrote:

> On Thu, Jan 05, 2012 at 05:14:28PM +0100, Sander Eikelenboom wrote:
>>=20
>> OK spoke too soon, i have been able to trigger it again:
>> - copying files from LV to the same LV without the snapshot went OK
>> - copying from the RO snapshot of a LV to the same LV gave the error=
 while copying the file again:

> OK.  Originally, you said you did this:

> 1) fsck -v -p -f the filesystem
> 2) mount the filesystem
> 3) Try to copy a file
> 4) filesystem will be mounted RO on error  (see below)
> 5) fsck again, journal will be recovered, no other errors
> 6) start at 1)

> Was this with with a read-only snapshot always being in existence
> through all of these five steps?  When was the RO snapshot created?

> If a RO snapshot has to be there in order for this to happen, then
> this is almost certainly a device-mapper regression.  (dm-devel folks=
,
> this is a problem which apparently occurred when the user went from
> v3.1.5 to v3.2, so this looks likes 3.2 regression.)

>                                                 - Ted


Well it seems to consist of 2 issues with a kernel booted with a 3.2.0 =
kernel:

1) - It only seems to trigger with a snapshot of the LV present
   - Just tested if the snapshot being mounted RO did really matter, it=
 doesn't.
   - It can also be triggerd if mounted RW
   - It can also be triggered when the snapshot is not mounted at all (=
by just copying some files on the filesystem itself)

   So that seems a device mapper issue

2) BUT:
   after the error triggerd by 1:
   - After removing the snapshot with lvremove,
   - umounting the filesystem on the LV
   - fsck=EDng the filesystem without errors (apart from the journal re=
covery)
   - rebooting the machine again with 3.2.0 kernel
   - mounting the filesystem on the LV
   - removing the partially copied files
   - trying to copy files from the filesystem on the LV to the same fil=
esystem, without a snapshot of the LV present
   - it fails with the exact same error mounting the filesystem RO.

   then
   - umounting the filesystem on the LV
   - fsck=EDng the filesystem without errors (apart from the journal re=
covery)
   - rebooting the machine with a 3.1.5 kernel
   - mounting the filesystem on the LV
   - removing the partially copied files
   - trying to copy files from the filesystem on the LV to the same fil=
esystem, without a snapshot of the LV present
   - no problems files copied ok

   then
   - rebooting into 3.2.0 again
   - mounting the filesystem on the LV
   - removing the completly copied files
   - trying to copy files from the filesystem on the LV to the same fil=
esystem, without a snapshot of the LV present
   - no problems files copied ok


   SO
   - it keeps on failing on 3.2.0, even when the snapshot is gone and t=
he system is rebooted, after 3.1.5 is booted once everything seems to b=
e OK again .... even under 3.2.0
   - that seems more like a filesystem thing ?


I doubled checked and performed all these steps again.

--
Sander








>>=20
>> [ 2357.655783] EXT4-fs error (device dm-2): ext4_mb_generate_buddy:7=
39: group 1861, 32254 clusters in bitmap, 32258 in gd
>> [ 2357.656056] Aborting journal on device dm-2-8.
>> [ 2357.718473] EXT4-fs (dm-2): Remounting filesystem read-only
>> [ 2357.736680] EXT4-fs error (device dm-2) in ext4_da_write_end:2532=
: IO failure
>> [ 2357.738328] EXT4-fs (dm-2): ext4_da_writepages: jbd2_start: 7615 =
pages, ino 4079617; err -30
>> [ 2716.125010] EXT4-fs error (device dm-2): ext4_put_super:818: Coul=
dn't clean up the journal
>>=20
>>=20
>> Attached are 4x output from dumpe2fs
>> - dumpe2fs-xen_images-3.2.0                           Made just afte=
r boot
>> - dumpe2fs-xen_images-3.2.0-afterfsck                 Made after doi=
ng a fsck -v -p -f on the unmounted LV
>> - dumpe2fs-xen_images-3.2.0-aftererror                Made after the=
 error occured on the mounted LV
>> - dumpe2fs-xen_images-3.2.0-aftererror-afterfsck      Made after the=
 error occured, and after a subsequent fsck -v -p -f on the unmounted L=
V
>> - dumpe2fs-xen_images-3.1.5                           Made after boo=
ting into 3.1.5 after all of the above
>>=20
>> Oh yes also did a badblock scan to rule that out, and it seems the n=
umbers stay the same.
>> e2fsck 1.41.12 (17-May-2010) (from debian squeeze)
>>=20
>> --
>> Sander
>>=20
>>=20
>>=20
>> >>=20
>> >> --
>> >> Sander
>> >>=20
>> >>=20
>> >> This is a forwarded message
>> >> From: Sander Eikelenboom <linux@eikelenboom.it>
>> >> To: "Theodore Ts'o" <tytso@mit.edu>
>> >> Date: Thursday, January 5, 2012, 11:37:59 AM
>> >> Subject: can't recover ext4 on lvm from ext4_mb_generate_buddy:73=
9: group 1687, 32254 clusters in bitmap, 32258 in gd
>> >>=20
>> >> =3D=3D=3D8<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DOriginal mes=
sage text=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >>=20
>> >> I'm having some troubles with a ext4 filesystem on LVM, it seems =
bricked and fsck doesn't seem to find and correct the problem.
>> >>=20
>> >> Steps:
>> >> 1) fsck -v -p -f the filesystem
>> >> 2) mount the filesystem
>> >> 3) Try to copy a file
>> >> 4) filesystem will be mounted RO on error  (see below)
>> >> 5) fsck again, journal will be recovered, no other errors
>> >> 6) start at 1)
>> >>=20
>> >>=20
>> >> I think the way i bricked it is:
>> >> - make a lvm snapshot from that lvm logical disk
>> >> - mount that lvm snapshot as RO
>> >> - try to copy a file from that mounted RO snapshot to a diffrent =
dir on the lvm logical disk the snapshot is from.
>> >> - it fails and i can't recover (see above)
>> >>=20
>> >>=20
>> >> Is there a way to recover from this ?
>> >>=20
>> >>=20
>> >>=20
>> >> [  220.748928] EXT4-fs error (device dm-2): ext4_mb_generate_budd=
y:739: group 1687, 32254 clusters in bitmap, 32258 in gd
>> >> [  220.749415] Aborting journal on device dm-2-8.
>> >> [  220.771633] EXT4-fs error (device dm-2): ext4_journal_start_sb=
:327: Detected aborted journal
>> >> [  220.772593] EXT4-fs (dm-2): Remounting filesystem read-only
>> >> [  220.792455] EXT4-fs (dm-2): Remounting filesystem read-only
>> >> [  220.805118] EXT4-fs (dm-2): ext4_da_writepages: jbd2_start: 96=
80 pages, ino 4079617; err -30
>> >> serveerstertje:/mnt/xen_images/domains/production# cd /
>> >> serveerstertje:/# umount /mnt/xen_images/
>> >> serveerstertje:/# fsck -f -v -p /dev/serveerstertje/xen_images
>> >> fsck from util-linux-ng 2.17.2
>> >> /dev/mapper/serveerstertje-xen_images: recovering journal
>> >>=20
>> >>     277 inodes used (0.00%)
>> >>       5 non-contiguous files (1.8%)
>> >>       0 non-contiguous directories (0.0%)
>> >>         # of inodes with ind/dind/tind blocks: 41/41/3
>> >>         Extent depth histogram: 69/28/2
>> >> 51890920 blocks used (79.18%)
>> >>       0 bad blocks
>> >>      41 large files
>> >>=20
>> >>     199 regular files
>> >>      53 directories
>> >>       0 character device files
>> >>       0 block device files
>> >>       0 fifos
>> >>       0 links
>> >>      16 symbolic links (16 fast symbolic links)
>> >>       0 sockets
>> >> --------
>> >>     268 files
>> >> serveerstertje:/#
>> >>=20
>> >>=20
>> >>=20
>> >>=20
>> >> System:
>> >> - Kernel 3.2.0
>> >> - Debian Squeeze with:
>> >> ii  e2fslibs                              1.41.12-4stable1       =
              ext2/ext3/ext4 file system libraries
>> >> ii  e2fsprogs                             1.41.12-4stable1       =
              ext2/ext3/ext4 file system utilities
>> >>=20
>> >> =3D=3D=3D8<=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DEnd of original messa=
ge text=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >>=20
>> >>=20
>> >>=20
>> >> --=20
>> >> Best regards,
>> >> Sander                            mailto:linux@eikelenboom.it<Mes=
sage01.eml>
>>=20
>>=20
>>=20
>>=20
>> --=20
>> Best regards,
>>  Sander                            mailto:linux@eikelenboom.it









--=20
Best regards,
 Sander                            mailto:linux@eikelenboom.it
