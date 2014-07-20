From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: Delayed block allocation failures after shrinking fs
Date: Mon, 21 Jul 2014 01:40:33 +0400
Message-ID: <20140720214033.GA24249@azat>
References: <20140719223906.GA8148@pyropus.ca>
 <20140719234749.GB6073@azat>
 <20140720040824.GA10571@pyropus.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: Charles Cazabon <charlesc-linux-ext4@pyropus.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:51769 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaGTVki (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Jul 2014 17:40:38 -0400
Received: by mail-la0-f50.google.com with SMTP id gf5so4076385lab.37
        for <linux-ext4@vger.kernel.org>; Sun, 20 Jul 2014 14:40:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140720040824.GA10571@pyropus.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 19, 2014 at 10:08:24PM -0600, Charles Cazabon wrote:
> Azat Khuzhin <a3at.mail@gmail.com> wrote:
> > On Sun, Jul 20, 2014 at 2:39 AM, Charles Cazabon <charlesc-linux-ext4@pyropus.ca> wrote:
> > >
> > > space.  Shrinking a formerly-full filesystem from several TB to a few hundred
> > > GB is probably not a case that gets tested a lot, I would guess.
> > 
> > I've also used resize2fs for shrinking the fs, but with extra padding.
> 
> I also left the LVM volume ~20GB bigger than I had shrunk the filesystem to,
> as I didn't want to risk corrupting the filesystem.  This should have been
> sufficient to take care of the 2^30 vs 10^9 confusion and other slack.
> 
> > I'm not sure about this, but if you could test shrinking with extra
> > padding, maybe it will help to avoid that errors, and also it would help
> > find the place where the problem is (if it is still there?).
> 
> I'm not entirely sure what you mean.  Is it that you think I didn't leave
> sufficient room for the fs?

No no, maybe I don't understand you correctly, but as I can see that you
only have lvm volume bigger, but that doesn't matter since you already
shrunk the fs.
Instead, I suggested you to try 'resize2fs -M' + 20G (for example),
instead of just 'resize2fs -M', *but* I looked into my scripts, and I
didn't see there any padding, so I guess that I was wrong about that, so
please forget it.

I looked into the place where that message printed, and there is extra
information, could you post full messages? Actually I'm insteresting in
'with error %d' part, and I guess it will be 28 (ENOSPC).

And one more thing, I remember that I had some errors after fsck on
destination fs'es, here is the output of fsck for one of disks (and
seems that you didn't run fsck on destination ssd?):
e2fsck 1.42.5 (29-Jul-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Group 9706 block(s) in use but group is marked BLOCK_UNINIT
Fix? yes

Block bitmap differences:  +(318046208--318073173)
Fix? yes

Free blocks count wrong for group #9706 (32768, counted=5802).
Fix? yes

Free blocks count wrong (1240824, counted=1213858).
Fix? yes


/dev/sdb1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sdb1: 8878914/319520768 files (1.7% non-contiguous),
318292078/319505936 blocks

> 
> > And one question for you, do you have bigalloc option enabled?
> 
> I have to confess I'm not familiar with that option.  When creating ext4 
> filesystems I generally use dir_index, extent, flex_bg, sparse_super, 
> and uninit_bg.  The shrunken filesystem shows this from tune2fs -l:
> 
> 
> Filesystem UUID:          bdf98430-a81c-4a92-9d81-e259a6aeec5b
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
> needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
> dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash 
> Default mount options:    (none)
> Filesystem state:         clean with errors
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              19660800
> Block count:              78643200
> Reserved block count:     7864
> Free blocks:              7300885
> Free inodes:              19657174
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      1005
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8192
> Inode blocks per group:   512
> RAID stride:              32
> RAID stripe width:        128
> Flex block group size:    16
> Filesystem created:       Mon Jun  6 07:06:52 2011
> Last mount time:          Tue Jul 15 21:34:45 2014
> Last write time:          Thu Jul 17 16:17:19 2014
> Mount count:              3
> Maximum mount count:      22
> Last checked:             Tue Jul 15 20:29:52 2014
> Check interval:           15552000 (6 months)
> Next check after:         Sun Jan 11 20:29:52 2015
> Lifetime writes:          19 TB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:           256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      9d433555-1436-4e13-8486-3b5cb1349e91
> Journal backup:           inode blocks
> FS Error count:           1127
> First error time:         Tue Jul 15 21:48:31 2014
> First error function:     ext4_ext_search_left
> First error line #:       1423
> First error inode #:      2648
> First error block #:      0
> Last error time:          Thu Jul 17 16:17:19 2014
> Last error function:      ext4_ext_search_left
> Last error line #:        1423
> Last error inode #:       2662
> Last error block #:       0
> 
