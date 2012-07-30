From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 7/8]fs/ocfs2: Evalue bio->bi_rw after calling bio_alloc() and
	before calling bio_add_page().
Date: Mon, 30 Jul 2012 15:24:48 +0800
Message-ID: <2012073015243906251018@gmail.com>
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
 fs/ocfs2/cluster/heartbeat.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index a4e855e..50079d3 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -399,7 +399,8 @@ static void o2hb_bio_end_io(struct bio *bio,
 static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 				      struct o2hb_bio_wait_ctxt *wc,
 				      unsigned int *current_slot,
-				      unsigned int max_slots)
+				      unsigned int max_slots,
+				      int rw)
 {
 	int len, current_page;
 	unsigned int vec_len, vec_start;
@@ -425,6 +426,7 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	bio->bi_bdev = reg->hr_bdev;
 	bio->bi_private = wc;
 	bio->bi_end_io = o2hb_bio_end_io;
+	bio->bi_rw = rw;
 
 	vec_start = (cs << bits) % PAGE_CACHE_SIZE;
 	while(cs < max_slots) {
@@ -460,7 +462,7 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 	o2hb_bio_wait_init(&wc);
 
 	while(current_slot < max_slots) {
-		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots);
+		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots, READ);
 		if (IS_ERR(bio)) {
 			status = PTR_ERR(bio);
 			mlog_errno(status);
@@ -492,7 +494,7 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 
 	slot = o2nm_this_node();
 
-	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1);
+	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1, WRITE);
 	if (IS_ERR(bio)) {
 		status = PTR_ERR(bio);
 		mlog_errno(status);
-- 
1.7.9.5
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
