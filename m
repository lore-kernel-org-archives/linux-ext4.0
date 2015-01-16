From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH ext4] ext4 crypto: ext4_xattr_encryption_context_set() can be
 static
Date: Fri, 16 Jan 2015 10:07:13 +0800
Message-ID: <20150116020713.GA50649@snb>
References: <201501161001.0s7ByimN%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Michael Halcrow <mhalcrow@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30151 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941AbbAPCHS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Jan 2015 21:07:18 -0500
Content-Disposition: inline
In-Reply-To: <201501161001.0s7ByimN%fengguang.wu@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fs/ext4/xattr_encryption.c:80:5: sparse: symbol 'ext4_xattr_encryption_context_set' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 xattr_encryption.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr_encryption.c b/fs/ext4/xattr_encryption.c
index d03697a..851064a 100644
--- a/fs/ext4/xattr_encryption.c
+++ b/fs/ext4/xattr_encryption.c
@@ -77,7 +77,7 @@ static int ext4_xattr_encryption_set(struct dentry *dentry, const char *name,
  * Made as a separate function on purpose, so that setting this value from user
  * space tools is not available through generic set attribute path.
  */
-int ext4_xattr_encryption_context_set(struct dentry *dentry, const void *value,
+static int ext4_xattr_encryption_context_set(struct dentry *dentry, const void *value,
 				      size_t size, int flags, int type)
 {
 	return ext4_xattr_set(dentry->d_inode,
