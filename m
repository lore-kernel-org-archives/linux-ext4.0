From: Salman Qazi <sqazi@google.com>
Subject: [PATCH 1/2] ext4: Add ext4_mb_unload_buddy in the error path
Date: Tue, 29 May 2012 16:36:09 -0700
Message-ID: <20120529233609.12259.48732.stgit@dungbeetle.mtv.corp.google.com>
References: <20120529233422.12259.959.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@google.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:62460 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab2E2XgM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2012 19:36:12 -0400
Received: by lbbgp10 with SMTP id gp10so248305lbb.1
        for <linux-ext4@vger.kernel.org>; Tue, 29 May 2012 16:36:10 -0700 (PDT)
In-Reply-To: <20120529233422.12259.959.stgit@dungbeetle.mtv.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_free_blocks fails to pair an ext4_mb_load_buddy with a matching
ext4_mb_unload_buddy when it fails a memory allocation.

Signed-off-by: Salman Qazi <sqazi@google.com>
---
 fs/ext4/mballoc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 99ab428..5c315ab 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4636,6 +4636,7 @@ do_more:
 		 */
 		new_entry = kmem_cache_alloc(ext4_free_data_cachep, GFP_NOFS);
 		if (!new_entry) {
+			ext4_mb_unload_buddy(&e4b);
 			err = -ENOMEM;
 			goto error_return;
 		}

