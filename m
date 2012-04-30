From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/3] ext3: pass custom EOF to generic_file_llseek_size()
Date: Mon, 30 Apr 2012 13:16:04 -0500
Message-ID: <4F9ED6E4.6050908@redhat.com>
References: <4F9AC770.8080004@redhat.com> <20120428183315.GA28349@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab2D3SQe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2012 14:16:34 -0400
In-Reply-To: <20120428183315.GA28349@parisc-linux.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the new custom EOF argument to generic_file_llseek_size so
that SEEK_END will go to the max hash value for htree dirs
in ext3 rather than to i_size_read()

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 92490e9..c8fff93 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -300,10 +300,11 @@ loff_t ext3_dir_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct inode *inode = file->f_mapping->host;
 	int dx_dir = is_dx_dir(inode);
+	loff_t htree_max = ext3_get_htree_eof(file);
 
 	if (likely(dx_dir))
 		return generic_file_llseek_size(file, offset, origin,
-					        ext3_get_htree_eof(file));
+					        htree_max, htree_max);
 	else
 		return generic_file_llseek(file, offset, origin);
 }


