From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: double free of blocks occurred during online defrag
Date: Wed, 25 Feb 2009 16:29:44 +0530
Message-ID: <20090225105944.GB25714@skywalker>
References: <49A4E7B8.2040804@sx.jp.nec.com> <20090225104446.GA25714@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54387 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZBYLAG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 06:00:06 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1PAwDms027793
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 21:58:13 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n1PB0K5g377084
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 22:00:20 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1PB02Jv030847
	for <linux-ext4@vger.kernel.org>; Wed, 25 Feb 2009 22:00:03 +1100
Content-Disposition: inline
In-Reply-To: <20090225104446.GA25714@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 25, 2009 at 04:14:46PM +0530, Aneesh Kumar K.V wrote:
> On Wed, Feb 25, 2009 at 03:39:52PM +0900, Kazuya Mio wrote:
> > Hi Aneesh,
> > 
> > When I remove the file that is running online defrag, the following error occurs
> > after closing the file descriptor:
> > 
> > Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8):
> > ext4_mb_release_inode_pa: free 2048, pa_free 1562
> > Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
> > double-free of inode 0's block 802817(bit 0 in group 98)
> > Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
> > double-free of inode 0's block 802818(bit 1 in group 98)
> > Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
> > double-free of inode 0's block 802819(bit 2 in group 98)
> > Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
> > double-free of inode 0's block 802820(bit 3 in group 98)
> > Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
> > double-free of inode 0's block 802821(bit 4 in group 98)
> > Jan 22 17:06:52 G3-OPC-SVR2 kernel: EXT4-fs error (device hda8): mb_free_blocks:
> > double-free of inode 0's block 802822(bit 5 in group 98)
> > 
> > So, online defrag calls ext4_discard_preallocations() at the end of
> > ext4_defrag() to avoid double-free error.
> > However, above error hasn't occurred since applying your patch posted on Nov
> > 6th, 2008 because this error is caused by the same reason of your report.
> > http://marc.info/?l=linux-ext4&m=122599787406193&w=4
> > 
> > What is the status of this patch?
> 
> We dropped the patch because I found that the double free in my case was
> not exactly due the explanation given in the patch above.
> 
> I asked to drop the patch in
> 
> http://article.gmane.org/gmane.comp.file-systems.ext4/10199
> 
> I also found that the patch is not completely correct. The meta-data
> blocks which are added to the free_list are not allocated from any
> prealloc space.
> 
> So what you are seeing may be a different problem which the patch is
> hiding from happening.  I guess you will have to look more closely at why the
> double-free is happening in your case.

I found one case of double-free , but not sure how the above patch is
helping to avoid that. Any how here is the case:


a) We have inode prealloc space. We allocated some blocks out of that
for data
b) We later free the data blocks. That means we mark the bits in bitmap
and buddy as free.
c) Now we want to discard the prealloc space. We look at the bitmap and
try mark the blocks which are free in bitmap as free in buddy. But since
the blocks are already marked free in buddy we hit the double free case.

To fix this we will have to scan all the inode prealloc space of the group
and if he blocks belong to the inode prealloc space we should not mark
them free in buddy.

-aneesh
