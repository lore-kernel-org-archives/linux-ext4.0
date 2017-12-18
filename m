From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 15/19] IMA: switch IMA over to new i_version API
Date: Mon, 18 Dec 2017 10:11:52 -0500
Message-ID: <20171218151156.14565-16-jlayton@kernel.org>
References: <20171218151156.14565-1-jlayton@kernel.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org,
        jack-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org,
        adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org,
        linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, jbacik-b10kYP2dOMg@public.gmane.org,
        dsterba-IBi9RG/b67k@public.gmane.org, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        jaltman-hRzEac23uH1Wk0Htik3J/w@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171218151156.14565-1-jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 security/integrity/ima/ima_api.c  | 3 ++-
 security/integrity/ima/ima_main.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index c7e8db0ea4c0..c6ae42266270 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -18,6 +18,7 @@
 #include <linux/fs.h>
 #include <linux/xattr.h>
 #include <linux/evm.h>
+#include <linux/iversion.h>
 
 #include "ima.h"
 
@@ -215,7 +216,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
 	 * which do not support i_version, support is limited to an initial
 	 * measurement/appraisal/audit.
 	 */
-	i_version = file_inode(file)->i_version;
+	i_version = inode_query_iversion(inode);
 	hash.hdr.algo = algo;
 
 	/* Initialize hash digest to 0's in case of failure */
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 50b82599994d..06a70c5a2329 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/xattr.h>
 #include <linux/ima.h>
+#include <linux/iversion.h>
 
 #include "ima.h"
 
@@ -128,7 +129,7 @@ static void ima_check_last_writer(struct integrity_iint_cache *iint,
 	inode_lock(inode);
 	if (atomic_read(&inode->i_writecount) == 1) {
 		if (!IS_I_VERSION(inode) ||
-		    (iint->version != inode->i_version) ||
+		    inode_cmp_iversion(inode, iint->version) ||
 		    (iint->flags & IMA_NEW_FILE)) {
 			iint->flags &= ~(IMA_DONE_MASK | IMA_NEW_FILE);
 			iint->measured_pcrs = 0;
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
