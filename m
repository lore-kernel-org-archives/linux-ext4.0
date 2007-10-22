From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 04/14] Rename feature name from gdt_checksum to uninit_groups.
Date: Sun, 21 Oct 2007 21:03:30 -0500
Message-ID: <20071022020330.23849.78156.stgit@toolssf2>
References: <20071022020308.23849.98773.stgit@toolssf2>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:46954 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbXJVCG4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Oct 2007 22:06:56 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l9M0vrw0016572
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:57:53 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9M26tiE112706
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:55 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9M26tFH008168
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:55 -0600
Received: from [127.0.0.1] (toolssf2.ltc.austin.ibm.com [9.3.190.66])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9M26tGD008163
	for <linux-ext4@vger.kernel.org>; Sun, 21 Oct 2007 20:06:55 -0600
In-Reply-To: <20071022020308.23849.98773.stgit@toolssf2>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Rename feature name from gdt_checksum to uninit_groups.

This name is a more intuitive option when running mke2fs.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-Off-By: Andreas Dilger <adilger@clusterfs.com>
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
