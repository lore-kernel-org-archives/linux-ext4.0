From: boxi liu <boxi10liu@gmail.com>
Subject: [PATCH] ext4:an improvement in ext4 feature inline_data
Date: Sun, 26 May 2013 21:19:15 +0800
Message-ID: <CAAFszuV7QJc2-5xFerStUrjNhD4+MR3R7kBVAxsg+Otx18RvGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Robin Dong <sanbai@taobao.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tm@tao.ma" <tm@tao.ma>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:47459 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3EZNTQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 26 May 2013 09:19:16 -0400
Received: by mail-ie0-f180.google.com with SMTP id b11so2088200iee.25
        for <linux-ext4@vger.kernel.org>; Sun, 26 May 2013 06:19:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4 feature inline_data,it use the xattr's space to store the
inline data in inode.When we calculate the inline data as the xattr,we
add the pad.But in get_max_inline_xattr_value_size() function we count
the free space without pad.It cause some contents are moved to a block
even if it can be
stored in the inode.

Signed-off-by:liulei <lewis.liulei@huawei.com>
---
 fs/ext4/inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index c0fd1a1..87758ca 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -71,7 +71,7 @@ static int get_max_inline_xattr_value_size(struct
inode *inode,
                entry = (struct ext4_xattr_entry *)
                        ((void *)raw_inode + EXT4_I(inode)->i_inline_off);

-               free += le32_to_cpu(entry->e_value_size);
+               free += EXT4_XATTR_SIZE(le32_to_cpu(entry->e_value_size));
                goto out;
        }

--
