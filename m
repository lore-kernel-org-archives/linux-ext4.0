Return-Path: <SRS0=rNbD=QL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B16B0C282C4
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 10:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F23020823
	for <linux-ext4@archiver.kernel.org>; Mon,  4 Feb 2019 10:24:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="tNNMRvBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbfBDKYx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 4 Feb 2019 05:24:53 -0500
Received: from forwardcorp1o.cmail.yandex.net ([37.9.109.47]:36940 "EHLO
        forwardcorp1o.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726928AbfBDKYx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2019 05:24:53 -0500
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Feb 2019 05:24:51 EST
Received: from mxbackcorp1g.mail.yandex.net (mxbackcorp1g.mail.yandex.net [IPv6:2a02:6b8:0:1402::301])
        by forwardcorp1o.cmail.yandex.net (Yandex) with ESMTP id 1B76B20F0D;
        Mon,  4 Feb 2019 13:17:46 +0300 (MSK)
Received: from smtpcorp1p.mail.yandex.net (smtpcorp1p.mail.yandex.net [2a02:6b8:0:1472:2741:0:8b6:10])
        by mxbackcorp1g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id AV5LQZu2rk-HjxGiKEb;
        Mon, 04 Feb 2019 13:17:45 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1549275466; bh=nskEYQ7ThjghW4ibG+bG57BN9tcX376JCrD/aTQ3o18=;
        h=Subject:From:To:Date:Message-ID;
        b=tNNMRvBef2FLEBoYRcS30UoBD4si2IVmUpf6KwUm1B53eZBCHjBmSQs/LI9/0flGK
         CgjJy7N5ppmti6M7tb72M1MkVg4V+1cWoNZX5GJ1Dh5MJSMtjaTL9W24zfHj1iBkty
         APCzSmluZVSIzkCTRSzxkAeDHFiXaoz7aVj1fdc4=
Authentication-Results: mxbackcorp1g.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:ccb1:d36:e945:f357])
        by smtpcorp1p.mail.yandex.net (nwsmtp/Yandex) with ESMTPSA id J2LyBcGuPo-Hj5aUBm9;
        Mon, 04 Feb 2019 13:17:45 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH] ext4: add sysfs attr /sys/fs/ext4/<disk>/journal_task
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     linux-fsdevel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-kernel@vger.kernel.org
Date:   Mon, 04 Feb 2019 13:17:43 +0300
Message-ID: <154927546304.133377.2385004506198637025.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

This is useful for moving journal thread into cgroup or
for tracing it with ftrace/perf/blktrace.

For now the only way is `pgrep jbd2/$DISK` but this is not reliable:
name may be longer than "comm" limit and any task could mock it.

Attribute shows pid in current pid-namespace or 0 if task is unreachable.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 Documentation/ABI/testing/sysfs-fs-ext4 |    7 +++++++
 fs/ext4/sysfs.c                         |   13 +++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-fs-ext4 b/Documentation/ABI/testing/sysfs-fs-ext4
index c631253cf85c..78604db56279 100644
--- a/Documentation/ABI/testing/sysfs-fs-ext4
+++ b/Documentation/ABI/testing/sysfs-fs-ext4
@@ -109,3 +109,10 @@ Description:
 		write operation (since a 4k random write might turn
 		into a much larger write due to the zeroout
 		operation).
+
+What:		/sys/fs/ext4/<disk>/journal_task
+Date:		February 2019
+Contact:	"Theodore Ts'o" <tytso@mit.edu>
+Description:
+		This file is read-only and shows the pid of journal thread in
+		current pid-namespace or 0 if task is unreachable.
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 9212a026a1f1..60085b2e41ed 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -30,6 +30,7 @@ typedef enum {
 	attr_feature,
 	attr_pointer_ui,
 	attr_pointer_atomic,
+	attr_journal_task,
 } attr_id_t;
 
 typedef enum {
@@ -125,6 +126,14 @@ static ssize_t trigger_test_error(struct ext4_sb_info *sbi,
 	return count;
 }
 
+static ssize_t journal_task_show(struct ext4_sb_info *sbi, char *buf)
+{
+	if (!sbi->s_journal)
+		return -ESRCH;
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			task_pid_vnr(sbi->s_journal->j_task));
+}
+
 #define EXT4_ATTR(_name,_mode,_id)					\
 static struct ext4_attr ext4_attr_##_name = {				\
 	.attr = {.name = __stringify(_name), .mode = _mode },		\
@@ -188,6 +197,7 @@ EXT4_RW_ATTR_SBI_UI(msg_ratelimit_burst, s_msg_ratelimit_state.burst);
 EXT4_RO_ATTR_ES_UI(errors_count, s_error_count);
 EXT4_ATTR(first_error_time, 0444, first_error_time);
 EXT4_ATTR(last_error_time, 0444, last_error_time);
+EXT4_ATTR(journal_task, 0444, journal_task);
 
 static unsigned int old_bump_val = 128;
 EXT4_ATTR_PTR(max_writeback_mb_bump, 0444, pointer_ui, &old_bump_val);
@@ -217,6 +227,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(errors_count),
 	ATTR_LIST(first_error_time),
 	ATTR_LIST(last_error_time),
+	ATTR_LIST(journal_task),
 	NULL,
 };
 
@@ -304,6 +315,8 @@ static ssize_t ext4_attr_show(struct kobject *kobj,
 		return print_tstamp(buf, sbi->s_es, s_first_error_time);
 	case attr_last_error_time:
 		return print_tstamp(buf, sbi->s_es, s_last_error_time);
+	case attr_journal_task:
+		return journal_task_show(sbi, buf);
 	}
 
 	return 0;

