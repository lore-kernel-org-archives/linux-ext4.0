From: Joel Becker <Joel.Becker@oracle.com>
Subject: [PATCH] ocfs2: Use the new jbd_journal_set_triggers() to printk.
Date: Wed, 17 Sep 2008 16:27:25 -0700
Message-ID: <20080917232725.GC20752@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: ocfs2-devel@oss.oracle.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:17179 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYIQX3H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Sep 2008 19:29:07 -0400
Received: from agmgw2.us.oracle.com (agmgw2.us.oracle.com [152.68.180.213])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id m8HNT3N4015549
	for <linux-ext4@vger.kernel.org>; Wed, 17 Sep 2008 17:29:03 -0600
Content-Disposition: inline
In-Reply-To: <20080917232629.GB20752@mail.oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Just a placeholder trigger set that prints.  ocfs2 would obviously do
more in the trigger with ot_offset.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/journal.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 373d943..d17d4a9 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -357,6 +357,51 @@ bail:
 	return status;
 }
 
+struct ocfs2_triggers {
+	struct jbd2_buffer_trigger_type	ot_triggers;
+	int				ot_offset;
+};
+
+static inline struct ocfs2_triggers *to_ocfs2_trigger(struct jbd2_buffer_trigger_type *triggers)
+{
+	return container_of(triggers, struct ocfs2_triggers, ot_triggers);
+}
+
+static void ocfs2_commit_trigger(struct jbd2_buffer_trigger_type *triggers,
+				 struct buffer_head *bh,
+				 void *data, size_t size)
+{
+	struct ocfs2_triggers *ot = to_ocfs2_trigger(triggers);
+
+	mlog(ML_NOTICE, "bh = 0x%lx, data = 0x%lx, size = %u, offset = %d\n",
+	     (unsigned long)bh, (unsigned long)data, size, ot->ot_offset);
+}
+
+static void ocfs2_abort_trigger(struct jbd2_buffer_trigger_type *triggers,
+				struct buffer_head *bh)
+{
+	struct ocfs2_triggers *ot = to_ocfs2_trigger(triggers);
+
+	mlog(ML_NOTICE, "bh = 0x%lx, offset = %d\n", (unsigned long)bh, ot->ot_offset);
+}
+
+static struct ocfs2_triggers inode_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+	.ot_offset	= 10, /* Garbage */
+};
+
+static struct ocfs2_triggers other_triggers = {
+	.ot_triggers = {
+		.t_commit = ocfs2_commit_trigger,
+		.t_abort = ocfs2_abort_trigger,
+	},
+	.ot_offset	= 20, /* Different garbage */
+};
+
+
 int ocfs2_journal_access(handle_t *handle,
 			 struct inode *inode,
 			 struct buffer_head *bh,
@@ -406,6 +451,12 @@ int ocfs2_journal_access(handle_t *handle,
 		status = -EINVAL;
 		mlog(ML_ERROR, "Uknown access type!\n");
 	}
+	if (!status)
+		jbd2_journal_set_triggers(bh,
+					  bh->b_blocknr ==
+					  OCFS2_I(inode)->ip_blkno ?
+					  &inode_triggers.ot_triggers :
+					  &other_triggers.ot_triggers);
 	mutex_unlock(&OCFS2_I(inode)->ip_io_mutex);
 
 	if (status < 0)
-- 
1.5.6.3

-- 

"There are some experiences in life which should not be demanded
 twice from any man, and one of them is listening to the Brahms Requiem."
        - George Bernard Shaw

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
