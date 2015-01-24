From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH ext4] ext4 crypto: ext4_find_dest_de_crypt() can be static
Date: Sat, 24 Jan 2015 08:33:41 +0800
Message-ID: <20150124003341.GA46929@lkp-sb04>
References: <201501240824.lsZlTlwQ%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Theodore Ts'o <tytso@mit.edu>,
	Uday Savagaonkar <savagaon@google.com>,
	Ildar Muslukhov <ildarm@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9970 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbbAXAea (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jan 2015 19:34:30 -0500
Content-Disposition: inline
In-Reply-To: <201501240824.lsZlTlwQ%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fs/ext4/namei.c:2056:5: sparse: symbol 'ext4_find_dest_de_crypt' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 0bd6758..7bbf0f9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2053,7 +2053,7 @@ journal_error:
 }
 
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
-int ext4_find_dest_de_crypt(struct inode *dir, struct inode *inode,
+static int ext4_find_dest_de_crypt(struct inode *dir, struct inode *inode,
 			    struct buffer_head *bh,
 			    void *buf, int buf_size,
 			    const char *name, int namelen,
