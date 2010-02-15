From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] ext4: handle optional-arg mount options better
Date: Mon, 15 Feb 2010 15:20:16 -0600
Message-ID: <4B79BA90.3060703@redhat.com>
References: <4B69E6FA.20901@redhat.com> <20100215160150.GJ5337@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab0BOVUU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Feb 2010 16:20:20 -0500
In-Reply-To: <20100215160150.GJ5337@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Wed, Feb 03, 2010 at 03:13:30PM -0600, Eric Sandeen wrote:
>   
>> We have 2 mount options, "barrier" and "auto_da_alloc"
>> which may or may not take a 1/0 argument.  This is confusing
>> the parser, it seems, because if we pass it without an
>> arg, it still tries to match_int for the arg, which
>> is uninitialized, and match_number uses those uninit from/to
>> values to do a kmalloc, resulting in potentially noisy
>> failures.
>>
>> I think just defining _arg variants of the tokens and
>> handling them separately is the simplest fix.
>>
>> Reported-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>     
>
> This fix works just as well, and doesn't require _arg and _no_arg
> versions of the token tags.
>
> As long as we initialize arg[0], things should work correctly.  They
> work correctly even without !args[0].from check, but I added that just
> in case the implementation of the match_token library function changes
> in the future.
>   
Hm, I prefer the explicit to the clever.  ;)  But I guess it looks
mostly right.

This new code:

	case Opt_barrier:
		if (!args[0].from || match_int(&args[0], &option)) {
			set_opt(sbi->s_mount_opt, BARRIER);
			break;
		}

takes a bit of thought for me to sort out what's going on.

I guess the first test is "if no argument was found" and the 2nd
is "if argument was found but can't be scanned?"

Previously we were relying on match_int failing for no args,
but now we test for that, explicitly so I think a match_int failure
should return an error (well 0) like every other call in the function.

Maybe something like this?  I think it's clearer and more correct.



ext4: handle optional-arg mount options better

We have 2 mount options, "barrier" and "auto_da_alloc"
which may or may not take an argument.  This is confusing
the parser, it seems, because if we pass it in without an
arg, it still tries to match_int for the arg, which
is uninitialized, and match_number() uses those uninitialized
from/to values to do a kmalloc, resulting in potentially noisy
failures.

Per Ted's suggestion, initialize the args struct so that
we know whether match_token() found an argument for the
option, and skip match_int() if not.

Also, return error (0) from parse_options if we thought
we found an argument, but match_int() Fails.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 735c20d..d107d29 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1229,6 +1229,11 @@ static int parse_options(char *options, struct super_block *sb,
 		if (!*p)
 			continue;
 
+		/*
+		 * Initialize args struct so we know whether arg was found;
+		 * Some options take optional arguments.
+		 */
+		args[0].to = args[0].from = 0;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
@@ -1518,10 +1523,13 @@ set_qf_format:
 			clear_opt(sbi->s_mount_opt, BARRIER);
 			break;
 		case Opt_barrier:
-			if (match_int(&args[0], &option)) {
+			if (!args[0].from) {
+				/* No argument was found */
 				set_opt(sbi->s_mount_opt, BARRIER);
 				break;
 			}
+			if (match_int(&args[0], &option))
+				return 0;
 			if (option)
 				set_opt(sbi->s_mount_opt, BARRIER);
 			else
@@ -1594,10 +1602,13 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
 		case Opt_auto_da_alloc:
-			if (match_int(&args[0], &option)) {
+			if (!args[0].from) {
+				/* No argument was found */
 				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
 				break;
 			}
+ 			if (match_int(&args[0], &option))
+				return 0;
 			if (option)
 				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
 			else

