From: "Wang Chen" <ellre923@gmail.com>
Subject: [PATCH] ext3: Fix not initialized hash info in ext3_dx_find_entry()
Date: Thu, 30 Aug 2007 22:42:33 +0800
Message-ID: <00ee01c7eb14$051e3ed0$0201a8c0@pinkpig>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: "Wang Chen" <wangchen@cn.fujitsu.com>
To: "linux-ext4" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:34230 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbXH3On1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 10:43:27 -0400
Received: by rv-out-0910.google.com with SMTP id k20so166843rvb
        for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2007 07:43:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- In fs/ext3/namei.c, Variable "hinfo" may be referenced before it has
been set with a value.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
---

diff -Nurp linux-2.6.22.4.org/fs/ext3/namei.c linux-2.6.22.4/fs/ext3/namei.c
--- linux-2.6.22.4.org/fs/ext3/namei.c  2007-08-22 15:33:40.000000000 +0800
+++ linux-2.6.22.4/fs/ext3/namei.c      2007-08-28 17:47:44.000000000 +0800
@@ -952,6 +952,12 @@ static struct buffer_head * ext3_dx_find
                frame->bh = NULL;                       /* for dx_release() */
                frame->at = (struct dx_entry *)frames;  /* hack for zero entry*/
                dx_set_block(frame->at, 0);             /* dx_root block is 0 */
+               if (dentry){
+                       ext3fs_dirhash(dentry->d_name.name, dentry->d_name.len,
+                                      &hinfo);
+               } else {
+                       return NULL;
+               }
        }
        hash = hinfo.hash;
        do {

--
Wang Chen 
