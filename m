From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] block: improve flush bio completion
Date: Fri, 21 Jan 2011 16:59:57 +0100
Message-ID: <1295625598-15203-3-git-send-email-tj@kernel.org>
References: <1295625598-15203-1-git-send-email-tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
	neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
	snitzer@redhat.com, linux-kernel@vger.kernel.org,
	kmannth@us
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47166 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab1AUQBc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Jan 2011 11:01:32 -0500
In-Reply-To: <1295625598-15203-1-git-send-email-tj@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bio's for flush are completed twice - once during the data phase and
one more time after the whole sequence is complete.  The first
completion shouldn't notify completion to the issuer.

This was achieved by skipping all bio completion steps in
req_bio_endio() for the first completion; however, this has two
drawbacks.

* Error is not recorded in bio and must be tracked somewhere else.

* Partial completion is not supported.

Both don't cause problems for the current users; however, they make
further improvements difficult.  Change req_bio_endio() such that it
only skips the actual notification part for the first completion.  bio
completion is implemented with partial completions on mind anyway so
this is as simple as moving the REQ_FLUSH_SEQ conditional such that
only calling of bio_endio() is skipped.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |   48 +++++++++++++++++++++---------------------------
 1 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 22e0b4f..038519b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -151,37 +151,31 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 {
 	struct request_queue *q = rq->q;
 
-	if (!(rq->cmd_flags & REQ_FLUSH_SEQ)) {
-		if (error)
-			clear_bit(BIO_UPTODATE, &bio->bi_flags);
-		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-			error = -EIO;
-
-		if (unlikely(nbytes > bio->bi_size)) {
-			printk(KERN_ERR "%s: want %u bytes done, %u left\n",
-			       __func__, nbytes, bio->bi_size);
-			nbytes = bio->bi_size;
-		}
+	if (error)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+		error = -EIO;
+
+	if (unlikely(nbytes > bio->bi_size)) {
+		printk(KERN_ERR "%s: want %u bytes done, %u left\n",
+		       __func__, nbytes, bio->bi_size);
+		nbytes = bio->bi_size;
+	}
 
-		if (unlikely(rq->cmd_flags & REQ_QUIET))
-			set_bit(BIO_QUIET, &bio->bi_flags);
+	if (unlikely(rq->cmd_flags & REQ_QUIET))
+		set_bit(BIO_QUIET, &bio->bi_flags);
 
-		bio->bi_size -= nbytes;
-		bio->bi_sector += (nbytes >> 9);
+	bio->bi_size -= nbytes;
+	bio->bi_sector += (nbytes >> 9);
 
-		if (bio_integrity(bio))
-			bio_integrity_advance(bio, nbytes);
+	if (bio_integrity(bio))
+		bio_integrity_advance(bio, nbytes);
 
-		if (bio->bi_size == 0)
-			bio_endio(bio, error);
-	} else {
-		/*
-		 * Okay, this is the sequenced flush request in
-		 * progress, just record the error;
-		 */
-		if (error && !q->flush_err)
-			q->flush_err = error;
-	}
+	/* don't actually finish bio if it's part of flush sequence */
+	if (bio->bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
+		bio_endio(bio, error);
+	else if (error && !q->flush_err)
+		q->flush_err = error;
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
-- 
1.7.1

