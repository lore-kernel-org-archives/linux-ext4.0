From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] ext4: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 17:00:19 -0700
Message-ID: <20171017000019.GA102779@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:46489 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752798AbdJQAAW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Oct 2017 20:00:22 -0400
Received: by mail-pf0-f169.google.com with SMTP id p87so1908pfj.3
        for <linux-ext4@vger.kernel.org>; Mon, 16 Oct 2017 17:00:21 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b5d393321b7b..759281cec51f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2793,14 +2793,11 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
  * This function is called once a day if we have errors logged
  * on the file system
  */
-static void print_daily_error_info(unsigned long arg)
+static void print_daily_error_info(struct timer_list *t)
 {
-	struct super_block *sb = (struct super_block *) arg;
-	struct ext4_sb_info *sbi;
-	struct ext4_super_block *es;
