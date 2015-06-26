From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] ext4: Reject mount an ext2 filesystem with journal options
Date: Fri, 26 Jun 2015 13:03:29 -0300
Message-ID: <1435334609-23192-1-git-send-email-cmaiolino@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbbFZQDj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Jun 2015 12:03:39 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id B33003E709C
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2015 16:03:39 +0000 (UTC)
Received: from hades.maiolino.org.com ([10.3.112.5])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t5QG3aNJ007526
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2015 12:03:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no reason to allow ext2 filesystems be mounted with journal mount
options. So, this patch adds them to the MOPT_NO_EXT2 mount options list.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/ext4/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f06d058..e4b1141 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1366,9 +1366,9 @@ static const struct mount_opts {
 	{Opt_stripe, 0, MOPT_GTE0},
 	{Opt_resuid, 0, MOPT_GTE0},
 	{Opt_resgid, 0, MOPT_GTE0},
-	{Opt_journal_dev, 0, MOPT_GTE0},
-	{Opt_journal_path, 0, MOPT_STRING},
-	{Opt_journal_ioprio, 0, MOPT_GTE0},
+	{Opt_journal_dev, 0, MOPT_NO_EXT2 | MOPT_GTE0},
+	{Opt_journal_path, 0, MOPT_NO_EXT2 | MOPT_STRING},
+	{Opt_journal_ioprio, 0, MOPT_NO_EXT2 | MOPT_GTE0},
 	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
 	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_NO_EXT2 | MOPT_DATAJ},
 	{Opt_data_writeback, EXT4_MOUNT_WRITEBACK_DATA,
-- 
2.1.0

