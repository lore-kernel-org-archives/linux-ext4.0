From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [PATCH] ext2 : Remove redundant condition in ext2_free_blocks()
Date: Sun, 1 Jun 2008 00:26:33 +0530
Message-ID: <ea11fea30805311156o3715d3f9ibd4ea8b44a8f3223@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:30421 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbYEaS4e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 May 2008 14:56:34 -0400
Received: by ti-out-0910.google.com with SMTP id b6so128657tic.23
        for <linux-ext4@vger.kernel.org>; Sat, 31 May 2008 11:56:33 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For two unsigned values the check "block+count < block"  is always
false. Thus the below patch removes that condition.

=============================================================

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

--- a/fs/ext2/balloc.c  2008-05-11 23:54:40.000000000 +0530
+++ b/fs/ext2/balloc.c  2008-06-01 00:03:44.000000000 +0530
@@ -499,7 +499,6 @@
        unsigned freed = 0, group_freed;

        if (block < le32_to_cpu(es->s_first_data_block) ||
-           block + count < block ||
            block + count > le32_to_cpu(es->s_blocks_count)) {
                ext2_error (sb, "ext2_free_blocks",
                            "Freeing blocks not in datazone - "


=============================================================

-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
