From: boxi liu <boxi10liu@gmail.com>
Subject: it may be a ext4 feature-inlinedata bug
Date: Mon, 20 May 2013 22:50:57 +0800
Message-ID: <CAAFszuUGv=0cKFw_ku7A12uZK7wNb5huMOUPKtC4b2REMMuFjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ia0-f193.google.com ([209.85.210.193]:35106 "EHLO
	mail-ia0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3ETOu6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 May 2013 10:50:58 -0400
Received: by mail-ia0-f193.google.com with SMTP id k38so1588465iah.8
        for <linux-ext4@vger.kernel.org>; Mon, 20 May 2013 07:50:57 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In fs/ext4/xattr.c file, the function ex4_xattr_set_entry(), the size
of xattr space we use the pad to count it .In line 675:
   size_t size = EXT4_XATTR_SIZE(i->value_len);
We use the EXT_XATTR_SIZE to count the value_len,then get the xattr's
used space.
But in fs/ext4/inline.c file,we just use the actual size to count the
inlinedata free size,in function get_max_inline_xattr_value_size()
,line 75,such as:
    free += le32_to_cpu(entry->e_value_size);
This may bring in a bug about count the inlinedata free space.
The bug reproduction way:
1. in the subarea with inline_data feature
    touch test
2. use echo to add to write the test file 129 bytes
3. use the "stat" to get the test file's status
    stat test
    the result is:  .....size:129 block:0 .....
4.use echo to add one byte in the test file
   echo -n "0">>test
5.use the "stat" to get the test file's status
   stat test
   the result is:  .....size:130 block:8 .....
It is incorrect.In inline_data feature,only when the size is bigger
then 132,it will use the block.

The patch about this bug:
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 3e2bf87..bea5ced 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -72,7 +72,7 @@ static int get_max_inline_xattr_value_size(struct
inode *inode,
                entry = (struct ext4_xattr_entry *)
                        ((void *)raw_inode + EXT4_I(inode)->i_inline_off);

-               free += le32_to_cpu(entry->e_value_size);
+              free += EXT4_XATTR_SIZE(le32_to_cpu(entry->e_value_size));
                goto out;
        }
It might be fix this bug.
