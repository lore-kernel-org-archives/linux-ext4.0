From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: resize2fs > 16TB questions
Date: Thu, 2 Aug 2012 13:15:24 -0700
Message-ID: <82C4FEEB-5926-494D-B68D-6FAC530F098A@whamcloud.com>
References: <2019C80F-7D05-44FD-89AE-829E3A97053A@sportsandbytes.de> <2AD4EE0D-16C3-4D01-9A34-544E5D5FE8ED@whamcloud.com> <28D780F2-63AA-4FD8-B873-EBE3FD1DF3D3@sportsandbytes.de> <4DA51F27-D3C1-4867-9DC2-7040423E4BAD@whamcloud.com> <71E9EE6B-0615-4F22-9B7F-37D238F2D683@sportsandbytes.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@whamcloud.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xiaoqiangnk@gmail.com" <xiaoqiangnk@gmail.com>
To: =?utf-8?Q?Arne_H=C3=BCggenberg?= <hueggenberg@sportsandbytes.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42534 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2HBUPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2012 16:15:32 -0400
Received: by vcbfk26 with SMTP id fk26so8660293vcb.19
        for <linux-ext4@vger.kernel.org>; Thu, 02 Aug 2012 13:15:31 -0700 (PDT)
In-Reply-To: <71E9EE6B-0615-4F22-9B7F-37D238F2D683@sportsandbytes.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-29, at 12:08, Arne H=C3=BCggenberg <hueggenberg@sportsandbyt=
es.de> wrote:

> On Jul 29, 2012, at 8:30 PM, Andreas Dilger wrote:
>>>> Unfortunately, the group descriptor size is not printed. =20
>>>=20
>>> how can i get the group descriptor size?
>>=20
>> Possibly with "debugfs stats"?
>=20
> ~ # debugfs /dev/vg0/lvol1=20
> debugfs 1.42.4 (12-June-2012)
> debugfs:  stats
> debugfs:  stats
>=20
> Filesystem volume name:   <none>
> Last mounted on:          /home/filestore_extern_1
> Filesystem UUID:          8fba4f1b-5311-4c9b-b8bf-def4957dc1bd
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index=
 filetype extent 64bit flex_bg sparse_super large_file huge_file uninit=
_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash=20
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              521011200
> Block count:              4168089600
> Reserved block count:     191127425
> Free blocks:              2162482117
> Free inodes:              520936736
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      60
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         4096
> Inode blocks per group:   256
> RAID stride:              16
> RAID stripe width:        160
> Flex block group size:    16
> Filesystem created:       Fri Jul 27 17:16:24 2012
> Last mount time:          Sun Jul 29 15:22:23 2012
> Last write time:          Sun Jul 29 20:50:44 2012
> Mount count:              6
> Maximum mount count:      -1
> Last checked:             Fri Jul 27 17:16:24 2012
> Check interval:           0 (<none>)
> Lifetime writes:          7662 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      ef2ec72a-750b-4822-bd8d-9117faadeaee
> Journal backup:           inode blocks
> Directories:              6392
> Group  0: block bitmap at 2049, inode bitmap at 2065, inode table at =
2081
>           26585 free blocks, 4085 free inodes, 2 used directories, 40=
84 unused inodes
>           [Checksum 0x7d46]
> Group  1: block bitmap at 2050, inode bitmap at 2066, inode table at =
2337
>           4634 free blocks, 4096 free inodes, 0 used directories, 409=
6 unused inodes
>           [Inode not init, Checksum 0x97aa]
> Group  2: block bitmap at 2051, inode bitmap at 2067, inode table at =
2593
>           1020 free blocks, 4096 free inodes, 0 used directories, 409=
6 unused inodes
>           [Inode not init, Checksum 0x571f]
> Group  3: block bitmap at 2052, inode bitmap at 2068, inode table at =
2849
>           2047 free blocks, 4096 free inodes, 0 used directories, 409=
6 unused inodes

Surprisingly, the group descriptor size is also not printed here. Looki=
ng at the code in mke2fs, it appears the 64-byte size used for filesyst=
ems when the 64bit flag is set, regardless of what size the filesystem =
is, and there is no way to change it.

It looks like my theory is wrong, but I don't have access to a system t=
o test this. Probably worthwhile to ask Yongqiang Yang (CC'd), who wrot=
e the 64-bit resize code.=20

Cheers, Andreas--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
