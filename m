From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, REWORKED 03/11] Rename feature name from gdt_checksum to uninit_groups
Date: Mon, 17 Mar 2008 09:28:39 -0400
Message-ID: <1205760527-14858-4-git-send-email-tytso@mit.edu>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
 <1205760527-14858-2-git-send-email-tytso@mit.edu>
 <1205760527-14858-3-git-send-email-tytso@mit.edu>
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60378 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825AbYCQN3F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 09:29:05 -0400
In-Reply-To: <1205760527-14858-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

This name is a more intuitive option when running mke2fs.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/e2p/feature.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index fc6052c..cf37447 100644
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
-- 
1.5.4.1.144.gdfee-dirty

