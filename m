From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Don't check quota format when there
	are no quota files
Date: Fri, 10 Oct 2014 16:23:14 +0200
Message-ID: <1412951028-4085-10-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
        tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
        Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>,
        reiserfs-devel@vger.kernel.org, stable@vger.kernel.org,
        xfs@oss.sgi.com, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
        ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk
To: linux-fsdevel@vger.kernel.org
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

The check whether quota format is set even though there are no
quota files with journalled quota is pointless and it actually
makes it impossible to turn off journalled quotas (as there's
no way to unset journalled quota format). Just remove the check.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0b28b36e7915..3ff598f3d4af 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1712,13 +1712,6 @@ static int parse_options(char *options, struct super_block *sb,
 					"not specified");
 			return 0;
 		}
-	} else {
-		if (sbi->s_jquota_fmt) {
-			ext4_msg(sb, KERN_ERR, "journaled quota format "
-					"specified with no journaling "
-					"enabled");
-			return 0;
-		}
 	}
 #endif
 	if (test_opt(sb, DIOREAD_NOLOCK)) {
-- 
1.8.1.4
