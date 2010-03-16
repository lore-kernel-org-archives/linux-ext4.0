From: Steven Liu <lingjiujianke@gmail.com>
Subject: [PATCH 1/1]ext4: cleanup a warning
Date: Tue, 16 Mar 2010 18:54:43 +0800
Message-ID: <bd0d95d71003160354h538eec47t3246b397f4e0c5be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f176.google.com ([209.85.223.176]:43185 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937718Ab0CPKyo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Mar 2010 06:54:44 -0400
Received: by iwn6 with SMTP id 6so764122iwn.4
        for <linux-ext4@vger.kernel.org>; Tue, 16 Mar 2010 03:54:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

        I have get a warning, too,


fs/ext4/move_extent.c:478: warning: start_ext.ee_block may be used
uninitialized in this function

my compiler version:

gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


I think i'm not the first get this warning,then i make a patch for
this warning, can you fix it in?

Signed-off-by: Qi Liu (lingjiujianke@gmail.com)

diff --git a/ext4/fs/ext4/move_extent.c.orig b/ext4/fs/ext4/move_extent.c
index aa5fe28..b399358 100644
--- a/ext4/fs/ext4/move_extent.c.orig
+++ b/ext4/fs/ext4/move_extent.c
@@ -481,6 +481,7 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
        int depth = ext_depth(orig_inode);
        int ret;

+       start_ext.ee_block = end_ext.ee_block = 0;
        o_start = o_end = oext = orig_path[depth].p_ext;
        oext_alen = ext4_ext_get_actual_len(oext);
        start_ext.ee_len = end_ext.ee_len = 0;




                                Qi Liu
