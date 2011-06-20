From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 1/3] ext4: Fix compilation with -DDX_DEBUG v2
Date: Mon, 20 Jun 2011 22:28:49 +0200
Message-ID: <20110620202849.2473133.84386.stgit@localhost.localdomain>
References: <20110620202631.2473133.4166.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: adilger@whamcloud.com, colyli@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:39430 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1FTU2v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jun 2011 16:28:51 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p5KKSoj6028578
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jun 2011 22:28:50 +0200
In-Reply-To: <20110620202631.2473133.4166.stgit@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

changes from v1 -> v2:
Use %p as suggested by Coly Li

Compilation of ext4/namei.c brought up an error and warning messages
when compiled with -DDX_DEBUG


Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 fs/ext4/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b754b77..bfb749f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -288,7 +288,7 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 				char *name = de->name;
 				while (len--) printk("%c", *name++);
 				ext4fs_dirhash(de->name, de->name_len, &h);
-				printk(":%x.%u ", h.hash,
+				printk(":%x.%p ", h.hash,
 				       ((char *) de - base));
 			}
 			space += EXT4_DIR_REC_LEN(de->name_len);
@@ -1013,7 +1013,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
 
 	*err = -ENOENT;
 errout:
-	dxtrace(printk(KERN_DEBUG "%s not found\n", name));
+	dxtrace(printk(KERN_DEBUG "%s not found\n", d_name->name));
 	dx_release (frames);
 	return NULL;
 }

