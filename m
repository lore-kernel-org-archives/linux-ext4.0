From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v4 15/20] ext4: use ext4_zero_partial_blocks in
 punch_hole
Date: Mon, 17 Jun 2013 14:30:28 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1306171423300.3270@localhost.localdomain>
References: <1368549454-8930-1-git-send-email-lczerner@redhat.com> <1368549454-8930-16-git-send-email-lczerner@redhat.com> <20130614030154.GA18731@thunk.org> <alpine.LFD.2.00.1306141216070.2327@localhost.localdomain> <20130614133710.GA6250@localhost>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2027307158-1371472231=:3270"
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab3FQMwU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Jun 2013 08:52:20 -0400
In-Reply-To: <20130614133710.GA6250@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2027307158-1371472231=:3270
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 14 Jun 2013, Ted Ts'o wrote:

> Date: Fri, 14 Jun 2013 09:39:39 -0400
> From: Ted Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH v4 15/20] ext4: use ext4_zero_partial_blocks in punch_hole
> 
> On Fri, Jun 14, 2013 at 12:16:53PM +0200, Lukáš Czerner wrote:
> > > It bisects down to this patch, and if I take the dev branch, and
> > > revert patches #15 through #19 in this series, the problem goes away.
> 
> Correction...  reverting patches #15 through #19 (which is what I did in
> the dev-with-revert branch found on ext4.git) causes the problem to go
> away in the nojournal case, but it causes a huge number of other
> problems.  Some of the reverts weren't clean, so it's possible I
> screwed up one of the reverts.  It's also possible that only applying
> part of this series leaves the tree in an unstable state.
> 
> I'd much rather figure out how to fix the problem on the dev branch,
> so thank you for looking into this!

Ok so it seem like the problems you're seeing here after the revert
might be cause wrong revert. Simply applying patches #1 through #14
on top of the c7788792a5e7b0d5d7f96d0766b4cb6112d47d75 (Linux
3.10-rc2 - that seem to be what is ext4 branch based on?) does not
yield any errors without journal.

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 rhel6_vm1 3.10.0-rc2-debug+
MKFS_OPTIONS  -- -q -F -b4096 -O ^has_journal /dev/sdb
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sdb /mnt/test1

generic/075 10s ... 10s
generic/091 21s ... 18s
generic/112      10s
generic/127 286s ... 248s
generic/231 206s ... 77s
generic/255 1s ... 1s
generic/263 16s ... 11s
generic/269 29s ... 30s
generic/270 32s ... 32s
generic/300 8s ... 7s
shared/218       4s
shared/298 33s ... 21s
Ran: generic/075 generic/091 generic/112 generic/127 generic/231
generic/255 generic/263 generic/269 generic/270 generic/300
shared/218 shared/298
Passed all 12 tests

If required I will do the revert myself to make sure that nothing
breaks. However I certainly hope it would not be necessary.

I am still working to figure out what's going on. I'll keep you
posted.

Thanks!
-Lukas


> 
> 						- Ted
> 
> BEGIN TEST: Ext4 4k block Thu Jun 13 23:25:45 EDT 2013
> Failures: generic/075 generic/091 generic/112 generic/127 generic/231 generic/255 generic/263 shared/218
> END TEST: Ext4 4k block Fri Jun 14 00:29:17 EDT 2013
> 
> BEGIN TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Fri Jun 14 00:29:22 EDT 2013
>     +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent (see /root/xfstests/results/generic/269.full)
> generic/270 69s ...     [01:34:24][ 8102.435986] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: inode #25735: block 99331: comm quotacheck: bad entry in directory: rec_len % 4 != 0 -\
>  offset=0(0), inode=3739147998, rec_len=57054, name_len=222
> Failures: generic/075 generic/091 generic/112 generic/127 generic/231 generic/263 generic/269 generic/270 generic/285 generic/300 shared/218
> END TEST: Ext4 4k block w/nodelalloc, no flex_bg, and no extents Fri Jun 14 01:49:59 EDT 2013
> 
> BEGIN TEST: Ext4 4k block w/ no journal Fri Jun 14 01:50:00 EDT 2013
>     +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent (see /root/xfstests/results/generic/269.full)
> generic/270 69s ...     [02:20:21][10531.911437] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: inode #9894: block 6526: comm quotacheck: bad entry in directory: rec_len is smaller t\
> han minimal - offset=0(0), inode=0, rec_len=0, name_len=0
> [10532.535861] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: inode #9692: block 6534: comm quotacheck: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=1044266558, rec_\
> len=15934, name_len=62
> [10534.266775] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: inode #9906: block 6530: comm quotacheck: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=1044266558, rec_\
> len=15934, name_len=62
> [10534.697885] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: inode #24673: block 6531: comm quotacheck: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=1044266558, rec\
> _len=15934, name_len=62
> [10535.157126] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: inode #9898: block 6532: comm quotacheck: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=1044266558, rec_\
> len=15934, name_len=62
> [10536.395838] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: inode #9905: block 6529: comm quotacheck: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=1044266558, rec_\
> len=15934, name_len=62
> [10537.029470] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: inode #9899: block 6533: comm quotacheck: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=1044266558, rec_\
> len=15934, name_len=62
> [10537.259601] EXT4-fs error (device vdc): htree_dirblock_to_tree:920: inode #9929: block 6527: comm quotacheck: bad entry in directory: rec_len % 4 != 0 - offset=0(0), inode=1044266558, rec_\
> len=15934, name_len=62
> Failures: generic/075 generic/091 generic/112 generic/127 generic/231 generic/255 generic/263 generic/269 generic/270 shared/218 shared/298
> END TEST: Ext4 4k block w/ no journal Fri Jun 14 02:32:14 EDT 2013
> 
> BEGIN TEST: Ext4 1k block Fri Jun 14 02:32:18 EDT 2013
> Failures: generic/075 generic/091 generic/112 generic/127 generic/231 generic/255 generic/263 generic/285 shared/218
> END TEST: Ext4 1k block Fri Jun 14 04:00:17 EDT 2013
> 
> BEGIN TEST: Ext4 4k block w/nodelalloc and no flex_bg Fri Jun 14 04:00:20 EDT 2013
>     +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent (see /root/xfstests/results/generic/269.full)
> Failures: generic/075 generic/091 generic/112 generic/127 generic/223 generic/231 generic/255 generic/263 generic/269 shared/218
> END TEST: Ext4 4k block w/nodelalloc and no flex_bg Fri Jun 14 05:16:10 EDT 2013
> 
> BEGIN TEST: Ext4 4k block w/metadata_csum Fri Jun 14 05:16:12 EDT 2013
> Failures: generic/075 generic/091 generic/112 generic/127 generic/231 generic/255 generic/263 shared/218
> END TEST: Ext4 4k block w/metadata_csum Fri Jun 14 06:16:31 EDT 2013
> 
> BEGIN TEST: Ext4 4k block w/dioread_nolock Fri Jun 14 06:16:31 EDT 2013
> _check_generic_filesystem: filesystem on /dev/vdb is inconsistent (see /root/xfstests/results/generic/013.full)
> Failures: generic/013
> END TEST: Ext4 4k block w/dioread_nolock Fri Jun 14 06:21:37 EDT 2013
> 
> BEGIN TEST: Ext4 4k block w/data=journal Fri Jun 14 06:21:41 EDT 2013
>     +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent (see /root/xfstests/results/generic/269.full)
>     +_check_generic_filesystem: filesystem on /dev/vdc is inconsistent (see /root/xfstests/results/generic/300.full)
> [29242.456266] WARNING: at /usr/local/google/home/tytso/linux/ext4/fs/buffer.c:1120 mark_buffer_dirty+0x54/0x1ff()
> Failures: generic/075 generic/091 generic/112 generic/127 generic/223 generic/231 generic/255 generic/263 generic/269 generic/270 generic/300 shared/218
> END TEST: Ext4 4k block w/data=journal Fri Jun 14 07:33:10 EDT 2013
> 
> BEGIN TEST: Ext4 4k block w/bigalloc Fri Jun 14 07:33:16 EDT 2013
> [33544.485801] WARNING: at /usr/local/google/home/tytso/linux/ext4/fs/quota/dquot.c:1090 dquot_claim_space_nodirty+0xf1/0x1e3()
> Failures: generic/204 generic/219 generic/233 generic/235 generic/273 generic/275 generic/300 shared/218
> END TEST: Ext4 4k block w/bigalloc Fri Jun 14 08:56:56 EDT 2013
> 
> 
--8323328-2027307158-1371472231=:3270--
