From: Pavel Machek <pavel@ucw.cz>
Subject: Re: ext4: media error but where?
Date: Fri, 4 Jul 2014 22:33:09 +0200
Message-ID: <20140704203309.GA28107@amd.pavel.ucw.cz>
References: <20140626203052.GA9449@xo-6d-61-c0.localdomain>
 <20140627024659.GF6826@thunk.org>
 <20140629202516.GA11430@amd.pavel.ucw.cz>
 <20140629210428.GD2162@thunk.org>
 <20140630064644.GA23079@amd.pavel.ucw.cz>
 <20140630134313.GA3753@thunk.org>
 <20140704102307.GA19252@amd.pavel.ucw.cz>
 <20140704121119.GB10514@thunk.org>
 <20140704172104.GA4877@xo-6d-61-c0.localdomain>
 <9BEA347C-2246-4746-95A4-0E00E0369816@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52480 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaGDUdM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2014 16:33:12 -0400
Content-Disposition: inline
In-Reply-To: <9BEA347C-2246-4746-95A4-0E00E0369816@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 2014-07-04 13:17:37, Andreas Dilger wrote:
> On Jul 4, 2014, at 11:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
> >>> pavel@duo:~$ uname -a
> >>> Linux duo 3.15.0-rc8+ #365 SMP Mon Jun 9 09:18:29 CEST 2014 i686
> >>> GNU/Linux
> >>> 
> >>> EXT4-fs (sda3): error count: 11
> >>> EXT4-fs (sda3): initial error at 1401714179: ext4_mb_generate_buddy:756
> >>> EXT4-fs (sda3): last error at 1401714179: ext4_reserve_inode_write:4877
> >>> 
> >>> That sounds like media error to me?
> >> 
> >> If you search your system logs since the last fsck, you should find 11
> >> instances of "EXT4-fs error" message, which means that there was some
> >> file system inconsisntencies detected.  The first error was detected at:
> >> 
> >> % date -d @1401714179
> >> Mon Jun  2 09:02:59 EDT 2014
> > 
> > Interesting. I always assumed 140... was block number.
> 
> Maybe it is worthwhile to improve this error message to be:
> 
>     EXT4-fs (sda3): initial error at time 1401714179: ...

I'm glad you suggested it. I actually done a patch before reading
this. What about:

---

Make it clear that values printed are times, and that it is error
since last fsck. Also add note about fsck version required.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b9b9aab..3423947 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2809,10 +2809,11 @@ static void print_daily_error_info(unsigned long arg)
 	es = sbi->s_es;
 
 	if (es->s_error_count)
-		ext4_msg(sb, KERN_NOTICE, "error count: %u",
+		/* fsck newer than v1.41.13 is needed to clean this condition. */
+		ext4_msg(sb, KERN_NOTICE, "error count since last fsck: %u",
 			 le32_to_cpu(es->s_error_count));
 	if (es->s_first_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): initial error at %u: %.*s:%d",
+		printk(KERN_NOTICE "EXT4-fs (%s): initial error at time %u: %.*s:%d",
 		       sb->s_id, le32_to_cpu(es->s_first_error_time),
 		       (int) sizeof(es->s_first_error_func),
 		       es->s_first_error_func,
@@ -2826,7 +2827,7 @@ static void print_daily_error_info(unsigned long arg)
 		printk("\n");
 	}
 	if (es->s_last_error_time) {
-		printk(KERN_NOTICE "EXT4-fs (%s): last error at %u: %.*s:%d",
+		printk(KERN_NOTICE "EXT4-fs (%s): last error at time %u: %.*s:%d",
 		       sb->s_id, le32_to_cpu(es->s_last_error_time),
 		       (int) sizeof(es->s_last_error_func),
 		       es->s_last_error_func,

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
