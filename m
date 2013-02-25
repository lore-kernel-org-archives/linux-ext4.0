From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] e2p: Fix 's' handling in parse_num_blocks2()
Date: Mon, 25 Feb 2013 16:55:05 +0100
Message-ID: <1361807708-15871-2-git-send-email-jack@suse.cz>
References: <1361807708-15871-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759881Ab3BYPzP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 10:55:15 -0500
In-Reply-To: <1361807708-15871-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

parse_num_blocks2() wrongly did:
	num << 1;
when log_block_size < 0. That is obviously wrong as such statement has
no effect (and the compiler properly warns about it). Callers expect
returned value to be in bytes when log_block_size < 0 so fix the
statement accordingly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/e2p/parse_num.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/e2p/parse_num.c b/lib/e2p/parse_num.c
index cb0dc5b..e8d6283 100644
--- a/lib/e2p/parse_num.c
+++ b/lib/e2p/parse_num.c
@@ -42,7 +42,7 @@ unsigned long long parse_num_blocks2(const char *arg, int log_block_size)
 		break;
 	case 's':
 		if (log_block_size < 0)
-			num << 1;
+			num <<= 9;
 		else
 			num >>= (1+log_block_size);
 		break;
-- 
1.7.1

