From: Kevin Liao <kevinlia@gmail.com>
Subject: Re: Possible file system corruption?
Date: Thu, 12 Feb 2015 18:44:27 +0800
Message-ID: <CAF_MivEszhM3F2naT8uMVhs5txM-hWPxDeNsbqL1V35_DdbM8A@mail.gmail.com>
References: <CAF_MivHO0nVcqUTv6M2rMBkAS0pmSGBa-KSurPdbqaN+MGp=iQ@mail.gmail.com>
 <20150210093949.GA1735@hades.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:49984 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbbBLKos (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2015 05:44:48 -0500
Received: by mail-qg0-f44.google.com with SMTP id j5so7213879qga.3
        for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2015 02:44:47 -0800 (PST)
In-Reply-To: <20150210093949.GA1735@hades.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Carlos,

Thank you for the reply. Today I try to run e2fsck again. This time I'm sure
I run it in correct volume. I also try to use different backup suprtblock.
The results are as below:

e2fsck -fnv /dev/md0
e2fsck 1.42.12 (29-Aug-2014)
ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
e2fsck: Group descriptors look bad... trying backup blocks...
Corruption found in superblock.  (reserved_gdt_blocks = 16384).

The superblock could not be read or does not describe a valid ext2/ext3/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>


e2fsck -fnv -b 8193 /dev/md0
e2fsck 1.42.12 (29-Aug-2014)
e2fsck: Bad magic number in super-block while trying to open /dev/md0

The superblock could not be read or does not describe a valid ext2/ext3/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>


e2fsck -fnv -b 32768 /dev/md0
e2fsck 1.42.12 (29-Aug-2014)
Corruption found in superblock.  (reserved_gdt_blocks = 16384).

The superblock could not be read or does not describe a valid ext2/ext3/ext4
filesystem.  If the device is valid and it really contains an ext2/ext3/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>

It all complains about superblock corrupted. I then use dumpe2fs to check the
superblock and get the following:

dumpe2fs -h /dev/md0
dumpe2fs 1.42.12 (29-Aug-2014)
Filesystem volume name:   <none>
Last mounted on:          /share/MD0_DATA
Filesystem UUID:          6c1f5c4f-7185-436f-bc1f-8876a1d524fe
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr filetype extent 64bit flex_bg
sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              610230272
Block count:              4881811920
Reserved block count:     218453
Free blocks:              1387940253
Free inodes:              610226921
First block:              0
Block size:               4096
Fragment size:            4096
Group descriptor size:    64
Reserved GDT blocks:      16384
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         4096
Inode blocks per group:   256
RAID stride:              1
Flex block group size:    16
Filesystem created:       Mon Jan 13 08:40:19 2014
Last mount time:          Thu Feb 12 10:34:24 2015
Last write time:          Thu Feb 12 10:35:23 2015
Mount count:              50
Maximum mount count:      31
Last checked:             Tue Jun 17 07:54:54 2014
Check interval:           15552000 (6 months)
Next check after:         Sun Dec 14 06:54:54 2014
Lifetime writes:          15 TB
Reserved blocks uid:      0 (user unknown)
Reserved blocks gid:      0 (group unknown)
First inode:              11
Inode size:          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      a9c4f391-d68d-4886-b7cb-5a804077f823
Directory Magic Number:   0x0000
Journal backup:           inode blocks
FS Error count:           25
First error time:         Thu Jan  1 12:19:59 2015
First error function:     ext4_ext_find_extent
First error line #:       400
First error inode #:      95223833
First error block #:      0
Last error time:          Wed Feb  4 11:57:05 2015
Last error function:      ext4_ext_find_extent
Last error line #:        400
Last error inode #:       95223833
Last error block #:       0
Journal features:         journal_incompat_revoke journal_64bit
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00092ac2
Journal start:            0

I can not see anything wrong (except the error count that was what I already
knew). That's why I am really confused about why e2fsck report something like
this.

Kevin

2015-02-10 17:39 GMT+08:00 Carlos Maiolino <cmaiolino@redhat.com>:
> Hello,
>
> I don't work with ext4 for a while, but maybe I can give a few suggestions.
>
> first of all, I'd suggest you to run `e2fsck -fnv` and attach the whole output
> of the command to the e-mail (pastebins are preferred though).
>
> Giving the description, I'd say that you might be trying to run e2fsck in a
> different volume/device that you're actually mounting, but well, that's too soon
> to say.
>
> have you tried to actually run e2fsck specifying a backup superblock?
>
> cheers
>
> On Mon, Feb 09, 2015 at 07:33:28PM +0800, Kevin Liao wrote:
>> Hi All,
>>
>> Recently whenvevr I try to access one file, I saw the following kernel log:
>>
>> "EXT4-fs error (device md0): ext4_ext_find_extent:400: inode #95223833: comm
>>  fio: bad header/extent: invalid magic - magic e2b6, entries 59156, max
>>  58100(0), depth 43399(0)"
>>
>> inode 95223833 is just the file I want to read. I guess there may be some
>> corruption in the file system. Therefore I umount it and run e2fsck command
>> but get the following result:
>>
>> "ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
>> ./e2fsck: Group descriptors look bad... trying backup blocks...
>> Corruption found in superblock. (reserved_gdt_blocks = 16384).
>>
>> The superblock could not be read or does not describe a valid ext2/ext3/ext4
>> filesystem. If the device is valid and it really contains an ext2/ext3/ext4
>> filesystem (and not swap or ufs or something else), then the superblock
>> is corrupt, and you might try running e2fsck with an alternate superblock:
>>     e2fsck -b 8193 <device>
>>  or
>>     e2fsck -b 32768 <device>"
>>
>> It seems that the superblock is bad, however I can still mount it and access
>> to other files without error. The kernel version is 3.4.23. Is there anything
>> I can do to recover the file? Any help is very appreciated. Thank a lot.
>>
>> Kevin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
