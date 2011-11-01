From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4: let ext4_ext_convet_to_initialized initialize var(eh) before using it
Date: Tue,  1 Nov 2011 09:21:21 +0800
Message-ID: <1320110481-12080-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34100 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab1KAD1f (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 23:27:35 -0400
Received: by iaby12 with SMTP id y12so7856389iab.19
        for <linux-ext4@vger.kernel.org>; Mon, 31 Oct 2011 20:27:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_convert_to_initialized() does not initialize eh before using it
and this is introduced in commit 864d21652.

Cc:Eric Gouriou <egouriou@google.com>
Cc:"Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---

Hi Eric,

Was that patch tested?

 fs/ext4/extents.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9dfdf8f..2798945 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2944,6 +2944,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		eof_block = map->m_lblk + map->m_len;
 
 	depth = ext_depth(inode);
+	eh = path[depth].p_hdr;
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
 	ee_len = ext4_ext_get_actual_len(ex);
-- 
1.7.5.1

