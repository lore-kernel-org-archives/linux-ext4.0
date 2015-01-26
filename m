From: Jan Mrazek <email@honzamrazek.cz>
Subject: [PATCH 1/1] Change of timer API
Date: Mon, 26 Jan 2015 08:23:10 -0800
Message-ID: <BLU436-SMTP228CB486F46AAB9E0D66C6ED9350@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jiri Slaby <gep@mail.muni.cz>, Jan Mrazek <email@honzamrazek.cz>
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	trivial@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu004-omc1s14.hotmail.com ([65.55.116.25]:64636 "EHLO
	BLU004-OMC1S14.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756481AbbAZQYE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Jan 2015 11:24:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- init_timer changed to setup_timer

Signed-off-by: Jan Mrazek <email@honzamrazek.cz>
---
 fs/ext4/super.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 496214d..fe3d48a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3949,9 +3949,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	get_random_bytes(&sbi->s_next_generation, sizeof(u32));
 	spin_lock_init(&sbi->s_next_gen_lock);
 
-	init_timer(&sbi->s_err_report);
-	sbi->s_err_report.function = print_daily_error_info;
-	sbi->s_err_report.data = (unsigned long) sb;
+	setup_timer(&sbi->s_err_report, print_daily_error_info,
+		(unsigned long) sb);
 
 	/* Register extent status tree shrinker */
 	if (ext4_es_register_shrinker(sbi))
-- 
1.9.1

