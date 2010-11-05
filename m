From: Joe Perches <joe@perches.com>
Subject: [PATCH V2 37/49] fs/ext4: Use vzalloc
Date: Fri, 05 Nov 2010 00:18:31 -0700
Message-ID: <1288941511.18440.63.camel@Joe-Laptop>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
	 <960a7efc569f61a50346257835ce5f457a0d4c99.1288925425.git.joe@perches.com>
	 <F35C793E-7CBA-4631-8928-C34D5B39F148@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jiri Kosina <trivial@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4271 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab0KEHSc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Nov 2010 03:18:32 -0400
In-Reply-To: <F35C793E-7CBA-4631-8928-C34D5B39F148@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Joe Perches <joe@perches.com>
---
differences from V1:
Andreas Dilger requested a block be moved so that
sbi->s_flex_groups isn't tested for NULL twice.
Also coalesced a ext4_msg printk format.

 fs/ext4/super.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 40131b7..6dbc4379 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1909,14 +1909,13 @@ static int ext4_fill_flex_info(struct
super_block *sb)
 	size = flex_group_count * sizeof(struct flex_groups);
 	sbi->s_flex_groups = kzalloc(size, GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {
-		sbi->s_flex_groups = vmalloc(size);
-		if (sbi->s_flex_groups)
-			memset(sbi->s_flex_groups, 0, size);
-	}
-	if (sbi->s_flex_groups == NULL) {
-		ext4_msg(sb, KERN_ERR, "not enough memory for "
-				"%u flex groups", flex_group_count);
-		goto failed;
+		sbi->s_flex_groups = vzalloc(size);
+		if (sbi->s_flex_groups == NULL) {
+			ext4_msg(sb, KERN_ERR,
+				 "not enough memory for %u flex groups",
+				 flex_group_count);
+			goto failed;
+		}
 	}
 
 	for (i = 0; i < sbi->s_groups_count; i++) {


