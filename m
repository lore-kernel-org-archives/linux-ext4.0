From: Marc Thomas <marc@dragonfly.plus.com>
Subject: Re: e4defrag: Corrupt file after running e4defrag
Date: Fri, 9 Jun 2017 02:31:08 +0100
Message-ID: <1b784854-89cc-60d6-8082-5a922b536528@dragonfly.plus.com>
References: <a9518dce-b61a-3c28-b597-f21b6db9be0a@dragonfly.plus.com>
 <20170608223511.2dw7gyqzgwgxxz2q@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from avasout04.plus.net ([212.159.14.19]:40473 "EHLO
        avasout04.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751442AbdFIBbM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jun 2017 21:31:12 -0400
In-Reply-To: <20170608223511.2dw7gyqzgwgxxz2q@thunk.org>
Content-Language: en-GB
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Many thanks for the quick reply.

On 08/06/17 23:35, Theodore Ts'o wrote:
> How big is the file system, and what file system features are enabled.
> Can you send me a copy of "dumpe2fs -h" on the file system?  Something
> else that would be useful would be to unmount the file system after
> seeing the md5sum failure, and run e2fsck -fn to see if e2fsck noticed
> any file system corruption.

Filesystem size is:

root@deepthought:~# df -h /old
Filesystem                          Size  Used Avail Use% Mounted on
/dev/mapper/storage_vg-old_home_lv  345G  240G  101G  71% /old


dumpe2fs output:

root@deepthought:~# umount /old
root@deepthought:~# dumpe2fs -h /dev/storage_vg/old_home_lv
dumpe2fs 1.43.4 (31-Jan-2017)
Filesystem volume name:   home
Last mounted on:          /old
Filesystem UUID:          29b7a949-8f67-454b-8d76-99bf656b8ffb
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent sparse_super large_file
Filesystem flags:         signed_directory_hash
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              22937600
Block count:              91750400
Reserved block count:     917504
Free blocks:              27373220
Free inodes:              21856957
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1002
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Filesystem created:       Wed Oct 15 22:34:49 2008
Last mount time:          Wed Jun  7 01:56:45 2017
Last write time:          Thu Jun  8 12:12:09 2017
Mount count:              0
Maximum mount count:      21
Last checked:             Thu Jun  8 12:12:09 2017
Check interval:           15552000 (6 months)
Next check after:         Tue Dec  5 11:12:09 2017
Lifetime writes:          1553 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Journal inode:            8
Default directory hash:   tea
Directory Hash Seed:      d863c54f-8fd7-40ee-b43a-119ebee8c4f0
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke
Journal size:             128M
Journal length:           32768
Journal sequence:         0x009ddb9b
Journal start:            0


e2fsck after corruption detected:

root@deepthought:~# time e2fsck -fn /dev/storage_vg/old_home_lv
e2fsck 1.43.5-WIP (17-Feb-2017)
Pass 1: Checking inodes, blocks, and sizes
Inode 141148 extent tree (at level 2) could be narrower.  Fix? no
Inode 362394 extent tree (at level 2) could be narrower.  Fix? no
Inode 394645 extent tree (at level 1) could be narrower.  Fix? no
Inode 412793 extent tree (at level 1) could be narrower.  Fix? no
[...]
Inode 16228394 extent tree (at level 1) could be narrower.  Fix? no
Inode 16318845 extent tree (at level 1) could be narrower.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
home: 1080643/22937600 files (0.4% non-contiguous), 64379509/91750400 blocks

real    1m47.814s
user    0m13.810s
sys     0m3.478s


If it helps, here's a debugfs "stat" of a file post-corruption. What I
don't have at present is the "before" case.

debugfs:  stat ./marc/.mozilla/firefox/jh6wc1il.default/formhistory.sqlite
Inode: 2074844   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 196400461    Version: 0x00000000:00000000
User:   510   Group:   100   Project:     0   Size: 92160
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 184
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x59308cb7:aa7df8c0 -- Thu Jun  1 22:52:55 2017
 atime: 0x59308cb7:e6cfad44 -- Thu Jun  1 22:52:55 2017
 mtime: 0x59308cb7:aa7df8c0 -- Thu Jun  1 22:52:55 2017
crtime: 0x00000000:00000000 -- Thu Jan  1 01:00:00 1970
Size of extra inode fields: 32
EXTENTS:
(0-22):38929313-38929335

> I don't know if this will be doable, since it depends on how big the
> file system is and how much extra space you have in your LVM volume
> group, but what would be *wonderful* would be if you can do a full
> image backup, or failing that, an compressed raw e2image backup (see
> the e2image man page, or the "REPORTING BUGS" section of the e2fsck
> man page).  The compressed raw e2image backup only contains the file
> system metadata, and no the data blocks, so it takes much less space.
>
> The idea then is after you discover which file is getting corrupted,
> you can look that inode both on the "before" file system image
> (looking only at the metadata blocks) and the "after" file system
> image, and see if there are any clues about how to make a reproducible
> test case, using the "stat" command of debugfs.  Getting a full
> dumpe2fs output of the filesystem before and after might give us a
> clue.

I have around 3TB unallocated space in the LVM group, so should be able
to hold a pre-defrag and post-defrag copy of the filesystem.
What I'll do is re-copy the source filesystem (ext3), and do the
conversion to ext4. I'll then make a block level copy of that and
e4defrag the copy.

I'm currently running:
# e2image -rs /dev/storage_vg/old_home_lv - | bzip2 >
/tmp/old_home_lv.e2i.bz2

...but it looks like that might take a while. I'll report back tomorrow.

Thanks & Kind Regards,
Marc
