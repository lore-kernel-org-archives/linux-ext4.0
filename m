From: Tao Ma <tm@tao.ma>
Subject: [PATCH RESEND] Documentation: Remove the obsolete parameters in 2 jbd2 functions.
Date: Tue,  7 Jun 2011 23:12:08 +0800
Message-ID: <1307459528-12266-1-git-send-email-tm@tao.ma>
References: <20110511145957.dff6c0ca.rdunlap@xenotime.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:39828 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755902Ab1FGPN1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:13:27 -0400
In-Reply-To: <20110511145957.dff6c0ca.rdunlap@xenotime.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

credits isn't a parameter for jbd2_journal_get_write_access and
jbd2_journal_get_undo_access. So remove the corresponding comments.

Acked-by: Jan Kara <jack@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/jbd2/transaction.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 3eec82d..547b101 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -814,7 +814,6 @@ out:
  * int jbd2_journal_get_write_access() - notify intent to modify a buffer for metadata (not data) update.
  * @handle: transaction to add buffer modifications to
  * @bh:     bh to be used for metadata writes
- * @credits: variable that will receive credits for the buffer
  *
  * Returns an error code or 0 on success.
  *
@@ -932,7 +931,6 @@ out:
  *     non-rewindable consequences
  * @handle: transaction
  * @bh: buffer to undo
- * @credits: store the number of taken credits here (if not NULL)
  *
  * Sometimes there is a need to distinguish between metadata which has
  * been committed to disk and that which has not.  The ext3fs code uses
-- 
1.7.1

