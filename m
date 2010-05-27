From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] ext3: fix non-update ctime when changing the file's permission
 by setfacl
Date: Thu, 27 May 2010 16:28:40 +0800
Message-ID: <4BFE2D38.2010501@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linux-Ext4 <linux-ext4@vger.kernel.org>,
	Linux-Kernel <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61938 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab0E0I1M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 May 2010 04:27:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext3 didn't update the ctime of the file when its permission was changed.

Steps to reproduce:
 # touch aaa
 # stat -c %Z aaa
 1275289822
 # setfacl -m  'u::x,g::x,o::x' aaa
 # stat -c %Z aaa
 1275289822				<- unchanged

But, according to the spec of the ctime, ext3 must update it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/ext3/acl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 01552ab..8a11fe2 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -205,6 +205,7 @@ ext3_set_acl(handle_t *handle, struct inode *inode, int type,
 					return error;
 				else {
 					inode->i_mode = mode;
+					inode->i_ctime = CURRENT_TIME_SEC;
 					ext3_mark_inode_dirty(handle, inode);
 					if (error == 0)
 						acl = NULL;
-- 
1.6.5.2


