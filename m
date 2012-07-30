From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 8/8]fs/xfs: Evalue bio->bi_rw after calling bio_alloc() and
	before calling bio_add_page().
Date: Mon, 30 Jul 2012 15:24:52 +0800
Message-ID: <2012073015244959361219@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion <jfs-discussion@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
To: axboe <axboe@kernel.dk>, "konrad.wilk" <konrad.wilk@oracle.com>,
        "chris.mason" <chris.mason@fusionio.com>,
        viro <viro@ZenIV.linux.org.uk>, tytso <tytso@mit.edu>,
        "adilger.kernel" <adilger.kernel@dilger.ca>,
        shaggy <shaggy@kernel.org>, mfasheh <mfasheh@suse.com>,
        jlbec <jlbec@evilplan.org>, bpm <bpm@sgi.com>,
        elder <elder@kernel.org>
Return-path: <xfs-bounces@oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

Because call bio_alloc, the bi_rw is zero by default,but in
bio_add_page used the bi_rw. So evalue bi_rw.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/xfs/xfs_aops.c |    2 ++
 fs/xfs/xfs_buf.c  |    1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8dad722..f69f4b2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -496,6 +496,8 @@ xfs_submit_ioend(
 			if (!bio) {
  retry:
 				bio = xfs_alloc_ioend_bio(bh);
+				bio->bi_rw = (wbc->sync_mode == WB_SYNC_ALL
+						? WRITE_SYNC : WRITE);
 			} else if (bh->b_blocknr != lastblock + 1) {
 				xfs_submit_ioend_bio(wbc, ioend, bio);
 				goto retry;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 269b35c..744ec64 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1186,6 +1186,7 @@ next_chunk:
 	bio->bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
+	bio->bi_rw = rw;
 
 
 	for (; size && nr_pages; nr_pages--, map_i++) {
-- 
1.7.9.5
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
