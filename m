From: Christoph Hellwig <hch@lst.de>
Subject: Re: Performance testing of various barrier reduction patches [was: Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Tue, 12 Oct 2010 16:14:55 +0200
Message-ID: <20101012141455.GA27572@lst.de>
References: <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com> <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca> <20100927230111.GV25555@tux1.beaverton.ibm.com> <20101008212606.GE25624@tux1.beaverton.ibm.com> <4CAF937C.4020500@redhat.com> <20101011202020.GF25624@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	hch@lst.de, Josef Bacik <josef@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:48499 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932516Ab0JLOP0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Oct 2010 10:15:26 -0400
Content-Disposition: inline
In-Reply-To: <20101011202020.GF25624@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I still think adding code to every filesystem to optimize for a rather
stupid use case is not a good idea.  I dropped out a bit from the
thread in the middle, but what was the real use case for lots of
concurrent fsyncs on the same inode again?

And what is the amount of performance you need?  If we go back to the
direct submission of REQ_FLUSH request from the earlier flush+fua
setups that were faster or high end storage, would that be enough for
you?

Below is a patch brining the optimization back.

	WARNING: completely untested!


Index: linux-2.6/block/blk-flush.c
===================================================================
--- linux-2.6.orig/block/blk-flush.c	2010-10-12 10:08:43.777004514 -0400
+++ linux-2.6/block/blk-flush.c	2010-10-12 10:10:37.547016093 -0400
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
