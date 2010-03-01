From: Michal Schmidt <mschmidt@redhat.com>
Subject: [PATCH] ext4: reduce scheduling latency with delayed allocation
Date: Mon, 1 Mar 2010 13:34:35 +0100
Message-ID: <20100301133435.141c4bc5@leela>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab0CAMem (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Mar 2010 07:34:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mpage_da_submit_io() may process tens of thousands of pages at a time.
Unless full preemption is enabled, it causes scheduling latencies in the order
of tens of milliseconds.

It can be reproduced simply by writing a big file on ext4 repeatedly with
dd if=/dev/zero of=/tmp/dummy bs=10M count=50

The patch fixes it by allowing to reschedule in the loop.

cyclictest can be used to measure the latency. I tested with:
$ cyclictest -t1 -p 80 -n -i 5000 -m -l 20000

The results from an UP AMD Turion 2GHz with voluntary preemption:

Without the patch:
T: 0 ( 2535) P:80 I:5000 C:  20000 Min:   12 Act:  23 Avg: 3166 Max:  70524
(i.e. Average latency was more than 3 ms. Max observed latency was 71 ms.)

With the patch:
T: 0 ( 2588) P:80 I:5000 C:  20000 Min:   13 Act:  33 Avg:   49 Max:  11009
(i.e. Average latency was only 49 us. Max observed latency was 11 ms.)

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
---
 fs/ext4/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e119524..687a993 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2007,6 +2007,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 				ret = err;
 		}
 		pagevec_release(&pvec);
+		cond_resched();
 	}
 	return ret;
 }
-- 
1.7.0

