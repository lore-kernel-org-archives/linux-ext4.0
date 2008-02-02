From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH][3/28] e2fsprogs-extended_ops.patch
Date: Sat, 02 Feb 2008 01:17:44 -0700
Message-ID: <20080202081744.GC31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49517 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbYBBIRr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:17:47 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128HlRf021282
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:17:47 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00M01QSZER00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:17:46 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Minor reformatting patch to make applying later patches easier.

Signed-off-by: Andreas Dilger <adilger@sun.com>

Index: e2fsprogs-cfs/e2fsck/unix.c
===================================================================
--- e2fsprogs-cfs.orig/e2fsck/unix.c
+++ e2fsprogs-cfs/e2fsck/unix.c
@@ -537,14 +537,13 @@ static void parse_extended_opts(e2fsck_t
 				continue;
 			}
 			ea_ver = strtoul(arg, &p, 0);
-			if (*p ||
-			    ((ea_ver != 1) && (ea_ver != 2))) {
-				fprintf(stderr,
-					_("Invalid EA version.\n"));
+			if (*p == '\0' && (ea_ver == 1 || ea_ver == 2)) {
+				ctx->ext_attr_ver = ea_ver;
+			} else {
+				fprintf(stderr, _("Invalid EA version.\n"));
 				extended_usage++;
 				continue;
 			}
-			ctx->ext_attr_ver = ea_ver;
 		} else {
 			fprintf(stderr, _("Unknown extended option: %s\n"),
 				token);
@@ -558,7 +557,8 @@ static void parse_extended_opts(e2fsck_t
 		       "and may take an argument which\n"
 		       "is set off by an equals ('=') sign.  "
 			"Valid extended options are:\n"
-		       "\tea_ver=<ea_version (1 or 2)>\n\n"), stderr);
+		       "\tea_ver=<ea_version (1 or 2)>\n"
+		       "\n"), stderr);
 		exit(1);
 	}
 }

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
