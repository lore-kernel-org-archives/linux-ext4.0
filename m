From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 23/53] fs: jbd2: escape a string with special chars on a kernel-doc
Date: Tue, 16 May 2017 09:16:15 -0300
Message-ID: <df1b560a4a04ac2e7591ffa7aff37899a45bf01a.1494935649.git.mchehab@s-opensource.com>
References: <cover.1494935649.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        linux-mtd@lists.infradead.org, "Theodore Ts'o" <tytso@mit.edu>,
        Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <cover.1494935649.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1494935649.git.mchehab@s-opensource.com>
References: <cover.1494935649.git.mchehab@s-opensource.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

kernel-doc will try to interpret a foo() string, except if
properly escaped.

Reviewed-by: Jan Kara <jack@suse.cz>
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

