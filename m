From: =?iso-8859-1?Q?Arne_H=FCggenberg?= <hueggenberg@sportsandbytes.de>
Subject: Re: resize2fs > 16TB questions
Date: Sun, 29 Jul 2012 21:08:56 +0200
Message-ID: <71E9EE6B-0615-4F22-9B7F-37D238F2D683@sportsandbytes.de>
References: <2019C80F-7D05-44FD-89AE-829E3A97053A@sportsandbytes.de> <2AD4EE0D-16C3-4D01-9A34-544E5D5FE8ED@whamcloud.com> <28D780F2-63AA-4FD8-B873-EBE3FD1DF3D3@sportsandbytes.de> <4DA51F27-D3C1-4867-9DC2-7040423E4BAD@whamcloud.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.sportsandbytes.de ([87.193.191.13]:54788 "EHLO
	mail2.sportsandbytes.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab2G2TJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 29 Jul 2012 15:09:00 -0400
In-Reply-To: <4DA51F27-D3C1-4867-9DC2-7040423E4BAD@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 29, 2012, at 8:30 PM, Andreas Dilger wrote:

>=20
> On 2012-07-29, at 9:46, Arne H=FCggenberg <hueggenberg@sportsandbytes=
=2Ede> wrote:
>> On Jul 29, 2012, at 6:11 PM, Andreas Dilger wrote:
>>=20
>>> On 2012-07-29, at 8:24, Arne H=FCggenberg <hueggenberg@sportsandbyt=
es.de> wrote:
>>>>=20
>>>> im trying to resize a ext4 fs to > 16TB.
>>>=20
>>> Unfortunately, this is not possible today without advance planning.=
  There are some structures on disk (group descriptors) that need to be=
 larger for 64-bit filesystems. It is possible to format a 32-bit files=
ystem with larger group descriptors using the "-O 64bit" option, but th=
is doesn't happen by default today.=20
>>>=20
>>> Possibly we should start using the 64-byte group descriptors by def=
ault for filesystems over, say, 4 TB, so they can be resized beyond 16 =
TB.
>>=20
>> I have no idea what the overhead for 64byte group descriptors is, bu=
t with LVM Setups becoming more common and enabling incremental storage=
 increases over a timeframe of several years, maybe 1TB filesystems sho=
uld be cutoff.
>=20
> The overhead is relatively low.=20
>=20
>>> It might also be possible to modify resize2fs to change the group d=
escriptor size, but that isn't possible today.=20
>>>=20
>>>> Having had a look at the e2fsprogs 1.42.x release notes i thought =
that, with the online resize ioctl having been merged in Kernel 3.3, th=
is should be possible.
>>>>=20
>>>> But so far i have had no success achieving this:
>>>>=20
>>>> ~ # uname -a
>>>> Linux 3.3.8-gentoo #1 SMP Fri Jul 27 16:13:25 CEST 2012 x86_64 Int=
el(R) Xeon(R) CPU E5620 @ 2.40GHz GenuineIntel GNU/Linux
>>>>=20
>>>> ~ # tune2fs -l /dev/vg0/lvol1
>>>> tune2fs 1.42.4 (12-June-2012)
>>>> Filesystem volume name:   <none>
>>>> Last mounted on:          /home/filestore_extern_1
>>>> Filesystem UUID:          8fba4f1b-5311-4c9b-b8bf-def4957dc1bd
>>>> Filesystem magic number:  0xEF53
>>>> Filesystem revision #:    1 (dynamic)
>>>> Filesystem features:      has_journal ext_attr resize_inode dir_in=
dex filetype needs_recovery extent 64bit flex_bg sparse_super large_fil=
e huge_file uninit_bg dir_nlink extra_isize
>>>=20
>>> Was the filesystem formatted with the 64bit option, or was this ena=
bled after formatting time?  This puts my earlier comment in doubt.=20
>>=20
>> the filesystem was formatted with
>> from mke2fs.conf:
>>=20
>>       ext4 =3D {
>>               features =3D has_journal,extent,huge_file,flex_bg,unin=
it_bg,dir_nlink,extra_isize,64bit
>>               auto_64-bit_support =3D 1
>>               inode_size =3D 256
>>       }
>=20
> I think the "auto_64-bit_support" means that 64-byte group descriptor=
s are not enabled for filesystems below 16TB.=20
>=20
>>>> Filesystem flags:         signed_directory_hash=20
>>>> Default mount options:    user_xattr acl
>>>> Filesystem state:         clean
>>>> Errors behavior:          Continue
>>>> Filesystem OS type:       Linux
>>>> Inode count:              521011200
>>>> Block count:              4168089600
>>>> Reserved block count:     191127425
>>>> Free blocks:              2195165566
>>>> Free inodes:              520937830
>>>> First block:              0
>>>> Block size:               4096
>>>> Fragment size:            4096
>>>> Reserved GDT blocks:      60
>>>> Blocks per group:         32768
>>>> Fragments per group:      32768
>>>> Inodes per group:         4096
>>>> Inode blocks per group:   256
>>>> RAID stride:              16
>>>> RAID stripe width:        160
>>>> Flex block group size:    16
>>>> Filesystem created:       Fri Jul 27 17:16:24 2012
>>>> Last mount time:          Sun Jul 29 15:22:23 2012
>>>> Last write time:          Sun Jul 29 15:22:23 2012
>>>> Mount count:              6
>>>> Maximum mount count:      -1
>>>> Last checked:             Fri Jul 27 17:16:24 2012
>>>> Check interval:           0 (<none>)
>>>> Lifetime writes:          7485 GB
>>>> Reserved blocks uid:      0 (user root)
>>>> Reserved blocks gid:      0 (group root)
>>>> First inode:              11
>>>> Inode size:              256
>>>> Required extra isize:     28
>>>> Desired extra isize:      28
>>>> Journal inode:            8
>>>> Default directory hash:   half_md4
>>>> Directory Hash Seed:      ef2ec72a-750b-4822-bd8d-9117faadeaee
>>>> Journal backup:           inode blocks
>>>=20
>>> Unfortunately, the group descriptor size is not printed. =20
>>=20
>> how can i get the group descriptor size?
>=20
> Possibly with "debugfs stats"?

~ # debugfs /dev/vg0/lvol1=20
debugfs 1.42.4 (12-June-2012)
debugfs:  stats
debugfs:  stats

=46ilesystem volume name:   <none>
Last mounted on:          /home/filestore_extern_1
=46ilesystem UUID:          8fba4f1b-5311-4c9b-b8bf-def4957dc1bd
=46ilesystem magic number:  0xEF53
=46ilesystem revision #:    1 (dynamic)
=46ilesystem features:      has_journal ext_attr resize_inode dir_index=
 filetype extent 64bit flex_bg sparse_super large_file huge_file uninit=
_bg dir_nlink extra_isize
=46ilesystem flags:         signed_directory_hash=20
Default mount options:    user_xattr acl
=46ilesystem state:         clean
Errors behavior:          Continue
=46ilesystem OS type:       Linux
Inode count:              521011200
Block count:              4168089600
Reserved block count:     191127425
=46ree blocks:              2162482117
=46ree inodes:              520936736
=46irst block:              0
Block size:               4096
=46ragment size:            4096
Reserved GDT blocks:      60
Blocks per group:         32768
=46ragments per group:      32768
Inodes per group:         4096
Inode blocks per group:   256
RAID stride:              16
RAID stripe width:        160
=46lex block group size:    16
=46ilesystem created:       Fri Jul 27 17:16:24 2012
Last mount time:          Sun Jul 29 15:22:23 2012
Last write time:          Sun Jul 29 20:50:44 2012
Mount count:              6
Maximum mount count:      -1
Last checked:             Fri Jul 27 17:16:24 2012
Check interval:           0 (<none>)
Lifetime writes:          7662 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
=46irst inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      ef2ec72a-750b-4822-bd8d-9117faadeaee
Journal backup:           inode blocks
Directories:              6392
 Group  0: block bitmap at 2049, inode bitmap at 2065, inode table at 2=
081
           26585 free blocks, 4085 free inodes, 2 used directories, 408=
4 unused inodes
           [Checksum 0x7d46]
 Group  1: block bitmap at 2050, inode bitmap at 2066, inode table at 2=
337
           4634 free blocks, 4096 free inodes, 0 used directories, 4096=
 unused inodes
           [Inode not init, Checksum 0x97aa]
 Group  2: block bitmap at 2051, inode bitmap at 2067, inode table at 2=
593
           1020 free blocks, 4096 free inodes, 0 used directories, 4096=
 unused inodes
           [Inode not init, Checksum 0x571f]
 Group  3: block bitmap at 2052, inode bitmap at 2068, inode table at 2=
849
           2047 free blocks, 4096 free inodes, 0 used directories, 4096=
 unused inodes

> Cheers, Andreas
>=20
>>>> ~ # resize2fs /dev/vg0/lvol1
>>>> resize2fs 1.42.4 (12-June-2012)
>>>> resize2fs: New size too large to be expressed in 32 bits
>>>=20
>>> This may just be a hard-coded check built into resize2fs, but may b=
e over-zealous of the filesystem was formatted with -O 64bit.=20
>>>=20
>>>> Any advice on how to proceed would be welcome.
>>>>=20
>>>> Regards,
>>>> Arne
>>>>=20
>>>>=20
>>=20
>> Regards,
>> Arne
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards,
Arne

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
