From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix small file fragmentation
Date: Fri, 15 Aug 2008 22:01:12 +0530
Message-ID: <20080815163112.GA6511@skywalker>
References: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080814231816.GA13048@mit.edu> <20080815133803.GL13048@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:49949 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbYHOQbY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 12:31:24 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7FGUtjm017789
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 02:30:55 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FGVKB53981468
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 02:31:20 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FGVJID020259
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 02:31:20 +1000
Content-Disposition: inline
In-Reply-To: <20080815133803.GL13048@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2008 at 09:38:03AM -0400, Theodore Tso wrote:
> Here's an interesting data point.  Using Chris Mason's compilebench:
> 
> http://oss.oracle.com/~mason/compilebench
> 
> If I use:
> 
> ./compilebench  -D /mnt -i 2 -r 0
> 
> on a 4GB machine such that I have plenty of memory (and nothing gets
> forced disk due to memory pressure), I don't see hardly any of the
> small file fragmentation problem (0.8% of the inodes in use on the
> filesystem.  This is with your patch applied.
> 
> However, if I use:
> 
> ./compilebench  -D /mnt -i 10 -r 0
> 
> so that data blocks are getting pushed out due to memory pressure,
> then I see plenty of non-contiugous inodes (8.1% of the inodes in use
> on the filesystem).  So with your patch applied, it seems that we
> still have a problem related to delayed allocation and how the VM
> system is doing its page cleaning.

As I explained in my previous patch the problem is due to pdflush
background_writeout. Now when pdflush does the writeout we may
have only few pages for the file and we would attempt
to write them to disk. So my attempt in the last patch was to
do the below

a) When allocation blocks try to be close to the goal block specified
b) When we call ext4_da_writepages make sure we have minimal nr_to_write
  that ensures we allocate all dirty buffer_heads in a single go.
  nr_to_write is set to 1024 in pdflush background_writeout and that
  would mean we may end up calling some inodes writepages() with really
  small values even though we have more dirty buffer_heads.

What it doesn't handle is
1) File A have 4 dirty buffer_heads.
2) pdflush try to write them. We get 4 contig blocks
3) File A now have new 5 dirty_buffer_heads
4) File B now have 6 dirty_buffer_heads
5) pdflush try to write the 6 dirty buffer_heads of file B and allocate
them next to earlier file A blocks
6) pdflush try to write the 5 dirty buffer_heads of file A and allocate
them after file B blocks resulting in discontinuity.

I am right now testing the below patch which make sure new dirty inodes
are added to the tail of the dirty inode list

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 25adfc3..a658690 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -163,7 +163,9 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 */
 		if (!was_dirty) {
 			inode->dirtied_when = jiffies;
-			list_move(&inode->i_list, &sb->s_dirty);
+			//list_move(&inode->i_list, &sb->s_dirty);
+			__list_del(&inode->i_list->prev, &inode->i_list->next);
+			list_add_tail(&inode->i_list, &sb->s_dirty);
 		}
 	}
 out:
