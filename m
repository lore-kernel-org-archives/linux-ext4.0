From: Jan Kara <jack@suse.cz>
Subject: [PATCH] scsi: Keep interrupts disabled while
	submitting requests
Date: Fri, 10 Oct 2014 16:23:33 +0200
Message-ID: <1412951028-4085-29-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
	Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>,
	reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
	cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Steven Whitehouse <swhiteho@redhat.com>,
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

scsi_request_fn() can be called from softirq context during IO
completion. If it enables interrupts there, HW interrupts can interrupt
softirq processing and queue more IO completion work which can
eventually lead to softlockup reports because IO completion softirq runs
for too long. Keep interrupts disabled in scsi_request_fn().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/scsi/scsi_lib.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e316368c99..44b867e9adc9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1481,7 +1481,8 @@ static void scsi_softirq_done(struct request *rq)
  *
  * Returns:     Nothing
  *
- * Lock status: IO request lock assumed to be held when called.
+ * Lock status: IO request lock assumed to be held when called, interrupts
+ * must be disabled.
  */
 static void scsi_request_fn(struct request_queue *q)
 	__releases(q->queue_lock)
@@ -1563,7 +1564,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
 		 *		take the lock again.
 		 */
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock(shost->host_lock);
 
 		/*
 		 * Finally, initialize any error handling parameters, and set up
@@ -1575,7 +1576,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * Dispatch the command to the low-level driver.
 		 */
 		rtn = scsi_dispatch_cmd(cmd);
-		spin_lock_irq(q->queue_lock);
+		spin_lock(q->queue_lock);
 		if (rtn)
 			goto out_delay;
 	}
@@ -1583,7 +1584,7 @@ static void scsi_request_fn(struct request_queue *q)
 	return;
 
  not_ready:
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock(shost->host_lock);
 
 	/*
 	 * lock q, handle tag, requeue req, and decrement device_busy. We
@@ -1593,7 +1594,7 @@ static void scsi_request_fn(struct request_queue *q)
 	 * cases (host limits or settings) should run the queue at some
 	 * later time.
 	 */
-	spin_lock_irq(q->queue_lock);
+	spin_lock(q->queue_lock);
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
 out_delay:
-- 
1.8.1.4


------------------------------------------------------------------------------
Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS Reports
Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
