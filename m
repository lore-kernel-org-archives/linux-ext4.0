From: Ding Dinghua <dingdinghua85@gmail.com>
Subject: Is this a bug?
Date: Sat, 2 Apr 2011 16:05:50 +0800
Message-ID: <BANLkTinPYj7_qpKcZgp3Oya1LXzcbfBczQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46492 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1DBIFv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Apr 2011 04:05:51 -0400
Received: by iyb14 with SMTP id 14so4288250iyb.19
        for <linux-ext4@vger.kernel.org>; Sat, 02 Apr 2011 01:05:51 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When truncate files and free blocks, the following codes make me puzzled:

void ext4_free_blocks(handle_t *handle, struct inode *inode,
                      struct buffer_head *bh, ext4_fsblk_t block,
                      unsigned long count, int flags)
{
        if (flags & EXT4_FREE_BLOCKS_FORGET) {
                struct buffer_head *tbh = bh;
                int i;

                BUG_ON(bh && (count > 1));

                for (i = 0; i < count; i++) {
                        if (!bh)
                                tbh = sb_find_get_block(inode->i_sb,
                                                        block + i);
                        if (unlikely(!tbh))
                                continue;
                        ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
                                    inode, tbh, block + i);
                }
        }
}

I notice that ext4_forget mainly do two things:
    a)  call jbd2_journa_forget to forget the modification of some buffer head
    b)  or deal with the revoke issue
however, if we are freeing data blocks && ext4_forget get into branch a),
tbh is not the buffer_head which journal took care of in ext4_write_begin,
so i'm puzzled with this.

Could anyone explain it to me? Thanks.

--
Ding Dinghua
