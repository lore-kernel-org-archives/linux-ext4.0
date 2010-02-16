From: tytso@mit.edu
Subject: Re: [PATCH V2] ext4: handle optional-arg mount options better
Date: Mon, 15 Feb 2010 20:19:44 -0500
Message-ID: <20100216011944.GQ5337@thunk.org>
References: <4B69E6FA.20901@redhat.com>
 <20100215160150.GJ5337@thunk.org>
 <4B79BA90.3060703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51639 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab0BPBTq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Feb 2010 20:19:46 -0500
Content-Disposition: inline
In-Reply-To: <4B79BA90.3060703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ok, how about this, for even more explicit?

						- Ted

commit 15121c18a22ae483279f76dc9e554334b800d0f7
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Feb 15 20:17:55 2010 -0500

    ext4: Fix optional-arg mount options
    
    We have 2 mount options, "barrier" and "auto_da_alloc" which may or
    may not take a 1/0 argument.  This causes the ext4 superblock mount
    code to subtract uninitialized pointers and pass the result to
    kmalloc, which results in very noisy failures.
    
    Per Ted's suggestion, initialize the args struct so that
    we know whether match_token() found an argument for the
    option, and skip match_int() if not.
    
    Also, return error (0) from parse_options if we thought
    we found an argument, but match_int() Fails.
    
    Reported-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 735c20d..68a55df 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1229,6 +1229,11 @@ static int parse_options(char *options, struct super_block *sb,
 		if (!*p)
 			continue;
 
+		/*
+		 * Initialize args struct so we know whether arg was
+		 * found; some options take optional arguments.
+		 */
+		args[0].to = args[0].from = 0;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
@@ -1518,10 +1523,11 @@ set_qf_format:
 			clear_opt(sbi->s_mount_opt, BARRIER);
 			break;
 		case Opt_barrier:
-			if (match_int(&args[0], &option)) {
-				set_opt(sbi->s_mount_opt, BARRIER);
-				break;
-			}
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				option = 1;	/* No argument, default to 1 */
 			if (option)
 				set_opt(sbi->s_mount_opt, BARRIER);
 			else
@@ -1594,10 +1600,11 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
 		case Opt_auto_da_alloc:
-			if (match_int(&args[0], &option)) {
-				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
-				break;
-			}
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				option = 1;	/* No argument, default to 1 */
 			if (option)
 				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
 			else
