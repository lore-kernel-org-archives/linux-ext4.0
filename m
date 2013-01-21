From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] quota: autoload the quota_v2 module for QFMT_VFS_V1 quota format
Date: Mon, 21 Jan 2013 01:46:21 -0500
Message-ID: <1358750781-5670-2-git-send-email-tytso@mit.edu>
References: <20130121054741.GB321@thunk.org>
 <1358750781-5670-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1358750781-5670-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Otherwise, ext4 file systems with the quota feature enable will get a
very confusing "No such process" error message if the quota code is
built as a mdoule and the quota_v2 module has not been loaded.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
---
 include/linux/quota.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/quota.h b/include/linux/quota.h
index 58fdef12..d133711 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -405,6 +405,7 @@ struct quota_module_name {
 #define INIT_QUOTA_MODULE_NAMES {\
 	{QFMT_VFS_OLD, "quota_v1"},\
 	{QFMT_VFS_V0, "quota_v2"},\
+	{QFMT_VFS_V1, "quota_v2"},\
 	{0, NULL}}
 
 #endif /* _QUOTA_ */
-- 
1.7.12.rc0.22.gcdd159b
