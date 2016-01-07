From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Thu, 7 Jan 2016 11:24:20 +0100
Message-ID: <20160107102420.GB8380@quack.suse.cz>
References: <697280a570654ae0aa1723fb7d11f51e@SGPMBX1004.APAC.bosch.com>
 <20151222150037.GB18178@quack.suse.cz>
 <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
 <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbcAGKYM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Jan 2016 05:24:12 -0500
Content-Disposition: inline
In-Reply-To: <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-01-16 06:43:00, HUANG Weller (CM/ESW12-CN) wrote:
> > -----Original Message-----
> > From: Jan Kara [mailto:jack@suse.cz]
> > Sent: Wednesday, January 06, 2016 6:06 PM
> > To: HUANG Weller (CM/ESW12-CN) <Weller.Huang@cn.bosch.com>
> > Subject: Re: ext4 out of order when use cfq scheduler
> > 
> > On Wed 06-01-16 02:39:15, HUANG Weller (CM/ESW12-CN) wrote:
> > > > So you are running in 'ws' mode of your tool, am I right? Just
> > > > looking into the sources you've sent me I've noticed that although
> > > > you set O_SYNC in openflg when mode == MODE_WS, you do not use
> > > > openflg at all. So file won't be synced at all. That would well
> > > > explain why you see that not all file contents is written. So did
> > > > you just send me a different version of the source or is your test program
> > really buggy?
> > > >
> > >
> > > Yes, it is a bug of the test code. So the test tool create files
> > > without O_SYNC flag actually.  But , even in this case, is the out of
> > > order acceptable ? or is it normal ?
> > 
> > Without fsync(2) or O_SYNC, it is perfectly possible that some files are written and
> > others are not since nobody guarantees order of writeback of inodes. OTOH you
> > shouldn't ever see uninitialized data in the inode (but so far it isn't clear to me
> > whether you really see unitialized data or whether we really wrote zeros to those
> > blocks - ext4 can sometimes decide to do so).  Your traces and disk contents
> > show that the problematic inode has extent of length 128 blocks starting at block
> > 0x12c00 and then extent of lenght 1 block starting at block 0x1268e.  What is the
> > block size of the filesystem?  Because inode size is only 0x40010.
> > 
> > Some suggestions to try:
> > 1) Print also length of a write request in addition to the starting
> > block so that we can see how much actually got written
> 
> Please see below failure analysis.
> 
> > 2) Initialize the device to 0xff so that we can distinguish
> > uninitialized blocks from zeroed-out blocks.
> 
> Yes, i Initialize the device to 0xff this time.
> 
> > 3) Report exactly for which 512-byte blocks checksum matches and for
> > which it is wrong.
> The wrong contents are old file contents which are created in previous
> test round.  It is caused by the "wrong" sequence inode data(in journal)
> and  the file contents. So the file contents are not updated.

So this confuses me somewhat. You previously said that you always remove
files after each test round and then new ones are created. Is it still the
case? So the old file contents you speak about above is just some random
contents that happened to be in disk blocks we freshly allocated to the
file, am I right?

> > 4) Try newer kernel if possible.
> > 
> 
> Please see my analysis with print length of a write request

Thanks for the detailed analysis!

> Ext4 information:
> ----------------------------
> [root@SiRFatlas6 ~]# dumpe2fs /dev/nandblk0p3
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super huge_file uninit_bg dir_nlink extra_isize
> Filesystem flags:         unsigned_directory_hash
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              42816
> Block count:              85632
> Reserved block count:     4281
> Free blocks:              41789
> Free inodes:              42519
> First block:              0
> Block size:               2048
> Fragment size:            2048
> Reserved GDT blocks:      83
> Blocks per group:         16384
> Fragments per group:      16384
> Inodes per group:         7136
> Inode blocks per group:   446
> Flex block group size:    16
> Filesystem created:       Thu Jan  1 00:42:42 1970
> Last mount time:          Thu Jan  1 00:30:58 1970
> Last write time:          Thu Jan  1 00:30:58 1970
> Mount count:              21
> Maximum mount count:      -1
> Last checked:             Thu Jan  1 00:42:42 1970
> Check interval:           0 (<none>)
> Lifetime writes:          10 MB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               128
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      e9c1cdf4-bc4c-40cb-930f-5f3923e68a33
> Journal backup:           inode blocks
> Journal features:         journal_incompat_revoke
> Journal size:             8M
> Journal length:           4096
> Journal sequence:         0x0000005b
> Journal start:            1
> 
> Last four files are contents error:
> Failure files:
> -rw-------    1 root     root        262160 Jan  1 00:44 /mnt/test/hp0000011aHHlIpPbjK6
> -rw-------    1 root     root        262160 Jan  1 00:44 /mnt/test/hp0000011bjwWXnrY2jn
> -rw-------    1 root     root        262160 Jan  1 00:44 /mnt/test/hp0000011c7HYSBFSTAk
> -rw-------    1 root     root        135168 Jan  1 00:44 /mnt/test/hp0000011dliQ04nIiLB
> 
> Analysis /mnt/test/hp0000011aHHlIpPbjK6
> 
> debugfs:  imap test/hp0000011aHHlIpPbjK6
> Inode 294 is part of block group 0
>         located at block 135, offset 0x0280
> 
> 00000280  80 81 00 00 10 00 04 00  aa 07 00 00 72 0a 00 00  
> 00000290  72 0a 00 00 00 00 00 00  00 00 01 00 04 02 00 00  
> 000002a0  00 00 08 00 01 00 00 00  0a f3 01 00 04 00 00 00  
> 000002b0  00 00 00 00 00 00 00 00  81 00 00 00 00 dd 00 00 ==> 0xdd00
> 
> Find the block number of the file contents: j.bin is the journal blocks which I backup before journal replay.
> [root@SiRFatlas6 ~]# hexdump j.bin  -C |  grep "00 dd 00 00"
> 0002eab0  00 00 00 00 00 00 00 00  81 00 00 00 00 dd 00 00 
> 
> Check the block number in which journal commit,  the commit ID is 0x58.
>  [root@SiRFatlas6 ~]# hexdump j.bin -C | grep "c0 3b 39 98"
> 00000000  c0 3b 39 98 00 00 00 04  00 00 00 00 00 00 08 00  |.;9.............|
> 00000800  c0 3b 39 98 00 00 00 05  00 00 00 55 00 00 00 30  |.;9........U...0|
> 00001000  c0 3b 39 98 00 00 00 01  00 00 00 55 00 00 00 75  |.;9........U...u|
> 0000f800  c0 3b 39 98 00 00 00 02  00 00 00 55 00 00 00 00  |.;9........U....|
> 00010000  c0 3b 39 98 00 00 00 01  00 00 00 56 00 00 00 65  |.;9........V...e|
> 00019000  c0 3b 39 98 00 00 00 02  00 00 00 56 00 00 00 00  |.;9........V....|
> 00019800  c0 3b 39 98 00 00 00 01  00 00 00 57 00 00 00 7c  |.;9........W...||
> 00024000  c0 3b 39 98 00 00 00 02  00 00 00 57 00 00 00 00  |.;9........W....|
> 00024800  c0 3b 39 98 00 00 00 01  00 00 00 58 00 00 00 82  |.;9........X....|
> 0002f000  c0 3b 39 98 00 00 00 02  00 00 00 58 00 00 00 00  |.;9........X....|
> 00039000  c0 3b 39 98 00 00 00 02  00 00 00 1a 00 00 00 00  |.;9.............|
> 00039800  c0 3b 39 98 00 00 00 01  00 00 00 1b 00 00 00 8c  |.;9.............|
> 00046800  c0 3b 39 98 00 00 00 02  00 00 00 1b 00 00 00 00  |.;9.............|
> 
> 
> 
> 
> Kernel log:
> 
> [   43.801072] 223746  54914(0xd682) 0x40800 bytes
> [   43.802580] 
> [   43.853328] 224000  55168(0xd780) 0x40000 bytes
> [   43.854876] 
> [   43.962590] 224128  55296(0xd800) 0x40800 bytes
> [   43.964097] 
> [   44.016428] 221062  52230(0xcc06) 0x1000 bytes
> [   44.017844] 
> [   44.019594] 224257  55425(0xd881) 0x40800 bytes
> [   44.023832] 
> [   44.100933] 224386  55554(0xd902) 0x40800 bytes
> [   44.102439] 
> [   44.165200] 224640  55808(0xda00) 0x40000 bytes
> [   44.166727] 
> [   44.216643] 224768  55936(0xda80) 0x40800 bytes
> [   44.218144] 
> [   44.270599] 224897  56065(0xdb01) 0x40800 bytes
> [   44.272108] 
> [   44.348213] 201673  32841(0x8049) 0xa800 bytes  ===> (32841-32768)*block_size = 0x24800 , it is the start block of journal ID 0x58
> [   44.349659] J [   44.351275] 
> [   44.360542] 201694  32862(0x805e) 0x800 bytes
> [   44.361876] J S                                                                   
> [   44.363695] 
> [   44.365843] 225026  56194(0xdb82) 0x40800 bytes
> [   44.369716] 
> [   44.417490] drop to 9v
> [   44.422435] 225280  56448(0xdc80) 0x40000 bytes   ==> file hp00000119py87lXtVHG contents. This file is checksum correct. But data contents are written after journal commit.
> [   44.423938] 
> [   44.474334] 225408  56576(0xdd00) 0x40800 bytes   ===> file hp0000011aHHlIpPbjK6's data written after journal commit!!!
> [   44.475904] 
> nanddisk idle -> 1.
> [   44.479310] 6v irq-2

OK, so I was looking into the code and indeed, reality is correct and my
mental model was wrong! ;) I thought that inode gets added to the list of
inodes for which we need to wait for data IO completion during transaction
commit during block allocation. And I was wrong. It used to happen in
mpage_da_map_and_submit() until commit f3b59291a69d (ext4: remove calls to
ext4_jbd2_file_inode() from delalloc write path) where it got removed. And
that was wrong because although we submit data writes before dropping
handle for allocating transaction and updating i_size, nobody guarantees
that data IO is not delayed in the block layer until transaction commit.
Which seems to happen in your case. I'll send a fix. Thanks for your report
and persistence!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
