Return-Path: <SRS0=9ApQ=RO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC001C4360F
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Mar 2019 09:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE21B206BA
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Mar 2019 09:09:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tpKcUXT4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbfCKJJM (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Mar 2019 05:09:12 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36329 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfCKJJL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Mar 2019 05:09:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id 197so2801754lfz.3
        for <linux-ext4@vger.kernel.org>; Mon, 11 Mar 2019 02:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+tQVQYWe09tN/53eaN4nUm+GEDZs0SoUNxXz40sJ7Bc=;
        b=tpKcUXT4CvnoeNz5qq2w03yaz39ptDimPBO8F7I0sDqIHVFkvgZXNb89QB7pGeyJ8H
         DErBaOcZTAcqrR3JbJ0Q0GIOv/Gl52C5M0jNMPD7pDTUJa7hA4UT368fzmylbb34Cl0z
         HEGxuYONwd7K09T83ZxOP+kkwc2E54KfZstY8IKz3scAWaY17buuk7YLMwbdexEcZmur
         w/1hmh8RSj/KqqoY2vg15lhGJpIGxnHF3B46wZOAYcnjTgZImDcpix4sgwct6fG1WA5v
         0a33ITSjARGQgFBahLhq6Tg84FzrBSPvlRNJpdKgO19vyMOYjbKXhrNoPXEbWqUQr9k9
         cPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+tQVQYWe09tN/53eaN4nUm+GEDZs0SoUNxXz40sJ7Bc=;
        b=LVCHwqAilk0DZ2+dlYfhqCt2Bk54WqbSbvKBesEn0J2lt1cO3zoq7twSyQYCDOu4p9
         GWSa9x5Cta4evlRWIc/WKf/eMTsYs46yHlPEuTn9aP4b/PW8RWQA338bXgxQa6qBPGys
         6ekOGgVi2Uuvxgv6yODW2EsdDkmRZqQcDHWe24/8O2ZdadV8YWucmWkyItZYWFvCHaEd
         3wuqFx/YN/dH3SWRc7UWAJVQOcScrluVBrLuvvhdClTb+/l2nke+MUSE5t4Y+tpHzHo0
         GJUh7kJAgDqM8F3sIRBV1qPWc0oj6ANDbtGGYxHl+TO9lOXZZ0GEF74CItjiN0uI0l3t
         i0lg==
X-Gm-Message-State: APjAAAUpX7W+qB8lSDeQyvY3eOHjEpiDBGrI/8FZWmhe+DY04+DuRjgR
        ZOU79fW4ryP7TY4J8WT9bOlTixFZ66I=
X-Google-Smtp-Source: APXvYqwdVyFpFWvh0SzjB8cm8TYDzH8X2Mj/9KSMRDBy6Tq7JnrN6nlXwx4oQlsEWOC1Wggmg6s6aw==
X-Received: by 2002:a19:2cce:: with SMTP id s197mr7978127lfs.15.1552295349160;
        Mon, 11 Mar 2019 02:09:09 -0700 (PDT)
Received: from C02TN4C6HTD6.us.cray.com (chippewa-nat.cray.com. [136.162.34.1])
        by smtp.gmail.com with ESMTPSA id y12sm1016642lfh.32.2019.03.11.02.09.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 02:09:08 -0700 (PDT)
From:   Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <c17828@cray.com>
To:     linux-ext4@vger.kernel.org
Cc:     adilger.kernel@dilger.ca, alexey.lyashkov@gmail.com
Subject: [RFC PATCH] don't search large block range if disk is full
Date:   Mon, 11 Mar 2019 12:08:51 +0300
Message-Id: <20190311090851.29189-1-c17828@cray.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

 Block allocator tries to find:
 1) group with the same range as required
 2) group with the same average range as required
 3) group with required amount of space
 4) any group

 For quite full disk step 1 is failed with higth
 probability, but takes a lot of time.

Skip 1st step if disk full > 75%
Skip 2d step if disk full > 85%
Skip 3d step if disk full > 95%

This three tresholds can be adjusted through added interface.

Signed-off-by: Artem Blagodarenko <c17828@cray.com>
---
 fs/ext4/ext4.h    |  3 +++
 fs/ext4/mballoc.c | 32 ++++++++++++++++++++++++++++++++
 fs/ext4/mballoc.h |  3 +++
 fs/ext4/sysfs.c   |  6 ++++++
 4 files changed, 44 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 185a05d3257e..fbccb459a296 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1431,6 +1431,9 @@ struct ext4_sb_info {
 	unsigned int s_mb_min_to_scan;
 	unsigned int s_mb_stats;
 	unsigned int s_mb_order2_reqs;
+	unsigned int s_mb_c1_treshold;
+	unsigned int s_mb_c2_treshold;
+	unsigned int s_mb_c3_treshold;
 	unsigned int s_mb_group_prealloc;
 	unsigned int s_max_dir_size_kb;
 	/* where last allocation was done - for stream allocation */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4e6c36ff1d55..85f364aa96c9 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2096,6 +2096,20 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	return 0;
 }
 
+static u64 available_blocks_count(struct ext4_sb_info *sbi)
+{
+	ext4_fsblk_t resv_blocks;
+	u64 bfree;
+	struct ext4_super_block *es = sbi->s_es;
+
+	resv_blocks = EXT4_C2B(sbi, atomic64_read(&sbi->s_resv_clusters));
+	bfree = percpu_counter_sum_positive(&sbi->s_freeclusters_counter) -
+		 percpu_counter_sum_positive(&sbi->s_dirtyclusters_counter);
+
+	bfree = EXT4_C2B(sbi, max_t(s64, bfree, 0));
+	return bfree - (ext4_r_blocks_count(es) + resv_blocks);
+}
+
 static noinline_for_stack int
 ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
@@ -2104,10 +2118,13 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	int err = 0, first_err = 0;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
+	struct ext4_super_block *es;
 	struct ext4_buddy e4b;
+	unsigned int free_rate;
 
 	sb = ac->ac_sb;
 	sbi = EXT4_SB(sb);
+	es = sbi->s_es;
 	ngroups = ext4_get_groups_count(sb);
 	/* non-extent files are limited to low blocks/groups */
 	if (!(ext4_test_inode_flag(ac->ac_inode, EXT4_INODE_EXTENTS)))
@@ -2157,6 +2174,18 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 
 	/* Let's just scan groups to find more-less suitable blocks */
 	cr = ac->ac_2order ? 0 : 1;
+
+	/* Choose what loop to pass based on disk fullness */
+	free_rate = available_blocks_count(sbi) * 100 / ext4_blocks_count(es);
+
+	if (free_rate < sbi->s_mb_c3_treshold) {
+		cr = 3;
+	} else if(free_rate < sbi->s_mb_c2_treshold) {
+		cr = 2;
+	} else if(free_rate < sbi->s_mb_c1_treshold) {
+		cr = 1;
+	}
+
 	/*
 	 * cr == 0 try to get exact allocation,
 	 * cr == 3  try to get anything
@@ -2618,6 +2647,9 @@ int ext4_mb_init(struct super_block *sb)
 	sbi->s_mb_stats = MB_DEFAULT_STATS;
 	sbi->s_mb_stream_request = MB_DEFAULT_STREAM_THRESHOLD;
 	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
+	sbi->s_mb_c1_treshold = MB_DEFAULT_C1_TRESHOLD;
+	sbi->s_mb_c2_treshold = MB_DEFAULT_C2_TRESHOLD;
+	sbi->s_mb_c3_treshold = MB_DEFAULT_C3_TRESHOLD;
 	/*
 	 * The default group preallocation is 512, which for 4k block
 	 * sizes translates to 2 megabytes.  However for bigalloc file
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 88c98f17e3d9..d880923e55a5 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -71,6 +71,9 @@ do {									\
  * for which requests use 2^N search using buddies
  */
 #define MB_DEFAULT_ORDER2_REQS		2
+#define MB_DEFAULT_C1_TRESHOLD		25
+#define MB_DEFAULT_C2_TRESHOLD		15
+#define MB_DEFAULT_C3_TRESHOLD		5
 
 /*
  * default group prealloc size 512 blocks
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 9212a026a1f1..e4f1d98195c2 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -175,6 +175,9 @@ EXT4_RW_ATTR_SBI_UI(mb_stats, s_mb_stats);
 EXT4_RW_ATTR_SBI_UI(mb_max_to_scan, s_mb_max_to_scan);
 EXT4_RW_ATTR_SBI_UI(mb_min_to_scan, s_mb_min_to_scan);
 EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
+EXT4_RW_ATTR_SBI_UI(mb_c1_treshold, s_mb_c1_treshold);
+EXT4_RW_ATTR_SBI_UI(mb_c2_treshold, s_mb_c2_treshold);
+EXT4_RW_ATTR_SBI_UI(mb_c3_treshold, s_mb_c3_treshold);
 EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
 EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
 EXT4_RW_ATTR_SBI_UI(extent_max_zeroout_kb, s_extent_max_zeroout_kb);
@@ -203,6 +206,9 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(mb_max_to_scan),
 	ATTR_LIST(mb_min_to_scan),
 	ATTR_LIST(mb_order2_req),
+	ATTR_LIST(mb_c1_treshold),
+	ATTR_LIST(mb_c2_treshold),
+	ATTR_LIST(mb_c3_treshold),
 	ATTR_LIST(mb_stream_req),
 	ATTR_LIST(mb_group_prealloc),
 	ATTR_LIST(max_writeback_mb_bump),
-- 
2.14.3

