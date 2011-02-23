From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V5 11/24] vfs: Make acl_permission_check() work for richacls
Date: Wed, 23 Feb 2011 19:21:58 +0530
Message-ID: <1298469131-16555-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
To: sfrench@us.ibm.com, agruen@linbit.com, dilger.kernel@dilger.ca,
	sandeen@redhat.com, tytso@mit.edu, bfields@fieldses.org,
	jlayton@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1298469131-16555-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andreas Gruenbacher <agruen@suse.de>

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 1b6dbc9..d7ff419 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -174,6 +174,20 @@ static int acl_permission_check(struct inode *inode, int mask, unsigned int flag
 {
 	umode_t			mode = inode->i_mode;
 
+	if (IS_RICHACL(inode)) {
+		int error = check_acl(inode, mask, flags);
+		if (error != -EAGAIN)
+			return error;
+		if (mask & (MAY_DELETE_SELF | MAY_TAKE_OWNERSHIP |
+			    MAY_CHMOD | MAY_SET_TIMES)) {
+			/*
+			 * The file permission bit cannot grant these
+			 * permissions.
+			 */
+			return -EACCES;
+		}
+	}
+
 	if (current_fsuid() == inode->i_uid)
 		mode >>= 6;
 	else {
-- 
1.7.1
