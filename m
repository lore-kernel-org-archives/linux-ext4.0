From: richard kennedy <richard@rsk.demon.co.uk>
Subject: jbd : config_jbd_debug cannot create /proc entry
Date: Tue, 25 Sep 2007 10:40:40 +0100
Message-ID: <1190713240.3154.20.camel@castor.rsk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752141AbXIYJlX@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I enabled config_jbd_debug in the hope that it may help track down the
lockup I'm seeing, but unfortunately the /proc entry does not get
created.

any ideas how to fix this ?

My machine is an Athlon 64X2 - fedora 7 x86_64 - 2.6.23-rc7

CONFIG_EXT3_FS=m
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y

I added the following patch that shows create_proc_entry is failing

Richard

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 06ab3c1..40e7ea3 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1983,7 +1983,8 @@ static void __init create_jbd_proc_entry(void)
 		/* Why is this so hard? */
 		proc_jbd_debug->read_proc = read_jbd_debug;
 		proc_jbd_debug->write_proc = write_jbd_debug;
-	}
+	} else 
+	  printk( KERN_WARNING "jbd:cannot create proc entry : " JBD_PROC_NAME "\n");
 }
 
 static void __exit remove_jbd_proc_entry(void)
