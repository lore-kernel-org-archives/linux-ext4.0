Return-Path: <SRS0=MuWy=P5=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37336C282DB
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 08:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F51E2084A
	for <linux-ext4@archiver.kernel.org>; Mon, 21 Jan 2019 08:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfAUIVS (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 21 Jan 2019 03:21:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33282 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729614AbfAUIU5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 21 Jan 2019 03:20:57 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD23973A67;
        Mon, 21 Jan 2019 08:20:56 +0000 (UTC)
Received: from localhost (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBD1D6012D;
        Mon, 21 Jan 2019 08:20:55 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>,
        Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V14 10/18] btrfs: use mp_bvec_last_segment to get bio's last page
Date:   Mon, 21 Jan 2019 16:17:57 +0800
Message-Id: <20190121081805.32727-11-ming.lei@redhat.com>
In-Reply-To: <20190121081805.32727-1-ming.lei@redhat.com>
References: <20190121081805.32727-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 21 Jan 2019 08:20:57 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Preparing for supporting multi-page bvec.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/btrfs/extent_io.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index dc8ba3ee515d..986ef49b0269 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2697,11 +2697,12 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 {
 	blk_status_t ret = 0;
 	struct bio_vec *bvec = bio_last_bvec_all(bio);
-	struct page *page = bvec->bv_page;
+	struct bio_vec bv;
 	struct extent_io_tree *tree = bio->bi_private;
 	u64 start;
 
-	start = page_offset(page) + bvec->bv_offset;
+	mp_bvec_last_segment(bvec, &bv);
+	start = page_offset(bv.bv_page) + bv.bv_offset;
 
 	bio->bi_private = NULL;
 
-- 
2.9.5

