From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: >16TB issues
Date: Fri, 31 Jul 2009 18:24:50 -0700
Message-ID: <150c16850907311824n71e36f66i86b508bc25d0c4bb@mail.gmail.com>
References: <150c16850907021523p25ddae32v2eeea54418d2e6d5@mail.gmail.com>
	 <20090703143729.GJ20343@webber.adilger.int>
	 <150c16850907161104j5e059baep988c5f04a0552c8c@mail.gmail.com>
	 <20090721161018.GH4231@webber.adilger.int>
	 <150c16850907211152y3136aadx6ce42a8535a6ed61@mail.gmail.com>
	 <20090721192123.GK4231@webber.adilger.int>
	 <150c16850907221527l3060aa85h883656bcc7d7e1c4@mail.gmail.com>
	 <20090730222349.GC31141@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:34979 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZHABbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Jul 2009 21:31:45 -0400
Received: by wa-out-1112.google.com with SMTP id j5so374791wah.21
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2009 18:31:44 -0700 (PDT)
In-Reply-To: <20090730222349.GC31141@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 30, 2009 at 3:23 PM, Valerie Aurora<vaurora@redhat.com> wro=
te:
> Any chance you can give us the exact mke2fs command lines, outputs,
> and device sizes you are using? =A0dumpe2fs -h would be bonus.
>

Sure thing.  Here's the output using an x86_64 kernel with all 32-bit u=
serland:

2TB-Monster:~# uname -a
Linux 2TB-Monster 2.6.30.1 #1 SMP Fri Jul 17 15:43:57 PDT 2009 x86_64 G=
NU/Linux

2TB-Monster:~# cat /etc/mke2fs.conf
[defaults]
	base_features =3D sparse_super,filetype,resize_inode,dir_index,ext_att=
r
	blocksize =3D 4096
	inode_size =3D 128
	inode_ratio =3D 65536

[fs_types]
	ext4 =3D {
		features =3D has_journal,extents,huge_file,flex_bg,uninit_bg,dir_nlin=
k,extra_isize
		inode_size =3D 256
	}

2TB-Monster:~# mkfs.ext4 /dev/md2
mke2fs 1.41.8 (20-Jul-2009)
=46ilesystem label=3D
OS type: Linux
Block size=3D4096 (log=3D2)
=46ragment size=3D4096 (log=3D2)
365400064 inodes, 5846380224 blocks
292319011 blocks (5.00%) reserved for the super user
=46irst data block=3D0
Maximum filesystem blocks=3D3699376128
178418 block groups
32768 blocks per group, 32768 fragments per group
2048 inodes per group
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208=
,
	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
	102400000, 214990848, 512000000, 550731776, 644972544, 1934917632,
	2560000000, 3855122432, 5804752896

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
This filesystem will be automatically checked every 36 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

2TB-Monster:~# dumpe2fs -h /dev/md2
dumpe2fs 1.41.8 (20-Jul-2009)
=46ilesystem volume name:   <none>
Last mounted on:          <not available>
=46ilesystem UUID:          482b503d-68e0-481e-906e-52eb70e7842c
=46ilesystem magic number:  0xEF53
=46ilesystem revision #:    1 (dynamic)
=46ilesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent 64bit flex_bg sparse_super large_file huge_file
uninit_bg dir_nlink extra_isize
=46ilesystem flags:         signed_directory_hash
Default mount options:    (none)
=46ilesystem state:         clean
Errors behavior:          Continue
=46ilesystem OS type:       Linux
Inode count:              365400064
Block count:              5846380224
Reserved block count:     292319011
=46ree blocks:              5823053972
=46ree inodes:              365400053
=46irst block:              0
Block size:               4096
=46ragment size:            4096
Reserved GDT blocks:      1024
Blocks per group:         32768
=46ragments per group:      32768
Inodes per group:         2048
Inode blocks per group:   128
=46lex block group size:    16
=46ilesystem created:       Fri Jul 31 16:23:29 2009
Last mount time:          n/a
Last write time:          Fri Jul 31 16:26:45 2009
Mount count:              0
Maximum mount count:      36
Last checked:             Fri Jul 31 16:23:29 2009
Check interval:           15552000 (6 months)
Next check after:         Wed Jan 27 15:23:29 2010
Lifetime writes:          88 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
=46irst inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      d92d80aa-9c24-4d1c-a452-9ddadd1ebc94
Journal backup:           inode blocks
Journal size:             128M

2TB-Monster:~# e2fsck -C0 -fy /dev/md2
e2fsck 1.41.8 (20-Jul-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +(1551368194--1551368207)
+(1551368210--1551368223) +(1551368480--1551370271)
+(4294967296--4294969375) +(4295491584--4295491599) +4295491601
+(4295491609--4295491610)
=2E.. tons more like this ...
-(5846368341--5846368342) -5846368345 -5846368347 -5846368350
-5846368384 -(5846368386--5846368387) -5846368391 -5846368399
-5846368401
=46ix? yes

/dev/md2: ***** FILE SYSTEM WAS MODIFIED *****
/dev/md2: 11/365400064 files (0.0% non-contiguous), 23326252/5846380224=
 blocks

2TB-Monster:~# e2fsck -C0 -fy /dev/md2
e2fsck 1.41.8 (20-Jul-2009)
e2fsck: Superblock invalid, trying backup blocks...
Group descriptor 0 checksum is invalid.  Fix? yes
Group descriptor 1 checksum is invalid.  Fix? yes
=2E.. every number sequentially ...
Group descriptor 89208 checksum is invalid.  Fix? yes
Pass 1: Checking inodes, blocks, and sizes
Block bitmap differences:  -1081356 -(1081362--1081363) -1081366
-(1081369--1081370) -1081372 -1081374 -1081410 -1081412
-(1081414--1081416) -1081419 -1081421 -(1081423--1081426)
-(1081429--1081430) -1081433
=2E.. tons more like this ...
(182679623--182679625) -182679628 -182679630 -(182679632--182679635)
-(182679638--182679639) -182679642 -182679644 -182679647
-(182679681--182679683) -182679687 -182679690 -182679697
=46ix? yes

/dev/md2: ***** FILE SYSTEM WAS MODIFIED *****
/dev/md2: 11/365400064 files (0.0% non-contiguous), 23326252/5846380224=
 blocks
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
