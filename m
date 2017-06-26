From: sayli karnik <karniksayli1995@gmail.com>
Subject: [PATCH] fs: jbd2: transaction: Add kernel-doc parameter descriptions
Date: Mon, 26 Jun 2017 10:20:22 +0530
Message-ID: <20170626045022.GA32222@sayli-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add function parameters in kernel-doc comments to fix warnings in the
Sphinx build:
transaction.c:511: warning: No description found for parameter 'type'
transaction.c:511: warning: No description found for parameter 'line_no'

Signed-off-by: sayli karnik <karniksayli1995@gmail.com>
---
 fs/jbd2/transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 8b08044..bca5f9f 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -497,6 +497,8 @@ EXPORT_SYMBOL(jbd2_journal_free_reserved);
 /**
  * int jbd2_journal_start_reserved(handle_t *handle) - start reserved handle
  * @handle: handle to start
+ * @type: type of handle
+ * @line_no: line number of handle
  *
  * Start handle that has been previously reserved with jbd2_journal_reserve().
  * This attaches @handle to the running transaction (or creates one if there's
-- 
2.7.4
