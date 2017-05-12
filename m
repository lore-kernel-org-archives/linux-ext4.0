From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 24/36] fs: jbd2: escape a string with special chars on a kernel-doc
Date: Fri, 12 May 2017 11:00:07 -0300
Message-ID: <97087d218a047d8d166c02f7f9b62dd8890963d5.1494596071.git.mchehab@s-opensource.com>
References: <cover.1494596071.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1494596071.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1494596071.git.mchehab@s-opensource.com>
References: <cover.1494596071.git.mchehab@s-opensource.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

kernel-doc will try to interpret a foo() string, except if
properly escaped.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 fs/jbd2/transaction.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index fe7f4a373436..38e1dcabbaca 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1066,10 +1066,10 @@ static bool jbd2_write_access_granted(handle_t *handle, struct buffer_head *bh,
  * @handle: transaction to add buffer modifications to
  * @bh:     bh to be used for metadata writes
  *
- * Returns an error code or 0 on success.
+ * Returns: error code or 0 on success.
  *
  * In full data journalling mode the buffer may be of type BJ_AsyncData,
- * because we're write()ing a buffer which is also part of a shared mapping.
+ * because we're ``write()ing`` a buffer which is also part of a shared mapping.
  */
 
 int jbd2_journal_get_write_access(handle_t *handle, struct buffer_head *bh)
-- 
2.9.3
