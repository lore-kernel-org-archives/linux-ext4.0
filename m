From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 1/2] block: skip elevator data initialization for
 flush requests
Date: Thu, 3 Feb 2011 09:54:57 -0500
Message-ID: <20110203145457.GB19801@redhat.com>
References: <20110201185225.GT14211@htj.dyndns.org>
 <1296600373-6906-1-git-send-email-snitzer@redhat.com>
 <20110202225549.GA28109@redhat.com>
 <4D4AAC9A.4050407@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tejun Heo <tj@kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
	"djwong@us.ibm.com" <djwong@us.ibm.com>,
	"shli@kernel.org" <shli@kernel.org>,
	"neilb@suse.de" <neilb@suse.de>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"jack@suse.cz" <jack@suse.cz>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kmannth@us.ibm.com" <kmannth@us.ibm.com>,
	"cmm@us.ibm.com" <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>,
	"hch@lst.de" <hch@lst.de>, "josef@redhat.com" <josef@redhat.com>,
	"jmoyer@redhat.com" <jmoyer@redhat.com>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855Ab1BCOzO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Feb 2011 09:55:14 -0500
Content-Disposition: inline
In-Reply-To: <4D4AAC9A.4050407@fusionio.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 03 2011 at  8:24am -0500,
Jens Axboe <jaxboe@fusionio.com> wrote:

> On 2011-02-02 23:55, Mike Snitzer wrote:
> > Set REQ_SORTED, in the @rw_flags passed to the request allocator, for
> > any request that may be put on IO scheduler.  Skip elevator data
> > initialization during request allocation if REQ_SORTED is not set.
> > 
> > REQ_SORTED is not set for flush requests because they are never put on
> > the IO scheduler.
> 
> That looks very wrong. REQ_SORTED gets set _when_ the request is sorted
> into the IO scheduler.

Yes, considerable oversight on my part.

> This is gross misuse, a bad hack.

As my recently posted v4 stated, even without the bug it is still a hack.

My initial version didn't get so cute with overloading flags, etc, e.g:

diff --git a/block/blk-core.c b/block/blk-core.c
index 72dd23b..e098598 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -764,7 +764,7 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	struct request_list *rl = &q->rq;
 	struct io_context *ioc = NULL;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
-	int may_queue, priv;
+	int may_queue, priv = 0;
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
@@ -808,9 +808,14 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	rl->count[is_sync]++;
 	rl->starved[is_sync] = 0;
 
-	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
-	if (priv)
-		rl->elvpriv++;
+	/*
+	 * Skip elevator data initialization for flush requests.
+	 */
+	if (!(bio && (bio->bi_rw & (REQ_FLUSH | REQ_FUA)))) {
+		priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
+		if (priv)
+			rl->elvpriv++;
+	}
 
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;


I ran with Tejun's suggestion of overloading @rw_flags when it became
clear he wasn't happy with the above (because it spread FLUSH/FUA
special casing too thin).

Regardless, other ideas for how to convey this info to get_request()
would be appreciated.

Mike
