From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] ext4: optimize test_root()
Date: Thu,  6 Jun 2013 11:41:15 -0400
Message-ID: <1370533275-22381-3-git-send-email-tytso@mit.edu>
References: <1370533275-22381-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55522 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab3FFPlV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Jun 2013 11:41:21 -0400
In-Reply-To: <1370533275-22381-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The test_root() function could potentially loop forever due to
overflow issues.  So rewrite test_root() to avoid this issue; as a
bonus, it is 38% faster when benchmarked via a test loop:

int main(int argc, char **argv)
{
	int  i;

	for (i = 0; i < 1 << 24; i++) {
		if (test_root(i, 7))
			printf("%d\n", i);
	}
}

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index d0f13ea..5833939 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -682,11 +682,15 @@ ext4_fsblk_t ext4_count_free_clusters(struct super_block *sb)
 
 static inline int test_root(ext4_group_t a, int b)
 {
-	int num = b;
