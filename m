From: "Rohit Sharma" <imreckless@gmail.com>
Subject: ext2_find_near
Date: Thu, 31 Jul 2008 20:17:06 +0530
Message-ID: <2d08ef090807310747p72716f56v6271f81aef7cb8a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:42697 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYGaOrI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 10:47:08 -0400
Received: by yw-out-2324.google.com with SMTP id 9so355213ywe.1
        for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 07:47:07 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I was going through the function "ext2_find_near" in inode.c and could not
interpret the meaning of the last part of this code :

static ext2_fsblk_t ext2_find_near(struct inode *inode, Indirect *ind)
{
       struct ext2_inode_info *ei = EXT2_I(inode);
       __le32 *start = ind->bh ? (__le32 *) ind->bh->b_data : ei->i_data;
       __le32 *p;
       ext2_fsblk_t bg_start;
       ext2_fsblk_t colour;

       /* Try to find previous block */
      for (p = ind->p - 1; p >= start; p--)
               if (*p)
                       return le32_to_cpu(*p);

       /* No such thing, so let's try location of indirect block */
      if (ind->bh)
               return ind->bh->b_blocknr;

       /*
        * It is going to be refered from inode itself? OK, just put it into
        * the same cylinder group then.
        */

       bg_start = ext2_group_first_block_no(inode->i_sb, ei->i_block_group);

       / * what does the code below do?? why its is using pid of
current process?? */

       colour = (current->pid % 16) *
                       (EXT2_BLOCKS_PER_GROUP(inode->i_sb) / 16);
      return bg_start + colour;
}


What I understand from it is that it has something to do with reducing
the chances of a concurrent allocation -- supposedly from a different
PID.

Can someone just explain a bit on this, what exactly is happening ?

Thanks,
Rohit Sharma.
