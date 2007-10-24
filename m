From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Show mballoc and delalloc options
Date: Wed, 24 Oct 2007 22:17:20 +0530
Message-ID: <1193244441-10149-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58226 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762951AbXJXQrz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 12:47:55 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9OGlrgf012634
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:53 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9OGpSeK291770
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:51:28 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9OGlb8t025774
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 02:47:37 +1000
In-Reply-To: <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Both these options are enabled by default.
So if they are are not set in mount options
that means the user explicity disabled them
using nomablloc and nodelalloc option. Show
the same in ext4_show_options

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0c32dc8..f1f70ce 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -733,8 +733,14 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",barrier=1");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
+
+	/* extents,mballoc and delalloc are enabled by default */
 	if (!test_opt(sb, EXTENTS))
 		seq_puts(seq, ",noextents");
+	if (!test_opt(sb, MBALLOC))
+		seq_puts(seq, ",nomballoc");
+	if (!test_opt(sb, DELALLOC))
+		seq_puts(seq, ",nodelalloc");
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 		seq_puts(seq, ",data=journal");
-- 
1.5.3.4.319.gdd817-dirty
