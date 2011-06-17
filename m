From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: [PATCH 1/2] ext4: Fix compilation with -DDX_DEBUG
Date: Fri, 17 Jun 2011 18:00:55 +0200
Message-ID: <20110617160055.2062012.47590.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:56342 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1FQQMD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2011 12:12:03 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p5HG0usE028704
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Fri, 17 Jun 2011 18:00:56 +0200
Received: from mail2.itwm.fhg.de ([131.246.191.79]:44945)
	by itwm2.itwm.fhg.de with esmtps (TLSv1:DES-CBC3-SHA:168)
	(/C=DE/ST=Rheinland-Pfalz/L=Kaiserslautern/O=Fraunhofer ITWM/OU=SLG/CN=mail2.itwm.fhg.de)(verified=1)
	 (Exim 4.74 #1)
	id 1QXbTc-0007QU-22
	for linux-ext4@vger.kernel.org; Fri, 17 Jun 2011 18:00:56 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

Compilation of ext4/namei.c brought up an error and warning messages
when compiled with -DDX_DEBUG


Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 fs/ext4/namei.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b754b77..6f32da4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -288,8 +288,8 @@ static struct stats dx_show_leaf(struct dx_hash_info *hinfo, struct ext4_dir_ent
 				char *name = de->name;
 				while (len--) printk("%c", *name++);
 				ext4fs_dirhash(de->name, de->name_len, &h);
-				printk(":%x.%u ", h.hash,
-				       ((char *) de - base));
+				printk(":%x.%ld ", h.hash,
+				       (long) ((char *) de - base));
 			}
 			space += EXT4_DIR_REC_LEN(de->name_len);
 			names++;
@@ -1013,7 +1013,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
 
 	*err = -ENOENT;
 errout:
-	dxtrace(printk(KERN_DEBUG "%s not found\n", name));
+	dxtrace(printk(KERN_DEBUG "%s not found\n", d_name->name));
 	dx_release (frames);
 	return NULL;
 }

