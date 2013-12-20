From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Fwd: [RESEND PATCH 1/2] ext4: fix a typo in extents.c
Date: Fri, 20 Dec 2013 13:11:38 +0800
Message-ID: <CAGBYx2bJKzNU9qQEbQjWKk3c=DzBEHu_5waa=2uShHwX3JbpYQ@mail.gmail.com>
References: <1387515880-10185-1-git-send-email-yangyongqiang01@baidu.com> <CAGBYx2buHtAYoRMAoJZqRHKAK2LQy68uPswWUP_oGWom1BYwbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43634 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3LTFL7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Dec 2013 00:11:59 -0500
Received: by mail-ea0-f170.google.com with SMTP id k10so812014eaj.15
        for <linux-ext4@vger.kernel.org>; Thu, 19 Dec 2013 21:11:58 -0800 (PST)
In-Reply-To: <CAGBYx2buHtAYoRMAoJZqRHKAK2LQy68uPswWUP_oGWom1BYwbg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

Signed-off-by: Yongqiang Yang <yangyongqiang01@baidu.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 54d52af..3654dac 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3492,7 +3492,7 @@ static int
ext4_ext_convert_to_initialized(handle_t *handle,
        WARN_ON(map->m_lblk < ee_block);
        /*
         * It is safe to convert extent to initialized via explicit
-        * zeroout only if extent is fully insde i_size or new_size.
+        * zeroout only if extent is fully inside i_size or new_size.
         */
        split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;

--
1.8.5.2
