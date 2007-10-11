From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 03/13][e2fsprogs] Rename feature name from gdt_checksum to uninit_groups.
Date: Thu, 11 Oct 2007 14:16:17 -0500
Message-ID: <20071011191617.4599.15954.stgit@gara>
References: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:42103 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbXJKTQG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 15:16:06 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJG4Lv010967
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:04 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJG4Lm480756
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:04 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJG4GE016779
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:04 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJG3MX016771
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:04 -0600
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJG33m040722
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:16:03 -0500
In-Reply-To: <20071011191559.4599.69332.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Rename feature name from gdt_checksum to uninit_groups.

This name is a more intuitive option when running mke2fs.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/e2p/feature.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index fe7e65a..7c25736 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -45,7 +45,7 @@ static struct feature feature_list[] = {
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_HUGE_FILE,
 			"huge_file" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_GDT_CSUM,
-			"gdt_checksum" },
+			"uninit_groups" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_DIR_NLINK,
 			"dir_nlink" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE,
