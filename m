Return-Path: <SRS0=an0e=3M=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579F5C33CB6
	for <linux-ext4@archiver.kernel.org>; Thu, 23 Jan 2020 09:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3862C22522
	for <linux-ext4@archiver.kernel.org>; Thu, 23 Jan 2020 09:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgAWJFR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 23 Jan 2020 04:05:17 -0500
Received: from relay.sw.ru ([185.231.240.75]:39818 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgAWJFR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 23 Jan 2020 04:05:17 -0500
Received: from vvs-ws.sw.ru ([172.16.24.21])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <vvs@virtuozzo.com>)
        id 1iuYQJ-0006pD-8x; Thu, 23 Jan 2020 12:05:11 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 1/1] jbd2_seq_info_next should increase position index
To:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.com>
Message-ID: <d13805e5-695e-8ac3-b678-26ca2313629f@virtuozzo.com>
Date:   Thu, 23 Jan 2020 12:05:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

Script below generates endless output
 $ q=;while read -r r;do echo "$((++q)) $r";done </proc/fs/jbd2/DEV/info

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 fs/jbd2/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 5e408ee..b3e2433 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -982,6 +982,7 @@ static void *jbd2_seq_info_start(struct seq_file *seq, loff_t *pos)
 
 static void *jbd2_seq_info_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	(*pos)++;
 	return NULL;
 }
 
-- 
1.8.3.1

