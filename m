From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Do not use stripe_with if it is not set
Date: Thu,  9 Feb 2017 16:30:50 +0100
Message-ID: <20170209153050.15317-2-jack@suse.cz>
References: <20170209153050.15317-1-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33861 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751178AbdBIPbg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 9 Feb 2017 10:31:36 -0500
In-Reply-To: <20170209153050.15317-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Avoid using stripe_width for sbi->s_stripe value if it is not actually
set. It prevents using the stride for sbi->s_stripe.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 66845a08a87a..b82cd3b263b4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2619,9 +2619,9 @@ static unsigned long ext4_get_stripe_size(struct ext4_sb_info *sbi)
 
 	if (sbi->s_stripe && sbi->s_stripe <= sbi->s_blocks_per_group)
 		ret = sbi->s_stripe;
-	else if (stripe_width <= sbi->s_blocks_per_group)
+	else if (stripe_width && stripe_width <= sbi->s_blocks_per_group)
 		ret = stripe_width;
-	else if (stride <= sbi->s_blocks_per_group)
+	else if (stride && stride <= sbi->s_blocks_per_group)
 		ret = stride;
 	else
 		ret = 0;
-- 
2.10.2
