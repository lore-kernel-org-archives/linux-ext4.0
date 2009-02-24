From: Felipe Franciosi <ozzy@doc.ic.ac.uk>
Subject: Simple inode question (ext2/3)
Date: Tue, 24 Feb 2009 17:13:52 +0000 (GMT)
Message-ID: <alpine.DEB.2.00.0902241713520.16614@pintail.doc.ic.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cardinal.doc.ic.ac.uk ([146.169.1.194]:57212 "EHLO
	cardinal.doc.ic.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758320AbZBXRgJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Feb 2009 12:36:09 -0500
Received: from pintail.doc.ic.ac.uk ([146.169.1.119])
	by cardinal.doc.ic.ac.uk with esmtps (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <ozzy@doc.ic.ac.uk>)
	id 1Lc0qu-0007c3-FE
	for linux-ext4@vger.kernel.org; Tue, 24 Feb 2009 17:13:52 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi there!

I've been trying to write a kernel module that is capable of locating a specific mounted filesystem (ext2/3) and dump all the inode entries that are in use. I have two questions:

1) Is it possible to know if an inode is free just by looking to its (struct ext3_inode) info or do I have to check the inode bitmap for the specific block group?

2) Does the following look correct?

--------8<--------

struct vfsmount        *mountpoint = ... // fetch this from the proper namespace
struct ext3_sb_info    *sbi = EXT3_SB(mountpoint->mnt_sb);
struct ext3_group_desc *egd;
struct ext3_inode      *ino;
struct buffer_head     *bh;
int i, j, k;

for (i=0; i<sbi->s_groups_count; i++) {
 egd = ext3_get_group_desc(mountpoint->mnt_sb, i, NULL);
 for (j=0; j<(sbi->s_inodes_per_group)/(sbi->s_inodes_per_block); j++) {
  bh = sb_getblk(mountpoint->mnt_sb, le32_to_cpu(egd->bg_inode_table+j));
  for (k=0; k<sbi->s_inodes_per_block; k++) {
   ino = (struct ext3_inode *)(bh+(k*sizeof(struct ext3_inode)));
   // dump contents of ino
   // index of ino should be: (i*(sbi->s_inodes_per_group)) + (j*(sbi->s_inodes_per_block)) + k
  }
 }
}

--------8<--------

Cheers,
Felipe

