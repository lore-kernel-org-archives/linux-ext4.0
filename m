From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent by fsync
Date: Tue, 30 Nov 2010 17:41:24 +0100
Message-ID: <20101130164124.GA30858@lst.de>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:47286 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab0K3QmD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 11:42:03 -0500
Content-Disposition: inline
In-Reply-To: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FYI, here's an updated version of my patch to not run pure flushes
that also works on SCSI/ATA and not just virtio.  I suspect the patch
alone might not be enough, but together with a variant of Neil's
suggestion might do the trick, with my patch taking care of the
highend-devices and Neil's scheme of taking care of stupid SATA disks.


Index: linux-2.6/block/blk-flush.c
===================================================================
--- linux-2.6.orig/block/blk-flush.c	2010-11-30 17:27:33.108254088 +0100
+++ linux-2.6/block/blk-flush.c	2010-11-30 17:27:38.790004333 +0100
@@ -143,6 +143,17 @@ struct request *blk_do_flush(struct requ
 	unsigned skip = 0;
 
 	/*
+	 * Just issue pure flushes directly.
+	 */
+	if (!blk_rq_sectors(rq)) {
+		if (!do_preflush) {
+			__blk_end_request_all(rq, 0);
+			return NULL;
+		}
+		return rq;
+	}
+
+	/*
 	 * Special case.  If there's data but flush is not necessary,
 	 * the request can be issued directly.
 	 *
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c	2010-11-30 17:27:33.120254298 +0100
+++ linux-2.6/drivers/scsi/scsi_lib.c	2010-11-30 17:27:38.791003634 +0100
@@ -1060,7 +1060,7 @@ int scsi_setup_blk_pc_cmnd(struct scsi_d
 	 * that does not transfer data, in which case they may optionally
 	 * submit a request without an attached bio.
 	 */
-	if (req->bio) {
+	if (req->bio && !(req->cmd_flags & REQ_FLUSH)) {
 		int ret;
 
 		BUG_ON(!req->nr_phys_segments);
