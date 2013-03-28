From: Tao Ma <tm@tao.ma>
Subject: [PATCH 2/2] ext4: Handle readdir when a file is converted from inline to block based.
Date: Thu, 28 Mar 2013 18:34:59 +0800
Message-ID: <1364466899-5599-2-git-send-email-tm@tao.ma>
References: <1364466899-5599-1-git-send-email-tm@tao.ma>
Cc: zab@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:34916 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751730Ab3C1Kfa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Mar 2013 06:35:30 -0400
In-Reply-To: <1364466899-5599-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Zach reported that if a dir is inlined, the offset is within the inode, while
if we have done the conversion, the dir now will have a block offset or even
a hashed pos. The good thing is that ext4 is also prepared to handle some
situation that the dir is changed during many calls of getdents.

This patch just increased the inode->i_version in dir conversion so that normal
ext4 readdir codes can work properly to handle this issue.

Reported-by: Zach Brown <zab@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inline.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 9c09dd5..b1379fc 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1130,6 +1130,7 @@ static int ext4_finish_convert_inline_dir(handle_t *handle,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	inode->i_version++;
 	inode->i_size = inode->i_sb->s_blocksize;
 	i_size_write(inode, inode->i_sb->s_blocksize);
 	EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
-- 
1.7.0.4

