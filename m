From: Hugh Dickins <hugh@veritas.com>
Subject: [PATCH 3/6] ext2 balloc: fix off-by-one against rsv_end
Date: Tue, 28 Nov 2006 17:41:39 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0611281740560.29701@blonde.wat.veritas.com>
References: <20061114014125.dd315fff.akpm@osdl.org>  <20061114184919.GA16020@skynet.ie>
  <Pine.LNX.4.64.0611141858210.11956@blonde.wat.veritas.com>
 <20061114113120.d4c22b02.akpm@osdl.org>  <Pine.LNX.4.64.0611142111380.19259@blonde.wat.veritas.com>
  <Pine.LNX.4.64.0611151404260.11929@blonde.wat.veritas.com>
 <20061115214534.72e6f2e8.akpm@osdl.org> <455C0B6F.7000201@us.ibm.com>
 <20061115232228.afaf42f2.akpm@osdl.org>  <1163666960.4310.40.camel@localhost.localdomain>
  <20061116011351.1401a00f.akpm@osdl.org>  <1163708116.3737.12.camel@dyn9047017103.beaverton.ibm.com>
  <20061116132724.1882b122.akpm@osdl.org>  <Pine.LNX.4.64.0611201544510.16530@blonde.wat.veritas.com>
  <1164073652.20900.34.camel@dyn9047017103.beaverton.ibm.com>
 <Pine.LNX.4.64.0611210508270.22957@blonde.wat.veritas.com>
 <1164156193.3804.48.camel@dyn9047017103.beaverton.ibm.com>
 <Pine.LNX.4.64.0611281659190.29701@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@osdl.org>, Mel Gorman <mel@skynet.ie>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:17308 "EHLO
	extu-mxob-1.symantec.com") by vger.kernel.org with ESMTP
	id S935963AbWK1RlT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Nov 2006 12:41:19 -0500
Received: from balaton.wat.veritas.com([10.10.97.7]) (2564 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1Gp6xK-0000gDC@megami.veritas.com>
	for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2006 09:41:18 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
To: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0611281659190.29701@blonde.wat.veritas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

rsv_end is the last block within the reservation,
so alloc_new_reservation should accept start_block == rsv_end as success.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/ext2/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.19-rc6-mm2/fs/ext2/balloc.c	2006-11-24 08:18:02.000000000 +0000
+++ linux/fs/ext2/balloc.c	2006-11-27 19:28:41.000000000 +0000
@@ -950,7 +950,7 @@ retry:
 	 * check if the first free block is within the
 	 * free space we just reserved
 	 */
-	if (start_block >= my_rsv->rsv_start && start_block < my_rsv->rsv_end)
+	if (start_block >= my_rsv->rsv_start && start_block <= my_rsv->rsv_end)
 		return 0;		/* success */
 	/*
 	 * if the first free bit we found is out of the reservable space
