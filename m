From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ocfs2: Fix quota file corruption
Date: Fri, 10 Oct 2014 16:23:28 +0200
Message-ID: <1412951028-4085-24-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
	Mark Fasheh <mfasheh@suse.de>, Mark Fasheh <mfasheh@suse.com>,
	Dave Chinner <david@fromorbit.com>,
	reiserfs-devel@vger.kernel.org, stable@vger.kernel.org,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Joel Becker <jlbec@evilplan.org>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>,
	ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk
To: linux-fsdevel@vger.kernel.org
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Global quota files are accessed from different nodes. Thus we cannot
cache offset of quota structure in the quota file after we drop our
node reference count to it because after that moment quota structure may
be freed and reallocated elsewhere by a different node resulting in
corruption of quota file.

Fix the problem by clearing dq_off when we are releasing dquot
structure. We also remove the DB_READ_B handling because it is useless -
DQ_ACTIVE_B is set iff DQ_READ_B is set.

CC: stable@vger.kernel.org
CC: Goldwyn Rodrigues <rgoldwyn@suse.de>
CC: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_global.c | 27 +++++++++++++++++----------
 fs/ocfs2/quota_local.c  |  4 ----
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index aaa50611ec66..d7b5108789e2 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -717,6 +717,12 @@ static int ocfs2_release_dquot(struct dquot *dquot)
 	 */
 	if (status < 0)
 		mlog_errno(status);
+	/*
+	 * Clear dq_off so that we search for the structure in quota file next
+	 * time we acquire it. The structure might be deleted and reallocated
+	 * elsewhere by another node while our dquot structure is on freelist.
+	 */
+	dquot->dq_off = 0;
 	clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_trans:
 	ocfs2_commit_trans(osb, handle);
@@ -756,16 +762,17 @@ static int ocfs2_acquire_dquot(struct dquot *dquot)
 	status = ocfs2_lock_global_qf(info, 1);
 	if (status < 0)
 		goto out;
-	if (!test_bit(DQ_READ_B, &dquot->dq_flags)) {
-		status = ocfs2_qinfo_lock(info, 0);
-		if (status < 0)
-			goto out_dq;
-		status = qtree_read_dquot(&info->dqi_gi, dquot);
-		ocfs2_qinfo_unlock(info, 0);
-		if (status < 0)
-			goto out_dq;
-	}
-	set_bit(DQ_READ_B, &dquot->dq_flags);
+	status = ocfs2_qinfo_lock(info, 0);
+	if (status < 0)
+		goto out_dq;
+	/*
+	 * We always want to read dquot structure from disk because we don't
+	 * know what happened with it while it was on freelist.
+	 */
+	status = qtree_read_dquot(&info->dqi_gi, dquot);
+	ocfs2_qinfo_unlock(info, 0);
+	if (status < 0)
+		goto out_dq;
 
 	OCFS2_DQUOT(dquot)->dq_use_count++;
 	OCFS2_DQUOT(dquot)->dq_origspace = dquot->dq_dqb.dqb_curspace;
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 2e4344be3b96..2001862bf2b1 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -1303,10 +1303,6 @@ int ocfs2_local_release_dquot(handle_t *handle, struct dquot *dquot)
 	ocfs2_journal_dirty(handle, od->dq_chunk->qc_headerbh);
 
 out:
-	/* Clear the read bit so that next time someone uses this
-	 * dquot he reads fresh info from disk and allocates local
-	 * dquot structure */
-	clear_bit(DQ_READ_B, &dquot->dq_flags);
 	return status;
 }
 
-- 
1.8.1.4


------------------------------------------------------------------------------
Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS Reports
Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
