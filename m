Return-Path: <SRS0=sRFN=33=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFE0C352A4
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Feb 2020 01:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71D7220715
	for <linux-ext4@archiver.kernel.org>; Fri,  7 Feb 2020 01:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBGBR6 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 6 Feb 2020 20:17:58 -0500
Received: from smtp-out-so.shaw.ca ([64.59.136.138]:60352 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgBGBR5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Feb 2020 20:17:57 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Feb 2020 20:17:55 EST
Received: from cabot.adilger.int ([70.77.216.213])
        by shaw.ca with ESMTP
        id zs9SiRcpt17ZDzs9ViUgmR; Thu, 06 Feb 2020 18:09:49 -0700
X-Authority-Analysis: v=2.3 cv=ZsqT1OzG c=1 sm=1 tr=0
 a=BQvS1EmAg2ttxjPVUuc1UQ==:117 a=BQvS1EmAg2ttxjPVUuc1UQ==:17
 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=ySfo2T4IAAAA:8 a=GIvX95oPQwleXx4aqbgA:9
 a=ZUkhVnNHqyo2at-WnAgH:22
From:   Andreas Dilger <adilger@whamcloud.com>
To:     tytso@mit.edu
Cc:     linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 5/9] debugfs: allow comment lines in command file
Date:   Thu,  6 Feb 2020 18:09:42 -0700
Message-Id: <1581037786-62789-5-git-send-email-adilger@whamcloud.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1581037786-62789-1-git-send-email-adilger@whamcloud.com>
References: <1581037786-62789-1-git-send-email-adilger@whamcloud.com>
X-CMAE-Envelope: MS4wfOHde0K32nLEvijb8mfmFT8kM7/76GliIsZ0QklZEDTiCBP3plZrFh+ygqz9JZ9dzd7TT4iPv6zdz9tutrPzHTllYuuCwyqbgvzUBfXKi5NSDi/wtFVh
 cyl3TSNRlCCpPjAkWAaQD5+62iWHbSyQDz8gwOAFnPenbIKXKdh9iXUbnttlRQ5A+JhCw/pjzywvgS/w+lb8rUFRMPu5l8J4yXgmc9w+65qxRxqkNhoNRyM8
 dBH54cfy15ZcTQJgFAnJtA==
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Allow comment lines with '#' at the start of the line in the command
file passed in to debugfs via the "-f" option or from standard input.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Lustre-bug-id: https://jira.whamcloud.com/browse/LU-13197
---
 debugfs/debugfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 15b0121..60931a9 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2486,6 +2486,10 @@ static int source_file(const char *cmd_file, int ss_idx)
 	while (!feof(f)) {
 		if (fgets(buf, sizeof(buf), f) == NULL)
 			break;
+		if (buf[0] == '#') {
+			printf("%s", buf);
+			continue;
+		}
 		cp = strchr(buf, '\n');
 		if (cp)
 			*cp = 0;
-- 
1.8.0

