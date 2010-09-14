From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: NULL pointer dereference in print_daily_error_info
Date: Tue, 14 Sep 2010 15:51:02 +0300
Message-ID: <20100914125102.GA5318@swordfish.minsk.epam.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41818 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0INMuv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Sep 2010 08:50:51 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,
      
This patch fixes NULL pointer dereference in print_daily_error_info, when   
called
on unmounted fs (EXT4_SB(sb) returns NULL). Deleting error reporting timer  
in
ext4_put_super fixes oops.

IRQ:
run_timer_softirq
?run_timer_softirq
print_daily_error_info
?__do_softirq
__do_softirq
call_softirq
do_softirq
irq_exit
smp_apic_timer_interrupt
apic_timer_interrupt
EOI
intel_idle
intel_idle
...


By the way, isn't print_daily_error_info racy? Is it safe to call           
print_daily_error_info
(by timer event (softirq)) when we'are remounting fs, etc.?

Please kindly review.

---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2614774..751997d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -719,6 +719,7 @@ static void ext4_put_super(struct super_block *sb)
 			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
+	del_timer(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);

