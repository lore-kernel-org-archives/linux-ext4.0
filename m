From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: [PATCH] [RFC] jbd2: Add buffer triggers
Date: Thu, 16 Oct 2008 12:44:38 -0700
Message-ID: <20081016194438.GB4748@mail.oracle.com>
References: <20080917232629.GB20752@mail.oracle.com>
	<20080929012527.GI8711@mit.edu> <20081004000336.GE11442@mit.edu>
	<20081006213754.GA26632@mail.oracle.com>
	<20081006214251.GB26632@mail.oracle.com>
	<20081006233248.GA9337@mit.edu>
	<20081007010154.GE26632@mail.oracle.com>
	<20081008231752.GA5310@mail.oracle.com>
	<20081016174241.GH12962@mit.edu>
	<20081016194011.GA4748@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, ocfs2-devel@oss.oracle.com,
        linux-ext4@vger.kernel.org, mfasheh@suse.com
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <20081016194011.GA4748@mail.oracle.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 16, 2008 at 12:40:11PM -0700, Joel Becker wrote:
> On Thu, Oct 16, 2008 at 01:42:41PM -0400, Theodore Tso wrote:
> > On Wed, Oct 08, 2008 at 04:17:52PM -0700, Joel Becker wrote:
> > > 	In other words, I think that the commit trigger is safe in all
> > > circumstances once moved up in journal_commit_transaction().  I'll be
> > > cooking that up shortly.
> > 
> > Have you had a chance to look at this?  Here's something which hasn't
> > been compile-tested yet, but it didn't take me long...
> 
> 	Actually, I've had the fixed up patch for a week, tested even.

	The testing was with this simple printk patch.  I just watched
the journal blocks go out.  Things like kernel untars, etc.

Joel

From: Joel Becker <joel.becker@oracle.com>
Date: Thu, 11 Sep 2008 15:53:07 -0700
Subject: [PATCH] ocfs2: Use the new jbd_journal_set_commit_trigger() to printk.

Just a placeholder trigger set that prints

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/ocfs2/journal.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 81e4067..f56666b 100644
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
1.5.6.5

-- 

"In a crisis, don't hide behind anything or anybody. They're going
 to find you anyway."
	- Paul "Bear" Bryant

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
