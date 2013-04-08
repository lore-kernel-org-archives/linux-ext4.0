From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/29] jbd2: Remove outdated comment
Date: Mon,  8 Apr 2013 23:32:13 +0200
Message-ID: <1365456754-29373-9-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936278Ab3DHVdB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:01 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The comment about credit estimates isn't true anymore. We do what the
comment describes now.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 81df09c..74cfbd3 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -283,16 +283,6 @@ repeat:
 	 * reduce the free space arbitrarily.  Be careful to account for
 	 * those buffers when checkpointing.
 	 */
