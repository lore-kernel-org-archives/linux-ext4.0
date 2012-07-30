From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 5/8]fs/ext4: Evalue bio->bi_rw after calling bio_alloc() and
	before calling bio_add_page().
Date: Mon, 30 Jul 2012 15:24:24 +0800
Message-ID: <2012073015241559305016@gmail.com>
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
 fs/ext4/page-io.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index dcdeef1..c875502 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -304,6 +304,7 @@ static int io_submit_init(struct ext4_io_submit *io,
 	io->io_bio = bio;
 	io->io_op = (wbc->sync_mode == WB_SYNC_ALL ?  WRITE_SYNC : WRITE);
 	io->io_next_block = bh->b_blocknr;
+	bio->bi_rw = io->io_op;
 	return 0;
 }
 
-- 
1.7.9.5
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
