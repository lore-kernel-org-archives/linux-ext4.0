From: number9652 <number9652@yahoo.com>
Subject: Re: [PATCH] mk2fs lazy_journal_init option
Date: Fri, 19 Feb 2010 11:53:54 -0800 (PST)
Message-ID: <127958.57045.qm@web43516.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Shuichi Ihara <ihara@sun.com>
To: Andreas Dilger <adilger@sun.com>, Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from n73.bullet.mail.sp1.yahoo.com ([98.136.44.191]:37548 "HELO
	n73.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753894Ab0BSTxy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2010 14:53:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I hope you decide to continue unconditionally zeroing the journal at mkfs time.

In this case, block_iterate2 was being used to create a file, but when the file became big enough to have an extent leaf, ext2fs_get_extent was returning an extent when it shouldn't have been.  That caused ext2fs_block_iterate2 to go wrong, eventually calling mkjournal_proc millions of times more than it needed to (during which it would immediately return).  A patch which resolves this is below.  It shows normal mkfs times for me with a 512 MB journal and passes make check.

Signed-off-by Nic Case <number9652@yahoo.com>

--- lib/ext2fs/extent-orig.c    2010-02-05 08:58:41.000000000 -0600
+++ lib/ext2fs/extent.c 2010-02-19 13:37:32.000000000 -0600
@@ -307,16 +307,12 @@
                                op = EXT2_EXTENT_DOWN;
                        } else if (path->left > 0)
                                op = EXT2_EXTENT_NEXT_SIB;
-                       else if (handle->level > 0)
-                               op = EXT2_EXTENT_UP;
                        else
                                return EXT2_ET_EXTENT_NO_NEXT;
                } else {
                        /* leaf node */
                        if (path->left > 0)
                                op = EXT2_EXTENT_NEXT_SIB;
-                       else if (handle->level > 0)
-                               op = EXT2_EXTENT_UP;
                        else
                                return EXT2_ET_EXTENT_NO_NEXT;
                }




      

