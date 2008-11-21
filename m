From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap
	and mark_diskspace_used
Date: Fri, 21 Nov 2008 23:09:20 +0530
Message-ID: <20081121173920.GG11212@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4926EE3C.7050207@redhat.com> <20081121173135.GF11212@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34692 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248AbYKURpy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 12:45:54 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mALHj367003352
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:45:03 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mALHdbtN205192
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:39:37 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mALHda2T027394
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:39:37 +1100
Content-Disposition: inline
In-Reply-To: <20081121173135.GF11212@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 11:01:35PM +0530, Aneesh Kumar K.V wrote:
> On Fri, Nov 21, 2008 at 11:22:04AM -0600, Eric Sandeen wrote:
> > Aneesh Kumar K.V wrote:
> > > We need to make sure we update the block bitmap and clear
> > > EXT4_BG_BLOCK_UNINIT flag with sb_bgl_lock held. We look
> > > at EXT4_BG_BLOCK_UNINIT and reinit the block bitmap each
> > > time in ext4_read_block_bitmap (introduced by
> > > c806e68f5647109350ec546fee5b526962970fd2 )
> > 
> > Can you add details about the failure mode(s) of this race, so people
> > (i.e. me) have an idea which bugs they've seen that it might address?
> > 
> 

The errors I have seen are

a)
3795  if (free != pa->pa_free) {
3796      printk(KERN_CRIT "pa %p: logic %lu, phys. %lu, len %lu\n",
3797                pa, (unsigned long) pa->pa_lstart,
3798                (unsigned long) pa->pa_pstart,
3799                 (unsigned long) pa->pa_len);

b)

1091     if (!mb_test_bit(block, EXT4_MB_BITMAP(e4b))) {
1092             ext4_fsblk_t blocknr;
1093             blocknr = e4b->bd_group * EXT4_BLOCKS_PER_GROUP(sb);
1094             blocknr += block;
1095             blocknr +=
1096 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
1097           ext4_unlock_group(sb, e4b->bd_group);
1098           ext4_error(sb, __func__, "double-free of
inode"

For inode bitmap i have seen

[root@llm19 tmp]# ls -al /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/l71
ls: /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/l71: Stale NFS file handle
[root@llm19 tmp]# ls -al /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/
total 411
drwxrwxrwx 3 689933 root    1024 Nov 18 05:59 .
drwxrwxrwx 3   8391 root    1024 Nov 18 05:59 ..
drwxrwxrwx 2 root   root    1024 Nov 18 05:33 d83
-rw-rw-rw- 1 root   root       0 Nov 18 05:06 fb4
-rw-rw-rw- 1 root   root 3350138 Nov 18 05:33 fb9
?--------- ? ?      ?          ?            ? l71
lrwxrwxrwx 1 root   root     509 Nov 18 05:23 ld9 -> xxxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxx
[root@llm19 tmp]# 

dmesg gives:

EXT4-fs error (device sdb1): ext4_free_inode: bit already cleared for inode 168449


Some other message i got before. But i didn't capture the info fully 

a) "Deleting nonexistent file ..." warning in ext4_unlink

b) "Empty directory has too many links..." in ext4_rmdir

