From: Joseph Fannin <jfannin@gmail.com>
Subject: EXT4-fs error: bad header in inode: unexpected eh_depth
Date: Fri, 5 Dec 2008 19:28:39 -0500
Message-ID: <20081206002838.GA16688@nineveh.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:64465 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757822AbYLFA3Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Dec 2008 19:29:25 -0500
Received: by qw-out-2122.google.com with SMTP id 3so72797qwe.37
        for <linux-ext4@vger.kernel.org>; Fri, 05 Dec 2008 16:29:24 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm not sure I can reproduce this, but I've seen it twice in two days.
I'm hoping someone could tell me a bit about what this means:

EXT4-fs error (device dm-1): ext4_ext_search_right: bad header in inode \
 #29753858: unexpected eh_depth - magic f30a, entries 2, max 340(0), depth 1(2)

... and then the journal aborts.  I ran fsck on the fs after the error
both times.  After the second one:

  Log of fsck -C -R -A -a -f
  Thu Dec  4 18:03:53 2008

  home: recovering journal
  home: Inode 7, i_blocks is 5768, should be 5408.  FIXED.
  home: 105120/37994496 files (10.6% non-contiguous), 74285453/75980800 blocks
  fsck died with exit status 1

... nothing about inode #29753858, which is a raw image of a hard disk
I was making with `dd` when the errors happened.  The first error
happened when 17GB had been copied, and the second attempt failed at
27GB -- which don't seem like "interesting" file sizes to me.

I was able to make a full 30GB image of the drive today (still inode
#29753858), however, and then a copy of that.

I am running a 2.6.27.7 kernel with the 20 "for-stable" patches Ted
Ts'o sent to stable@kernel.org on Nov 16 applied, which I think is
what's in 2.6.27.8 today.  Testing .28-rc wouldn't mean much unless I
can find a more reliable way to reproduce this.

I don't see any other disk- or fs-related errors in my logs other than
the fallout from the aborted journal.

Could this be caused by a problem with the underlying block device?
Is it likely to be disk corruption that's going undetected by fsck or
something?  Is the extent_header actually *in* inode #29753858 (I'm
not sure that question makes even makes sense)?

Thanks for any help or info.

This filesystem was originally created as ext3, but most of the files
on it have been copied or created since it's been converted to ext4.
It was created with 256B inodes.

dumpe2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   home
Last mounted on:          <not available>
Filesystem UUID:          4ff8ee4b-b54d-4085-9622-3fa3c6fce4ef
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash test_filesystem 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Remount read-only
Filesystem OS type:       Linux
Inode count:              37994496
Block count:              75980800
Reserved block count:     0
Free blocks:              328372
Free inodes:              37915916
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      45
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         16384
Inode blocks per group:   1024
Filesystem created:       Wed Jun 13 22:44:28 2007
Last mount time:          Thu Dec  4 18:07:17 2008
Last write time:          Thu Dec  4 18:07:17 2008
Mount count:              1
Maximum mount count:      -1
Last checked:             Thu Dec  4 18:03:54 2008
Check interval:           0 (<none>)
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      1eb54f7f-8b56-4c3b-9120-d0c36f121d0d
Journal backup:           inode blocks
Journal size:             128M

--
Joseph Fannin
jfannin@gmail.com

