From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH] ext4: fix error ext number comments
Date: Fri, 16 May 2008 10:51:06 +0800
Message-ID: <482CF69A.4090308@cn.fujitsu.com>
References: <482B9E27.60100@cn.fujitsu.com> <20080515163831.8221e33d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61332 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbYEPCxG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2008 22:53:06 -0400
In-Reply-To: <20080515163831.8221e33d.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andrew Morton Wrote:
> On Thu, 15 May 2008 10:21:27 +0800
> Shen Feng <shen@cn.fujitsu.com> wrote:
> 
>> Subject: [PATCH] ext4: fix error ext number comments
> 
> Oh dear.  When my eail client (sylpheed) saves this email to a file I get
> 
> Subject: =?GB2312?B?o9tQQVRDSF0gZXh0NDogZml4IGVycm9yIGV4dCBudW1iZXIgY29tbQ==?=
>  =?GB2312?B?ZW50cw==?=
> 
> 
> This can only increase.  Sigh, life used to be simple.
> 
> 

It seems that there is a coding problem.
Sorry for that.  And the fix is not complete and here is the new one.

ext4: fix error ext number comments

Change second/third to fourth.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/ext4_i.h  |    2 +-
 fs/ext4/ext4_sb.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8158083..f8e22e4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -22,7 +22,7 @@
 #include "ext4_i.h"

 /*
- * The second extended filesystem constants/structures
+ * The fourth extended filesystem constants/structures
  */

 /*
diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
index 26a4ae2..abf2744 100644
--- a/fs/ext4/ext4_i.h
+++ b/fs/ext4/ext4_i.h
@@ -79,7 +79,7 @@ struct ext4_ext_cache {
 };

 /*
- * third extended file system inode data in memory
+ * fourth extended file system inode data in memory
  */
 struct ext4_inode_info {
 	__le32	i_data[15];	/* unconverted */
diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index 5802e69..4de9a75 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -25,7 +25,7 @@
 #include <linux/rbtree.h>

 /*
- * third extended-fs super-block data in memory
+ * fourth extended-fs super-block data in memory
  */
 struct ext4_sb_info {
 	unsigned long s_desc_size;	/* Size of a group descriptor in bytes */
-- 1.5.4.1

