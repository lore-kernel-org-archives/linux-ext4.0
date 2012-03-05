From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 02/11] ext4: remove Opt_ignore
Date: Sun,  4 Mar 2012 22:08:16 -0500
Message-ID: <1330916905-5976-2-git-send-email-tytso@mit.edu>
References: <1330916905-5976-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41863 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934Ab2CEDI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 22:08:26 -0500
In-Reply-To: <1330916905-5976-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is completely unused so let's just get rid of it.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ed9a4b5..7dbad76 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1341,7 +1341,7 @@ enum {
 	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
-	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
+	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
 	Opt_usrquota, Opt_grpquota, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_mblk_io_submit,
 	Opt_nomblk_io_submit, Opt_block_validity, Opt_noblock_validity,
@@ -1784,8 +1784,6 @@ set_qf_format:
 			else
 				clear_opt(sb, BARRIER);
 			break;
-		case Opt_ignore:
-			break;
 		case Opt_nobh:
 			ext4_msg(sb, KERN_WARNING,
 				 "Ignoring deprecated nobh option");
-- 
1.7.9.107.g97f9a

