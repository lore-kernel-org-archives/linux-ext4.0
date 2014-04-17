From: Contact <neitsab@ovh.fr>
Subject: Re: Make huge files strictly contiguous (fallocate, bigalloc, e4defrag...)
Date: Thu, 17 Apr 2014 20:41:34 +0200
Message-ID: <5350205E.3030403@ovh.fr>
References: <534F39F6.2000208@ovh.fr> <20140417152457.GE18591@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, lczerner@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo29.mail-out.ovh.net ([178.32.228.29]:36594 "EHLO
	mo29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaDQSli (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Apr 2014 14:41:38 -0400
In-Reply-To: <20140417152457.GE18591@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Le 17/04/2014 14:04, Luk=E1=9A Czerner a =E9crit :
>
> This is not how it it supposed to be used. Yes fallocate
> preallocates the file, but cp will truncate it so fallocate will
> certainly not help you in any way. In order for fallocate to be
> useful you'll have to write into the file without actually
> truncating it (dd can do this if you do not want to write your own
> program)
>
> Also the file is probably as contiguous as it could be. Here is what
> I get on the file system with default mkfs options.
>
> # e4defrag -c /mnt/test/file1
> <File>                                         now/best      size/ext
> /mnt/test/file1                                 10/1         120649 K=
B
>
> But that does not tell the whole story. See
>
> xfs_io -f -c "fiemap -v" /mnt/test/file1
> /mnt/test/file1:
>  EXT: FILE-OFFSET        BLOCK-RANGE       TOTAL FLAGS
>    0: [0..262143]:       2768896..3031039 262144   0x0
>    1: [262144..524287]:  3031040..3293183 262144   0x0
>    2: [524288..786431]:  3293184..3555327 262144   0x0
>    3: [786432..1048575]: 3555328..3817471 262144   0x0
>    4: [1048576..1310719]: 3817472..4079615 262144   0x0
>    5: [1310720..1425407]: 4079616..4194303 114688   0x0
>    6: [1425408..1687551]: 4456448..4718591 262144   0x0
>    7: [1687552..1949695]: 4718592..4980735 262144   0x0
>    8: [1949696..2211839]: 4980736..5242879 262144   0x0
>    9: [2211840..2412991]: 5242880..5444031 201152   0x1
>
> (Note that the output is in 512B blocks)
>
> As you can see the file is mostly contiguous, but it is divided into
> several extents because of two reasons.
>
> 1. The extent in ext4 has a limited size of 32768 blocks for
> initialized extent and 32767 block for unwritten extent. So when we
> exceed that size we need another extent which might be physically
> contiguous on disk with the previous one.
>
> 2. Ext4 divides disk space into allocation groups of certain size
> (cluster size * 8)blocks. Now with flex_bg medatada such as inode
> tables, block bitmaps and so one are packed closely together so the
> do not have to be stored with each block group and you'll get more
> contiguous data space.
>
> However we're still storing backup superblock and Groups descriptors
> in certain groups and those are the gaps you're seeing in the fiemap
> list.
>
> For detailed overview you can use dumpe2fs to see what is allocated
> where on the file system.
>

Thanks, that was much interesting. I had delved a bit into ext4 data
structure before posting but was never able to get a clear grasp on the
limitations concerning contiguity.

So, I tried the correct way you recommended about how to use fallocate:

# mkfs.ext4 -m 0 -L iso -i 67108864 -E root_owner=3D1000:100 /dev/sdc2
$ fallocate -l 1589166080
'/run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso'
$ dd if=3D'/home/neitsab/iso/Manjaro/manjaro-gnome-0.8.9-x86_64.iso'
of=3D'/run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso'

However grub4dos displayed the error message about file being
non-contiguous. Output of xfs_io:
$ xfs_io -f -c "fiemap -v"
'/run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso'
/run/media/neitsab/iso/_ISO/manjaro-gnome-0.8.9-x86_64.iso:
 EXT: FILE-OFFSET        BLOCK-RANGE       TOTAL FLAGS
   0: [0..262143]:       3457024..3719167 262144   0x0
   1: [262144..524287]:  3719168..3981311 262144   0x0
   2: [524288..737279]:  3981312..4194303 212992   0x0
   3: [737280..999423]:  4456448..4718591 262144   0x0
   4: [999424..1261567]: 4718592..4980735 262144   0x0
   5: [1261568..1523711]: 4980736..5242879 262144   0x0
   6: [1523712..1785855]: 5242880..5505023 262144   0x0
   7: [1785856..2047999]: 5505024..5767167 262144   0x0
   8: [2048000..2310143]: 5767168..6029311 262144   0x0
   9: [2310144..2572287]: 6029312..6291455 262144   0x0
  10: [2572288..2834431]: 6291456..6553599 262144   0x0
  11: [2834432..3096575]: 6569984..6832127 262144   0x0
  12: [3096576..3103839]: 6832128..6839391   7264   0x1

Second and third extents aren't contiguous, neither are tenth and
eleventh. But it was close!

Anyway, thanks to your explanations I understand why perfect contiguity
isn't so likely. However I remember using with success a Perl script
from 2007 called defragfs [1] recommended by Easy2Boot's author. After
running this script a couple of times on the key's ISO folder I was abl=
e
to boot on most of the files. Problem with this approach, is that AFAIK
defragmentation is pretty harmful for flash drives, so I wasn't willing
to do it every time I add an ISO.

> Bigalloc file system should help since you'll get much larger
> contiguous data spaces since the cluster size would be much bigger
> hence you'll get much bigger block groups. But you'll still get
> multiple extents (I do not really know how grub4dos recognizes
> contiguous files) even though there will be mostly contiguous.
>
> But then again you'll have Group descriptors and backup superblocks
> in some groups so potentially some files might end up not
> contiguous. And even though you can turn off backup superblock you
> can not turn off writing group descriptors.
>
> So no, at the moment there is not way to make really *really* sure
> that the file you're creating even with fallocate will allways be
> strictly contiguous. It'll mostly work, but it really depends on
> where the file will be put on the file system and how big is the
> file.
>
> Also I've been talking about the case where nothing else is using
> the file system, when that's not the case. It might happen that the
> allocation will interfere (even though we're trying to allocate as
> contiguous file as we can). And also the file system free space will
> become more fragmented over time as it is used, but it really
> depends on the workload.
>
>
> Now for the problem with bigalloc, I am not sure what kernel version
> are you using, but it's probably old. fallocate on bigalloc should
> work just fine.
>
> Hope it helps.
> Thanks!
> -Lukas
>

Concerning fallocate with bigalloc, I don't think it is related to my
kernel which is rather recent:
$ uname -a
Linux arch-clevo 3.14.1-1-ARCH #1 SMP PREEMPT Mon Apr 14 20:40:47 CEST
2014 x86_64 GNU/Linux

So, I tried again to use fallocate on the bigalloc'ed fs, it hanged
again (uninterruptible sleep state, D in ps aux:
$ ps aux | grep fallocate
neitsab   3673  0.0  0.0      0     0 ?        D    19:36   0:00 [fallo=
cate]
kill/kill -9 don't change anything. gnome-system-monitor gives in the
process properties for fallocate: "Wait channel |
call_rwsem_down_write_failed".

So after searching a bit more, it seems to be related to a driver
issue (see [2] and [3] for a discussion and more info), apparently
fallocate is waiting on some I/O that never come... So that's on my USB
key (for info it is a Sandisk Extreme 64 GB USB 3.0, model SDCZ80-0654G=
,
using driver xhci_hcd).

As I've been advised in another discussion to be cautious with bigalloc
because it is still in development, I'll leave it aside for now.


> Le 17/04/2014 17:24, Theodore Ts'o a =E9crit :
>=20
> Most of the time, files don't have to be "strictly contiguous", so
> that's not something that we've spent a lot of time trying to achieve=
=2E
>=20
> There is a way to do this if you are willing to use the tip of the
> e2fsprogs "maint" branch, and then you put something like this into
> your mke2fs.conf file:
>=20
> 	easy2boot =3D {
> 		features =3D extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isi=
ze,^resize_inode,sparse_super2
> 		hash_alg =3D half_md4
> 		num_backup_sb =3D 0
> 		packed_meta_blocks =3D 1
> 		make_hugefiles =3D 1
> 		inode_ratio =3D 4194304
> 		hugefiles_dir =3D /
> 		hugefiles_name =3D my-big-file
> 		hugefiles_digits =3D 0
> 		hugefiles_size =3D 16G
> 		num_hugefiles =3D 1
> 		zero_hugefiles =3D false
> 	}
>=20
> Then "mke2fs -T easy2boot /dev/sdc1" will create an ext4 filesystem
> with a file called /my-big-file which is guaranteed to be contiguous.
>=20
> For your particular use case, where you want to create a new
> filesystem when you want to create your strictly contiguous file, thi=
s
> might be the best way to go.
>=20

Thanks a lot for the detailed solution! If I want mke2fs to create
multiple contiguous files (this is for a multiboot medium so I'm gonna
have quite a few of them, e.g. 20 files of 2 GB so as to account for th=
e
maximum), which variables should I modify in the mke2fs.conf entry?
hugefiles_size and num_hugefiles?

Although I'd like to test this solution, I still have to get into git
and compiling, moreover I'm looking for a less involving solution so fo=
r
now I think I'll just stick to regular e2fsprogs and try to find anothe=
r
multiboot utility.

But thanks for your quick and detailed answers!

-- Bastien

[1] http://defragfs.sourceforge.net/
[2] http://linuxgazette.net/issue83/tag/6.html
[3] http://www.novell.com/support/kb/doc.php?id=3D7002725
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
