From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 7/12] ext4 balloc: reset windowsz when full
Date: Tue, 28 Nov 2006 20:14:55 -0800
Message-ID: <1164773695.4341.41.camel@localhost.localdomain>
References: <20061114014125.dd315fff.akpm@osdl.org>
	 <20061114184919.GA16020@skynet.ie>
	 <Pine.LNX.4.64.0611141858210.11956@blonde.wat.veritas.com>
	 <20061114113120.d4c22b02.akpm@osdl.org>
	 <Pine.LNX.4.64.0611142111380.19259@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0611151404260.11929@blonde.wat.veritas.com>
	 <20061115214534.72e6f2e8.akpm@osdl.org> <455C0B6F.7000201@us.ibm.com>
	 <20061115232228.afaf42f2.akpm@osdl.org>
	 <1163666960.4310.40.camel@localhost.localdomain>
	 <20061116011351.1401a00f.akpm@osdl.org>
	 <1163708116.3737.12.camel@dyn9047017103.beaverton.ibm.com>
	 <20061116132724.1882b122.akpm@osdl.org>
	 <Pine.LNX.4.64.0611201544510.16530@blonde.wat.veritas.com>
	 <1164073652.20900.34.camel@dyn9047017103.beaverton.ibm.com>
	 <Pine.LNX.4.64.0611210508270.22957@blonde.wat.veritas.com>
	 <1164156193.3804.48.camel@dyn9047017103.beaverton.ibm.com>
	 <Pine.LNX.4.64.0611281659190.29701@blonde.wat.veritas.com>
	 <Pine.LNX.4.64.0611281741490.29701@blonde.wat.veritas.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>, Mel Gorman <mel@skynet.ie>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:8670 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1758781AbWK2EPJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Nov 2006 23:15:09 -0500
To: Hugh Dickins <hugh@veritas.com>
In-Reply-To: <Pine.LNX.4.64.0611281741490.29701@blonde.wat.veritas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


------------------------------------------------------
Subject: ext2 balloc: reset windowsz when full
From: Hugh Dickins <hugh@veritas.com>

ext2_new_blocks should reset the reservation window size to 0 when squeezing
the last blocks out of an almost full filesystem, so the retry doesn't skip
any groups with less than half that free, reporting ENOSPC too soon.

------------------------------------------------------
Sync up reservation fix from ext2 in ext4

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---


---

 linux-2.6.19-rc5-cmm/fs/ext4/balloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ext4/balloc.c~ext4_reset_windowsz_in_full_fs fs/ext4/balloc.c
--- linux-2.6.19-rc5/fs/ext4/balloc.c~ext4_reset_windowsz_in_full_fs	2006-11-28 19:37:01.000000000 -0800
+++ linux-2.6.19-rc5-cmm/fs/ext4/balloc.c	2006-11-28 19:37:01.000000000 -0800
@@ -1566,6 +1566,7 @@ retry_alloc:
 	 */
 	if (my_rsv) {
 		my_rsv = NULL;
+		windowsz = 0;
 		group_no = goal_group;
 		goto retry_alloc;
 	}

_
