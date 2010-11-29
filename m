From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/4] md: Compute average flush time from component devices
Date: Mon, 29 Nov 2010 14:05:51 -0800
Message-ID: <20101129220551.12401.80601.stgit@elm3b57.beaverton.ibm.com>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>,
	"Darrick J.
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

For md devices which are composed of other block devices, a flush is spread out
to those other block devices.  Therefore, the average flush time can be
computed as the average flush time of whichever device flushes most slowly.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 drivers/md/md.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 43243a4..af25c96 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -357,6 +357,28 @@ EXPORT_SYMBOL(mddev_congested);
  * Generic flush handling for md
  */
 
+static void measure_flushes(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	u64 max = 0, samples = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
+		if (rdev->raid_disk >= 0 &&
+		    !test_bit(Faulty, &rdev->flags)) {
+			if (rdev->bdev->bd_disk->avg_flush_time_ns <= max)
+				continue;
+			max = rdev->bdev->bd_disk->avg_flush_time_ns;
+			samples = rdev->bdev->bd_disk->flush_samples;
+		}
+	rcu_read_unlock();
+
+	spin_lock(&mddev->gendisk->flush_time_lock);
+	mddev->gendisk->avg_flush_time_ns = max;
+	mddev->gendisk->flush_samples = samples;
+	spin_unlock(&mddev->gendisk->flush_time_lock);
+}
+
 static void md_end_flush(struct bio *bio, int err)
 {
 	mdk_rdev_t *rdev = bio->bi_private;
@@ -365,6 +387,7 @@ static void md_end_flush(struct bio *bio, int err)
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
+		measure_flushes(mddev);
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}

