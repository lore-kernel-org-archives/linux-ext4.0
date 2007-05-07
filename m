From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] - Make mke2fs.c defaults match mke2fs.conf defaults
Date: Mon, 07 May 2007 11:31:22 -0500
Message-ID: <463F545A.10903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965861AbXEGQdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 12:33:36 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l47GXaI8029170
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 12:33:36 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l47GXaQV019429
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 12:33:36 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l47GXXNN015182
	for <linux-ext4@vger.kernel.org>; Mon, 7 May 2007 12:33:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

One of our testers filed a bug that said "mkfs.ext3 is much slower when mke2fs.conf is missing..."

This is because the shipped defaults in mke2fs.conf do not match the shipped defaults in the
mkfs code itself; he wound up making a 1k block filesystem on a very large block device,
for example.

So - How about this patch, to bring them back into line?  Which makes me wonder; having
"defaults" in 2 different places is bound to get out of sync; should we instead generate
both code & config file defaults (and maybe man page defaults) from a common source?

Anyway, here's a patch to bring mke2fs.conf and mke2fs.c into line for current defaults...

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: e2fsprogs-hg/misc/mke2fs.c
===================================================================
--- e2fsprogs-hg.orig/misc/mke2fs.c
+++ e2fsprogs-hg/misc/mke2fs.c
@@ -1288,7 +1288,8 @@ static void PRS(int argc, char *argv[])
 	tmp = tmp2 = NULL;
 	if (fs_param.s_rev_level != EXT2_GOOD_OLD_REV) {
 		profile_get_string(profile, "defaults", "base_features", 0,
-				   "filetype,sparse_super", &tmp);
+				   "sparse_super,filetype,resize_inode,dir_index",
+				   &tmp);
 		profile_get_string(profile, "fs_types", fs_type, 
 				   "base_features", tmp, &tmp2);
 		edit_feature(tmp2, &fs_param.s_feature_compat);
@@ -1365,7 +1366,7 @@ static void PRS(int argc, char *argv[])
 	
 	if (blocksize <= 0) {
 		profile_get_integer(profile, "defaults", "blocksize", 0,
-				    1024, &use_bsize);
+				    4096, &use_bsize);
 		profile_get_integer(profile, "fs_types", fs_type, 
 				    "blocksize", use_bsize, &use_bsize);
 
