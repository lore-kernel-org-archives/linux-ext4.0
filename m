From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: fix potential use after free during resize
Date: Sat, 6 Dec 2014 16:53:41 +0300
Message-ID: <20141206135341.GC17278@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22628 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaLFNxw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Dec 2014 08:53:52 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Dmitry Monakhov,

The patch fdfe07398761: "ext4: fix potential use after free during
resize" from Dec 2, 2014, leads to the following static checker
warning:

	fs/ext4/balloc.c:300 ext4_get_group_desc()
	warn: 'gd_bh' can't be NULL.

This is a false positive in Smatch, but I still had a question about the
code.

fs/ext4/balloc.c
   295          group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
   296          offset = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
   297          rcu_read_lock();
   298          gd_bh = *rcu_dereference(sbi->s_group_desc) + group_desc;
   299          rcu_read_unlock();
   300          if (!gd_bh) {

Are you sure you don't want to "*rcu_dereference(sbi->s_group_desc)"
separate from group_desc?

		gd_bh = *rcu_dereference(sbi->s_group_desc);
		rcu_read_unlock();
		if (!gd_bh) {
			...
		}
		gd_bh = (u8 *) + group_desc;

   301                  ext4_error(sb, "Group descriptor not loaded - "
   302                             "block_group = %u, group_desc = %u, desc = %u",
   303                             block_group, group_desc, offset);
                                                ^^^^^^^^^^
We already know this is zero.

   304                  return NULL;
   305          }
   306  
   307          desc = (struct ext4_group_desc *)(
   308                  (__u8 *)gd_bh->b_data + offset * EXT4_DESC_SIZE(sb));
   309          if (bh)
   310                  *bh = gd_bh;

regards,
dan carpenter
