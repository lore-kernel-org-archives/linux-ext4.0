From: Jan Kara <jack@suse.cz>
Subject: [PATCH] writeback: plug writeback at a high level
Date: Fri, 10 Oct 2014 16:23:41 +0200
Message-ID: <1412951028-4085-37-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
	tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>,
	Mark Fasheh <mfasheh@suse.com>, Dave Chinner <david@fromorbit.com>,
	reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
	cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>,
	Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
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

From: Dave Chinner <dchinner@redhat.com>

tl;dr: 3 lines of code, 86% better fsmark thoughput consuming 13%
less CPU and 43% lower runtime.

Doing writeback on lots of little files causes terrible IOPS storms
because of the per-mapping writeback plugging we do. This
essentially causes imeediate dispatch of IO for each mapping,
regardless of the context in which writeback is occurring.

IOWs, running a concurrent write-lots-of-small 4k files using fsmark
on XFS results in a huge number of IOPS being issued for data
writes.  Metadata writes are sorted and plugged at a high level by
XFS, so aggregate nicely into large IOs.

However, data writeback IOs are dispatched in individual 4k IOs -
even when the blocks of two consecutively written files are
adjacent - because the underlying block device is fast enough not to
congest on such IO. This behaviour is not SSD related - anything
with hardware caches is going to see the same benefits as the IO
rates are limited only by how fast adjacent IOs can be sent to the
hardware caches for aggregation.

Hence the speed of the physical device is irrelevant to this common
writeback workload (happens every time you untar a tarball!) -
performance is limited by the overhead of dispatching individual
IOs from a single writeback thread.

Test VM: 16p, 16GB RAM, 2xSSD in RAID0, 500TB sparse XFS filesystem,
metadata CRCs enabled.

Test:

$ ./fs_mark  -D  10000  -S0  -n  10000  -s  4096  -L  120  -d
/mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d
/mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d
/mnt/scratch/6  -d  /mnt/scratch/7

Result:
		wall	sys	create rate	Physical write IO
		time	CPU	(avg files/s)	 IOPS	Bandwidth
		-----	-----	-------------	------	---------
unpatched	5m54s	15m32s	32,500+/-2200	28,000	150MB/s
patched		3m19s	13m28s	52,900+/-1800	 1,500	280MB/s
improvement	-43.8%	-13.3%	  +62.7%	-94.6%	+86.6%

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 279292ba9403..d935fd3796ba 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -599,6 +599,9 @@ static long generic_writeback_inodes(struct wb_writeback_work *work)
 	unsigned long end_time = jiffies + HZ / 10;
 	long write_chunk;
 	long wrote = 0;  /* count both pages and inodes */
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
 
 	spin_lock(&wb->list_lock);
 	while (1) {
@@ -688,6 +691,8 @@ static long generic_writeback_inodes(struct wb_writeback_work *work)
 out:
 	spin_unlock(&wb->list_lock);
 
+	blk_finish_plug(&plug);
+
 	return wrote;
 }
 
-- 
1.8.1.4


------------------------------------------------------------------------------
Meet PCI DSS 3.0 Compliance Requirements with EventLog Analyzer
Achieve PCI DSS 3.0 Compliant Status with Out-of-the-box PCI DSS Reports
Are you Audit-Ready for PCI DSS 3.0 Compliance? Download White paper
Comply to PCI DSS 3.0 Requirement 10 and 11.5 with EventLog Analyzer
http://pubads.g.doubleclick.net/gampad/clk?id=154622311&iu=/4140/ostg.clktrk
