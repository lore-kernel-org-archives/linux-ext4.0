From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext4: oops on boot with root fs needing recovery
Date: Thu, 16 Oct 2008 16:32:57 -0400
Message-ID: <20081016203257.GI12962@mit.edu>
References: <48F7A013.6060508@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33934 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754625AbYJPUdE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Oct 2008 16:33:04 -0400
Content-Disposition: inline
In-Reply-To: <48F7A013.6060508@goop.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 16, 2008 at 01:12:03PM -0700, Jeremy Fitzhardinge wrote:
> I had a crash and rebooted.  The root filesystem needed journal  
> recovery, but ext4 crashed.
>
> My root fs is ext3 (no extents), but I've been mounting it as ext4 to  
> see how it turns out.

Yeah, known bug.  I'll push a patch to Linus to fix this.

      	    	       	      	       	     - Ted

ext4: Do mballoc init before doing filesystem recovery

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

During filesystem recovery we may be doing a truncate
which expects some of the mballoc data structures to
be initialized. So do ext4_mb_init before recovery.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0e661c5..6ca2146 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2441,6 +2441,21 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			"available.\n");
 	}
 
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
+		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
+				"requested data journaling mode\n");
+		clear_opt(sbi->s_mount_opt, DELALLOC);
+	} else if (test_opt(sb, DELALLOC))
+		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
+
+	ext4_ext_init(sb);
+	err = ext4_mb_init(sb, needs_recovery);
+	if (err) {
+		printk(KERN_ERR "EXT4-fs: failed to initalize mballoc (%d)\n",
+		       err);
+		goto failed_mount4;
+	}
+
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
 	 * That deadlocks, because orphan cleanup needs to lock the superblock
@@ -2460,21 +2475,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	       test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA ? "ordered":
 	       "writeback");
 
-	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
-		printk(KERN_WARNING "EXT4-fs: Ignoring delalloc option - "
-				"requested data journaling mode\n");
-		clear_opt(sbi->s_mount_opt, DELALLOC);
-	} else if (test_opt(sb, DELALLOC))
-		printk(KERN_INFO "EXT4-fs: delayed allocation enabled\n");
-
-	ext4_ext_init(sb);
-	err = ext4_mb_init(sb, needs_recovery);
-	if (err) {
-		printk(KERN_ERR "EXT4-fs: failed to initalize mballoc (%d)\n",
-		       err);
-		goto failed_mount4;
-	}
