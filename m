From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH] ext4: fix COLLAPSE RANGE test failure when bigalloc is
 enable
Date: Thu, 05 Jun 2014 17:48:34 +0900
Message-ID: <002c01cf809a$ef312cd0$cd938670$@samsung.com>
References: <001001cf7fcc$34f3c2c0$9edb4840$@samsung.com>
 <alpine.LFD.2.00.1406041456210.2927@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:64977 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaFEIsn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2014 04:48:43 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N6O00MZLTSY9I30@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 05 Jun 2014 17:48:35 +0900 (KST)
In-reply-to: <alpine.LFD.2.00.1406041456210.2927@localhost.localdomain>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Wed, 4 Jun 2014, Namjae Jeon wrote:
> 
> > Date: Wed, 04 Jun 2014 17:08:45 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: Theodore Ts'o <tytso@mit.edu>
> > Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
> >     Ashish Sangwan <a.sangwan@samsung.com>
> > Subject: [PATCH] ext4: fix COLLAPSE RANGE test failure when bigalloc is enable
> >
> > Blocks in collapse range should be collapsed per cluster unit when bigalloc
> > is enable. If bigalloc is not enable, EXT4_CLUSTER_SIZE will be same with
> > EXT4_BLOCK_SIZE.
> 
> I wonder why it is so ? Bigalloc only affects the way we allocate
> and free blocks, it does not affect extent tree at all and so
> freeing and allocating extents at the block boundary on bigalloc
> file system should be just fine - underlying code should be able to
> handle it.
> 
> It might be that there is some complication in shift_extent code
> which is not obvious to me. Could you please describe the problem
> and why this is needed little bit more ?
The reason we can not do intra cluster collapse is because the way
ext4 code works when bigalloc is enabled.
It does not expect the relative mapping between file's logical block
number and physical block numbers within a cluster to be changed.
The following example elaborates this point:
Logs on a ext4 partition with cluster size as 64k.

1. Create a 64k file and dump its extent tree =>
VDLinux#> dd if=/dev/zero of=abc bs=65536 count=1
1+0 records in
1+0 records out
65536 bytes (64.0KB) copied, 0.000699 seconds, 89.4MB/s

debugfs: ex abc
Level Entries Logical Physical Length Flags
0/ 0 1/ 1 0 - 15 557088 - 557103 16

2. Collapse the first block =>
debugfs: ex abc
Level Entries Logical Physical Length Flags
0/ 0 1/ 1 0 - 14 557089 - 557103 15

3. punch a hole at second block =>
debugfs: ex abc
Level Entries Logical Physical Length Flags
0/ 0 1/ 2 0 - 0 557089 - 557089 1
0/ 0 2/ 2 2 - 14 557091 - 557103 13

4. Again allocate block for the hole at block1.
This time already allocated block is allocated.
debugfs: ex abc
Level Entries Logical Physical Length Flags
0/ 0 1/ 3 0 - 0 557089 - 557089 1
0/ 0 2/ 3 1 - 1 557089 - 557089 1 Uninit
0/ 0 3/ 3 2 - 14 557091 - 557103 13

mballoc code thinks that at logical block 1, block number 557089 is
present but when we shift by 1 block using collapse range, 557089
is moved to block 0. But mballoc code does not expect this intra
cluster block movement, so when again try to allocate for block 1,
it allocates block 557089 again.
Also, we can exercise collapse range such that a single block could
be part of 2 clusters:

debugfs:  ex abc
Level Entries       Logical          Physical Length Flags
 0/ 0   1/  4     0 -    14  557088 -  557102     15
 0/ 0   2/  4    15 -    15  557104 -  557104      1
 0/ 0   3/  4    16 -    16  557104 -  557104      1 Uninit
 0/ 0   4/  4    17 -    30  557106 -  557119     14

block number 557104 is part of both cluster#0 and #1.
when we try to remove such a file, ext4 throws error.
[ 2488.440000] EXT4-fs error (device sdb2):
ext4_mb_free_metadata:4563: group 1, block 557104:Block already on
to-be-freed list
[ 2488.452000] JBD2: Spotted dirty metadata buffer (dev = sdb2,
blocknr = 0). There's a risk of filesystem corruption in case of
system crash.

> 
> Have you done some testing with bigalloc enabled file system with
> respect to collapse range ?
Yes, generic/075 and 091 in xfstests was tested. It was getting
failed and on checking we found the above issue.

Thanks!
> 
> Thanks!
> -Lukas
> 
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/ext4/extents.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 4da228a..2b9f5f3 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -5403,16 +5403,13 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
> >  	int ret;
> >
> >  	/* Collapse range works only on fs block size aligned offsets. */
> > -	if (offset & (EXT4_BLOCK_SIZE(sb) - 1) ||
> > -	    len & (EXT4_BLOCK_SIZE(sb) - 1))
> > +	if (offset & (EXT4_CLUSTER_SIZE(sb) - 1) ||
> > +	    len & (EXT4_CLUSTER_SIZE(sb) - 1))
> >  		return -EINVAL;
> >
> >  	if (!S_ISREG(inode->i_mode))
> >  		return -EINVAL;
> >
> > -	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1)
> > -		return -EOPNOTSUPP;
> > -
> >  	trace_ext4_collapse_range(inode, offset, len);
> >
> >  	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
> >

