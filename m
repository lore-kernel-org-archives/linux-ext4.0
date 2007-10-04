From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd/jbd2: Journal initialization doesn't need __GFP_NOFAIL
Date: Thu,  4 Oct 2007 01:50:37 -0400
Message-ID: <1191477059-5357-3-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44794 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbXJDFvJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:09 -0400
In-Reply-To: <1191477059-5357-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index ae2c25d..8d6d475 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -653,7 +653,7 @@ static journal_t * journal_init_common (void)
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4281244..0e329a3 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -654,7 +654,7 @@ static journal_t * journal_init_common (void)
 	journal_t *journal;
 	int err;
 
-	journal = kmalloc(sizeof(*journal), GFP_KERNEL|__GFP_NOFAIL);
+	journal = kmalloc(sizeof(*journal), GFP_KERNEL);
 	if (!journal)
 		goto fail;
 	memset(journal, 0, sizeof(*journal));
-- 
1.5.3.2.81.g17ed
