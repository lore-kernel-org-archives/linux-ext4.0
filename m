From: tytso@mit.edu
Subject: Re: [PATCH] handle optional-arg mount options better
Date: Mon, 15 Feb 2010 11:01:50 -0500
Message-ID: <20100215160150.GJ5337@thunk.org>
References: <4B69E6FA.20901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:60340 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab0BOQBw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Feb 2010 11:01:52 -0500
Content-Disposition: inline
In-Reply-To: <4B69E6FA.20901@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 03, 2010 at 03:13:30PM -0600, Eric Sandeen wrote:
> We have 2 mount options, "barrier" and "auto_da_alloc"
> which may or may not take a 1/0 argument.  This is confusing
> the parser, it seems, because if we pass it without an
> arg, it still tries to match_int for the arg, which
> is uninitialized, and match_number uses those uninit from/to
> values to do a kmalloc, resulting in potentially noisy
> failures.
> 
> I think just defining _arg variants of the tokens and
> handling them separately is the simplest fix.
> 
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

This fix works just as well, and doesn't require _arg and _no_arg
versions of the token tags.

As long as we initialize arg[0], things should work correctly.  They
work correctly even without !args[0].from check, but I added that just
in case the implementation of the match_token library function changes
in the future.

						- Ted

commit 1e6276ea260bcd37284f4387c435239919fbc628
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Feb 15 11:00:12 2010 -0500

    ext4: Fix optional-arg mount options
    
    We have 2 mount options, "barrier" and "auto_da_alloc" which may or
    may not take a 1/0 argument.  This causes the ext4 superblock mount
    code to subtract uninitialized pointers and pass the result to
    kmalloc, which results in very noisy failures.
    
    Reported-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 735c20d..7e9a7ea 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1229,6 +1229,7 @@ static int parse_options(char *options, struct super_block *sb,
 		if (!*p)
 			continue;
 
+		args[0].to = args[0].from = 0;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
@@ -1518,7 +1519,7 @@ set_qf_format:
 			clear_opt(sbi->s_mount_opt, BARRIER);
 			break;
 		case Opt_barrier:
-			if (match_int(&args[0], &option)) {
+			if (!args[0].from || match_int(&args[0], &option)) {
 				set_opt(sbi->s_mount_opt, BARRIER);
 				break;
 			}
@@ -1594,7 +1595,7 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
 		case Opt_auto_da_alloc:
-			if (match_int(&args[0], &option)) {
+			if (!args[0].from || match_int(&args[0], &option)) {
 				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
 				break;
 			}


