From: Charles Cazabon <charlesc-linux-ext4@pyropus.ca>
Subject: Re: Delayed block allocation failures after shrinking fs
Date: Sat, 19 Jul 2014 22:08:24 -0600
Message-ID: <20140720040824.GA10571@pyropus.ca>
References: <20140719223906.GA8148@pyropus.ca>
 <20140719234749.GB6073@azat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:54390 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750706AbaGTEI7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Jul 2014 00:08:59 -0400
Content-Disposition: inline
In-Reply-To: <20140719234749.GB6073@azat>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Azat Khuzhin <a3at.mail@gmail.com> wrote:
> On Sun, Jul 20, 2014 at 2:39 AM, Charles Cazabon <charlesc-linux-ext4@pyropus.ca> wrote:
> >
> > space.  Shrinking a formerly-full filesystem from several TB to a few hundred
> > GB is probably not a case that gets tested a lot, I would guess.
> 
> I've also used resize2fs for shrinking the fs, but with extra padding.

I also left the LVM volume ~20GB bigger than I had shrunk the filesystem to,
as I didn't want to risk corrupting the filesystem.  This should have been
sufficient to take care of the 2^30 vs 10^9 confusion and other slack.

> I'm not sure about this, but if you could test shrinking with extra
> padding, maybe it will help to avoid that errors, and also it would help
> find the place where the problem is (if it is still there?).

I'm not entirely sure what you mean.  Is it that you think I didn't leave
sufficient room for the fs?

> And one question for you, do you have bigalloc option enabled?

I have to confess I'm not familiar with that option.  When creating ext4 
filesystems I generally use dir_index, extent, flex_bg, sparse_super, 
and uninit_bg.  The shrunken filesystem shows this from tune2fs -l:


Filesystem UUID:          bdf98430-a81c-4a92-9d81-e259a6aeec5b
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype
needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg
dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              19660800
Block count:              78643200
Reserved block count:     7864
Free blocks:              7300885
Free inodes:              19657174
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1005
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              32
RAID stripe width:        128
Flex block group size:    16
Filesystem created:       Mon Jun  6 07:06:52 2011
Last mount time:          Tue Jul 15 21:34:45 2014
Last write time:          Thu Jul 17 16:17:19 2014
Mount count:              3
Maximum mount count:      22
Last checked:             Tue Jul 15 20:29:52 2014
Check interval:           15552000 (6 months)
Next check after:         Sun Jan 11 20:29:52 2015
Lifetime writes:          19 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:           256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      9d433555-1436-4e13-8486-3b5cb1349e91
Journal backup:           inode blocks
FS Error count:           1127
First error time:         Tue Jul 15 21:48:31 2014
First error function:     ext4_ext_search_left
First error line #:       1423
First error inode #:      2648
First error block #:      0
Last error time:          Thu Jul 17 16:17:19 2014
Last error function:      ext4_ext_search_left
Last error line #:        1423
Last error inode #:       2662
Last error block #:       0


Charles
-- 
------------------------------------------------------------------
Charles Cazabon                   <charlesc-linux-ext4@pyropus.ca>
Software, consulting, and services available at http://pyropus.ca/
------------------------------------------------------------------
