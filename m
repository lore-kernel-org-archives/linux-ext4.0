Return-Path: <SRS0=03HA=MU=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59841 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbeJIHEj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Oct 2018 03:04:39 -0400
From: Chengguang Xu <cgxu519@gmx.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext4: remove QUOTA flag setting in set_qf_name()
Date: Tue,  9 Oct 2018 07:50:13 +0800
Message-Id: <20181008235013.13687-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mount flag QUOTA is the same as flag USRQUOTA in ext4, so should
not set flag QUOTA in set_qf_name().

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext4/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1145109968ef..9ed33e4860db 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1566,7 +1566,6 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
 		goto errout;
 	}
 	sbi->s_qf_names[qtype] = qname;
-	set_opt(sb, QUOTA);
 	return 1;
 errout:
 	kfree(qname);
-- 
2.17.1
