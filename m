From: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Fri, 28 Aug 2015 09:27:20 +0300
Message-ID: <CAETWcftzdWdjzVQnP-rD-o0iEFLgZFQeLx++90ZyQZiaFJB0kw@mail.gmail.com>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
 <28A25D6A-DA5A-42D2-9BFE-9F6C95B51BE7@dilger.ca> <CAETWcfti7NL3N96K1pEAX9ezKUrZn0QeGTwjn0qUni0u6i=Gcg@mail.gmail.com>
 <CAETWcfvtjF6bh_V64LgJ1QCyW=OKjzvV+HT5zFTThS574rWfgA@mail.gmail.com> <20150827190548.GC3357@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35438 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbbH1G2A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2015 02:28:00 -0400
Received: by obbwr7 with SMTP id wr7so35184882obb.2
        for <linux-ext4@vger.kernel.org>; Thu, 27 Aug 2015 23:27:59 -0700 (PDT)
In-Reply-To: <20150827190548.GC3357@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Since the moment when fsck has been restarted yesterday (under screen)
it found only a few errors:
-----------------------------
root@rescue ~ # fsck -y -v /dev/sda3
fsck from util-linux 2.20.1
e2fsck 1.42.5 (29-Jul-2012)
/dev/sda3 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Inode 4425472 is too big.  Truncate? yes

Block #593549637 (1359559318) causes file to be too big.  CLEARED.
Block #593549638 (782521882) causes file to be too big.  CLEARED.
Block #593549639 (1184464312) causes file to be too big.  CLEARED.
Block #593549640 (1283655900) causes file to be too big.  CLEARED.
Block #593549641 (2241107660) causes file to be too big.  CLEARED.
Block #593549642 (117581257) causes file to be too big.  CLEARED.
Block #593549643 (957560556) causes file to be too big.  CLEARED.
Block #593549644 (1037291178) causes file to be too big.  CLEARED.
Block #593549645 (2099220496) causes file to be too big.  CLEARED.
Block #593549646 (539062498) causes file to be too big.  CLEARED.
Block #593549647 (96880969) causes file to be too big.  CLEARED.
Too many illegal blocks in inode 4425472.
Clear inode? yes

Inode 4425549, i_size is 18119674890280087280, should be 0.  Fix? yes

Inode 4425549, i_blocks is 27717127168711, should be 0.  Fix? yes

Inode 4425554 has compression flag set on filesystem without
compression support.  Clear? yes

Inode 4425554, i_size is 12927291416082045099, should be 0.  Fix? yes

Inode 4425554, i_blocks is 207957728820169, should be 0.  Fix? yes

Inode 4425667, i_size is 3071282098034816027, should be 0.  Fix? yes

Inode 4425667, i_blocks is 225290567745721, should be 0.  Fix? yes

Inode 4425603 has INDEX_FL flag set but is not a directory.
Clear HTree index? yes

Inode 4425603, i_size is 13931552572174262662, should be 0.  Fix? yes

Inode 4425603, i_blocks is 109288676305237, should be 0.  Fix? yes

Inode 4425281 has INDEX_FL flag set but is not a directory.
Clear HTree index? yes

Inode 4425281, i_size is 16737347569809842710, should be 0.  Fix? yes

Inode 4425281, i_blocks is 231725314734850, should be 0.  Fix? yes

Inode 4425553 is too big.  Truncate? yes

Block #1 (1012277717) causes symlink to be too big.  CLEARED.
Block #2 (2730874111) causes symlink to be too big.  CLEARED.
Block #3 (2924388706) causes symlink to be too big.  CLEARED.
Block #4 (739968058) causes symlink to be too big.  CLEARED.
Block #5 (2349486480) causes symlink to be too big.  CLEARED.
Block #6 (184918148) causes symlink to be too big.  CLEARED.
Block #7 (3200511249) causes symlink to be too big.  CLEARED.
Block #8 (4199384552) causes symlink to be too big.  CLEARED.
Block #9 (2310276563) causes symlink to be too big.  CLEARED.
Block #10 (960264107) causes symlink to be too big.  CLEARED.
Block #11 (3387206892) causes symlink to be too big.  CLEARED.
Too many illegal blocks in inode 4425553.
Clear inode? yes

-----------------------------

dumpe2fs "hangs" after dumping superblock info (no group info is shown):
-----------------------------
root@rescue ~ # dumpe2fs /dev/sda3
dumpe2fs 1.42.5 (29-Jul-2012)
Filesystem volume name:   <none>
Last mounted on:          /
Filesystem UUID:          552052d1-9e25-4b2b-bc04-21c7b4a87aa4
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr dir_index filetype
extent 64bit flex_bg sparse_super huge_file uninit_bg dir_nlink
extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         not clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              793231360
Block count:              12691701243
Reserved block count:     634585062
Free blocks:              12641158920
Free inodes:              793231369
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         2048
Inode blocks per group:   128
Flex block group size:    16
Filesystem created:       Thu Feb 12 16:57:47 2015
Last mount time:          Thu Aug 27 10:58:45 2015
Last write time:          Thu Aug 27 10:58:58 2015
Mount count:              4
Maximum mount count:      -1
Last checked:             Thu Feb 12 16:57:47 2015
Check interval:           0 (<none>)
Lifetime writes:          279 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      9ddd8b55-ff3f-4447-bf5c-732402ddd8d6
Journal backup:           inode blocks
FS Error count:           154
First error time:         Thu Aug 13 17:25:45 2015
First error function:     ext4_mb_generate_buddy
First error line #:       739
First error inode #:      0
First error block #:      0
Last error time:          Fri Aug 14 16:48:41 2015
Last error function:      ext4_mb_generate_buddy
Last error line #:        739
Last error inode #:       0
Last error block #:       0
Journal features:         journal_incompat_revoke journal_64bit
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00321045
Journal start:            0

^C

-----------------------------

/boot partition which sits on /dev/sda2 is shown perfectly by dumpe2fs

Regards,
Alexander

On Thu, Aug 27, 2015 at 10:05 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Aug 27, 2015 at 05:23:58PM +0300, Alexander Afonyashin wrote:
>> Hi,
>>
>> I've restarted fsck ~6 hours ago. It's again occupied ~30GB RAM and
>> strace shows that number of syscalls per second becomes fewer and
>> fewer.
>
> Can you run it under "script" so we can get a transcript of the run?
>
> It sounds like your file system has gotten very badly damaged, so the
> question is figuring out what happened so we can advise you about how
> to recover.
>
> Can you also send the output of dumpe2fs?
>
> Thanks,
>
>                                         - Ted
