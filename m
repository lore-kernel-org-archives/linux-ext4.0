From: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Subject: [PATCH]ext4: add the spec for ext4 subdirectory limit(was: Problems
 with the max value for create directory)
Date: Mon, 19 Jan 2009 11:57:05 +0800
Message-ID: <4973FA11.3000309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51090 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758001AbZASDzs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Jan 2009 22:55:48 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: add the spec for ext4 subdirectory limit

When the block size is 1024, users can't creat 32000 subdirectories for htree limit.
I think it should be added to ext4 document.

Signed-off-by: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
---
 Documentation/filesystems/ext4.txt |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index cec829b..df17557 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -85,7 +85,8 @@ Note: More extensive information for getting started with ext4 can be
 * extent format more robust in face of on-disk corruption due to magics,
 * internal redundancy in tree
 * improved file allocation (multi-block alloc)
-* fix 32000 subdirectory limit
+* fix 32000 subdirectory limit (when block size is 1024, the limit will be
+* less than 32000)
 * nsec timestamps for mtime, atime, ctime, create time
 * inode version field on disk (NFSv4, Lustre)
 * reduced e2fsck time via uninit_bg feature

