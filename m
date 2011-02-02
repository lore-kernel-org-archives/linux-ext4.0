From: Jim Meyering <jim@meyering.net>
Subject: [PATCH] filefrag: remove useless assignment
Date: Wed, 02 Feb 2011 21:55:38 +0100
Message-ID: <87ei7qp35h.fsf@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain
To: ext <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:53820 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049Ab1BBUzq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Feb 2011 15:55:46 -0500
Received: from mx.meyering.net (unknown [82.230.74.64])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 259BC9400EB
	for <linux-ext4@vger.kernel.org>; Wed,  2 Feb 2011 21:55:39 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Barely worth posting, but...
There's no point in setting fiemap->ANYTHING
when the very next statement zeros the entire buffer.
The correct initialization is already done after the memset.

>From b2e2dd33c57dbae034b9ea7830d21681bc788fbe Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Tue, 1 Feb 2011 19:25:35 +0100
Subject: [PATCH] filefrag: remove useless assignment

The very next one memset's all bytes of fiemap to 0.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 misc/filefrag.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index bd4486d..d604b6c 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -168,28 +168,26 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 	struct fiemap *fiemap = (struct fiemap *)buf;
 	struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
 	int count = (sizeof(buf) - sizeof(*fiemap)) /
 			sizeof(struct fiemap_extent);
 	unsigned long long last_blk = 0;
 	unsigned long flags = 0;
 	unsigned int i;
 	static int fiemap_incompat_printed;
 	int fiemap_header_printed = 0;
 	int tot_extents = 1, n = 0;
 	int last = 0;
 	int rc;

-	fiemap->fm_length = ~0ULL;
