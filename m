From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Enable delalloc and mballoc by default.
Date: Wed, 24 Oct 2007 22:17:19 +0530
Message-ID: <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:45944 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764695AbXJXQs2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 12:48:28 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9OGlp5t012750
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:51 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9OGlqmO2347042
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:52 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9OGlavW025727
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:36 +1000
In-Reply-To: <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This ensure we test the latest features more easily.
We need an option to clear delayed alloc feature.
Add nodealloc option.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 62d7ec8..0c32dc8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -872,7 +872,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota, Opt_extents, Opt_noextents, Opt_delalloc,
+	Opt_grpquota, Opt_extents, Opt_noextents, Opt_delalloc, Opt_nodelalloc,
 	Opt_mballoc, Opt_nomballoc, Opt_stripe,
 };
 
@@ -928,6 +928,7 @@ static match_table_t tokens = {
 	{Opt_extents, "extents"},
 	{Opt_noextents, "noextents"},
 	{Opt_delalloc, "delalloc"},
+	{Opt_nodelalloc, "nodelalloc"},
 	{Opt_mballoc, "mballoc"},
 	{Opt_nomballoc, "nomballoc"},
 	{Opt_stripe, "stripe=%u"},
@@ -1279,6 +1280,9 @@ clear_qf_name:
 		case Opt_delalloc:
 			set_opt (sbi->s_mount_opt, DELALLOC);
 			break;
+		case Opt_nodelalloc:
+			clear_opt (sbi->s_mount_opt, DELALLOC);
+			break;
 		case Opt_mballoc:
 			set_opt(sbi->s_mount_opt, MBALLOC);
 			break;
@@ -1824,6 +1828,8 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	 * User -o noextents to turn it off
 	 */
 	set_opt(sbi->s_mount_opt, EXTENTS);
+	set_opt(sbi->s_mount_opt, DELALLOC);
+	set_opt(sbi->s_mount_opt, MBALLOC);
 
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
 			    NULL, 0))
-- 
1.5.3.4.319.gdd817-dirty
