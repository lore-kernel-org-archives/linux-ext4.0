From: Xi Wang <xi.wang@gmail.com>
Subject: [PATCH RESEND] ext4: fix undefined behavior in ext4_fill_flex_info()
Date: Mon,  9 Jan 2012 18:47:20 -0500
Message-ID: <1326152840-1188-1-git-send-email-xi.wang@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xi Wang <xi.wang@gmail.com>, stable@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63691 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab2AIXtb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jan 2012 18:49:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 503358ae01b70ce6909d19dd01287093f6b6271c ("ext4: avoid divide by
zero when trying to mount a corrupted file system") fixes CVE-2009-4307
by performing a sanity check on s_log_groups_per_flex, since it can be
set to a bogus value by an attacker.

	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
	groups_per_flex = 1 << sbi->s_log_groups_per_flex;

	if (groups_per_flex < 2) { ... }

This patch fixes two potential issues in the previous commit.

1) The sanity check might only work on architectures like PowerPC.
On x86, 5 bits are used for the shifting amount.  That means, given a
large s_log_groups_per_flex value like 36, groups_per_flex = 1 << 36
is essentially 1 << 4 = 16, rather than 0.  This will bypass the check,
leaving s_log_groups_per_flex and groups_per_flex inconsistent.

2) The sanity check relies on undefined behavior, i.e., oversized shift.
A standard-confirming C compiler could rewrite the check in unexpected
ways.  Consider the following equivalent form, assuming groups_per_flex
is unsigned for simplicity.

	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
	if (groups_per_flex == 0 || groups_per_flex == 1) {

We compile the code snippet using Clang 3.0 and GCC 4.6.  Clang will
completely optimize away the check groups_per_flex == 0, leaving the
patched code as vulnerable as the original.  GCC keeps the check, but
there is no guarantee that future versions will do the same.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: stable@vger.kernel.org
---
BTW, the patch does not limit s_log_groups_per_flex too much, so
groups_per_flex could be as large as 1 << 31.  When calculating
flex_group_count, can

	sbi->s_groups_count + groups_per_flex

overflow and cause any problem?
---
 fs/ext4/super.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 64e2529..ecea4c9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2005,17 +2005,16 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	struct ext4_group_desc *gdp = NULL;
 	ext4_group_t flex_group_count;
 	ext4_group_t flex_group;
-	int groups_per_flex = 0;
+	unsigned int groups_per_flex = 0;
 	size_t size;
 	int i;
 
 	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
-	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
