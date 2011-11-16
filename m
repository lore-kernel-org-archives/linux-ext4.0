From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4 offers less blocks than other fs
Date: Tue, 15 Nov 2011 21:20:02 -0600
Message-ID: <4EC32BE2.9080906@redhat.com>
References: <alpine.LNX.2.01.1111152031020.11901@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab1KPDUJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Nov 2011 22:20:09 -0500
In-Reply-To: <alpine.LNX.2.01.1111152031020.11901@frira.zrqbmnf.qr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/15/11 1:51 PM, Jan Engelhardt wrote:
> Hi.
> 
> 
> In moving away from some ntfs-3g filesystem to ext4 (migration of a 
> Windows-esque fileserver), I see a rather steep metadata use with ext4 
> such that moving the data was not completely possible. Per df:
> 
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/dm-5            1953514324 1952543856    970468 100% /mnt/old
> /dev/mapper/data     1922858888 1922858880         0 100% /mnt/new
> [attempted a rsync as root]
> 
> The blockdev size is just minimally different:
> 20:32 nas:~ # blockdev --getsize64 /dev/dm-5
> 2000398671872
> 20:32 nas:~ # blockdev --getsize64 /dev/dm-6
> 2000396836864

extN filesystems preallocate a lot of metadata, vs other filesystems
which may allocate this on the fly; that is what you are seeing.

> And there is a 29 GB(!) difference between 1953514324 and 1922858888,
> so my question is: where is all of that going?

Yongqiang Yang has it right; 7661170 + 32768 blocks for metadata
is right at 29G.

- -Eric
 
> (e2fsprogs 1.41.14)
> Filesystem volume name:   data
> Last mounted on:          /mnt/new
> Filesystem UUID:          807fec49-7a8a-3520-a648-be677475377c
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
> needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
> dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash 
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              122101760
> Block count:              488378134
> Reserved block count:     24418906
> Free blocks:              480664715
> Free inodes:              122101749
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      907
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8192
> Inode blocks per group:   512
> Flex block group size:    16
> Filesystem created:       Mon Nov 14 20:43:23 2011
> Last mount time:          Mon Nov 14 20:43:55 2011
> Last write time:          Mon Nov 14 20:43:55 2011
> Mount count:              1
> Maximum mount count:      26
> Last checked:             Mon Nov 14 20:43:23 2011
> Check interval:           15552000 (6 months)
> Next check after:         Sat May 12 21:43:23 2012
> Lifetime writes:          144 MB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      5e2619e2-7683-4589-b390-57e569444705
> Journal backup:           inode blocks
> Journal features:         (none)
> Journal size:             128M
> Journal length:           32768
> Journal sequence:         0x00002751
> Journal start:            4341
> [Details about groups 0-14904 omitted.]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOwyvhAAoJECCuFpLhPd7gGLMP/iVzSXfPM5jjHK2BLSuFj/Ua
/OpbnlC7wuxd5HS8B5AhX/ke3ho7k0QNapJh6RTNp6mfjY1BHPH64rw35XbSTeT1
EZJTueR0VLobPSwjMOiwO5kqi55N20w8lStpU2dLGhYHeOnwGgZfO4KKGJulUf8U
ljw5HLHONeovJ0lYdiOdOcvFVJqc5rMtVL1krNA4iDrNypfGRngk14PSFmTUtrX2
CcN8Z13QR1o0Vl6iwaRyeEb6lIDliEy+Chm45ywpKru4OPUiOXbDxOKOWSg7EdOT
+o3fm4J7WtRFBXeey5DA8pU0JgW3ep9R/3x48QrKksiiUXRt9Ha27uo82WcqkQAk
oDelP7ztC2ST/B5Eci9YQ3EO3fWZg3dKP40D1ZjkXRw95+FgmBD1PA1TTmOGfDEV
U1AvlVsuxvTIw/4cw+mv/00piQdQmY6YqPTf5IjpsCqJLuKjIRXBPTSep9/m+ry/
zUWCEhFBFoeGyJ6PUbzt344odDHnVoFeIFxxkT4XTGoxU8vpVEepqbIpxdk8UWOS
aXT34gLbO3OnYUj5DdVQ480mG8m2tN2eLGESv5vdxRnRGO7ntquuFTq6IE9nkSon
SrEZNPiEVbQ8N15nzet7/DmXxBVSJuX23k7n/Kmn9V0X9i5roDAoiQzxwz44ex57
UXnNtGS3fGZLZmtvbHlN
=TYLS
-----END PGP SIGNATURE-----
