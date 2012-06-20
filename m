From: Norbert Preining <preining@logic.at>
Subject: Ext4 slow on links
Date: Wed, 20 Jun 2012 09:20:14 +0900
Message-ID: <20120620002014.GA25471@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:52743 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2FTAs4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2012 20:48:56 -0400
Received: from gamma.logic.tuwien.ac.at ([128.130.175.3] ident=Debian-exim)
	by mx.logic.tuwien.ac.at with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <preining@logic.at>)
	id 1Sh8ec-0008J3-5v
	for linux-ext4@vger.kernel.org; Wed, 20 Jun 2012 02:20:14 +0200
Received: from preining by gamma.logic.tuwien.ac.at with local (Exim 4.69)
	(envelope-from <preining@logic.at>)
	id 1Sh8ec-0006gv-3l
	for linux-ext4@vger.kernel.org; Wed, 20 Jun 2012 02:20:14 +0200
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear all

(please Cc)

I recently had to track down a big delay in one of my Debian packages,
and it turned out that it seems to be due to ext4 being *horribly*
slow on dealing with symlinks.

On my system, if I create a directory with 8000 symlinks (that is
a real case of a font package shipping special encoded files) and
the symlink targets are "far away" (long names), then, after 
a reboot a simply
	ls -l
in this directory took 1m20sec. While on second run it is down to 2secs
(nice caching).

I read in the ext4 design document that if the symlink target is
less then 66 (?) chars long, then it is saved right in the inode,
otherwise some other action has to be taken.

Now my questions are:
- is this to be expected and not to be avoided?
- do you have a way around it?
- do other file systems, esp ext2/ext3 behave differently in this respect?

Finally the specs: kernel 3.5.0-rc3 (but was the same with 3.4.0 and
before), mount options rw,noatime,errors=remount-ro,user_xattr

tune2fs -l output:
tune2fs 1.42.4 (12-Jun-2012)
Filesystem volume name:   <none>
Last mounted on:          /
Filesystem UUID:          961635f4-762d-4136-a3d5-35fca8e4f3d8
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent sparse_super large_file uninit_bg
Filesystem flags:         signed_directory_hash 
Default mount options:    journal_data_writeback
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              46333952
Block count:              185335808
Reserved block count:     9266789
Free blocks:              104044481
Free inodes:              41749891
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      979
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Filesystem created:       Sun Nov 15 15:09:13 2009
Last mount time:          Tue Jun 19 15:15:48 2012
Last write time:          Tue May 29 07:17:52 2012
Mount count:              34
Maximum mount count:      50
Last checked:             Tue May 29 07:17:52 2012
Check interval:           15552000 (6 months)
Next check after:         Sun Nov 25 07:17:52 2012
Lifetime writes:          2151 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       13246498
Default directory hash:   half_md4
Directory Hash Seed:      87ea85d5-2287-4211-a920-f793468c22c1
Journal backup:           inode blocks


Anything else I can provide?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
BALDOCK
The sharp prong on the top of a tree stump where the tree has snapped
off before being completely sawn through.
			--- Douglas Adams, The Meaning of Liff
